"""Chạy cả đồ thị với LLM / mô hình / KG giả để kiểm tra định tuyến."""
from agents import agents as A, critic, graph, llm, vision_agent
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
    assert ag[:2] == ["supervisor", "intake"]
    assert set(ag[2:4]) == {"risk", "knowledge"}
    assert ag[4:] == ["advisor", "critic", "finalize"]
    assert out["risk"]["probability"] == 0.1


def test_parallel_assess_waits_for_risk_intake_retry(monkeypatch):
    setup(monkeypatch, ["Nguy cơ của bạn khoảng 20,0% [1]. Bạn nên gặp bác sĩ."])
    calls = []

    def screening_risk(_patient):
        calls.append("risk")
        return {"model": "screening", "probability": 0.2, "threshold": 0.3,
                "label": "nguy cơ thấp", "needs_lab": True}

    monkeypatch.setattr(A.predictor, "predict_risk", screening_risk)
    out = graph.run_case("Tôi nam 45 tuổi, BMI 29, không cao huyết áp. Nguy cơ thế nào?")
    agents = [trace["agent"] for trace in out["trace"]]

    assert len(calls) == 2
    assert agents.count("risk") == 2
    assert agents.index("advisor") > agents.index("knowledge")


def test_uploaded_image_runs_vision_before_advisor(monkeypatch):
    setup(monkeypatch, ["Mô hình ảnh phát hiện một dấu hiệu cần bác sĩ kiểm tra."])
    monkeypatch.setitem(SETTINGS, "use_critic", False)
    prediction = {
        "label": "loet_ban_chan",
        "display_label": "Dấu hiệu loét bàn chân",
        "confidence": 0.82,
        "uncertain": False,
        "probs": {"loet_ban_chan": 0.82, "ban_chan_binh_thuong": 0.18},
        "cam_data_url": "data:image/png;base64,dGVzdA==",
    }
    monkeypatch.setattr(vision_agent, "_assess_image", lambda image: prediction)

    out = graph.run_case(
        "Ảnh này có dấu hiệu biến chứng tiểu đường không?",
        vision_image=b"fake-image",
    )

    assert out["trace"][0]["agent"] == "vision"
    assert out["vision_image"] is None
    assert out["vision_result"]["label"] == "loet_ban_chan"
    assert "KẾT QUẢ CNN TRÊN ẢNH" in A.facts({"vision_result": prediction})
    assert "Kết quả CNN chỉ hỗ trợ sàng lọc ảnh" in out["answer"]
