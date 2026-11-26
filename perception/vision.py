"""CNN đa lớp: ảnh triệu chứng/biến chứng tiểu đường (loét bàn chân, võng mạc, ...) + lớp 'bình thường/khác'.
Cấu hình bằng dict SOURCES: {tên_lớp: [nguồn, ...]}; nguồn là thư mục (mọi ảnh bên trong thuộc lớp đó)
hoặc dict {"csv":..., "images":<thư mục>, "id":"id_code", "label":"diagnosis", "keep":[1,2,3,4]} (lấy ảnh có nhãn trong keep).
Lưu: artifacts/perception/vision_cnn.{pt,json}.   Dùng: assess(ảnh) -> {label, confidence, probs, uncertain, cam_path}
"""
import json
from pathlib import Path

import numpy as np
import torch
import torch.nn as nn
from PIL import Image
import os
import torch.nn.functional as F
from concurrent.futures import ThreadPoolExecutor

import config
from .retina import SmallCNN, _last_conv, preprocess  # dùng lại tiền xử lý + CNN nhỏ

PERC_DIR = config.ARTIFACTS / "perception"
MODEL_PATH, META_PATH = PERC_DIR / "vision_cnn.pt", PERC_DIR / "vision_cnn.json"
EXT = {".png", ".jpg", ".jpeg", ".bmp", ".webp"}
THR = 0.55                                    # dưới ngưỡng này coi là "chưa đủ rõ"


def collect(sources: dict):
    import pandas as pd
    items = []
    for cls, srcs in sources.items():
        for s in srcs:
            if isinstance(s, dict):
                df = pd.read_csv(s["csv"])
                idx = {p.stem: p for p in Path(s["images"]).rglob("*") if p.suffix.lower() in EXT}
                for r in df.itertuples():
                    k = getattr(r, s["label"])
                    if (not s.get("keep") or k in s["keep"]) and str(getattr(r, s["id"])) in idx:
                        items.append((idx[str(getattr(r, s["id"]))], cls))
            else:
                items += [(p, cls) for p in Path(s).rglob("*") if p.suffix.lower() in EXT]
    return items


def build(n, arch="resnet18", pretrained=False):
    if arch == "small":
        return SmallCNN(n)
    from torchvision import models
    m = models.resnet18(weights="IMAGENET1K_V1" if pretrained else None)
    m.fc = nn.Sequential(nn.Dropout(0.3), nn.Linear(m.fc.in_features, n))
    return m


class _DS(torch.utils.data.Dataset):
    def __init__(self, items, cls, size, train):
        self.cls, self.train = cls, train
        self.y = [cls.index(c) for _, c in items]
        def load(it):
            return preprocess(Image.open(it[0]), size).half()
        with ThreadPoolExecutor(max_workers=os.cpu_count() or 4) as ex:
            self.x = list(ex.map(load, items))

    def __len__(self):
        return len(self.y)

    def __getitem__(self, i):
        x = self.x[i].float()
        if self.train:
            if np.random.rand() < .5:
                x = x.flip(2)
            s = x.shape[-1]
            k = int(s * np.random.uniform(0.6, 1.0))              # zoom ngẫu nhiên 60–100%
            a, b = np.random.randint(0, s - k + 1, 2)
            x = F.interpolate(x[None, :, a:a + k, b:b + k], size=(s, s), mode="bilinear", align_corners=False)[0]
            x = x * (0.85 + 0.3 * np.random.rand()) + (np.random.rand() - .5) * .3
        return x, self.y[i]


