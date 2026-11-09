"""Huấn luyện, hiệu chỉnh isotonic, chọn ngưỡng F1 và đánh giá mô hình dự đoán tiểu đường.

Chạy: python -m ml.train [--mlp]
Kết quả: artifacts/ml/model_full.pkl, model_screening.pkl, metrics.csv, pr_curves.png, reliability.png
"""
import argparse
import glob

import joblib
import numpy as np
import pandas as pd
from sklearn.calibration import CalibratedClassifierCV
from sklearn.compose import ColumnTransformer
from sklearn.ensemble import RandomForestClassifier
from sklearn.frozen import FrozenEstimator
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import (average_precision_score, brier_score_loss, f1_score, precision_recall_curve,
                             precision_score, recall_score, roc_auc_score)
from sklearn.model_selection import train_test_split
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import OneHotEncoder, StandardScaler
from xgboost import XGBClassifier

import config

CAT = ["gender", "smoking_history"]
FULL = ["gender", "age", "hypertension", "heart_disease", "smoking_history", "bmi", "HbA1c_level", "blood_glucose_level"]
SCREEN = [f for f in FULL if f not in ("HbA1c_level", "blood_glucose_level")]


# ---------------------------------------------------------------- dữ liệu
def load_clean(path=None) -> pd.DataFrame:
    """Đọc CSV, giữ 8 đặc trưng + nhãn, loại dòng thiếu/trùng và gender='Other'."""
    path = path or config.RAW_CSV
    if not path.exists():
        found = glob.glob(str(config.DATA_DIR / "*.csv"))
        if not found:
            raise FileNotFoundError(f"Không thấy CSV: đặt tệp tại {config.RAW_CSV} hoặc đặt biến DIABETES_CSV")
        path = found[0]
    raw = pd.read_csv(path).rename(columns={"hbA1c_level": "HbA1c_level"})
    df = raw[FULL + ["diabetes"]].dropna().drop_duplicates()
    df = df[df["gender"].isin(["Male", "Female"])].reset_index(drop=True)
    print(f"Gốc {len(raw)} dòng -> sau làm sạch {len(df)} | tỉ lệ dương {df['diabetes'].mean():.2%}")
    return df


def split(df: pd.DataFrame, seed: int = 42):
    train, tmp = train_test_split(df, test_size=0.30, stratify=df["diabetes"], random_state=seed)
    val, test = train_test_split(tmp, test_size=0.50, stratify=tmp["diabetes"], random_state=seed)
    print(f"train/val/test: {len(train)}/{len(val)}/{len(test)}")
    return train, val, test


# ---------------------------------------------------------------- mô hình
def make_pre(features):
    num = [f for f in features if f not in CAT]
    cat = [f for f in features if f in CAT]
    return ColumnTransformer([("num", StandardScaler(), num), ("cat", OneHotEncoder(handle_unknown="ignore"), cat)])


def best_f1_threshold(y_true, prob) -> float:
    p, r, t = precision_recall_curve(y_true, prob)
    f1 = 2 * p[:-1] * r[:-1] / np.clip(p[:-1] + r[:-1], 1e-9, None)
    return float(t[np.argmax(f1)])


def evaluate(y_true, prob, thr) -> dict:
    pred = (prob >= thr).astype(int)
    return {"PR-AUC": average_precision_score(y_true, prob), "ROC-AUC": roc_auc_score(y_true, prob),
            "F1": f1_score(y_true, pred), "Precision": precision_score(y_true, pred),
            "Recall": recall_score(y_true, pred), "Brier": brier_score_loss(y_true, prob)}


def fit_and_evaluate(estimator, features, train, val, test) -> dict:
    """Huấn luyện trên train, hiệu chỉnh isotonic trên validation, chọn ngưỡng F1 trên validation, đo trên test."""
    base = Pipeline([("pre", make_pre(features)), ("clf", estimator)])
    base.fit(train[features], train["diabetes"])
    cal = CalibratedClassifierCV(FrozenEstimator(base), method="isotonic")
    cal.fit(val[features], val["diabetes"])
    val_prob = cal.predict_proba(val[features])[:, 1]
    thr = best_f1_threshold(val["diabetes"], val_prob)
    test_prob = cal.predict_proba(test[features])[:, 1]
    m = evaluate(test["diabetes"], test_prob, thr)
    m["Brier_raw"] = brier_score_loss(test["diabetes"], base.predict_proba(test[features])[:, 1])
    m["val_PR-AUC"] = average_precision_score(val["diabetes"], val_prob)
    return {"calibrated": cal, "threshold": thr, "features": features, "metrics": m, "test_prob": test_prob}


