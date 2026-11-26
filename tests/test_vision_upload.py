import io
import json

from ui import web_app


def test_web_upload_passes_image_bytes_to_graph(monkeypatch):
    image = b"example-image"
    received = {}
    vision_result = {"label": "loet_ban_chan", "confidence": 0.82}

    def fake_run_case(question, form, patient, vision_image):
        received.update(question=question, form=form, patient=patient, vision_image=vision_image)
        return {
            "answer": "CNN screening result",
            "trace": [],
            "knowledge_graph": {},
            "vision_result": vision_result,
        }

    monkeypatch.setattr(web_app, "run_case", fake_run_case)
    response = web_app.app.test_client().post(
        "/api/chat",
        data={
            "question": "Phân tích ảnh",
            "patient": "{}",
            "form": json.dumps({"age": 50}),
            "vision_image": (io.BytesIO(image), "foot.png", "image/png"),
        },
        content_type="multipart/form-data",
    )

    assert response.status_code == 200
    assert received["vision_image"] == image
    assert response.get_json()["vision_result"] == vision_result
