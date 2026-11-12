"""Năm agent: Supervisor, Intake, Risk, Knowledge, Advisor (Critic nằm ở critic.py)."""
import os
import re

from pydantic import BaseModel

import config
from common.text import fmt, num, pct
from kb import kg_tools as K
from ml import predictor

from . import llm
from .settings import SETTINGS
from .state import MAX_KNOWLEDGE, traced


# ======================================================================= Supervisor
class Intent(BaseModel):
    intent: str   # assess | ask | both


PROFILE_HINT = re.compile(r"\d+\s*tuổi|hba1c\s*\d|bmi\s*\d|nặng\s*\d|cao\s*\d", re.I)
SELF_RISK = re.compile(
    r"(?:nguy cơ|khả năng)\s+(?:của\s+(?:tôi|mình)|(?:tôi|mình)\s+(?:bị|mắc|là))"
    r"|(?:tôi|mình)\s+(?:có|có khả năng)\s+(?:nguy cơ|khả năng)\s*(?:bị|mắc)?"
    r"|(?:đánh giá|dự đoán|ước tính|tính)\s+.{0,30}(?:nguy cơ|khả năng)",
    re.I,
)


@traced("supervisor")
def supervisor_node(state):
    q, form = state["question"], state.get("form") or {}
    has_profile = bool(form) or bool(state.get("patient")) or bool(PROFILE_HINT.search(q))
    r = llm.submit("Phân loại ý định người dùng: assess = muốn đánh giá nguy cơ cá nhân từ hồ sơ sức khỏe; "
                   "ask = hỏi kiến thức hoặc mối liên hệ giữa các bệnh/triệu chứng/thuốc, kể cả khi người dùng "
                   "nói 'tôi bị...' để làm bối cảnh; both = vừa muốn đánh giá cá nhân vừa hỏi thêm kiến thức. "
                   "Chỉ chọn assess khi người dùng hỏi nguy cơ/khả năng của chính họ hoặc yêu cầu dự đoán, đánh giá, "
                   "tính nguy cơ.", q, Intent)
    intent = r.intent if r and r.intent in ("assess", "ask", "both") else None
    if not has_profile:       # chưa có dữ liệu: hỏi "nguy cơ của tôi" vẫn đi qua Intake để được hỏi lại
        intent = "assess" if SELF_RISK.search(q.lower()) else "ask"
    elif intent is None:
        intent = "assess"
    return {"intent": intent, "_decision": f"intent={intent} → {'Knowledge' if intent == 'ask' else 'Intake'}"}


# ======================================================================= Intake
class Profile(BaseModel):
    gender: str = ""            # Male | Female
    age: float = 0
    hypertension: int = -1      # 1 có, 0 không, -1 chưa nói
    heart_disease: int = -1
    smoking_history: str = ""   # never | former | current | not current | ever
    height_cm: float = 0
    weight_kg: float = 0
    bmi: float = 0
    hba1c: float = 0
    glucose: float = 0
    glucose_unit: str = ""


RANGE = {"age": (1, 120), "bmi": (10, 70), "HbA1c_level": (3, 15), "blood_glucose_level": (30, 600)}
LABEL = {"age": "Tuổi", "bmi": "BMI", "HbA1c_level": "HbA1c", "blood_glucose_level": "Đường huyết"}


def glu(v: float, unit: str):
    """Đổi đường huyết về mg/dL (đoán mmol/L khi không ghi đơn vị và số nhỏ)."""
    return round(v * 18.016) if ("mmol" in unit.lower() or (not unit and v < 30)) else v


def parse_labs(t: str) -> dict:
    out = {}
    if m := re.search(r"hba1c\D{0,12}?(\d+(?:[.,]\d+)?)", t):
        out["HbA1c_level"] = num(m[1])
    if m := re.search(r"(?:đường huyết|glucose|đường máu)\D{0,15}?(\d+(?:[.,]\d+)?)\s*(mg/dl|mmol/l)?", t):
        out["blood_glucose_level"] = glu(num(m[1]), m[2] or "")
    return out


