"""Huan luyen MLP (DL), so sanh voi baseline ML, xuat model_full.pkl va model_screening.pkl.

Chay tu thu muc goc project:
    python -m dl.train --csv data/diabetes_dataset.csv
"""
import json
import os

import joblib
import numpy as np
import pandas as pd
import torch
import torch.nn as nn
from sklearn.ensemble import RandomForestClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split

from .config import LAB_KEYWORDS, MODEL_VERSIONS, SEED, default_model_dir
from .data import build_preprocess, detect_target, find_csv
from .metrics import evaluate
from .model import DiabetesMLP, TorchTabularClassifier


def train_mlp(Xtr, ytr, Xva, yva, epochs=100, patience=10, lr=1e-3, batch=256):
    torch.manual_seed(SEED)
    dev = "cuda" if torch.cuda.is_available() else "cpu"
    model = DiabetesMLP(Xtr.shape[1]).to(dev)
    pos_weight = torch.tensor((ytr == 0).sum() / max((ytr == 1).sum(), 1),
                              dtype=torch.float32, device=dev)  # xu ly mat can bang lop
    loss_fn = nn.BCEWithLogitsLoss(pos_weight=pos_weight)
    opt = torch.optim.Adam(model.parameters(), lr=lr, weight_decay=1e-4)
    T = lambda a: torch.from_numpy(a.astype(np.float32)).to(dev)
    Xtr_t, ytr_t, Xva_t, yva_t = T(Xtr), T(ytr), T(Xva), T(yva)

    best, best_state, wait = float("inf"), None, 0
    for ep in range(epochs):
        model.train()
        perm = torch.randperm(len(Xtr_t), device=dev)
        for i in range(0, len(perm), batch):
            idx = perm[i:i + batch]
            opt.zero_grad()
            loss_fn(model(Xtr_t[idx]), ytr_t[idx]).backward()
            opt.step()
        model.eval()
        with torch.no_grad():
            vl = loss_fn(model(Xva_t), yva_t).item()
        if vl < best - 1e-4:
            best, wait = vl, 0
            best_state = {k: v.detach().cpu().numpy().copy() for k, v in model.state_dict().items()}
        else:
            wait += 1
            if wait >= patience:  # early stopping
                break
    return best_state, ep + 1


def train_one_mode(mode, X, y, out_dir):
    X_tr, X_tmp, y_tr, y_tmp = train_test_split(X, y, test_size=0.30, stratify=y, random_state=SEED)
    X_va, X_te, y_va, y_te = train_test_split(X_tmp, y_tmp, test_size=0.50, stratify=y_tmp, random_state=SEED)

    prep = build_preprocess(X_tr).fit(X_tr)
    Xtr, Xva, Xte = (prep.transform(d) for d in (X_tr, X_va, X_te))

    res = {}
    lr = LogisticRegression(max_iter=1000, class_weight="balanced").fit(Xtr, y_tr)
    res["LogisticRegression"] = evaluate(y_te, lr.predict_proba(Xte)[:, 1])
    rf = RandomForestClassifier(n_estimators=200, class_weight="balanced",
                                n_jobs=-1, random_state=SEED).fit(Xtr, y_tr)
    res["RandomForest"] = evaluate(y_te, rf.predict_proba(Xte)[:, 1])

    state, n_ep = train_mlp(Xtr, y_tr, Xva, y_va)
    clf = TorchTabularClassifier(prep, state, Xtr.shape[1], list(X.columns), MODEL_VERSIONS[mode])
    res["MLP (DL)"] = evaluate(y_te, clf.predict_proba(X_te)[:, 1])

    path = os.path.join(out_dir, f"model_{mode}.pkl")
    joblib.dump(clf, path)
    print(f"\n[{mode}] {len(X.columns)} dac trung goc: {list(X.columns)}")
    print(f"[{mode}] MLP dung sau {n_ep} epoch -> {path}")
    print(pd.DataFrame(res).T.to_string())
    return {"features": list(X.columns), "epochs_run": n_ep, "test_metrics": res}


def main(csv_path=None, out_dir=None, target=None, exclude_screening=None):
    csv_path = csv_path or find_csv()
    out_dir = out_dir or default_model_dir()
    os.makedirs(out_dir, exist_ok=True)

    df = pd.read_csv(csv_path)
    target = detect_target(df, target)
    X_all, y = df.drop(columns=[target]), df[target].astype(int).values
    print(f"Du lieu {df.shape}, cot nhan '{target}', ty le duong tinh {y.mean():.3f}")

    if exclude_screening is None:
        exclude_screening = [c for c in X_all.columns if any(k in c.lower() for k in LAB_KEYWORDS)]
    print("Cot bi loai o che do screening:", exclude_screening)

    summary = {
        "full": train_one_mode("full", X_all, y, out_dir),
        "screening": train_one_mode("screening", X_all.drop(columns=exclude_screening), y, out_dir),
    }
    with open(os.path.join(out_dir, "metrics_dl.json"), "w", encoding="utf-8") as f:
        json.dump(summary, f, ensure_ascii=False, indent=2)
    return summary


if __name__ == "__main__":
    import argparse

    ap = argparse.ArgumentParser()
    ap.add_argument("--csv", default=None)
    ap.add_argument("--out", default=None)
    ap.add_argument("--target", default=None)
    a, _ = ap.parse_known_args()
    main(a.csv, a.out, a.target)
