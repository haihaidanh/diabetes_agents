"""DL Prediction Agent: tra thong diep theo hop dong (muc 6.2 tai lieu cua thay)."""
import os

import joblib

from .config import default_model_dir
from .model import TorchTabularClassifier  # noqa: F401  (can import de joblib nap duoc .pkl)


class DLPredictionAgent:
    """mode: 'full' | 'screening'."""

    def __init__(self, model_dir=None, threshold=0.5):
        model_dir = model_dir or default_model_dir()
        self.models = {m: joblib.load(os.path.join(model_dir, f"model_{m}.pkl"))
                       for m in ("full", "screening")}
        self.threshold = threshold

    def run(self, request_id: str, features: dict, mode: str = "full") -> dict:
        try:
            clf = self.models[mode]
            score = float(clf.predict_proba(features)[0, 1])
            return {"request_id": request_id, "agent": "DLPredictionAgent", "status": "ok",
                    "payload": {"prediction": int(score >= self.threshold),
                                "score": round(score, 3), "mode": mode},
                    "evidence": [], "model_version": clf.model_version}
        except Exception as e:  # loi tra ve tuong minh
            return {"request_id": request_id, "agent": "DLPredictionAgent", "status": "error",
                    "payload": {"message": str(e)}, "evidence": [], "model_version": None}