def parse_rules(q: str) -> dict:
    """Đọc hồ sơ bằng luật (regex): bổ sung khi LLM bỏ sót và tự tính BMI từ chiều cao/cân nặng."""
    t, out = q.lower(), {}
    if m := re.search(r"(\d{1,3})\s*tuổi", t):
        out["age"] = num(m[1])
    if re.search(r"\b(nữ|bà|chị|cô)\b", t):
        out["gender"] = "Female"
    elif re.search(r"\b(nam|ông|anh|chú)\b", t):
        out["gender"] = "Male"
    h = w = None
    if m := re.search(r"cao\s*(\d)\s*m\s*(\d{1,2})", t):
        h = int(m[1]) * 100 + int(m[2])
    elif m := re.search(r"cao\s*(\d{3})\s*cm", t):
        h = int(m[1])
    if m := re.search(r"(\d{2,3}(?:[.,]\d)?)\s*kg", t):
        w = num(m[1])
    if m := re.search(r"bmi\D{0,6}?(\d+(?:[.,]\d+)?)", t):
        out["bmi"] = num(m[1])
    elif h and w:
        out["bmi"] = round(w / (h / 100) ** 2, 1)
    if re.search(r"(không|chưa)\s*(bị\s*|có\s*)?(cao|tăng)\s*huyết áp", t):
        out["hypertension"] = 0
    elif re.search(r"(cao|tăng)\s*huyết áp", t):
        out["hypertension"] = 1
    if re.search(r"(không|chưa)\s*(bị\s*|có\s*)?(bệnh\s*)?tim", t):
        out["heart_disease"] = 0
    elif re.search(r"bệnh tim|tim mạch", t):
        out["heart_disease"] = 1
    if re.search(r"không\s*hút", t):
        out["smoking_history"] = "never"
    elif re.search(r"bỏ thuốc|từng hút|đã bỏ|cai thuốc", t):
        out["smoking_history"] = "former"
    elif re.search(r"hút thuốc", t):
        out["smoking_history"] = "current"
    out.update(parse_labs(t))
    return out


def from_llm(r) -> dict:
    out = {}
    if r is None:
        return out
    if r.gender in ("Male", "Female"):
        out["gender"] = r.gender
    if r.age > 0:
        out["age"] = r.age
    for k in ("hypertension", "heart_disease"):
        if getattr(r, k) in (0, 1):
            out[k] = getattr(r, k)
    if r.smoking_history:
        out["smoking_history"] = r.smoking_history
    if r.bmi > 0:
        out["bmi"] = r.bmi
    elif r.height_cm > 0 and r.weight_kg > 0:
        out["bmi"] = round(r.weight_kg / (r.height_cm / 100) ** 2, 1)
    if r.hba1c > 0:
        out["HbA1c_level"] = r.hba1c
    if r.glucose > 0:
        out["blood_glucose_level"] = glu(r.glucose, r.glucose_unit)
    return out


@traced("intake")
def intake_node(state):
    q, patient = state["question"], dict(state.get("patient") or {})
    if state.get("risk_request"):                        # Risk nhờ tìm thêm xét nghiệm trong tin nhắn
        labs = parse_labs(q.lower())
        patient.update(labs)
        return {"patient": patient, "risk_request": None, "ask_user": None,
                "_decision": ("tìm thấy " + ", ".join(labs) if labs else "không có xét nghiệm trong tin nhắn") + " → Risk"}
    prof = llm.submit("Trích hồ sơ sức khỏe từ tin nhắn tiếng Việt. Chỉ điền trường được nói rõ, trường chưa nói để mặc định "
                      "(chuỗi rỗng, 0 hoặc -1). Giới tính: Male hoặc Female.", q, Profile)
    patient.update(from_llm(prof))
    patient.update(parse_rules(q))
    for k, v in (state.get("form") or {}).items():       # giá trị nhập trong form được ưu tiên
        if v not in (None, ""):
            patient[k] = v
    errs = []
    for k, (lo, hi) in RANGE.items():
        if k in patient and not lo <= float(patient[k]) <= hi:
            errs.append(f"{LABEL[k]} = {patient.pop(k):g} nằm ngoài khoảng hợp lý")
    missing = [vn for k, vn in [("gender", "giới tính"), ("age", "tuổi"), ("bmi", "BMI (hoặc chiều cao và cân nặng)")] if k not in patient]
    if errs or missing:
        msg = ("; ".join(errs) + ". " if errs else "") + (
            "Bạn vui lòng cho mình biết thêm: " + ", ".join(missing) + "." if missing else "Bạn kiểm tra lại giúp mình nhé.")
        return {"patient": patient, "ask_user": msg, "_decision": "thiếu/sai dữ liệu → hỏi lại người dùng"}
    assumed = []
    for k, default, vn in [("hypertension", 0, "không tăng huyết áp"), ("heart_disease", 0, "không có bệnh tim"),
                           ("smoking_history", "No Info", "chưa rõ tiền sử hút thuốc")]:
        if k not in patient:
            patient[k] = default
            assumed.append(f"chưa nói nên giả định {vn}")
    patient["assumed"] = assumed
    return {"patient": patient, "ask_user": None, "_decision": "hồ sơ hợp lệ → Risk"}


