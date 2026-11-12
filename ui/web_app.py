"""Giao diện web (Flask + HTML thuần): form hồ sơ, câu trả lời, thẻ nguy cơ SHAP, bằng chứng, đường đi các agent."""
import json
import os
import re
import subprocess
import threading
import time
import urllib.request
from pathlib import Path

from flask import Flask, Response, jsonify, request

from agents.graph import run_case

PAGE = (Path(__file__).parent / "index.html").read_text(encoding="utf-8")
app = Flask(__name__)


def _clean(o):
    return o.tolist() if hasattr(o, "tolist") else str(o)


def build_form(d: dict) -> dict:
    f = {"gender": d.get("gender"), "age": d.get("age"), "bmi": d.get("bmi"),
         "hypertension": d.get("hypertension"), "heart_disease": d.get("heart_disease"),
         "smoking_history": d.get("smoking_history"), "HbA1c_level": d.get("hba1c"),
         "blood_glucose_level": d.get("glu")}
    return {k: v for k, v in f.items() if v not in (None, "")}


@app.get("/")
def index():
    return Response(PAGE, mimetype="text/html")


@app.post("/api/chat")
def api_chat():
    d = request.get_json(force=True) or {}
    q = (d.get("question") or "").strip()
    form = build_form(d.get("form") or {})
    patient = d.get("patient") or {}
    if not q and form:
        q = "Hãy đánh giá nguy cơ tiểu đường theo hồ sơ của tôi."
    if not q:
        return jsonify(error="Vui lòng nhập câu hỏi hoặc hồ sơ.")
    try:
        s = run_case(q, form=form, patient=patient)
    except Exception as e:
        return jsonify(error=f"{type(e).__name__}: {e}")
    out = {"answer": s.get("answer"), "trace": s.get("trace"), "risk": s.get("risk"),
           "lab_checks": s.get("lab_checks"), "evidence": s.get("evidence"),
           "knowledge_graph": s.get("knowledge_graph"),
           "patient": s.get("patient") or patient}
    return Response(json.dumps(out, default=_clean, ensure_ascii=False), mimetype="application/json")


def _tunnel(port: int) -> str | None:
    """Mở link công khai bằng cloudflared (dùng trên Kaggle, cần bật Internet)."""
    if not os.path.exists("cloudflared"):
        urllib.request.urlretrieve(
            "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64", "cloudflared")
        os.chmod("cloudflared", 0o755)
    subprocess.Popen(["./cloudflared", "tunnel", "--url", f"http://127.0.0.1:{port}", "--no-autoupdate"],
                     stdout=open("cf.log", "w"), stderr=subprocess.STDOUT)
    for _ in range(60):
        time.sleep(1)
        m = re.search(r"https://[-a-z0-9]+\.trycloudflare\.com", open("cf.log").read())
        if m:
            return m.group(0)
    return None


def launch(port: int = 5001, tunnel: bool = False, block: bool = False):
    """Trên máy: launch() rồi mở http://127.0.0.1:5001.
    Trên Kaggle: launch(tunnel=True) để lấy link trycloudflare.com. block=True giữ tiến trình sống (dùng cho CLI)."""
    run = lambda: app.run(host="0.0.0.0", port=port, debug=False, use_reloader=False)
    if not tunnel and block:
        return run()
    threading.Thread(target=run, daemon=True).start()
    print("👉 Mở link này trong trình duyệt:", (_tunnel(port) if tunnel else f"http://127.0.0.1:{port}") or "chưa lấy được link, xem cf.log")
    while block:
        time.sleep(3600)