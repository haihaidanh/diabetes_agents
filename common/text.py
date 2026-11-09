"""Hàm xử lý văn bản tiếng Việt dùng chung."""
import json
import re
import unicodedata

SENT = re.compile(r"(?<=[.!?;:])\s+")


def norm(s: str) -> str:
    """Bỏ dấu, hạ chữ thường (đ -> d)."""
    s = s.replace("đ", "d").replace("Đ", "D")
    return "".join(c for c in unicodedata.normalize("NFD", s) if unicodedata.category(c) != "Mn").lower()


def alnum(s: str) -> str:
    """Chuẩn hóa mạnh: không dấu, chỉ chữ-số, cách nhau một khoảng trắng."""
    return re.sub(r"[^a-z0-9]+", " ", norm(s)).strip()


def clean_name(s) -> str:
    return re.sub(r"\s+", " ", str(s)).strip(" .;:,-–•\t\"'")


def sentences(text: str, min_words: int = 4):
    for line in text.split("\n"):
        for s in SENT.split(line):
            if len(s.split()) >= min_words:
                yield s.strip()


fmt = lambda x: f"{x:g}".replace(".", ",")                       # 6.5 -> "6,5"
pct = lambda p: f"{p * 100:.1f}".replace(".", ",") + "%"          # 0.109 -> "10,9%"
num = lambda s: float(s.replace(",", "."))


def read_jsonl(path):
    with open(path, encoding="utf-8") as f:
        return [json.loads(line) for line in f if line.strip()]


def write_jsonl(path, rows):
    with open(path, "w", encoding="utf-8") as f:
        for r in rows:
            f.write(json.dumps(r, ensure_ascii=False) + "\n")
