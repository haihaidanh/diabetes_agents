"""Do luong chat luong mo hinh."""
from sklearn.metrics import (accuracy_score, f1_score, precision_score,
                             recall_score, roc_auc_score)


def evaluate(y_true, y_prob, thr: float = 0.5) -> dict:
    p = (y_prob >= thr).astype(int)
    return {
        "accuracy": round(accuracy_score(y_true, p), 4),
        "precision": round(precision_score(y_true, p, zero_division=0), 4),
        "recall": round(recall_score(y_true, p), 4),
        "f1": round(f1_score(y_true, p), 4),
        "auc": round(roc_auc_score(y_true, y_prob), 4),
    }
