"""Trích ngưỡng chẩn đoán (HbA1c, đường huyết) từ câu văn bằng biểu thức chính quy.

Không dùng LLM nên kết quả tất định. Bộ lọc `plausible` thay cho bước duyệt tay: loại các con số
không phải ngưỡng chẩn đoán (mức giảm HbA1c của thuốc, % giảm cân, mục tiêu đường huyết sau ăn,
ngưỡng hạ đường huyết...). Vẫn nên đọc danh sách in ra để kiểm chứng.
"""
import re

from common.text import norm, num, sentences

NUM = r"(\d+(?:[.,]\d+)?)"
UNIT = r"(%|mg/dl|mmol/l)"
OPS = [(r"lon hon hoac bang|>=|≥|tu", ">="), (r"nho hon hoac bang|<=|≤", "<="), (r"tren|lon hon|>", ">"), (r"duoi|nho hon|<", "<")]
BAD_CTX = re.compile(r"giam|ha duong huyet|muc tieu|truoc an|sau an|trong luong|can nang|tang them|thuoc|insulin")

FASTING, RANDOM, OGTT, GLUCOSE = "Đường huyết lúc đói", "Đường huyết bất kỳ", "Đường huyết sau 2 giờ (OGTT)", "Đường huyết"
DISEASE, PREDIABETES = "Đái tháo đường", "Tiền đái tháo đường"


def test_name(s: str):
    n = norm(s)
    if "hba1c" in n:
        return "HbA1c"
    if "duong huyet" in n or "glucose" in n or "duong mau" in n:
        if re.search(r"bat ky|ngau nhien", n):
            return RANDOM
        if re.search(r"luc doi|luc no|khi doi|\bdoi\b|nhin an", n):
            return FASTING
        if re.search(r"2 gio|ogtt|dung nap", n):
            return OGTT
        return GLUCOSE
    return None


def parse_threshold(s: str):
    n = norm(s).replace("≥", ">=").replace("≤", "<=")
    m = re.search(rf"(?:tu\s*)?{NUM}\s*{UNIT}?\s*(?:-|–|den)\s*{NUM}\s*{UNIT}", n)           # khoảng
    if m:
        return {"op": "range", "value": num(m.group(1)), "value_max": num(m.group(3)), "unit": m.group(4), "max_exclusive": False}
    m = re.search(rf"tu\s*{NUM}\s*{UNIT}?\s*(?:tro len)", n)
    if m:
        u = re.search(UNIT, n)
        return {"op": ">=", "value": num(m.group(1)), "unit": u.group(1) if u else None}
    for pat, op in OPS:
        m = re.search(rf"(?:{pat})\s*{NUM}\s*{UNIT}", n)
        if m:
            return {"op": op, "value": num(m.group(1)), "unit": m.group(2)}
    return None


def plausible(t: dict) -> bool:
    """Chỉ giữ ngưỡng chẩn đoán: HbA1c 4-15%, đường huyết mg/dL với phép >= hoặc khoảng."""
    v, u, tn = t["value"], t["unit"], t["test"]
    if BAD_CTX.search(norm(t["evidence"])):
        return False
    if tn == "HbA1c":
        return u == "%" and 4 <= v <= 15 and (t["op"] != "range" or t["value_max"] <= 15)
    if u != "mg/dl" or t["op"] not in (">=", "range") or v < 90:
        return False
    if tn == OGTT:
        return t["op"] == ">=" and v >= 140
    return True


def relabel(t: dict):
    """Chuẩn hóa nhãn bệnh/xét nghiệm theo dạng ngưỡng; trả None nếu không xác định được."""
    t = dict(t)
    t["disease"] = PREDIABETES if t["op"] == "range" else DISEASE            # khoảng 5,7–6,4 / 100–125 là tiền ĐTĐ
    if t["test"] == GLUCOSE:
        if t["op"] == ">=" and t["value"] == 126:
            t["test"] = FASTING
        elif t["op"] == ">=" and t["value"] == 200:
            t["test"] = RANDOM
        elif t["op"] == "range" and t["value"] == 100:
            t["test"] = FASTING
        else:
            return None
    return t


def extract_thresholds(chunks: list[dict]) -> list[dict]:
    found = []
    for c in chunks:
        if "/thuoc/" in c["url"]:
            continue
        for s in sentences(c["text"]):
            tn = test_name(s)
            th = parse_threshold(s) if tn else None
            if tn and th and th.get("unit"):
                found.append({**th, "test": tn, "evidence": s, "url": c["url"], "chunk_id": c["id"]})
    out, seen = [], set()
    for t in found:
        t = relabel(t) if plausible(t) else None
        if not t:
            continue
        k = (t["disease"], t["test"], t["op"], t["value"], t.get("value_max"), t["unit"])
        if k not in seen:
            seen.add(k)
            out.append(t)
    return out


if __name__ == "__main__":
    import config
    from common.text import read_jsonl
    for t in extract_thresholds(read_jsonl(config.KB_DIR / "chunks_final.jsonl")):
        hi = f"-{t['value_max']}" if t.get("value_max") else ""
        print(f"{t['disease']:22} {t['test']:30} {t['op']:6}{t['value']}{hi} {t['unit']} | {t['evidence'][:80]}")
