import json

from agents.monitor import MonitorAgent


def test_monitor_records_summary_without_patient_data(tmp_path):
    log_path = tmp_path / "audit.jsonl"
    monitor = MonitorAgent(log_path)
    monitor.record({
        "question": "private question",
        "patient": {"age": 52},
        "intent": "both",
        "risk": {"model": "full"},
        "trace": [{"llm": 2, "decision": "done"}],
        "evidence": [{"quote": "evidence"}],
        "critique": {"passed": True},
    }, 123.45)

    entry = json.loads(log_path.read_text(encoding="utf-8"))
    assert entry["intent"] == "both"
    assert entry["latency_ms"] == 123.5
    assert entry["risk_model"] == "full"
    assert entry["llm_calls"] == 2
    assert entry["evidence_count"] == 1
    assert entry["critique_passed"] is True
    assert entry["run_error"] is None
    assert "private question" not in json.dumps(entry)
    assert "patient" not in entry


def test_monitor_records_failed_run(tmp_path):
    log_path = tmp_path / "audit.jsonl"
    MonitorAgent(log_path).record({}, 10, error="RuntimeError")

    entry = json.loads(log_path.read_text(encoding="utf-8"))
    assert entry["run_error"] == "RuntimeError"
    assert entry["risk_model"] == "unknown"
