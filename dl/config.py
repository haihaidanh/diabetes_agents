"""Cau hinh chung cho phan Deep Learning."""
import os

SEED = 42
TARGET_CANDIDATES = ["diabetes", "Outcome", "outcome", "target", "label", "class"]

# Che do sang loc: loai cac cot co ten chua tu khoa xet nghiem.
# CHINH LAI cho khop voi model_screening cu neu khac.
LAB_KEYWORDS = ["hba1c", "glucose", "insulin"]

MODEL_VERSIONS = {
    "full": "diabetes_dl_full_v1",
    "screening": "diabetes_dl_screening_v1",
}


def default_model_dir() -> str:
    """Thu muc xuat .pkl moi (khong de len model_full.pkl / model_screening.pkl cu).
    Kaggle: /kaggle/working/dl_artifacts ; local: dl/artifacts"""
    if os.path.exists("/kaggle/working"):
        return "/kaggle/working/dl_artifacts"
    return os.path.join(os.path.dirname(os.path.abspath(__file__)), "artifacts")
