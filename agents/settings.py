"""Công tắc cấu hình lúc chạy (dùng cho giao diện và thí nghiệm ablation)."""
import config

SETTINGS = {
    "use_critic": not config.FAST_MODE,
    "knowledge_mode": "rag" if config.FAST_MODE else "kg",
    "use_llm_critic": False if config.FAST_MODE else True,
    "show_sources": False,       # True: hiện số [n] và danh sách nguồn trong câu trả lời
}
