"""Run the trained image classifier and return a Grad-CAM preview."""
import base64
from pathlib import Path
from tempfile import TemporaryDirectory
from threading import Lock

from .state import traced

_MODEL_LOCK = Lock()
_LABELS = {
    "loet_ban_chan": "Dấu hiệu loét bàn chân",
    "ban_chan_binh_thuong": "Không thấy loét bàn chân trong các lớp mô hình",
    "vong_mac_tieu_duong": "Dấu hiệu bệnh võng mạc đái tháo đường",
    "binh_thuong_hoac_khac": "Bình thường hoặc bất thường khác (không phân loại cụ thể)",
}


def _assess_image(image_bytes: bytes) -> dict:
    from io import BytesIO

    from PIL import Image

    from perception.vision import assess

    with TemporaryDirectory(prefix="diabetes-vision-") as directory:
        cam_path = Path(directory) / "gradcam.png"
        with Image.open(BytesIO(image_bytes)) as image, _MODEL_LOCK:
            result = assess(image, cam_path=str(cam_path))
        result["cam_data_url"] = "data:image/png;base64," + base64.b64encode(cam_path.read_bytes()).decode("ascii")
    result.pop("cam_path", None)
    result["display_label"] = _LABELS.get(result["label"], result["label"].replace("_", " "))
    return result


@traced("vision")
def vision_node(state):
    image_bytes = state.get("vision_image")
    if not image_bytes:
        raise ValueError("Vision Agent cần ảnh đầu vào.")
    prediction = _assess_image(image_bytes)
    decision = f"{prediction['display_label']} ({prediction['confidence']:.0%})"
    if prediction["uncertain"]:
        decision += " — chưa đủ chắc chắn"
    return {
        "vision_image": None,
        "vision_result": prediction,
        "_decision": decision,
    }
