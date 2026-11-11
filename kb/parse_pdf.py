"""Thêm nguồn PDF vào knowledge base.

Đặt các file PDF (có lớp chữ, không phải ảnh quét) vào data/pdf/ rồi chạy SAU `python main.py parse`:
    python main.py parse-pdf
Các chunk PDF được thêm vào artifacts/kb/chunks_final.jsonl cùng schema với chunk HTML
(id "pdf-<tên>-<n>", url "pdf/<tên>#trang-<số>", page = tên file). Chạy lại nhiều lần vẫn đúng (chunk pdf cũ bị thay).
Sau đó chạy lại: extract (chỉ chunk mới gọi LLM nhờ cache) -> kg. Mô hình ML KHÔNG cần huấn luyện lại.
"""
import re
import unicodedata
from collections import Counter
from pathlib import Path

import config
from common.text import norm, read_jsonl, write_jsonl

PDF_DIR = Path(config.DATA_DIR) / "pdf"
MAX_WORDS = 320
END = re.compile(r"[.!?:;…)]\s*$")
BULLET = re.compile(r"^\s*(?:[-•●▪*–]|\d+[.)]|[a-z][.)])\s+")
HEAD_NUM = re.compile(r"^\s*(?:\d+(?:\.\d+)*[.)]?|[IVX]+[.)]|Chương\s+\d+|Phần\s+\d+)\s+\S")
SKIP_HEAD = re.compile(r"tai lieu tham khao|muc luc|loi cam on|danh muc|phu luc hinh|references|bibliography")


def _fix(t: str) -> str:
    t = unicodedata.normalize("NFC", t).replace("\u00ad", "").replace("\xa0", " ")
    return re.sub(r"[ \t]+", " ", t)


def read_pages(path: Path) -> list[str]:
    from pypdf import PdfReader
    return [_fix(p.extract_text() or "") for p in PdfReader(str(path)).pages]


def strip_repeated(pages: list[list[str]]) -> list[list[str]]:
    """Bỏ đầu/cuối trang lặp lại (số trang, tên tài liệu) xuất hiện ở >= 30% số trang."""
    n = len(pages)
    if n < 4:
        return pages
    key = lambda l: re.sub(r"\d+", "#", l.strip())
    cnt = Counter(key(l) for p in pages for l in set(p[:2] + p[-2:]) if l.strip())
    bad = {k for k, v in cnt.items() if v >= max(3, 0.3 * n)}
    return [[l for l in p if not (l.strip() and key(l) in bad and (l in p[:2] or l in p[-2:]))] for p in pages]


def is_heading(line: str) -> bool:
    w = len(line.split())
    if w == 0 or w > 14 or END.search(line):
        return False
    return bool(HEAD_NUM.match(line)) or (line.isupper() and w >= 2) or (line[:1].isupper() and w <= 8 and not BULLET.match(line))


def _heading_before(cur: str, nxt: str) -> bool:
    """`cur` là dòng tiêu đề đứng riêng (mục đánh số, chữ in hoa, hoặc dòng ngắn viết hoa đầu và dòng sau cũng viết hoa đầu)."""
    w = len(cur.split())
    if w > 14 or END.search(cur):
        return False
    return bool(HEAD_NUM.match(cur)) or (cur.isupper() and w >= 2) or (w <= 6 and cur[:1].isupper() and nxt[:1].isupper())


def paragraphs(lines: list[str]) -> list[str]:
    """Nối các dòng bị ngắt cứng thành câu/đoạn hoàn chỉnh (để câu trích trong KG là nguyên văn)."""
    out, cur = [], ""
    for l in lines:
        l = l.strip()
        if not l:
            if cur:
                out.append(cur); cur = ""
            continue
        if cur and (BULLET.match(l) or END.search(cur) or _heading_before(cur, l)):
            out.append(cur); cur = l
        else:
            cur = (cur[:-1] + l) if cur.endswith("-") and l[:1].islower() else f"{cur} {l}".strip()
    if cur:
        out.append(cur)
    return out


def parse_pdf(path: Path) -> list[dict]:
    raw = [p.split("\n") for p in read_pages(path)]
    if not any(l.strip() for p in raw for l in p):
        print(f"  [bỏ] {path.name}: không có lớp chữ (PDF ảnh quét, cần OCR)")
        return []
    pages = strip_repeated(raw)
    slug = re.sub(r"[^a-z0-9]+", "-", norm(path.stem)).strip("-")[:40]
    sections, head, buf, start = [], path.stem, [], 1
    for pno, lines in enumerate(pages, 1):
        for para in paragraphs(lines):
            if is_heading(para) and len(para) < 120:
                if buf:
                    sections.append((head, start, buf))
                head, buf, start = para.strip(), [], pno
            else:
                if not buf:
                    start = pno
                buf.append(para)
    if buf:
        sections.append((head, start, buf))
    chunks = []
    for head, pno, paras in sections:
        if SKIP_HEAD.search(norm(head)):
            continue
        cur, n = [], 0
        for para in paras + [None]:
            w = len(para.split()) if para else 0
            if para is None or n + w > MAX_WORDS:
                if cur and sum(len(x.split()) for x in cur) >= 12:
                    chunks.append({"id": f"pdf-{slug}-{len(chunks)}", "url": f"pdf/{path.stem}#trang-{pno}",
                                   "page": path.stem, "section": head, "text": "\n".join(cur)})
                cur, n = [], 0
            if para:
                cur.append(para); n += w
    return chunks


def main(pdf_dir: Path | None = None):
    files = sorted((pdf_dir or PDF_DIR).rglob("*.pdf"))
    if not files:
        raise FileNotFoundError(f"Không có file .pdf trong {pdf_dir or PDF_DIR}")
    new = []
    for f in files:
        c = parse_pdf(f)
        print(f"  {f.name[:60]:60} {len(c):3} chunk")
        new += c
    path = config.KB_DIR / "chunks_final.jsonl"
    old = [c for c in (read_jsonl(path) if path.exists() else []) if not c["id"].startswith("pdf-")]
    write_jsonl(path, old + new)
    print(f"{len(files)} PDF -> {len(new)} chunk; tổng {len(old) + len(new)} chunk ({len(old)} HTML)")
    return new


if __name__ == "__main__":
    main()