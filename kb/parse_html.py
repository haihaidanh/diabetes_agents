"""Tách các trang Long Châu (HTML lưu bằng SingleFile) thành mục và chunk.

Chạy: python -m kb.parse_html      ->  artifacts/kb/chunks_final.jsonl
Long Châu chặn request từ script (Cloudflare), nên trang được lưu thủ công bằng tiện ích SingleFile
rồi đặt vào data/raw_html/. Trang bệnh phải bấm "Xem thêm" trước khi lưu.
"""
import hashlib
import re
from collections import Counter
from pathlib import Path

from bs4 import BeautifulSoup

import config
from common.text import norm, write_jsonl

MAX_WORDS = 320
JUNK_HEAD = re.compile(r"san pham|bai viet lien quan|hoi dap|muc luc|tac gia|binh luan|goi y|"
                       r"nguon tham khao|dang ky|xem them|danh muc")
STOP = re.compile(r"benh lien quan|bai viet lien quan|cau hoi thuong gap|hoi dap|binh luan|tac gia|"
                  r"nguon tham khao|co the ban quan tam|kiem tra nguy co|goi y cho ban")
PRODUCT = re.compile(r"^(sua |que thu|bo truyen|vien ho tro|may do|dung dich|kem boi|dau kim)|"
                     r"\((?:hop|\d+ ?(?:vi|vien|que|g|ml|chai|goi|cai)\b)")


def get_url(html: str, soup) -> str:
    m = re.search(r"url:\s*(https?://\S+)", html[:3000])
    if m:
        return m.group(1)
    c = soup.find("link", rel="canonical")
    return c["href"] if c else ""


def parse_page(path: Path) -> dict:
    html = path.read_text(encoding="utf-8", errors="ignore")
    soup = BeautifulSoup(html, "lxml")
    url = get_url(html, soup)
    for t in soup(["script", "style", "nav", "footer", "aside", "form", "noscript", "svg", "button", "iframe", "header"]):
        t.decompose()
    root = soup.find("article") or soup.find("main") or soup.body
    h1 = soup.find("h1")
    title = h1.get_text(" ", strip=True) if h1 else path.stem
    sections, cur = [], {"heading": title, "lines": []}
    for el in root.find_all(["h2", "h3", "h4", "p", "li", "tr"]):
        if el.name in ("h2", "h3", "h4"):
            sections.append(cur)
            cur = {"heading": el.get_text(" ", strip=True), "lines": []}
            continue
        if el.name == "li" and el.find("li"):
            continue                                              # chỉ lấy li lá
        if el.name == "p" and el.find_parent(["li", "td"]):
            continue                                              # tránh trùng
        if el.name == "tr":
            txt = " | ".join(c.get_text(" ", strip=True) for c in el.find_all(["td", "th"]))
        else:
            txt = el.get_text(" ", strip=True)
        if len(txt.split()) >= 3:
            cur["lines"].append(txt)
    sections.append(cur)
    return {"slug": path.stem, "url": url, "title": title, "sections": sections}


def clean(p: dict, heading_count: Counter) -> dict:
    """Cắt từ mục rác (bài/sản phẩm liên quan) trở xuống; gộp đoạn văn bị nhận nhầm là tiêu đề."""
    out = []
    for i, s in enumerate(p["sections"]):
        hn = norm(s["heading"])
        if i > 0 and (STOP.search(hn) or PRODUCT.search(hn)
                      or ("/bai-viet/" in p["url"] and heading_count[s["heading"]] >= 2)):
            break
        if len(s["heading"].split()) > 20 and out:
            out[-1]["lines"] += [s["heading"]] + s["lines"]
            continue
        out.append(s)
    return {**p, "sections": out}


def build_chunks(pages: list[dict]) -> list[dict]:
    h = lambda s: hashlib.md5(" ".join(s["lines"]).encode()).hexdigest()
    cnt = Counter(h(s) for p in pages for s in p["sections"] if s["lines"])      # khối lặp ở >= 3 trang
    ok = lambda s: s["lines"] and not JUNK_HEAD.search(norm(s["heading"])) and cnt[h(s)] < 3
    chunks = []
    for p in pages:
        for s in filter(ok, p["sections"]):
            buf, n = [], 0
            for line in s["lines"] + [None]:
                w = len(line.split()) if line else 0
                if line is None or n + w > MAX_WORDS:
                    if buf:
                        chunks.append({"id": f"{p['slug']}-{len(chunks)}", "url": p["url"], "page": p["title"],
                                       "section": s["heading"], "text": "\n".join(buf)})
                    buf, n = [], 0
                if line:
                    buf.append(line)
                    n += w
    return chunks


def main(html_dir: Path | None = None) -> list[dict]:
    files = sorted((html_dir or config.HTML_DIR).rglob("*.html"))
    if not files:
        raise FileNotFoundError(f"Không có file .html trong {html_dir or config.HTML_DIR}")
    pages = [parse_page(f) for f in files]
    heading_count = Counter(h for p in pages for h in {s["heading"] for s in p["sections"]})
    pages = [clean(p, heading_count) for p in pages]
    chunks = build_chunks(pages)
    write_jsonl(config.KB_DIR / "chunks_final.jsonl", chunks)
    print(f"{len(pages)} trang -> {len(chunks)} chunk")
    for p in pages:
        n = sum(c["page"] == p["title"] for c in chunks)
        print(f"  {p['slug'][:55]:55} {n:3} chunk | mục cuối: {[s['heading'] for s in p['sections']][-2:]}")
    return chunks


if __name__ == "__main__":
    main()
