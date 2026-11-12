"""Chạy cả đồ thị với LLM / mô hình / KG giả để kiểm tra định tuyến."""
from agents import agents as A, critic, graph, llm
from agents.settings import SETTINGS


def setup(monkeypatch, drafts):
    monkeypatch.setattr(llm, "submit", lambda *a, **k: None)
    monkeypatch.setattr(llm, "run_tools", lambda *a, **k: [])
    it = iter(drafts)
    monkeypatch.setattr(llm, "text", lambda *a, **k: next(it))
    monkeypatch.setattr(A.predictor, "predict_risk", lambda p: {"model": "full", "probability": 0.1, "threshold": 0.3,
                                                                  "label": "nguy cơ thấp", "needs_lab": False})
    monkeypatch.setattr(A.predictor, "explain_risk", lambda p, k=5: {"model": "full", "factors": [
        {"feature": "bmi", "value": 29, "direction": "tăng"}]})
    monkeypatch.setattr(A.K, "search_chunks", lambda q, top_k=4: [{"text": f"Triệu chứng là khát nước {i}", "url": "u", "page": "p", "section": "s"} for i in range(4)])
    monkeypatch.setattr(A.K, "link_entities", lambda t, k=5: [])
    monkeypatch.setattr(A.K, "explain_feature", lambda *a: {"lab_checks": []})
    SETTINGS.update(use_critic=True, knowledge_mode="rag", use_llm_critic=False)
    graph._GRAPH = None


def test_ask_flow(monkeypatch):
    setup(monkeypatch, ["Triệu chứng gồm khát nước [1]. Bạn nên gặp bác sĩ."])
    out = graph.run_case("Triệu chứng tiểu đường là gì?")
    assert [t["agent"] for t in out["trace"]] == ["supervisor", "knowledge", "advisor", "critic", "finalize"]
    assert "[1]" not in out["answer"]


def test_missing_data_asks_back(monkeypatch):
    setup(monkeypatch, [])
    out = graph.run_case("Nguy cơ của tôi thế nào?")
    assert "Bạn vui lòng" in out["answer"] and out["trace"][-1]["agent"] == "finalize"


def test_personal_condition_can_be_context_for_knowledge_question(monkeypatch):
    monkeypatch.setattr(llm, "submit", lambda *a, **k: None)
    out = A.supervisor_node({
        "question": "Tôi bị tăng huyết áp thì có nguy cơ bị tiểu đường không?",
        "form": {},
        "patient": {},
    })
    assert out["intent"] == "ask"


def test_critic_loop(monkeypatch):
    setup(monkeypatch, ["Uống 500 mg [9].", "Triệu chứng là khát nước [1]. Hãy gặp bác sĩ."])
    out = graph.run_case("Triệu chứng tiểu đường là gì?")
    assert [t["agent"] for t in out["trace"]].count("advisor") == 2
    assert out["critique"]["passed"]


def test_assess_flow(monkeypatch):
    setup(monkeypatch, ["Nguy cơ của bạn khoảng 10,0% [1]. Bạn nên gặp bác sĩ."])
    out = graph.run_case("Tôi nam 45 tuổi, BMI 29, không cao huyết áp. Nguy cơ thế nào?")
    ag = [t["agent"] for t in out["trace"]]
    assert ag[:3] == ["supervisor", "intake", "risk"] and out["risk"]["probability"] == 0.1