# ======================================================================= Risk
MED = {"HbA1c_level": 5.8, "blood_glucose_level": 140}     # giá trị thay thế khi chỉ có một xét nghiệm


def make_tools(p: dict):
    def predict_risk() -> dict:
        """Dự đoán xác suất nguy cơ tiểu đường (đã hiệu chỉnh) của người dùng hiện tại."""
        return predictor.predict_risk(p)

    def explain_risk(top_k: int = 5) -> dict:
        """Giải thích SHAP: các yếu tố ảnh hưởng nhiều nhất tới nguy cơ."""
        return predictor.explain_risk(p, top_k)

    def what_if(bmi: float) -> dict:
        """Nguy cơ thay đổi thế nào nếu BMI đổi thành giá trị bmi."""
        return predictor.what_if(p, {"bmi": bmi})
    return [predict_risk, explain_risk, what_if]


@traced("risk")
def risk_node(state):
    p = {k: v for k, v in state["patient"].items() if k != "assumed"}
    imputed = []
    if any(k in p for k in MED):                         # mô hình full cần đủ 2 xét nghiệm
        for k, v in MED.items():
            if k not in p:
                p[k] = v
                imputed.append(k)
    log = llm.run_tools("Bạn là Risk Agent. Gọi predict_risk trước, sau đó explain_risk. what_if chỉ khi người dùng hỏi về thay đổi BMI.",
                        "Hãy dự đoán và giải thích nguy cơ của người dùng.", make_tools(p),
                        max_steps=config.LLM_TOOL_STEPS)
    got = {c["tool"]: c["result"] for c in log if "error" not in c["result"]}
    pred = got.get("predict_risk") or predictor.predict_risk(p)
    expl = got.get("explain_risk") or predictor.explain_risk(p)
    risk = {**pred, "factors": expl["factors"]}
    if "what_if" in got:
        risk["what_if"] = got["what_if"]
    if imputed:
        risk["imputed"] = imputed
    asked = (state.get("counters") or {}).get("risk_asked", 0)
    req = None
    if pred["model"] == "screening" and pred["probability"] >= 0.5 * pred["threshold"] and not asked:
        req = "Xác suất ở vùng xám và chưa có xét nghiệm: nhờ Intake tìm HbA1c/đường huyết."
    return {"risk": risk, "risk_request": req, "counters": {"risk_asked": 1} if req else {},
            "_decision": f"{pct(pred['probability'])} (mô hình {pred['model']}) → {'Intake' if req else 'Knowledge'}"}


# ======================================================================= Knowledge
def harvest(res, limit: int = 4) -> list:
    """Gom (mô tả, câu trích, url) từ kết quả của các công cụ KG."""
    rows = []
    if isinstance(res, list):
        for r in res:
            if isinstance(r, dict) and "text" in r and "url" in r:
                rows.append((f"Đoạn văn, trang '{r['page']}', mục '{r['section']}'", r["text"][:300], r["url"]))
    elif isinstance(res, dict):
        for key in ("edges", "side_effects", "contraindications", "class", "indications", "risk_links"):
            for e in res.get(key) or []:
                if "evidence" in e:
                    rows.append((f"{e['subject']} — {e.get('relation', 'HAS_RISK_FACTOR')} — {e['object']}", e["evidence"], e["url"]))
    return rows[:limit]


def graph_rows(res) -> list:
    """Extract graph edges returned by Neo4j-backed KG tools."""
    rows = []
    if not isinstance(res, dict):
        return rows
    for key in ("edges", "side_effects", "contraindications", "class", "indications", "risk_links"):
        for edge in res.get(key) or []:
            if not isinstance(edge, dict) or not all(edge.get(k) for k in ("subject", "object", "relation")):
                continue
            rows.append({
                "subject": edge["subject"],
                "relation": edge["relation"],
                "object": edge["object"],
                "evidence": edge.get("evidence", ""),
                "url": edge.get("url", ""),
            })
    return rows


KSYS = ("Bạn là Knowledge Agent: tra cứu bằng chứng trong Knowledge Graph về bệnh tiểu đường. Dùng link_entities để tìm thực thể, "
        "neighbors/drug_info để lấy quan hệ, explain_feature để nối đặc trưng với ngưỡng, search_chunks khi đồ thị chưa đủ. "
        "Tên thực thể phải đúng như link_entities trả về. Không trả lời người dùng, chỉ gọi công cụ.")
