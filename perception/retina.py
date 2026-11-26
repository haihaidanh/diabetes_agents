"""CNN phân loại bệnh võng mạc đái tháo đường (DR) từ ảnh đáy mắt + Grad-CAM.

Dữ liệu: APTOS 2019 (train.csv: id_code, diagnosis 0..4; ảnh train_images/<id_code>.png).
Huấn luyện: python main.py train-retina --data <thư mục APTOS> [--arch resnet18|small] [--epochs 6]
Lưu: artifacts/perception/retina_cnn.{pt,json}
Đầu ra assess(): cấp 0-4, xác suất, nhóm (không / nhẹ-vừa / nặng), cờ 'cần khám chuyên khoa', bản đồ Grad-CAM.
"""
import json
from pathlib import Path

import numpy as np
import torch
import torch.nn as nn
from PIL import Image

import config

PERC_DIR = config.ARTIFACTS / "perception"
MODEL_PATH, META_PATH = PERC_DIR / "retina_cnn.pt", PERC_DIR / "retina_cnn.json"
GRADES = ["Không có bệnh võng mạc", "Nhẹ", "Trung bình", "Nặng", "Tăng sinh"]
MEAN, STD = np.array([0.485, 0.456, 0.406], np.float32), np.array([0.229, 0.224, 0.225], np.float32)


class SmallCNN(nn.Module):
    """CNN nhỏ tự viết (để chạy CPU/kiểm thử, không cần tải trọng số)."""

    def __init__(self, n=5):
        super().__init__()
        ch, layers = 3, []
        for o in (16, 32, 64, 96):
            layers += [nn.Conv2d(ch, o, 3, padding=1), nn.BatchNorm2d(o), nn.ReLU(), nn.MaxPool2d(2)]
            ch = o
        self.features = nn.Sequential(*layers)
        self.head = nn.Sequential(nn.AdaptiveAvgPool2d(1), nn.Flatten(), nn.Dropout(0.3), nn.Linear(ch, n))

    def forward(self, x):
        return self.head(self.features(x))


def build(arch: str = "resnet18", pretrained: bool = False):
    if arch == "small":
        return SmallCNN()
    from torchvision import models
    m = models.resnet18(weights="IMAGENET1K_V1" if pretrained else None)
    m.fc = nn.Sequential(nn.Dropout(0.3), nn.Linear(m.fc.in_features, 5))
    return m


def _last_conv(net):
    return net.features[-4] if isinstance(net, SmallCNN) else net.layer4[-1]


def preprocess(img: Image.Image, size: int = 224) -> torch.Tensor:
    """Cắt viền đen quanh ảnh đáy mắt, đưa về vuông size×size, chuẩn hoá ImageNet."""
    img = img.convert("RGB")
    a = np.asarray(img)
    m = a.max(2) > 12
    if m.any():
        ys, xs = np.where(m)
        img = img.crop((xs.min(), ys.min(), xs.max() + 1, ys.max() + 1))
    img = img.resize((size, size), Image.BILINEAR)
    x = (np.asarray(img, np.float32) / 255 - MEAN) / STD
    return torch.from_numpy(x.transpose(2, 0, 1))


def _find_csv_and_images(root: Path):
    csv = next(iter(sorted(root.rglob("train.csv"))), None)
    if csv is None:
        raise FileNotFoundError(f"Không thấy train.csv (APTOS) trong {root}")
    imgs = {p.stem: p for p in root.rglob("*") if p.suffix.lower() in (".png", ".jpg", ".jpeg")}
    return csv, imgs


class _DS(torch.utils.data.Dataset):
    def __init__(self, items, size, train):
        self.items, self.size, self.train = items, size, train

    def __len__(self):
        return len(self.items)

    def __getitem__(self, i):
        p, y = self.items[i]
        x = preprocess(Image.open(p), self.size)
        if self.train:
            if np.random.rand() < .5:
                x = x.flip(2)
            if np.random.rand() < .5:
                x = x.flip(1)
            x = torch.rot90(x, np.random.randint(4), (1, 2))
        return x, y


def _qwk(y, p, k=5):
    O = np.zeros((k, k))
    for a, b in zip(y, p):
        O[a, b] += 1
    W = np.array([[(i - j) ** 2 for j in range(k)] for i in range(k)]) / (k - 1) ** 2
    E = np.outer(O.sum(1), O.sum(0)) / max(O.sum(), 1)
    return float(1 - (W * O).sum() / max((W * E).sum(), 1e-9))


