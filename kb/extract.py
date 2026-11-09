"""Trích xuất bộ ba tri thức từ chunk bằng LLM, rồi kiểm tra bằng code.

Chạy: python -m kb.extract
  - gọi LLM (có cache theo nội dung đoạn văn, chạy lại gần như tức thì)  -> raw_triples.json
  - kiểm tra, vá câu trích, loại câu chứa liều thuốc                     -> triples_valid.json
Mục "Liều dùng" của trang thuốc bị bỏ có chủ đích để KG không bao giờ có dữ liệu liều.
"""
import hashlib
import json
import re
from collections import Counter

import config
from common.text import SENT, alnum, clean_name, norm, read_jsonl

# ---------------------------------------------------------------- ontology
ENT = ["Disease", "Symptom", "RiskFactor", "Test", "Drug", "DrugClass", "SideEffect", "Lifestyle"]
REL = {  # quan hệ: (kiểu chủ thể, các kiểu đối tượng)
    "HAS_SYMPTOM": ("Disease", ["Symptom"]),
    "HAS_RISK_FACTOR": ("Disease", ["RiskFactor", "Disease"]),
    "HAS_COMPLICATION": ("Disease", ["Disease"]),
    "DIAGNOSED_BY": ("Disease", ["Test"]),
    "TREATED_BY": ("Disease", ["Drug", "DrugClass", "Lifestyle"]),
    "PREVENTED_BY": ("Disease", ["Lifestyle"]),
    "BELONGS_TO": ("Drug", ["DrugClass"]),
    "HAS_SIDE_EFFECT": ("Drug", ["SideEffect"]),
    "CONTRAINDICATED_IN": ("Drug", ["Disease"]),
}
REL_VI = {"HAS_SYMPTOM": "có triệu chứng", "HAS_RISK_FACTOR": "có yếu tố nguy cơ/nguyên nhân",
          "HAS_COMPLICATION": "gây biến chứng", "DIAGNOSED_BY": "được chẩn đoán bằng xét nghiệm",
          "TREATED_BY": "được điều trị bằng", "PREVENTED_BY": "được phòng ngừa bằng",
          "BELONGS_TO": "thuộc nhóm thuốc", "HAS_SIDE_EFFECT": "có tác dụng phụ",
          "CONTRAINDICATED_IN": "chống chỉ định trong bệnh"}

# luật ánh xạ tên mục -> quan hệ: (regex trên tên mục không dấu, quan hệ, hướng, kiểu đối tượng)
DISEASE_PRIORITY_RULES = [
    (r"\bco lam tang nguy co mac\b.*\bkhong\b", "HAS_COMPLICATION", "out", ["Disease"]),
    (r"han che dien tien", "TREATED_BY", "out", ["Lifestyle"]),
]
DISEASE_SECTION_RULES = [
    (r"bien chung|nguy hiem", "HAS_COMPLICATION", "out", ["Disease"]),
    (r"trieu chung|dau hieu|bieu hien", "HAS_SYMPTOM", "out", ["Symptom"]),
    (r"nguyen nhan|nguy co|doi tuong|tac nhan|yeu to", "HAS_RISK_FACTOR", "out", ["RiskFactor", "Disease"]),
    (r"chan doan|xet nghiem|chi so", "DIAGNOSED_BY", "out", ["Test"]),
    (r"phong ngua|phong tranh|che do|sinh hoat|loi song", "PREVENTED_BY", "out", ["Lifestyle"]),
    (r"dieu tri|thuoc|phac do", "TREATED_BY", "out", ["Drug", "DrugClass", "Lifestyle"]),
]
DRUG_SECTION_RULES = [
    (r"lieu dung|cach dung|qua lieu|quen lieu", None, None, None),        # KHÔNG lưu liều dùng
    (r"chong chi dinh", "CONTRAINDICATED_IN", "out", ["Disease"]),
    (r"chi dinh|cong dung", "TREATED_BY", "in", ["Disease"]),
    (r"tac dung phu|tac dung khong mong muon|phan ung co hai", "HAS_SIDE_EFFECT", "out", ["SideEffect"]),
]
BENH_SUBJECT = {"tieu-duong-289": "Đái tháo đường", "tieu-duong-tuyp-1": "Đái tháo đường tuýp 1",
                "tieu-duong-tuyp-2": "Đái tháo đường tuýp 2", "ha-duong-huyet-294": "Hạ đường huyết",
                "tang-huyet-ap": "Tăng huyết áp", "dong-mach-ngoai-bien": "Bệnh động mạch ngoại biên"}


