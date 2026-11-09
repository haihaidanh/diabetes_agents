"""Công cụ của Risk Agent: predict_risk, explain_risk, what_if."""
import numpy as np
import pandas as pd

import config

FULL_REQUIRED = ["HbA1c_level", "blood_glucose_level"]
CAT = ["gender", "smoking_history"]
_cache: dict = {}


def _bundle(kind: str) -> dict:
    if kind not in _cache:
        import joblib
        import shap
        b = joblib.load(config.ML_DIR / f"model_{kind}.pkl")
        inner = b["model"].calibrated_classifiers_[0].estimator
        pipe = getattr(inner, "estimator", inner)          # FrozenEstimator -> Pipeline
        b["pipe"] = pipe
        b["explainer"] = shap.TreeExplainer(pipe.named_steps["clf"])
        _cache[kind] = b
    return _cache[kind]


def _choose(patient: dict) -> str:
    return "full" if any(patient.get(k) is not None for k in FULL_REQUIRED) else "screening"


def _row(patient: dict, feats: list) -> pd.DataFrame:
    d = {f: patient.get(f) for f in feats}
    if "HbA1c_level" in d and d["HbA1c_level"] is None:
        raise ValueError("Mô hình full cần HbA1c_level và blood_glucose_level")
    return pd.DataFrame([d])


def predict_risk(patient: dict) -> dict:
    """Ước lượng nguy cơ tiểu đường đã hiệu chỉnh. patient: gender, age, hypertension, heart_disease,
    smoking_history, bmi và (nếu có) HbA1c_level, blood_glucose_level."""
    kind = _choose(patient)
    b = _bundle(kind)
    p = float(b["model"].predict_proba(_row(patient, b["features"]))[:, 1][0])
    return {"model": kind, "probability": round(p, 4), "threshold": round(b["threshold"], 4),
            "label": "nguy cơ cao" if p >= b["threshold"] else "nguy cơ thấp", "needs_lab": kind == "screening"}


def explain_risk(patient: dict, top_k: int = 5) -> dict:
    """SHAP: đóng góp của từng đặc trưng (log-odds), gộp one-hot về cột gốc."""
    kind = _choose(patient)
    b = _bundle(kind)
    pipe, feats = b["pipe"], b["features"]
    X = pipe.named_steps["pre"].transform(_row(patient, feats))
    X = X.toarray() if hasattr(X, "toarray") else np.asarray(X)
    sv = b["explainer"].shap_values(X)[0]
    names = pipe.named_steps["pre"].get_feature_names_out()
    agg: dict = {}
    for n, v in zip(names, sv):
        col = n.split("__", 1)[1]
        orig = next((c for c in CAT if col.startswith(c + "_")), col)
        agg[orig] = agg.get(orig, 0.0) + float(v)
    top = sorted(agg.items(), key=lambda kv: -abs(kv[1]))[:top_k]
    return {"model": kind, "factors": [
        {"feature": k, "value": patient.get(k), "shap": round(v, 3),
         "direction": "tăng nguy cơ" if v > 0 else "giảm nguy cơ"} for k, v in top]}


def what_if(patient: dict, changes: dict) -> dict:
    """So sánh nguy cơ trước/sau khi đổi một vài chỉ số (vd {'bmi': 24})."""
    before = predict_risk(patient)
    after = predict_risk({**patient, **changes})
    return {"before": before["probability"], "after": after["probability"],
            "delta": round(after["probability"] - before["probability"], 4), "changes": changes}
