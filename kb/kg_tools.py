"""Công cụ truy xuất GraphRAG trên Knowledge Graph NetworkX + embedding bge-m3.

Dữ liệu nạp lười (lần gọi đầu tiên) từ artifacts/kb.
"""
import json
import pickle
import os
import re

import numpy as np

import config
from common.embed import embed
from common.text import norm, read_jsonl

_S: dict = {}


def _load() -> dict:
    if not _S:
        kb = config.KB_DIR
        # _S["G"] = pickle.load(open(kb / "kg.pkl", "rb"))
        if os.getenv("KG_BACKEND", "networkx") == "neo4j":
            from .neo4j_store import Neo4jGraph
            _S["G"] = Neo4jGraph()
        else:
            _S["G"] = pickle.load(open(kb / "kg.pkl", "rb"))
        _S["CH"] = read_jsonl(kb / "chunks_final.jsonl")
        z = np.load(kb / "emb.npz")
        _S["E_ENT"], _S["E_CH"] = z["E_ent"], z["E_chunk"]
        _S["ENTS"] = json.load(open(kb / "ents.json", encoding="utf-8"))
    return _S


def graph():
    return _load()["G"]


def _q(text: str) -> np.ndarray:
    return embed([text])[0]


# Từ đồng nghĩa phổ biến để map thẳng vào thực thể chuẩn trong KG
SYNONYMS = {
    "tieu duong": "Đái tháo đường",
    "benh tieu duong": "Đái tháo đường",
    "dai thao duong": "Đái tháo đường",
    "benh dai thao duong": "Đái tháo đường",
    "tieu duong tuyp 2": "Đái tháo đường tuýp 2",
    "tieu duong type 2": "Đái tháo đường tuýp 2",
    "tieu duong tuyp 1": "Đái tháo đường tuýp 1",
    "tieu duong type 1": "Đái tháo đường tuýp 1",
    "tang huyet ap": "Tăng huyết áp",
    "cao huyet ap": "Tăng huyết áp",
    "beo phi": "Béo phì",
    "thua can": "Thừa cân",
}


def link_entities(text: str, top_k: int = 5) -> list:
    """Tìm thực thể trong KG khớp với đoạn văn (khớp tên + từ đồng nghĩa + ngữ nghĩa)."""
    s_, G = _load(), graph()
    n, out = norm(text), {}
    words = re.findall(r"\w+", n)
    word_set = set(words)

    # 1. Khớp từ đồng nghĩa thông dụng
    for syn_key, syn_target in SYNONYMS.items():
        if syn_key in n and syn_target in G:
            out[syn_target] = 1.0

    # 2. Khớp chuỗi tên thực thể
    for e in s_["ENTS"]:
        k = norm(e)
        if not k or len(k) < 3:
            continue
        # Tránh các từ quá chung gây nhiễu (như từ 'Đường' bị khớp khi người dùng gõ 'tiểu đường')
        if k in ("duong", "tuoi", "gioi"):
            continue
        if " " in k:
            if k in n:
                out[e] = 1.0
        else:
            if k in word_set and len(k) >= 4:
                out[e] = 0.9

    # 3. Embedding tương đồng ngữ nghĩa
    s = s_["E_ENT"] @ _q(text)
    for i in np.argsort(-s)[: top_k * 3]:
        ent_name = s_["ENTS"][i]
        out.setdefault(ent_name, float(s[i]))

    # Ưu tiên các thực thể có quan hệ (degree > 0) và thuộc các lớp quan trọng
    def _rank_key(item):
        name, score = item
        deg = G.degree(name) if name in G else 0
        node_type = G.nodes[name].get("type", "") if name in G else ""
        type_bonus = 0.2 if node_type in ("Disease", "Drug", "RiskFactor", "Test") else 0.0
        deg_bonus = 0.15 if deg > 0 else -0.3
        return score + type_bonus + deg_bonus

    top = sorted(out.items(), key=_rank_key, reverse=True)[:top_k]
    return [{"name": e, "type": G.nodes[e]["type"], "score": round(sc, 3)} for e, sc in top]


