"""Đồ thị LangGraph: 6 agent + Finalize, định tuyến động với ba cạnh quay lui.

  Risk -> Intake        (vùng xám, thiếu xét nghiệm: nhờ Intake tìm thêm)
  Knowledge -> Knowledge (chưa đủ bằng chứng: tự mở rộng truy vấn, tối đa 3 vòng)
  Critic -> Advisor     (bản nháp không đạt: viết lại, tối đa 2 vòng)
"""
import re
from functools import lru_cache

from langgraph.graph import END, START, StateGraph

import config
from common.text import read_jsonl

from .agents import advisor_node, intake_node, knowledge_node, risk_node, supervisor_node
from .critic import critic_node
from .settings import SETTINGS
from .state import MAX_CRITIC, CaseState, traced

DISCLAIMER = ("⚠️ Kết quả chỉ mang tính tham khảo, được tạo tự động từ mô hình học máy và thông tin của Nhà thuốc Long Châu; "
              "không thay thế chẩn đoán của bác sĩ.")


@lru_cache(maxsize=1)
def _titles() -> dict:
    try:
        return {c["url"]: c["page"] for c in read_jsonl(config.KB_DIR / "chunks_final.jsonl")}
    except FileNotFoundError:
        return {}


@traced("finalize")
def finalize_node(state):
    if state.get("ask_user"):
        return {"answer": state["ask_user"], "_decision": "hỏi lại người dùng"}
    d, ev = state.get("draft", ""), {e["id"]: e for e in state.get("evidence") or []}
    cited = sorted({int(n) for n in re.findall(r"\[(\d+)\]", d) if int(n) in ev})
    note = (
        ""
        if SETTINGS["knowledge_mode"] == "kg" or (state.get("critique") or {}).get("passed", True)
        else "\n\n_(Câu trả lời chưa qua hết kiểm duyệt tự động.)_"
    )
    if SETTINGS["show_sources"]:
        by: dict = {}
        for n in cited:
            by.setdefault(ev[n]["url"], []).append(n)
        src = "\n".join(f"- {''.join(f'[{n}]' for n in ns)} [{_titles().get(u, 'Nguồn')}]({u})" for u, ns in by.items())
        ans = d + note + (f"\n\n**Nguồn (Nhà thuốc Long Châu):**\n{src}" if src else "") + "\n\n" + DISCLAIMER
    else:                                        # trích dẫn vẫn được kiểm ngầm, chỉ ẩn khi hiển thị
        ans = re.sub(r"\s*\[\d+\]", "", d) + note + "\n\n" + DISCLAIMER
    return {"answer": ans, "_decision": f"gắn {len(cited)} nguồn" if SETTINGS["show_sources"] else f"ẩn {len(cited)} nguồn"}


after_supervisor = lambda s: "knowledge" if s.get("intent") == "ask" else "intake"
after_intake = lambda s: "finalize" if s.get("ask_user") else "risk"
after_risk = lambda s: "intake" if s.get("risk_request") else "knowledge"
after_knowledge = lambda s: "advisor" if s.get("knowledge_done", True) else "knowledge"
after_advisor = lambda s: "critic" if (s.get("draft") and SETTINGS["use_critic"]) else "finalize"


def after_critic(s):
    c = s.get("critique") or {}
    # critic_rounds được tăng ngay trong critic_node: tối đa MAX_CRITIC lần viết lại
    return "advisor" if not c.get("passed") and (s.get("counters") or {}).get("critic_rounds", 0) <= MAX_CRITIC else "finalize"


def build_graph():
    g = StateGraph(CaseState)
    for n, f in [("supervisor", supervisor_node), ("intake", intake_node), ("risk", risk_node), ("knowledge", knowledge_node),
                 ("advisor", advisor_node), ("critic", critic_node), ("finalize", finalize_node)]:
        g.add_node(n, f)
    g.add_edge(START, "supervisor")
    g.add_conditional_edges("supervisor", after_supervisor, ["intake", "knowledge"])
    g.add_conditional_edges("intake", after_intake, ["risk", "finalize"])
    g.add_conditional_edges("risk", after_risk, ["intake", "knowledge"])
    g.add_conditional_edges("knowledge", after_knowledge, ["knowledge", "advisor"])
    g.add_conditional_edges("advisor", after_advisor, ["critic", "finalize"])
    g.add_conditional_edges("critic", after_critic, ["advisor", "finalize"])
    g.add_edge("finalize", END)
    return g.compile()


_GRAPH = None


def run_case(question: str, form: dict | None = None, patient: dict | None = None) -> dict:
    """Chạy một lượt hội thoại. `patient` là hồ sơ đã có từ lượt trước (hội thoại nhiều lượt)."""
    global _GRAPH
    _GRAPH = _GRAPH or build_graph()
    return _GRAPH.invoke({"question": question, "form": form or {}, "patient": patient or {},
                          "evidence": [], "counters": {}, "trace": []}, {"recursion_limit": 40})
