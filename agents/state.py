"""Trạng thái dùng chung của các agent và decorator ghi vết chạy."""
import functools
import operator
import time
from typing import Annotated, TypedDict


class CaseState(TypedDict, total=False):
    question: str
    form: dict
    intent: str                       # assess | ask | both
    patient: dict
    ask_user: str | None              # có giá trị thì kết thúc lượt bằng câu hỏi lại
    risk: dict
    risk_request: str | None          # Risk nhờ Intake tìm thêm xét nghiệm
    knowledge_done: bool              # False thì Knowledge tự lặp thêm một vòng
    evidence: list
    lab_checks: list
    draft: str
    critique: dict
    answer: str
    counters: Annotated[dict, lambda a, b: {**a, **b}]
    trace: Annotated[list, operator.add]


MAX_KNOWLEDGE, MAX_CRITIC = 3, 2


def traced(name):
    """Bọc node: đo thời gian, số lượt LLM; node trả `_decision` để ghi vào vết."""
    def deco(fn):
        @functools.wraps(fn)
        def wrapper(state):
            from . import llm
            t, c0 = time.time(), llm.CALLS
            out = fn(state)
            dec = out.pop("_decision", "")
            out["trace"] = [{"agent": name, "decision": dec, "sec": round(time.time() - t, 1), "llm": llm.CALLS - c0}]
            return out
        return wrapper
    return deco
