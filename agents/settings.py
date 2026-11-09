"""Công tắc cấu hình lúc chạy (dùng cho giao diện và thí nghiệm ablation)."""

SETTINGS = {
    "use_critic": True,          # False: bỏ Critic (cấu hình B)
    "knowledge_mode": "kg",      # "kg": GraphRAG đầy đủ | "rag": chỉ tìm kiếm vector trên đoạn văn (cấu hình C)
    "use_llm_critic": True,      # False: Critic chỉ dùng luật bằng code
    "show_sources": False,       # True: hiện số [n] và danh sách nguồn trong câu trả lời
}
