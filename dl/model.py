"""Kien truc MLP va lop dong goi (tien xu ly + MLP) giong sklearn.
LUU Y: pickle ghi nho duong dan import 'dl.model', nen huan luyen va nap
.pkl phai cung dung 'from dl.model import ...' (chay tu thu muc goc project)."""
import numpy as np
import pandas as pd
import torch
import torch.nn as nn


class DiabetesMLP(nn.Module):
    def __init__(self, n_features: int):
        super().__init__()
        self.net = nn.Sequential(
            nn.Linear(n_features, 64), nn.ReLU(), nn.Dropout(0.2),
            nn.Linear(64, 32), nn.ReLU(), nn.Dropout(0.1),
            nn.Linear(32, 1),  # logit; sigmoid ap dung khi du doan
        )

    def forward(self, x):
        return self.net(x).squeeze(-1)


class TorchTabularClassifier:
    """Dong goi tien xu ly + MLP de pickle/joblib; co predict_proba, predict."""

    def __init__(self, prep, state_dict_np, n_features, raw_features,
                 model_version, threshold=0.5):
        self.prep = prep
        self.state_dict_np = state_dict_np  # numpy -> pickle on dinh
        self.n_features = n_features
        self.raw_features = raw_features
        self.model_version = model_version
        self.threshold = threshold
        self.classes_ = np.array([0, 1])
        self._net = None

    def _get_net(self):
        if self._net is None:
            net = DiabetesMLP(self.n_features)
            net.load_state_dict({k: torch.from_numpy(v) for k, v in self.state_dict_np.items()})
            net.eval()
            self._net = net
        return self._net

    def __getstate__(self):
        d = self.__dict__.copy()
        d["_net"] = None  # khong pickle mang torch dang cache
        return d

    def _to_frame(self, X):
        if isinstance(X, dict):
            X = pd.DataFrame([X])
        return pd.DataFrame(X).reindex(columns=self.raw_features)  # dung ten + thu tu cot goc

    def predict_proba(self, X):
        x = self.prep.transform(self._to_frame(X)).astype(np.float32)
        with torch.no_grad():
            p = torch.sigmoid(self._get_net()(torch.from_numpy(x))).numpy()
        return np.column_stack([1 - p, p])

    def predict(self, X):
        return (self.predict_proba(X)[:, 1] >= self.threshold).astype(int)
