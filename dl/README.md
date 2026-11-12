# dl/ - Phan Deep Learning (DL Prediction Agent)

Thu muc nay chua code huan luyen MLP (PyTorch) va xuat model_full.pkl,
model_screening.pkl. Mac dinh ghi vao dl/artifacts/ (khong de len .pkl cu).

| File | Vai tro |
|---|---|
| config.py  | seed, tu khoa cot xet nghiem (che do screening), ten phien ban model |
| data.py    | tim CSV, nhan cot nhan, bo tien xu ly (so/phan loai) |
| metrics.py | Accuracy, Precision, Recall, F1, AUC |
| model.py   | DiabetesMLP, TorchTabularClassifier (predict_proba / predict) |
| train.py   | huan luyen MLP, so sanh voi ML (LogReg, RF), luu .pkl + metrics_dl.json |
| agent.py   | DLPredictionAgent (thong diep: request_id, agent, status, payload, evidence, model_version) |

Chay (tu thu muc goc project, can torch, scikit-learn, pandas, joblib):

    python -m dl.train --csv data/diabetes_dataset.csv