def fit_mlp(features, train, val, test, spw, epochs=40, seed=42) -> dict:
    """MLP PyTorch + hiệu chỉnh isotonic (chỉ chạy khi có torch)."""
    import torch
    import torch.nn as nn
    from sklearn.isotonic import IsotonicRegression

    dev = "cuda" if torch.cuda.is_available() else "cpu"
    dense = lambda m: m.toarray() if hasattr(m, "toarray") else np.asarray(m)
    torch.manual_seed(seed)
    np.random.seed(seed)
    pre = make_pre(features).fit(train[features])
    X = {k: torch.tensor(dense(pre.transform(d[features])), dtype=torch.float32, device=dev)
         for k, d in [("tr", train), ("va", val), ("te", test)]}
    ytr = torch.tensor(train["diabetes"].values, dtype=torch.float32, device=dev)
    net = nn.Sequential(nn.Linear(X["tr"].shape[1], 64), nn.ReLU(), nn.Dropout(0.2),
                        nn.Linear(64, 32), nn.ReLU(), nn.Linear(32, 1)).to(dev)
    opt = torch.optim.Adam(net.parameters(), lr=1e-3)
    loss_fn = nn.BCEWithLogitsLoss(pos_weight=torch.tensor(spw, dtype=torch.float32, device=dev))
    prob = lambda k: torch.sigmoid(net(X[k]).squeeze(1)).detach().cpu().numpy()
    best, best_state = -1, None
    for _ in range(epochs):
        net.train()
        for idx in torch.randperm(len(ytr), device=dev).split(512):
            opt.zero_grad()
            loss_fn(net(X["tr"][idx]).squeeze(1), ytr[idx]).backward()
            opt.step()
        net.eval()
        with torch.no_grad():
            s = average_precision_score(val["diabetes"], prob("va"))
        if s > best:
            best, best_state = s, {k: v.clone() for k, v in net.state_dict().items()}
    net.load_state_dict(best_state)
    net.eval()
    with torch.no_grad():
        pv, pt = prob("va"), prob("te")
    iso = IsotonicRegression(out_of_bounds="clip").fit(pv, val["diabetes"])
    val_prob, test_prob = iso.predict(pv), iso.predict(pt)
    thr = best_f1_threshold(val["diabetes"], val_prob)
    m = evaluate(test["diabetes"], test_prob, thr)
    m["Brier_raw"] = brier_score_loss(test["diabetes"], pt)
    m["val_PR-AUC"] = average_precision_score(val["diabetes"], val_prob)
    return {"metrics": m, "threshold": thr, "test_prob": test_prob, "features": None}


# ---------------------------------------------------------------- hình
def plots(results, test):
    import matplotlib
    matplotlib.use("Agg")
    import matplotlib.pyplot as plt
    from sklearn.calibration import calibration_curve

    fig, ax = plt.subplots(1, 2, figsize=(12, 4.5))
    for a, s in zip(ax, ["full", "screening"]):
        for (set_name, name), r in results.items():
            if set_name != s:
                continue
            p, rc, _ = precision_recall_curve(test["diabetes"], r["test_prob"])
            a.plot(rc, p, label=f"{name} (AP={r['metrics']['PR-AUC']:.3f})")
        a.set(title=f"Precision-Recall ({s})", xlabel="Recall", ylabel="Precision")
        a.legend()
    plt.tight_layout()
    plt.savefig(config.ML_DIR / "pr_curves.png", dpi=150)
    plt.close()

    plt.figure(figsize=(5.5, 5))
    for s in ["full", "screening"]:
        fp, mp = calibration_curve(test["diabetes"], results[(s, "XGBoost")]["test_prob"], n_bins=10, strategy="quantile")
        plt.plot(mp, fp, "o-", label=f"{s}: XGBoost")
    plt.plot([0, 1], [0, 1], "k--", label="Hiệu chỉnh hoàn hảo")
    plt.xlabel("Xác suất dự đoán")
    plt.ylabel("Tỉ lệ dương tính thực tế")
    plt.title("Reliability diagram (tập test)")
    plt.legend()
    plt.savefig(config.ML_DIR / "reliability.png", dpi=150)
    plt.close()


# ---------------------------------------------------------------- chạy
def main(use_mlp: bool = False):
    df = load_clean()
    train, val, test = split(df)

    # kiểm tra mâu thuẫn giữa nhãn và ngưỡng chẩn đoán (đưa vào báo cáo)
    hb = pd.cut(df["HbA1c_level"], [0, 5.7, 6.5, 7.0, 20], right=False)
    print("\nTỉ lệ nhãn dương theo HbA1c:\n", df.groupby(hb, observed=True)["diabetes"].agg(["mean", "count"]).round(4))
    gl = pd.cut(df["blood_glucose_level"], [0, 100, 126, 200, 1000], right=False)
    print("\nTỉ lệ nhãn dương theo đường huyết:\n", df.groupby(gl, observed=True)["diabetes"].agg(["mean", "count"]).round(4))

    spw = (train["diabetes"] == 0).sum() / (train["diabetes"] == 1).sum()
    models = {
        "Logistic Regression": lambda: LogisticRegression(class_weight="balanced", max_iter=1000),
        "Random Forest": lambda: RandomForestClassifier(n_estimators=300, class_weight="balanced_subsample",
                                                        min_samples_leaf=2, n_jobs=-1, random_state=42),
        "XGBoost": lambda: XGBClassifier(n_estimators=400, max_depth=5, learning_rate=0.05, scale_pos_weight=spw,
                                         eval_metric="logloss", n_jobs=-1, random_state=42),
    }
    results = {}
    for set_name, feats in [("full", FULL), ("screening", SCREEN)]:
        for name, make in models.items():
            print(f"huấn luyện {set_name} / {name}")
            results[(set_name, name)] = fit_and_evaluate(make(), feats, train, val, test)
        if use_mlp:
            results[(set_name, "MLP (PyTorch)")] = fit_mlp(feats, train, val, test, spw)

    table = pd.DataFrame({k: v["metrics"] for k, v in results.items()}).T.round(4)
    table["threshold"] = [round(v["threshold"], 4) for v in results.values()]
    table.to_csv(config.ML_DIR / "metrics.csv")
    print("\n", table.sort_index())

    for set_name in ("full", "screening"):      # mô hình phục vụ agent: XGBoost
        r = results[(set_name, "XGBoost")]
        joblib.dump({"model": r["calibrated"], "threshold": r["threshold"], "features": r["features"]},
                    config.ML_DIR / f"model_{set_name}.pkl")
        print(f"lưu model_{set_name}.pkl, ngưỡng {r['threshold']:.4f}")
    plots(results, test)


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("--mlp", action="store_true", help="huấn luyện thêm MLP PyTorch")
    main(ap.parse_args().mlp)