def neighbors(entity: str, relation: str = "", direction: str = "out", limit: int = 12) -> dict:
    """Các quan hệ lân cận của một thực thể (direction: out | in), kèm câu trích và URL."""
    G = graph()
    if entity not in G:
        return {"error": f"không có thực thể '{entity}'"}
    it = G.out_edges(entity, data=True) if direction == "out" else G.in_edges(entity, data=True)
    rows = [{"subject": a, "relation": d["relation"], "object": b, "evidence": d["evidence"], "url": d["url"]}
            for a, b, d in it if d["relation"] != "MAPS_TO" and (not relation or d["relation"] == relation)]
    return {"entity": entity, "edges": rows[:limit]}


def drug_info(drug: str) -> dict:
    """Nhóm thuốc, chỉ định, tác dụng phụ, chống chỉ định của một thuốc (KG không có liều)."""
    G = graph()
    name = next((e for e in _load()["ENTS"] if G.nodes[e]["type"] == "Drug" and norm(drug) in norm(e)), None)
    if not name:
        return {"error": f"không có thuốc '{drug}'"}
    info = {"drug": name}
    for key, rel in [("side_effects", "HAS_SIDE_EFFECT"), ("contraindications", "CONTRAINDICATED_IN"), ("class", "BELONGS_TO")]:
        info[key] = neighbors(name, rel, "out", 8)["edges"]
    info["indications"] = neighbors(name, "TREATED_BY", "in", 5)["edges"]
    return info


OPS = {">=": lambda v, a, b: v >= a, ">": lambda v, a, b: v > a, "<=": lambda v, a, b: v <= a,
       "<": lambda v, a, b: v < a, "range": lambda v, a, b: a <= v <= b}
SYM = {">=": "≥", ">": ">", "<=": "≤", "<": "<"}
LAB = {"HbA1c_level": {"HbA1c"}, "blood_glucose_level": {"Đường huyết lúc đói", "Đường huyết bất kỳ"}}


def condition_text(d: dict) -> str:
    u = {"mg/dl": "mg/dL", "mmol/l": "mmol/L"}.get(d["unit"], d["unit"])
    f = lambda x: f"{x:g}".replace(".", ",")
    if d["op"] == "range":
        return f"{f(d['value'])}–{f(d['value_max'])} {u}"
    return f"{SYM[d['op']]} {f(d['value'])} {u}"


def explain_feature(feature: str, value: float = None, unit: str = "") -> dict:
    """Nối một đặc trưng của mô hình tới tri thức; với HbA1c/đường huyết thì đối chiếu giá trị với ngưỡng chẩn đoán."""
    G = graph()
    if feature not in G:
        return {"error": f"không có đặc trưng '{feature}'"}
    mapped = [b for _, b, d in G.out_edges(feature, data=True) if d["relation"] == "MAPS_TO"]
    res = {"feature": feature, "mapped": mapped[:6]}
    if feature in LAB and value is not None:
        v = float(value)
        if feature == "blood_glucose_level" and unit.lower().startswith("mmol"):
            v *= 18.016                                           # mmol/L -> mg/dL
        checks = []
        for a, b, d in G.edges(data=True):
            if "op" in d and b in LAB[feature]:
                checks.append({"disease": a, "test": b, "condition": condition_text(d), "value": round(v, 2),
                               "met": bool(OPS[d["op"]](v, d["value"], d.get("value_max"))),
                               "assumption": "chỉ đúng nếu mẫu đo lúc đói" if b == "Đường huyết lúc đói" else "",
                               "evidence": d["evidence"], "url": d["url"]})
        res["lab_checks"] = checks
    else:
        res["risk_links"] = [{"subject": a, "object": b, "evidence": d["evidence"], "url": d["url"]}
                             for b in mapped[:6] for a, _, d in G.in_edges(b, data=True) if d["relation"] == "HAS_RISK_FACTOR"][:6]
    return res


def search_chunks(query: str, top_k: int = 4) -> list:
    """Tìm đoạn văn gốc theo ngữ nghĩa khi đồ thị chưa có thông tin."""
    s_ = _load()
    s = s_["E_CH"] @ _q(query)
    return [{"text": s_["CH"][i]["text"][:700], "section": s_["CH"][i]["section"], "page": s_["CH"][i]["page"],
             "url": s_["CH"][i]["url"], "score": round(float(s[i]), 3)} for i in np.argsort(-s)[:top_k]]