def page_subject(c: dict):
    u = c["url"]
    if "/thuoc/" in u:
        m = re.match(r"Thuốc\s+(\S+)", c["page"])
        return m.group(1) if m else None
    if "/benh/" in u:
        return next((v for k, v in BENH_SUBJECT.items() if k in u), None)
    return None                                   # bài viết: để LLM tự xác định chủ thể


def find_rule(c: dict):
    hn = norm(c["section"])
    rules = DRUG_SECTION_RULES if "/thuoc/" in c["url"] else DISEASE_PRIORITY_RULES + DISEASE_SECTION_RULES
    return next(((rel, d, t) for pat, rel, d, t in rules if re.search(pat, hn)), None)


# ---------------------------------------------------------------- gọi LLM
def _tool(name, props, req):
    return {"type": "function", "function": {"name": name, "description": "Nộp kết quả trích xuất.",
            "parameters": {"type": "object", "properties": {"items": {"type": "array", "items":
                           {"type": "object", "properties": props, "required": req}}}, "required": ["items"]}}}


_S = {"type": "string"}
T_ENT = _tool("submit_entities", {"name": _S, "type": {"type": "string", "enum": ENT}, "evidence": _S}, ["name", "type", "evidence"])
T_TRI = _tool("submit_triples", {"subject": _S, "subject_type": {"type": "string", "enum": ENT},
              "relation": {"type": "string", "enum": list(REL)}, "object": _S,
              "object_type": {"type": "string", "enum": ENT}, "evidence": _S},
              ["subject", "subject_type", "relation", "object", "object_type", "evidence"])
SYS = ("Bạn trích xuất tri thức y khoa từ đoạn văn tiếng Việt. Chỉ dùng thông tin có trong đoạn văn, không bịa. "
       "Mỗi mục phải kèm MỘT câu trích NGUYÊN VĂN copy từ đoạn văn. Không đưa liều thuốc. Tên thực thể ngắn gọn, cụ thể. "
       "Luôn nộp kết quả bằng cách gọi công cụ (danh sách có thể rỗng).")

_cache: dict | None = None
CACHE_FILE = config.KB_DIR / "llm_cache.jsonl"


def _load_cache() -> dict:
    global _cache
    if _cache is None:
        _cache = {}
        if CACHE_FILE.exists():
            for line in open(CACHE_FILE, encoding="utf-8"):
                r = json.loads(line)
                _cache[r["key"]] = r["items"]
    return _cache


def call_llm(user: str, tool_def: dict, key: str) -> list:
    import ollama
    cache = _load_cache()
    if key in cache:
        return cache[key]
    items = []
    for _ in range(3):
        kw = dict(model=config.LLM_MODEL, tools=[tool_def], options={"temperature": 0, "num_ctx": 8192},
                  messages=[{"role": "system", "content": SYS}, {"role": "user", "content": user}])
        try:
            r = ollama.chat(**kw, think=False)
        except TypeError:
            r = ollama.chat(**kw)
        calls = r.message.tool_calls or []
        if calls:
            a = calls[0].function.arguments
            got = a.get("items") if isinstance(a, dict) else None
            if isinstance(got, str):
                try:
                    got = json.loads(got)
                except Exception:
                    got = None
            if isinstance(got, list):
                items = [g for g in got if isinstance(g, dict)]
                break
        user += "\n\nBắt buộc gọi công cụ để nộp kết quả."
    cache[key] = items
    with open(CACHE_FILE, "a", encoding="utf-8") as f:
        f.write(json.dumps({"key": key, "items": items}, ensure_ascii=False) + "\n")
    return items


