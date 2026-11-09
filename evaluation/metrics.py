"""Chỉ số tự động cho câu trả lời: dùng chính các luật của Critic để đo."""
import re
from agents.critic import DIAG, DOCTOR, DOSAGE, rule_issues


def score(out: dict) -> dict:
    ans, d = out.get("answer", ""), out.get("draft", "")
    ev = out.get("evidence") or []
    cited = {int(n) for n in re.findall(r"\[(\d+)\]", d)}
    tr = out.get("trace") or []
    return {
        "asked_back": bool(out.get("ask_user")),
        "rule_issues": len(rule_issues(out, d)) if d else 0,
        "has_dosage": bool(DOSAGE.search(ans)),
        "claims_diagnosis": bool(DIAG.search(ans)),
        "advises_doctor": bool(DOCTOR.search(ans)),
        "n_evidence": len(ev),
        "n_cited": len(cited & set(range(1, len(ev) + 1))),
        "llm_calls": sum(t["llm"] for t in tr),
        "seconds": round(sum(t["sec"] for t in tr), 1),
        "words": len(ans.split()),
    }
