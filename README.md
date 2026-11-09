# Hệ đa agent tư vấn nguy cơ tiểu đường

ML (XGBoost + hiệu chỉnh isotonic + SHAP) → Knowledge Graph từ Nhà thuốc Long Châu (NetworkX, không cần Neo4j) → 6 agent LangGraph
(Supervisor, Intake, Risk, Knowledge, Advisor, Critic) chạy bằng Ollama (qwen3:8b, bge-m3), không cần API key.

## Chuẩn bị
```bash
pip install -r requirements.txt
ollama serve &            # Kaggle: phải chạy lại mỗi phiên
ollama pull qwen3:8b && ollama pull bge-m3
```
Mặc định hệ thống chạy chế độ nhanh (`FAST_MODE=1`): bỏ vòng Critic LLM, dùng RAG,
giảm số vòng gọi tool và giữ model trong RAM. Hệ thống dùng `qwen3:8b`. Nếu ưu tiên
tốc độ hơn nữa, có thể dùng model nhỏ hơn:
```powershell
ollama pull qwen2.5:3b
$env:LLM_MODEL = "qwen2.5:3b"
$env:FAST_MODE = "1"
python main.py ui
```
Các biến `LLM_NUM_CTX` (mặc định `2048` ở chế độ nhanh), `LLM_NUM_PREDICT`
(mặc định `512`) và `LLM_KEEP_ALIVE` (mặc định `30m`) điều chỉnh độ dài ngữ cảnh,
độ dài đầu ra và
thời gian giữ model trong RAM để tránh nạp lại giữa các câu hỏi.
Đặt `FAST_MODE=0` để khôi phục cấu hình đầy đủ với KG và Critic.
Đặt dữ liệu: `data/diabetes.csv` (hoặc biến môi trường `DIABETES_CSV`) và các trang HTML đã lưu vào `data/raw_html/`.

## Chạy theo thứ tự
```bash
python main.py train                 # -> artifacts/ml (model_full/screening.pkl, metrics.csv, biểu đồ)
python main.py parse                 # HTML -> artifacts/kb/chunks_final.jsonl
python main.py extract               # LLM trích triples (lâu, có cache llm_cache.jsonl)
python main.py thresholds            # xem ngưỡng chẩn đoán trích được để duyệt
python main.py kg                    # -> kg.pkl, precision_sample.csv
python main.py ask "Metformin có tác dụng phụ gì?"
python main.py ui                    # Gradio
python main.py eval                  # ablation 4 cấu hình x 24 kịch bản -> artifacts/eval/ablation.csv
python -m pytest                     # test không cần Ollama
```
**Việc phải làm tay:** gán nhãn đúng/sai cột `label` trong `artifacts/kb/precision_sample.csv` (50 dòng) để tính precision của KG.

## Cấu trúc
`config.py` đường dẫn · `common/` tiện ích · `ml/` huấn luyện + predictor · `kb/` parse, trích triples, ngưỡng, dựng KG, công cụ truy vấn ·
`agents/` state, llm, 5 agent, critic, graph, settings · `ui/` · `evaluation/` · `tests/`.
`agents/settings.py` bật/tắt Critic, chế độ Knowledge (`kg`/`rag`), hiện nguồn.