def extract_chunk(c: dict) -> list[dict]:
    """Trả về danh sách bộ ba thô (chưa kiểm tra) của một chunk."""
    subj, rule = page_subject(c), find_rule(c)
    drug = "/thuoc/" in c["url"]
    if drug and (rule is None or rule[0] is None):
        return []                                  # trang thuốc: chỉ dùng mục có luật, bỏ liều dùng
    base = {"chunk_id": c["id"], "url": c["url"], "section": c["section"]}
    if rule and rule[0] and subj:                  # trích xuất có hướng dẫn theo tên mục
        rel, d, types = rule
        user = (f"Chủ đề trang: {subj}\nMục: {c['section']}\nNhiệm vụ: liệt kê các thực thể kiểu {types} mà "
                f"'{subj}' {REL_VI[rel]} (hoặc ngược lại nếu là chỉ định).\nĐoạn văn:\n{c['text']}")
        key = hashlib.md5(f"G|{config.LLM_MODEL}|{rel}|{subj}|{c['text']}".encode()).hexdigest()
        out = []
        for it in call_llm(user, T_ENT, key):
            if it.get("type") not in types:
                it["type"] = types[0] if len(types) == 1 else it.get("type")
            st = "Drug" if drug else "Disease"
            if d == "in":
                out.append({**base, "mode": "guided", "subject": it.get("name", ""), "subject_type": it.get("type", ""),
                            "relation": rel, "object": subj, "object_type": st, "evidence": it.get("evidence", "")})
            else:
                out.append({**base, "mode": "guided", "subject": subj, "subject_type": st, "relation": rel,
                            "object": it.get("name", ""), "object_type": it.get("type", ""), "evidence": it.get("evidence", "")})
        return out
    if drug:
        return []
    rels = "\n".join(f"- {r}: {a} {REL_VI[r]} {b}" for r, (a, b) in REL.items())      # trích xuất tổng quát
    user = f"Trang: {c['page']}\nMục: {c['section']}\nCác quan hệ cho phép:\n{rels}\nĐoạn văn:\n{c['text']}"
    key = hashlib.md5(f"T|{config.LLM_MODEL}|{c['text']}".encode()).hexdigest()
    return [{**base, "mode": "general", **{k: it.get(k, "") for k in ("subject", "subject_type", "relation", "object", "object_type", "evidence")}}
            for it in call_llm(user, T_TRI, key)]


# ---------------------------------------------------------------- kiểm tra bằng code
GENERIC = {"benh", "trieu chung", "nguyen nhan", "thuoc", "co the", "nguoi benh", "suc khoe", "bieu hien",
           "dieu tri", "tac dung phu", "bien chung", "bien chung nguy hiem", "benh ly", "tinh trang",
           "van de suc khoe", "benh khac", "cac benh khac", "phuong phap dieu tri", "che do an", "loi song",
           "che do sinh hoat"}
NAV = re.compile(r"cham soc ca nhan|ho tro tinh duc|tim hieu them|xem them|doc them|mua ngay|chat voi duoc si")
DOSE = re.compile(r"\d[\d.,]*\s*(mg|mcg|µg|viên)\b(?!\s*/)", re.I)


