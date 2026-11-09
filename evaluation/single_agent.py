"""Đường cơ sở: một LLM duy nhất, có công cụ nhưng không có phân vai, không Critic."""
from agents import llm
from agents.agents import make_tools, parse_rules
from kb import kg_tools as K

SYS = "Bạn là trợ lý tư vấn tiểu đường bằng tiếng Việt. Dùng công cụ khi cần. Trả lời ngắn gọn, có khuyên gặp bác sĩ."


def run_single(question: str) -> dict:
    c0 = llm.CALLS
    p = parse_rules(question)
    tools = [K.link_entities, K.neighbors, K.search_chunks] + (make_tools(p) if {"age", "gender", "bmi"} <= set(p) else [])
    log, ans = llm.run_tools(SYS, question, tools, max_steps=5, with_text=True)
    return {"answer": ans, "draft": ans, "evidence": [], "trace": [{"agent": "single", "decision": "", "sec": 0, "llm": llm.CALLS - c0}]}
