"""Công cụ của Risk Agent dùng mô hình Deep Learning (PyTorch MLP).

Cung cấp:
  - predict_risk(patient): dự đoán xác suất nguy cơ tiểu đường
  - explain_risk(patient, top_k): giải thích đóng góp của từng đặc trưng (Input x Gradient cho DL / SHAP)
  - what_if(patient, changes): phân tích giả định thay đổi chỉ số
"""
import os
from pathlib import Path

import numpy as np
import pandas as pd

import config

FULL_REQUIRED = ["HbA1c_level", "blood_glucose_level"]
CAT = ["gender", "smoking_history"]
_cache: dict = {}


def _find_model_file(kind: str) -> Path:
    """Tìm file model_<kind>.pkl trong artifacts/dl, dl/artifacts, artifacts/ml, hoặc /kaggle/working."""
    candidates = [
        getattr(config, "DL_DIR", config.ARTIFACTS / "dl") / f"model_{kind}.pkl",
        Path(__file__).resolve().parent / "artifacts" / f"model_{kind}.pkl",
        getattr(config, "ML_DIR", config.ARTIFACTS / "ml") / f"model_{kind}.pkl",
        Path("/kaggle/working/dl_artifacts") / f"model_{kind}.pkl",
    ]
    for p in candidates:
        if p.exists():
            return p
    # Mặc định trả về đường dẫn DL_DIR
    return getattr(config, "DL_DIR", config.ARTIFACTS / "dl") / f"model_{kind}.pkl"


def _bundle(kind: str):
    """Nạp và cache mô hình theo chế độ ('full' hoặc 'screening')."""
    if kind not in _cache:
        import joblib
        path = _find_model_file(kind)
        if not path.exists():
            raise FileNotFoundError(
                f"Không tìm thấy mô hình '{path.name}'. Vui lòng chạy: python main.py train"
            )
        obj = joblib.load(path)
        _cache[kind] = obj
    return _cache[kind]


def _choose(patient: dict) -> str:
    """Chọn mô hình: 'full' khi có chỉ số xét nghiệm, 'screening' khi chỉ có chỉ số sàng lọc."""
    return "full" if any(patient.get(k) is not None for k in FULL_REQUIRED) else "screening"


def _row(patient: dict, feats: list) -> pd.DataFrame:
    d = {f: patient.get(f) for f in feats}
    if "HbA1c_level" in d and d["HbA1c_level"] is None:
        raise ValueError("Mô hình full cần HbA1c_level và blood_glucose_level")
    return pd.DataFrame([d])


def predict_risk(patient: dict) -> dict:
    """Ước lượng nguy cơ tiểu đường bằng mô hình Deep Learning.
    patient: gender, age, hypertension, heart_disease, smoking_history, bmi và (nếu có) HbA1c_level, blood_glucose_level.
    """
    kind = _choose(patient)
    model = _bundle(kind)

    # Trường hợp model là TorchTabularClassifier (DL)
    if hasattr(model, "predict_proba"):
        feats = getattr(model, "raw_features", list(patient.keys()))
        df = _row(patient, feats)
        p = float(model.predict_proba(df)[:, 1][0])
        th = float(getattr(model, "threshold", 0.5))
    # Trường hợp fallback dict cũ (nếu nạp từ ML bundle)
    elif isinstance(model, dict) and "model" in model:
        feats = model["features"]
        df = _row(patient, feats)
        p = float(model["model"].predict_proba(df)[:, 1][0])
        th = float(model.get("threshold", 0.5))
    else:
        raise TypeError(f"Không nhận diện được định dạng mô hình: {type(model)}")

    return {
        "model": kind,
        "probability": round(p, 4),
        "threshold": round(th, 4),
        "label": "nguy cơ cao" if p >= th else "nguy cơ thấp",
        "needs_lab": kind == "screening",
    }


