"""Critic: kiểm duyệt bản nháp chủ yếu bằng luật tất định (code), LLM chỉ kiểm phần code không kiểm được."""
import re

from pydantic import BaseModel

from common.text import norm

from . import llm
from .settings import SETTINGS
from .state import MAX_CRITIC, traced

NUMBER = re.compile(r"(\d+(?:[.,]\d+)?)\s*(%|mg/dl|mmol/l)", re.I)
DOSAGE = re.compile(r"\d[\d.,]*\s*(?:mg|mcg|µg|viên|lần\s*/\s*ngày|lần mỗi ngày)\b(?!\s*/)", re.I)
DIAG = re.compile(r"(bạn|anh|chị|bà|ông)\s+(đã\s+)?(bị|mắc)\s+(bệnh\s+)?(tiểu đường|đái tháo đường)", re.I)
DOCTOR = re.compile(r"bác sĩ|chuyên gia y tế|cơ sở y tế", re.I)
TOL = 0.06


def allowed_numbers(state: dict) -> set:
    """Các con số được phép xuất hiện: hồ sơ người dùng, kết quả mô hình, ngưỡng và bằng chứng."""
    s, p, r = set(), state.get("patient") or {}, state.get("risk")
    for k in ("HbA1c_level", "blood_glucose_level", "age", "bmi"):
        if k in p:
            s.add(float(p[k]))
    if "blood_glucose_level" in p:
        s |= {round(p["blood_glucose_level"] / 18.016, 1), round(p["blood_glucose_level"] / 18.016)}
    if r:
        for k in ("probability", "threshold"):
            s |= {round(r[k] * 100, 1), round(r[k] * 100)}
        if "what_if" in r:
            s |= {round(r["what_if"][k] * 100, 1) for k in ("before", "after")} | {round(r["what_if"]["changes"]["bmi"], 1)}
    texts = [e["claim"] + " " + e["quote"] for e in state.get("evidence") or []] + [c["condition"] for c in state.get("lab_checks") or []]
    for t in texts:
        s |= {float(x.replace(",", ".")) for x in re.findall(r"\d+(?:[.,]\d+)?", t)}
    return s


def threshold_issues(lab_checks: list, draft: str) -> list:
    """Chỉ số đã đạt ngưỡng chẩn đoán thì câu trả lời phải nói ra (và nêu giả định đo lúc đói)."""
    issues, text = [], norm(draft)
    for c in lab_checks or []:
        if c["met"] and c["disease"] == "Đái tháo đường":
            names = ("hba1c",) if c["test"] == "HbA1c" else ("duong huyet", "glucose")
            if not any(n in text for n in names):
                issues.append(f"Phải nêu rằng {c['test']} của người dùng đạt ngưỡng '{c['condition']}'.")
            elif c["assumption"] and "doi" not in text:
                issues.append("Phải nói rõ giả định: so ngưỡng lúc đói chỉ đúng nếu mẫu đo lúc đói.")
    return issues


def rule_issues(state: dict, draft: str) -> list:
    issues, ev = [], state.get("evidence") or []
    cited = [int(n) for n in re.findall(r"\[(\d+)\]", draft)]
    bad = sorted({n for n in cited if not 1 <= n <= len(ev)})
    if bad:
        issues.append(f"Trích dẫn {bad} không tồn tại; chỉ được dùng [1]–[{len(ev)}].")
    if ev and not cited:
        issues.append("Chưa có trích dẫn [n] nào cho thông tin y khoa.")
    allowed = allowed_numbers(state)
    for raw, unit in NUMBER.findall(re.sub(r"\[\d+\]", "", draft)):
        if not any(abs(float(raw.replace(",", ".")) - a) <= TOL for a in allowed):
            issues.append(f"Con số {raw}{unit} không khớp kết quả mô hình hay nguồn.")
    if DOSAGE.search(draft):
        issues.append("Không được nêu liều/hàm lượng thuốc (mg, số viên, số lần dùng).")
    if DIAG.search(draft):
        issues.append("Không được khẳng định người dùng đã mắc bệnh; chỉ nói đạt ngưỡng chẩn đoán và cần bác sĩ xác nhận.")
    if not DOCTOR.search(draft):
        issues.append("Chưa khuyên gặp bác sĩ.")
    issues += threshold_issues(state.get("lab_checks"), draft)
    return list(dict.fromkeys(issues))


class Verdict(BaseModel):
    unsupported: list[str] = []


def llm_issues(state: dict, draft: str) -> list:
    ev = "\n".join(f"[{e['id']}] {e['claim']}: {e['quote']}" for e in state.get("evidence") or [])
    v = llm.submit("Bạn là Critic. Liệt kê (tối đa 2) khẳng định y khoa trong câu trả lời KHÔNG có trong bằng chứng hoặc kết quả mô hình. "
                   "Không tính lời khuyên gặp bác sĩ hay lời nhắc chung. Nếu mọi thứ đều có nguồn, trả về danh sách rỗng.",
                   f"BẰNG CHỨNG:\n{ev}\n\nCÂU TRẢ LỜI:\n{draft}", Verdict)
    return [f"Khẳng định thiếu nguồn: {x}" for x in (v.unsupported[:2] if v else [])]


@traced("critic")
def critic_node(state):
    draft = state.get("draft", "")
    issues = rule_issues(state, draft)
    if not issues and SETTINGS["use_llm_critic"]:
        issues = llm_issues(state, draft)
    n = (state.get("counters") or {}).get("critic_rounds", 0) + 1
    nxt = "Advisor" if n <= MAX_CRITIC else "Finalize"
    return {"critique": {"passed": not issues, "issues": issues}, "counters": {"critic_rounds": n},
            "_decision": "đạt → Finalize" if not issues else f"bác ({len(issues)} lỗi: {issues[0][:60]}) → {nxt}"}
