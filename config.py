"""Cấu hình trung tâm: đường dẫn và tên mô hình. Có thể ghi đè bằng biến môi trường."""
import os
from pathlib import Path

ROOT = Path(__file__).resolve().parent
DATA_DIR = Path(os.getenv("DATA_DIR", ROOT / "data"))
RAW_CSV = Path(os.getenv("DIABETES_CSV", DATA_DIR / "diabetes.csv"))
HTML_DIR = Path(os.getenv("HTML_DIR", DATA_DIR / "raw_html"))      # các trang Long Châu lưu bằng SingleFile

ARTIFACTS = Path(os.getenv("ARTIFACTS_DIR", ROOT / "artifacts"))
ML_DIR = ARTIFACTS / "ml"      # model_full.pkl, model_screening.pkl, metrics.csv, hình
KB_DIR = ARTIFACTS / "kb"      # chunks_final.jsonl, kg.pkl, emb.npz, ents.json ...
EVAL_DIR = ARTIFACTS / "eval"  # kết quả ablation

LLM_MODEL = os.getenv("LLM_MODEL", "qwen2.5:3b")
EMBED_MODEL = os.getenv("EMBED_MODEL", "bge-m3")
FAST_MODE = os.getenv("FAST_MODE", "1").lower() not in ("0", "false", "no")
LLM_NUM_CTX = int(os.getenv("LLM_NUM_CTX", "2048" if FAST_MODE else "4096"))
LLM_NUM_PREDICT = int(os.getenv("LLM_NUM_PREDICT", "512" if FAST_MODE else "1024"))
LLM_KEEP_ALIVE = os.getenv("LLM_KEEP_ALIVE", "30m")
LLM_SUBMIT_RETRIES = int(os.getenv("LLM_SUBMIT_RETRIES", "0" if FAST_MODE else "2"))
LLM_TOOL_STEPS = int(os.getenv("LLM_TOOL_STEPS", "2" if FAST_MODE else "5"))

for _d in (ML_DIR, KB_DIR, EVAL_DIR):
    _d.mkdir(parents=True, exist_ok=True)
