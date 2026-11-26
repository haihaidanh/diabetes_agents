"""Audit log tối thiểu cho mỗi lượt chạy, không ghi câu hỏi hay hồ sơ sức khỏe."""
import json
import threading
from datetime import datetime, timezone
from uuid import uuid4

import config


class MonitorAgent:
    def __init__(self, log_path=None):
        self.log_path = log_path or config.EVAL_DIR / "audit_log.jsonl"
        self._lock = threading.Lock()

    def record(self, state: dict, run_ms: float, error: str | None = None) -> None:
        trace = state.get("trace") or []
        risk = state.get("risk") or {}
        entry = {
            "run_id": str(uuid4()),
            "ts": datetime.now(timezone.utc).isoformat(),
            "intent": state.get("intent"),
            "latency_ms": round(run_ms, 1),
            "llm_model": config.LLM_MODEL,
            "risk_model": risk.get("model", "unknown"),
            "llm_calls": sum(t.get("llm", 0) for t in trace),
            "evidence_count": len(state.get("evidence") or []),
            "critique_passed": (state.get("critique") or {}).get("passed"),
            "errors": [t["decision"] for t in trace if "error" in t.get("decision", "").lower()],
            "run_error": error,
        }
        with self._lock:
            with self.log_path.open("a", encoding="utf-8") as log:
                log.write(json.dumps(entry, ensure_ascii=False) + "\n")