class Validator:
    def __init__(self, chunks: list[dict]):
        self.text_of = {c["id"]: alnum(c["text"]) for c in chunks}
        self.lines_of = {c["id"]: c["text"].split("\n") for c in chunks}

    def find_evidence(self, cid, name, no_dose=False):
        a = alnum(name)
        if not a:
            return None
        for line in self.lines_of[cid]:
            for sent in SENT.split(line):
                if a in alnum(sent) and not (no_dose and DOSE.search(sent)):
                    return sent.strip()
        return None

    def fix(self, t: dict) -> dict:
        t = dict(t)
        t["subject"], t["object"] = clean_name(t["subject"]), clean_name(t["object"])
        if t["mode"] == "guided":
            item = "subject" if (t["relation"] == "TREATED_BY" and "/thuoc/" in t["url"]) else "object"
            ok = alnum(t["evidence"]) in self.text_of[t["chunk_id"]] and alnum(t[item]) in alnum(t["evidence"])
            if alnum(t[item]) and not ok:
                ev = self.find_evidence(t["chunk_id"], t[item])
                if ev:
                    t["evidence"], t["evidence_fixed"] = ev, True
        return t

    def check(self, t: dict):
        if t["relation"] not in REL:
            return "quan hệ lạ"
        dom, rng = REL[t["relation"]]
        if t["subject_type"] != dom or t["object_type"] not in rng:
            return "sai miền/giá trị"
        tx = self.text_of[t["chunk_id"]]
        if not t["evidence"] or alnum(t["evidence"]) not in tx:
            return "câu trích không khớp văn bản"
        for name in (t["subject"], t["object"]):
            a = alnum(name)
            if len(a) < 3 or a in GENERIC:
                return "tên quá chung chung"
            if len(name.split()) > 12:
                return "tên quá dài (là cả câu)"
        if t["mode"] == "general":
            if alnum(t["subject"]) not in tx and alnum(t["subject"]) not in alnum(t["url"]):
                return "tên không có trong văn bản"
            if alnum(t["object"]) not in tx:
                return "tên không có trong văn bản"
            if alnum(t["object"]) not in alnum(t["evidence"]):
                return "câu trích không chứa thực thể"
        if NAV.search(alnum(t["evidence"])):
            return "rác giao diện web"
        return None

    def drop_dose(self, t: dict):
        """Trang thuốc: thay câu trích có liều bằng câu khác của cùng thực thể; không có thì bỏ."""
        if "/thuoc/" not in t["url"] or not DOSE.search(t["evidence"]):
            return t
        item = "subject" if (t["relation"] == "TREATED_BY" and t["mode"] == "guided") else "object"
        ev = self.find_evidence(t["chunk_id"], t[item], no_dose=True)
        return {**t, "evidence": ev, "evidence_fixed": True} if ev else None


def validate(raw: list[dict], chunks: list[dict]) -> list[dict]:
    v = Validator(chunks)
    ids = {c["id"] for c in chunks}
    raw = [v.fix(t) for t in raw if t["chunk_id"] in ids]
    for t in raw:
        t["reason"] = v.check(t)
    good = [x for x in (v.drop_dose(t) for t in raw if not t["reason"]) if x]
    print(f"Giữ {len(good)}/{len(raw)} ({len(good) / max(len(raw), 1):.1%})")
    print("Theo chế độ:", {m: f"{sum(1 for t in good if t['mode'] == m)}/{sum(1 for t in raw if t['mode'] == m)}" for m in ("guided", "general")})
    print("Lý do loại:", Counter((t["mode"], t["reason"]) for t in raw if t["reason"]).most_common(8))
    left = sum(1 for t in good if "/thuoc/" in t["url"] and DOSE.search(t["evidence"]))
    print("Bộ ba trang thuốc còn nghi liều:", left)
    return good


def main(skip_llm: bool = False):
    chunks = read_jsonl(config.KB_DIR / "chunks_final.jsonl")
    raw_path = config.KB_DIR / "raw_triples.json"
    if skip_llm and raw_path.exists():
        raw = json.load(open(raw_path, encoding="utf-8"))
    else:
        from tqdm.auto import tqdm
        raw = []
        for c in tqdm(chunks):
            raw.extend(extract_chunk(c))
        json.dump(raw, open(raw_path, "w", encoding="utf-8"), ensure_ascii=False)
    print("Bộ ba thô:", len(raw), Counter(r["mode"] for r in raw))
    good = validate(raw, chunks)
    json.dump(good, open(config.KB_DIR / "triples_valid.json", "w", encoding="utf-8"), ensure_ascii=False)
    return good


if __name__ == "__main__":
    import argparse
    ap = argparse.ArgumentParser()
    ap.add_argument("--skip-llm", action="store_true", help="dùng raw_triples.json có sẵn, chỉ chạy bước kiểm tra")
    main(ap.parse_args().skip_llm)