KSYS_RAG = "Bạn là Knowledge Agent: dùng search_chunks (có thể gọi nhiều lần với từ khóa khác nhau) để tìm đoạn văn liên quan. Không trả lời người dùng."


@traced("knowledge")
def knowledge_node(state):
    kg_mode = SETTINGS["knowledge_mode"] == "kg"
    rnd = (state.get("counters") or {}).get("knowledge_rounds", 0) + 1
    p, ev = state.get("patient") or {}, list(state.get("evidence") or [])
    graph_edges = list((state.get("knowledge_graph") or {}).get("edges") or [])
    labs = state.get("lab_checks")
    if labs is None:                                     # đối chiếu xét nghiệm với ngưỡng trong KG bằng code, tất định
        labs = []
        if kg_mode:
            for feat, unit in (("HbA1c_level", "%"), ("blood_glucose_level", "mg/dL")):
                if feat in p:
                    labs += K.explain_feature(feat, p[feat], unit).get("lab_checks", [])
        for c in labs:
            ev.append({"claim": f"{c['disease']} — chẩn đoán bằng {c['test']} {c['condition']}; giá trị của người dùng "
                                f"{fmt(c['value'])} → {'đạt' if c['met'] else 'chưa đạt'}",
                       "quote": c["evidence"], "url": c["url"]})
    topic = state["question"]
    r = state.get("risk")
    if r:
        topic += "\nYếu tố ảnh hưởng nguy cơ: " + ", ".join(f["feature"] for f in r["factors"][:3])
    hint = "" if rnd == 1 else f"\nVòng {rnd}: bằng chứng chưa đủ ({len(ev)}). Dùng từ khóa khác, thêm search_chunks hoặc neighbors của thực thể liên quan."
    tools = [K.link_entities, K.neighbors, K.drug_info, K.explain_feature, K.search_chunks] if kg_mode else [K.search_chunks]
    log = llm.run_tools(KSYS if kg_mode else KSYS_RAG, topic + hint, tools,
                        max_steps=config.LLM_TOOL_STEPS)
    rows = [row for c in log if "error" not in c["result"] for row in harvest(c["result"])]
    for c in log:
        if "error" not in c["result"]:
            graph_edges.extend(graph_rows(c["result"]))
    if kg_mode:
        # The graph shown in the UI must not depend on the LLM choosing neighbors().
        # Resolve the top linked entities deterministically from the configured KG.
        linked = K.link_entities(state["question"], top_k=2)
        for entity in linked:
            related = K.neighbors(entity["name"], limit=12)
            graph_edges.extend(graph_rows(related))
            rows.extend(harvest(related))
    if rnd == 1 and not rows:                            # dự phòng khi model không gọi công cụ
        if kg_mode:
            for e in K.link_entities(state["question"], 2):
                fallback = K.neighbors(e["name"])
                rows += harvest(fallback)
                graph_edges.extend(graph_rows(fallback))
        rows += harvest(K.search_chunks(state["question"]))
    seen = {e["quote"] for e in ev}
    for claim, quote, url in rows:
        if quote not in seen and len(ev) < 12:
            seen.add(quote)
            ev.append({"claim": claim, "quote": quote, "url": url})
    for i, e in enumerate(ev, 1):
        e["id"] = i
    unique_edges = []
    seen_edges = set()
    for edge in graph_edges:
        key = (edge["subject"], edge["relation"], edge["object"], edge.get("url", ""))
        if key not in seen_edges:
            seen_edges.add(key)
            unique_edges.append(edge)
    graph_nodes = sorted({x for edge in unique_edges for x in (edge["subject"], edge["object"])})
    done = len(ev) >= 4 or rnd >= MAX_KNOWLEDGE
    return {"evidence": ev, "lab_checks": labs,
            "knowledge_graph": {
                                "backend": ("neo4j" if os.getenv("KG_BACKEND", "networkx") == "neo4j"
                                            else "networkx") if kg_mode else None,
                                "nodes": graph_nodes, "edges": unique_edges},
            "knowledge_done": done, "counters": {"knowledge_rounds": rnd},
            "_decision": f"vòng {rnd}: {len(ev)} bằng chứng → {'Advisor' if done else 'tự mở rộng truy vấn'}"}