def train(sources: dict, arch="resnet18", epochs=8, size=224, bs=32, max_per_class=3000, seed=42):
    torch.manual_seed(seed)
    rng = np.random.default_rng(seed)
    items = collect(sources)
    cls = list(sources)
    by = {c: [it for it in items if it[1] == c] for c in cls}
    print({c: len(v) for c, v in by.items()}, "ảnh/lớp")
    empty = [c for c, v in by.items() if len(v) < 10]
    if empty:
        raise ValueError(f"Lớp quá ít/không có ảnh: {empty} — kiểm tra lại đường dẫn trong SOURCES")
    S = {"tr": [], "va": [], "te": []}
    for c, v in by.items():                       # chia theo từng lớp, cân bằng tối đa max_per_class
        v = [v[i] for i in rng.permutation(len(v))[:max_per_class]]
        a, b = int(.7 * len(v)), int(.85 * len(v))
        S["tr"] += v[:a]; S["va"] += v[a:b]; S["te"] += v[b:]
    dev = "cuda" if torch.cuda.is_available() else "cpu"
    try:
        net = build(len(cls), arch, pretrained=True)
    except Exception as e:
        print("  [không tải được trọng số ImageNet → huấn luyện từ đầu]", str(e)[:80])
        net = build(len(cls), arch)
    net.to(dev)
    cnt = np.array([sum(1 for _, c in S["tr"] if c == k) for k in cls]) + 1
    w = torch.tensor(cnt.sum() / cnt, dtype=torch.float32, device=dev)
    loss_fn = nn.CrossEntropyLoss(weight=w / w.mean())
    opt = torch.optim.AdamW(net.parameters(), lr=1e-3 if arch == "small" else 3e-4, weight_decay=1e-4)
    L = {k: torch.utils.data.DataLoader(_DS(v, cls, size, k == "tr"), batch_size=bs, shuffle=k == "tr", num_workers=2) for k, v in S.items()}

    def run(loader):
        net.eval(); P, Y = [], []
        with torch.no_grad():
            for x, y in loader:
                P.append(net(x.to(dev)).argmax(1).cpu().numpy()); Y.append(y.numpy())
        return np.concatenate(Y), np.concatenate(P)

    best, state = -1, None
    for ep in range(epochs):
        net.train()
        for x, y in L["tr"]:
            opt.zero_grad(); loss_fn(net(x.to(dev)), y.to(dev)).backward(); opt.step()
        y, p = run(L["va"])
        mf1 = float(np.mean([((p == k) & (y == k)).sum() * 2 / max((p == k).sum() + (y == k).sum(), 1) for k in range(len(cls))]))
        print(f"epoch {ep + 1}/{epochs}  macro-F1(val)={mf1:.3f}  acc={np.mean(y == p):.3f}")
        if mf1 > best:
            best, state = mf1, {k: v.detach().cpu().clone() for k, v in net.state_dict().items()}
    net.load_state_dict(state)
    y, p = run(L["te"])
    cm = np.zeros((len(cls), len(cls)), int)
    for a, b in zip(y, p):
        cm[a, b] += 1
    rec = {c: float(cm[i, i] / max(cm[i].sum(), 1)) for i, c in enumerate(cls)}
    prec = {c: float(cm[i, i] / max(cm[:, i].sum(), 1)) for i, c in enumerate(cls)}
    metrics = {"accuracy": float(np.mean(y == p)), "recall": rec, "precision": prec, "confusion": cm.tolist(), "n_test": int(len(y))}
    PERC_DIR.mkdir(parents=True, exist_ok=True)
    torch.save(state, MODEL_PATH)
    json.dump({"classes": cls, "arch": arch, "size": size, "metrics": metrics}, open(META_PATH, "w"), indent=1, ensure_ascii=False)
    print(json.dumps(metrics, indent=1, ensure_ascii=False))
    return metrics


_cache: dict = {}


def _load():
    if not _cache:
        if not MODEL_PATH.exists():
            raise FileNotFoundError("Chưa có mô hình ảnh (chạy train trong notebook)")
        meta = json.load(open(META_PATH))
        net = build(len(meta["classes"]), meta["arch"])
        net.load_state_dict(torch.load(MODEL_PATH, map_location="cpu"))
        net.eval()
        _cache.update(net=net, meta=meta)
    return _cache["net"], _cache["meta"]


def assess(image, cam_path=None) -> dict:
    net, meta = _load()
    img = Image.open(image) if not isinstance(image, Image.Image) else image
    x = preprocess(img, meta["size"]).unsqueeze(0)
    feats, grads, layer = [], [], _last_conv(net)
    h1 = layer.register_forward_hook(lambda m, i, o: feats.append(o))
    h2 = layer.register_full_backward_hook(lambda m, gi, go: grads.append(go[0]))
    try:
        net.zero_grad(); out = net(x)
        prob = torch.softmax(out, 1)[0].detach().numpy(); g = int(prob.argmax()); out[0, g].backward()
    finally:
        h1.remove(); h2.remove()
    res = {"label": meta["classes"][g], "confidence": round(float(prob[g]), 3), "uncertain": bool(prob[g] < THR),
           "probs": {c: round(float(p), 3) for c, p in zip(meta["classes"], prob)}}
    if cam_path:
        from matplotlib import cm
        cam = torch.relu((grads[0].mean((2, 3), keepdim=True) * feats[0]).sum(1))[0].detach().numpy()
        cam = (cam - cam.min()) / (cam.max() - cam.min() + 1e-9)
        base = img.convert("RGB").resize((meta["size"],) * 2)
        heat = (cm.jet(np.asarray(Image.fromarray((cam * 255).astype("uint8")).resize(base.size, Image.BICUBIC)) / 255)[..., :3] * 255).astype("uint8")
        Image.fromarray((np.asarray(base) * .55 + heat * .45).astype("uint8")).save(cam_path)
        res["cam_path"] = cam_path
    return res
