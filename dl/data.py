"""Doc du lieu va xay dung bo tien xu ly."""
import glob
import os

import pandas as pd
from sklearn.compose import ColumnTransformer
from sklearn.impute import SimpleImputer
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import OneHotEncoder, StandardScaler

from .config import TARGET_CANDIDATES


def find_csv(name: str = "diabetes_dataset.csv") -> str:
    """Tim file o thu muc hien tai, data/, hoac /kaggle/input."""
    for p in (name, os.path.join("data", name)):
        if os.path.exists(p):
            return p
    hits = glob.glob(f"/kaggle/input/**/{name}", recursive=True)
    if not hits:
        raise FileNotFoundError(f"Khong thay {name}. Truyen csv_path=...")
    return hits[0]


def detect_target(df: pd.DataFrame, target: str | None = None) -> str:
    if target:
        return target
    for c in TARGET_CANDIDATES:
        if c in df.columns:
            return c
    raise ValueError(f"Khong tu nhan duoc cot nhan: {list(df.columns)}. Truyen target=...")


def build_preprocess(X: pd.DataFrame) -> ColumnTransformer:
    """So: dien median + chuan hoa. Phan loai: dien 'missing' + one-hot."""
    cat = [c for c in X.columns if X[c].dtype == "object" or str(X[c].dtype) == "category"]
    num = [c for c in X.columns if c not in cat]
    return ColumnTransformer([
        ("num", Pipeline([("imp", SimpleImputer(strategy="median")),
                          ("sc", StandardScaler())]), num),
        ("cat", Pipeline([("imp", SimpleImputer(strategy="constant", fill_value="missing")),
                          ("oh", OneHotEncoder(handle_unknown="ignore", sparse_output=False))]), cat),
    ])