# ======================================================================= Advisor
ASYS = """Bạn là Advisor, trả lời người dùng bằng tiếng Việt như một cuộc trò chuyện tự nhiên, liền mạch: 1 đến 3 đoạn văn ngắn (khoảng 80-150 từ). KHÔNG dùng tiêu đề, KHÔNG gạch đầu dòng, KHÔNG in đậm. Không tiết lộ bản nháp, Critic, lỗi nội bộ hoặc mục "Lỗi cần sửa".
Thứ tự ý: câu đầu trả lời thẳng vào câu hỏi hoặc nêu kết luận chính; tiếp theo là lý do quan trọng nhất; cuối cùng là một lời khuyên cụ thể kèm việc gặp bác sĩ.
Chỉ nêu ý liên quan trực tiếp tới câu hỏi, bỏ qua bằng chứng không liên quan. Không nhắc các từ kỹ thuật như SHAP, screening, bằng chứng; với yếu tố ảnh hưởng chỉ nêu 1-2 yếu tố nổi bật nếu có. Câu hỏi kiến thức thì trả lời trực tiếp, không nhắc mô hình dự đoán.
Quy tắc bắt buộc:
- Chỉ dùng số liệu có trong dữ liệu được cung cấp; chép xác suất đúng như chuỗi cho sẵn. Không bịa số.
- Mỗi ý y khoa kèm trích dẫn [n] đúng số bằng chứng.
- Không nêu liều thuốc, hàm lượng, số viên, số lần dùng.
- Không khẳng định người dùng đã mắc bệnh; nói đạt ngưỡng chẩn đoán và cần bác sĩ xác nhận.
- Nếu chỉ số xét nghiệm ĐẠT ngưỡng chẩn đoán trong khi mô hình báo nguy cơ thấp, nói rõ mâu thuẫn này.
- Đường huyết so với ngưỡng lúc đói chỉ đúng nếu mẫu đo lúc đói: nói rõ giả định này bằng một câu ngắn.
- Chưa có xét nghiệm thì đề nghị làm HbA1c hoặc đường huyết.
- Luôn có lời khuyên gặp bác sĩ."""


def facts(state) -> str:
    """Dữ kiện (đã được code kiểm soát) đưa cho Advisor."""
    p, r, L = state.get("patient") or {}, state.get("risk"), []
    if p:
        L.append("HỒ SƠ: " + ", ".join(f"{k}={v}" for k, v in p.items() if k != "assumed"))
        if p.get("assumed"):
            L.append("GIẢ ĐỊNH: " + "; ".join(p["assumed"]))
    if r:
        L.append(f"MÔ HÌNH ({r['model']}): xác suất {pct(r['probability'])}; ngưỡng phân loại {pct(r['threshold'])}; mô hình kết luận: {r['label']}")
        L.append("YẾU TỐ ẢNH HƯỞNG (SHAP): " + "; ".join(f"{f['feature']}={f['value']} ({f['direction']})" for f in r["factors"]))
        if r.get("needs_lab"):
            L.append("Chưa có xét nghiệm: hãy đề nghị làm HbA1c hoặc đường huyết.")
        if r.get("imputed"):
            L.append("GIẢ ĐỊNH: chỉ có một xét nghiệm nên xét nghiệm còn lại được thay bằng giá trị trung bình của dữ liệu huấn luyện.")
        if r.get("what_if"):
            L.append(f"WHAT-IF: {pct(r['what_if']['before'])} → {pct(r['what_if']['after'])} khi {r['what_if']['changes']}")
    for c in state.get("lab_checks") or []:
        L.append(f"ĐỐI CHIẾU: {c['test']} của người dùng = {fmt(c['value'])} so với ngưỡng {c['condition']} ({c['disease']}) → "
                 f"{'ĐẠT ngưỡng chẩn đoán' if c['met'] else 'chưa đạt'}" + (f" [{c['assumption']}]" if c["assumption"] else ""))
    L.append("BẰNG CHỨNG:")
    L += [f"[{e['id']}] {e['claim']} — \"{e['quote']}\"" for e in state.get("evidence") or []]
    return "\n".join(L)


@traced("advisor")
def advisor_node(state):
    user = f"CÂU HỎI: {state['question']}\n\n{facts(state)}"
    crit = state.get("critique")
    if crit and not crit.get("passed"):
        user += "\n\nBẢN NHÁP TRƯỚC:\n" + state.get("draft", "") + "\n\nCÁC LỖI PHẢI SỬA:\n- " + "\n- ".join(crit["issues"])
    draft = llm.text(ASYS, user)
    return {"draft": draft, "_decision": "viết lại theo góp ý" if crit and not crit.get("passed") else "viết bản nháp"}
