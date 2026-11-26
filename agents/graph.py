"""Đồ thị LangGraph: 6 agent + Finalize, định tuyến động với ba cạnh quay lui.

  Risk -> Intake        (vùng xám, thiếu xét nghiệm: nhờ Intake tìm thêm)
  Knowledge -> Knowledge (chưa đủ bằng chứng: tự mở rộng truy vấn, tối đa 3 vòng)
  Critic -> Advisor     (bản nháp không đạt: viết lại, tối đa 2 vòng)
"""
import re
from functools import lru_cache
from time import perf_counter

from langgraph.graph import END, START, StateGraph
from langgraph.types import Send

import config
from common.text import read_jsonl

from .agents import advisor_node, intake_node, knowledge_node, risk_node, supervisor_node
from .critic import critic_node
from .monitor import MonitorAgent
from .settings import SETTINGS
from .state import MAX_CRITIC, CaseState, traced
from .vision_agent import vision_node

DISCLAIMER = "⚠️ Kết quả chỉ mang tính tham khảo, không thay thế chẩn đoán của bác sĩ."
INTERNAL_FEEDBACK = re.compile(
    r"(?:^|\n)\s*(?:lỗi cần sửa|các lỗi phải sửa|các lỗi cần sửa)\s*:?.*$",
    re.IGNORECASE | re.MULTILINE,
)
META_OPENING = re.compile(
    r"^\s*(?:"
    r"Tôi hiểu bạn muốn[^.?!]*[.?!]\s*|"
    r"Dựa trên (?:các )?(?:đoạn văn|bằng chứng)[^.?!]*[,:]?\s*"
    r")",
    re.IGNORECASE,
)
LABEL_LEAK = re.compile(
    r"(?:^|\n)\s*bằng chứng\s*:\s*.*?(?=\n\n|\n[A-ZÀ-Ỹ]|\Z)",
    re.IGNORECASE | re.DOTALL,
)
ADVICE_PREFIX = re.compile(
    r"(?:^|\n)\s*(?:lời khuyên|khuyến nghị)\s*:\s*",
    re.IGNORECASE,
)


@lru_cache(maxsize=1)
def _titles() -> dict:
    try:
        return {c["url"]: c["page"] for c in read_jsonl(config.KB_DIR / "chunks_final.jsonl")}
    except FileNotFoundError:
        return {}


def _vision_answer(prediction: dict) -> str:
    if prediction.get("uncertain"):
        return (
            "Chưa đủ cơ sở để đưa ra kết luận phân loại. "
            "Độ tin cậy của mô hình đối với hình ảnh đầu vào chưa đạt ngưỡng yêu cầu."
        )

    label = prediction.get("label")

    if label == "loet_ban_chan":
        return (
            "Phát hiện dấu hiệu hình ảnh nghi ngờ loét bàn chân do đái tháo đường. "
            "Nếu có biểu hiện bất thường hoặc nghi ngờ mắc bệnh, "
            "bạn nên đến cơ sở y tế để được thăm khám và đánh giá chính xác."
        )

    if label == "vong_mac_tieu_duong":
        return (
            "Phát hiện dấu hiệu hình ảnh nghi ngờ bệnh võng mạc đái tháo đường. "
            "Bạn nên đến cơ sở y tế hoặc khám chuyên khoa mắt để được kiểm tra, "
            "đánh giá và xác định tình trạng bệnh chính xác."
        )

    if label == "ban_chan_binh_thuong":
        return (
            "Không phát hiện dấu hiệu hình ảnh đặc trưng của loét bàn chân "
            "trong phạm vi phân loại của mô hình. "
            "Kết quả này không loại trừ hoàn toàn nguy cơ mắc bệnh. "
            "Nếu xuất hiện các triệu chứng bất thường, bạn nên đến cơ sở y tế "
            "để được thăm khám."
        )

    return (
        "Không ghi nhận dấu hiệu thuộc các nhóm bệnh lý được mô hình hỗ trợ "
        "phân loại trong hình ảnh đầu vào. "
        "Kết quả này không đồng nghĩa với việc hình ảnh hoàn toàn bình thường. "
        "Nếu có biểu hiện bất thường, bạn nên đến cơ sở y tế để được thăm khám "
        "và đánh giá chính xác."
    )