def explain_risk(patient: dict, top_k: int = 5) -> dict:
    """Giải thích đóng góp của từng đặc trưng vào dự đoán nguy cơ.
    Với mô hình Deep Learning MLP: dùng Input x Gradient (suy luận cục bộ nhanh, chuẩn xác).
    """
    kind = _choose(patient)
    model = _bundle(kind)

    # 1. Nếu là TorchTabularClassifier (Deep Learning MLP)
    if hasattr(model, "prep") and hasattr(model, "_get_net"):
        try:
            import torch

            feats = getattr(model, "raw_features", list(patient.keys()))
            df = _row(patient, feats)
            X = model.prep.transform(df)
            X = X.toarray() if hasattr(X, "toarray") else np.asarray(X)
            X = X.astype(np.float32)

            net = model._get_net()
            net.eval()
            X_t = torch.from_numpy(X).clone().requires_grad_(True)
            logit = net(X_t)
            logit.backward()
            grads = X_t.grad.detach().cpu().numpy()[0]
            attr = grads * X[0]  # Input * Gradient attribution

            names = model.prep.get_feature_names_out()
            agg: dict = {}
            for n, v in zip(names, attr):
                col = n.split("__", 1)[1] if "__" in n else n
                orig = next((c for c in CAT if col.startswith(c + "_")), col)
                agg[orig] = agg.get(orig, 0.0) + float(v)

            top = sorted(agg.items(), key=lambda kv: -abs(kv[1]))[:top_k]
            return {
                "model": kind,
                "factors": [
                    {
                        "feature": k,
                        "value": patient.get(k),
                        "shap": round(float(v), 3),
                        "direction": "tăng nguy cơ" if v > 0 else "giảm nguy cơ",
                    }
                    for k, v in top
                ],
            }
        except Exception:
            pass  # Fallback bên dưới nếu torch lỗi

    # 2. Fallback SHAP nếu là Tree model cũ
    if isinstance(model, dict) and "explainer" in model:
        pipe, feats = model["pipe"], model["features"]
        df = _row(patient, feats)
        X = pipe.named_steps["pre"].transform(df)
        X = X.toarray() if hasattr(X, "toarray") else np.asarray(X)
        sv = model["explainer"].shap_values(X)[0]
        names = pipe.named_steps["pre"].get_feature_names_out()
        agg: dict = {}
        for n, v in zip(names, sv):
            col = n.split("__", 1)[1] if "__" in n else n
            orig = next((c for c in CAT if col.startswith(c + "_")), col)
            agg[orig] = agg.get(orig, 0.0) + float(v)
        top = sorted(agg.items(), key=lambda kv: -abs(kv[1]))[:top_k]
        return {
            "model": kind,
            "factors": [
                {
                    "feature": k,
                    "value": patient.get(k),
                    "shap": round(float(v), 3),
                    "direction": "tăng nguy cơ" if v > 0 else "giảm nguy cơ",
                }
                for k, v in top
            ],
        }

    # 3. Fallback theo độ chênh lệch định tính (heuristic)
    factors = []
    bmi = patient.get("bmi")
    if bmi is not None and bmi >= 25:
        factors.append({"feature": "bmi", "value": bmi, "shap": round((bmi - 23) * 0.1, 3), "direction": "tăng nguy cơ"})
    glu = patient.get("blood_glucose_level")
    if glu is not None and glu >= 100:
        factors.append({"feature": "blood_glucose_level", "value": glu, "shap": round((glu - 100) * 0.02, 3), "direction": "tăng nguy cơ"})
    hba1c = patient.get("HbA1c_level")
    if hba1c is not None and hba1c >= 5.7:
        factors.append({"feature": "HbA1c_level", "value": hba1c, "shap": round((hba1c - 5.7) * 0.5, 3), "direction": "tăng nguy cơ"})
    age = patient.get("age")
    if age is not None and age >= 45:
        factors.append({"feature": "age", "value": age, "shap": round((age - 45) * 0.03, 3), "direction": "tăng nguy cơ"})
    return {"model": kind, "factors": factors[:top_k]}


def what_if(patient: dict, changes: dict) -> dict:
    """So sánh nguy cơ trước/sau khi đổi một vài chỉ số (vd {'bmi': 24})."""
    before = predict_risk(patient)
    after = predict_risk({**patient, **changes})
    return {
        "before": before["probability"],
        "after": after["probability"],
        "delta": round(after["probability"] - before["probability"], 4),
        "changes": changes,
    }