def train(data_dir, arch="resnet18", epochs=6, size=224, bs=32, max_n=None, seed=42):
    import pandas as pd
    torch.manual_seed(seed)
    rng = np.random.default_rng(seed)
    csv, imgs = _find_csv_and_images(Path(data_dir))
    df = pd.read_csv(csv)
    items = [(imgs[r.id_code], int(r.diagnosis)) for r in df.itertuples() if r.id_code in imgs]
    if max_n:
        items = [items[i] for i in rng.permutation(len(items))[:max_n]]
    idx = rng.permutation(len(items))
    a, b = int(.7 * len(idx)), int(.85 * len(idx))
    S = {k: [items[i] for i in ids] for k, ids in (("tr", idx[:a]), ("va", idx[a:b]), ("te", idx[b:]))}
    print({k: len(v) for k, v in S.items()}, "ảnh")
    dev = "cuda" if torch.cuda.is_available() else "cpu"
    try:
        net = build(arch, pretrained=True)
    except Exception as e:
        print("  [không tải được trọng số ImageNet, huấn luyện từ đầu]", str(e)[:80])
        net = build(arch)
    net.to(dev)
    cnt = np.bincount([y for _, y in S["tr"]], minlength=5) + 1
    w = torch.tensor((cnt.sum() / cnt) ** .5, dtype=torch.float32, device=dev)   # bù lệch lớp nhẹ
    loss_fn = nn.CrossEntropyLoss(weight=w / w.mean())
    opt = torch.optim.AdamW(net.parameters(), lr=1e-3 if arch == "small" else 3e-4, weight_decay=1e-4)
    L = {k: torch.utils.data.DataLoader(_DS(v, size, k == "tr"), batch_size=bs, shuffle=k == "tr", num_workers=2) for k, v in S.items()}

    def predict(loader):
        net.eval()
        P, Y = [], []
        with torch.no_grad():
            for x, y in loader:
                P.append(net(x.to(dev)).argmax(1).cpu().numpy())
                Y.append(y.numpy())
        return np.concatenate(Y), np.concatenate(P)

    best, state = -9, None
    for ep in range(epochs):
        net.train()
        for x, y in L["tr"]:
            opt.zero_grad()
            loss_fn(net(x.to(dev)), y.to(dev)).backward()
            opt.step()
        y, p = predict(L["va"])
        q = _qwk(y, p)
        print(f"epoch {ep + 1}/{epochs}  QWK(val)={q:.3f}  acc={np.mean(y == p):.3f}")
        if q > best:
            best, state = q, {k: v.detach().cpu().clone() for k, v in net.state_dict().items()}
    net.load_state_dict(state)
    y, p = predict(L["te"])
    refer = lambda g: (g >= 2).astype(int)        # cần chuyển khám: từ mức trung bình trở lên
    tp, fn = int(((refer(y) == 1) & (refer(p) == 1)).sum()), int(((refer(y) == 1) & (refer(p) == 0)).sum())
    tn, fp = int(((refer(y) == 0) & (refer(p) == 0)).sum()), int(((refer(y) == 0) & (refer(p) == 1)).sum())
    metrics = {"QWK": _qwk(y, p), "accuracy": float(np.mean(y == p)), "refer_sensitivity": tp / max(tp + fn, 1),
               "refer_specificity": tn / max(tn + fp, 1), "n_test": int(len(y))}
    PERC_DIR.mkdir(parents=True, exist_ok=True)
    torch.save(state, MODEL_PATH)
    json.dump({"arch": arch, "size": size, "metrics": metrics, "dataset": str(data_dir)}, open(META_PATH, "w"), indent=1)
    print(json.dumps(metrics, indent=1))
    return metrics


_cache: dict = {}


def _load():
    if not _cache:
        if not MODEL_PATH.exists():
            raise FileNotFoundError("Chưa có mô hình võng mạc (python main.py train-retina --data <thư mục APTOS>)")
        meta = json.load(open(META_PATH))
        net = build(meta["arch"])
        net.load_state_dict(torch.load(MODEL_PATH, map_location="cpu"))
        net.eval()
        _cache.update(net=net, meta=meta)
    return _cache["net"], _cache["meta"]


def assess(image, cam_path: str | None = None) -> dict:
    """image: đường dẫn hoặc PIL.Image. Trả về cấp DR, xác suất, cờ chuyển khám, (tuỳ chọn) lưu ảnh Grad-CAM."""
    net, meta = _load()
    img = Image.open(image) if not isinstance(image, Image.Image) else image
    x = preprocess(img, meta["size"]).unsqueeze(0)
    feats, grads = [], []
    layer = _last_conv(net)
    h1 = layer.register_forward_hook(lambda m, i, o: feats.append(o))
    h2 = layer.register_full_backward_hook(lambda m, gi, go: grads.append(go[0]))
    try:
        net.zero_grad()
        out = net(x.requires_grad_(False))
        prob = torch.softmax(out, 1)[0].detach().numpy()
        g = int(prob.argmax())
        out[0, g].backward()
    finally:
        h1.remove()
        h2.remove()
    cam = torch.relu((grads[0].mean((2, 3), keepdim=True) * feats[0]).sum(1))[0].detach().numpy()
    cam = (cam - cam.min()) / (cam.max() - cam.min() + 1e-9)
    res = {"grade": g, "grade_name": GRADES[g], "probs": [round(float(p), 3) for p in prob],
           "confidence": round(float(prob[g]), 3), "refer": bool(prob[2:].sum() >= .5),
           "prob_refer": round(float(prob[2:].sum()), 3), "qwk_test": round(meta["metrics"]["QWK"], 2),
           "sens_test": round(meta["metrics"]["refer_sensitivity"], 2)}
    if cam_path:
        import matplotlib
        matplotlib.use("Agg")
        from matplotlib import cm
        base = img.convert("RGB").resize((meta["size"], meta["size"]))
        heat = (cm.jet(np.asarray(Image.fromarray((cam * 255).astype("uint8")).resize(base.size, Image.BICUBIC)) / 255)[..., :3] * 255).astype("uint8")
        Image.fromarray((np.asarray(base) * .55 + heat * .45).astype("uint8")).save(cam_path)
        res["cam_path"] = cam_path
    return res