@traced("finalize")
def finalize_node(state):
    if state.get("ask_user"):
        return {"answer": state["ask_user"], "_decision": "hỏi lại người dùng"}
    if state.get("vision_result"):
        return {
            "answer": _vision_answer(state["vision_result"]),
            "_decision": "trả lời trực tiếp theo kết quả phân loại ảnh",
        }
    d, ev = state.get("draft", ""), {e["id"]: e for e in state.get("evidence") or []}
    # Critic feedback is internal control data, never part of the user-facing answer.
    d = INTERNAL_FEEDBACK.split(d, maxsplit=1)[0].rstrip()
    d = META_OPENING.sub("", d, count=1).lstrip()
    d = LABEL_LEAK.sub("", d)
    d = ADVICE_PREFIX.sub("\n\n", d)
    d = re.sub(r"\n{3,}", "\n\n", d).strip()
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
after_start = lambda s: "vision" if s.get("vision_image") else "supervisor"
after_risk = lambda s: "intake" if s.get("risk_request") else "risk_complete"
after_knowledge = lambda s: "advisor" if s.get("knowledge_done", True) else "knowledge"
after_advisor = lambda s: (
    "finalize"
    if s.get("vision_result")
    else "critic" if (s.get("draft") and SETTINGS["use_critic"]) else "finalize"
)


def after_intake_parallel(state):
    if state.get("ask_user"):
        return "finalize"
    if (state.get("counters") or {}).get("risk_asked", 0):
        return "risk"
    return [Send("risk", state), Send("knowledge_init", state)]


def after_parallel_knowledge(state):
    return "knowledge_parallel" if not state.get("knowledge_done", True) else "knowledge_complete"


def _barrier_node(_state):
    return {}


def after_critic(s):
    c = s.get("critique") or {}
    # critic_rounds được tăng ngay trong critic_node: tối đa MAX_CRITIC lần viết lại
    return "advisor" if not c.get("passed") and (s.get("counters") or {}).get("critic_rounds", 0) <= MAX_CRITIC else "finalize"


def build_graph():
    g = StateGraph(CaseState)
    for n, f in [("supervisor", supervisor_node), ("intake", intake_node), ("risk", risk_node), ("knowledge", knowledge_node),
                 ("knowledge_init", knowledge_node), ("knowledge_parallel", knowledge_node),
                 ("risk_complete", _barrier_node), ("knowledge_complete", _barrier_node),
                 ("parallel_complete", _barrier_node),
                 ("vision", vision_node), ("advisor", advisor_node), ("critic", critic_node),
                 ("finalize", finalize_node)]:
        g.add_node(n, f)
    g.add_conditional_edges(START, after_start, ["vision", "supervisor"])
    g.add_edge("vision", "supervisor")
    g.add_conditional_edges("supervisor", after_supervisor, ["intake", "knowledge"])
    g.add_conditional_edges("intake", after_intake_parallel, ["risk", "knowledge_init", "finalize"])
    g.add_conditional_edges("risk", after_risk, ["intake", "risk_complete"])
    g.add_conditional_edges("knowledge", after_knowledge, ["knowledge", "advisor"])
    g.add_conditional_edges("knowledge_init", after_parallel_knowledge, ["knowledge_parallel", "knowledge_complete"])
    g.add_conditional_edges("knowledge_parallel", after_parallel_knowledge, ["knowledge_parallel", "knowledge_complete"])
    g.add_edge(["risk_complete", "knowledge_complete"], "parallel_complete")
    g.add_edge("parallel_complete", "advisor")
    g.add_conditional_edges("advisor", after_advisor, ["critic", "finalize"])
    g.add_conditional_edges("critic", after_critic, ["advisor", "finalize"])
    g.add_edge("finalize", END)
    return g.compile()


_GRAPH = None
_MONITOR = MonitorAgent()


def run_case(
    question: str,
    form: dict | None = None,
    patient: dict | None = None,
    vision_image: bytes | None = None,
) -> dict:
    """Chạy một lượt hội thoại. `patient` là hồ sơ đã có từ lượt trước (hội thoại nhiều lượt)."""
    global _GRAPH
    _GRAPH = _GRAPH or build_graph()
    started = perf_counter()
    try:
        result = _GRAPH.invoke({"question": question, "form": form or {}, "patient": patient or {},
                                "vision_image": vision_image,
                                "evidence": [], "counters": {}, "trace": []}, {"recursion_limit": 40})
    except Exception as exc:
        _MONITOR.record({}, (perf_counter() - started) * 1000, error=type(exc).__name__)
        raise
    _MONITOR.record(result, (perf_counter() - started) * 1000)
    return result
