"""Chuẩn hóa/gộp thực thể, thêm ngưỡng + Feature, dựng Knowledge Graph (NetworkX) và embedding.

Chạy: python -m kb.build_kg [--no-embed]
Đầu ra (artifacts/kb): kg.pkl, kg_triples.json, merge_decisions.csv, precision_sample.csv, emb.npz, ents.json
"""
import csv
import json
import pickle
import random
import re
from collections import Counter

import networkx as nx
import numpy as np

import config
from common.text import alnum, norm, read_jsonl, sentences
from kb.thresholds import extract_thresholds

# từ đồng nghĩa của bệnh (khóa: tên không dấu)
SYN = {"tieu duong": "Đái tháo đường", "dai thao duong": "Đái tháo đường", "dtd": "Đái tháo đường",
       "benh tieu duong": "Đái tháo đường", "benh dai thao duong": "Đái tháo đường",
       "tieu duong tuyp 2": "Đái tháo đường tuýp 2", "tieu duong type 2": "Đái tháo đường tuýp 2",
       "dai thao duong tuyp 2": "Đái tháo đường tuýp 2", "dai thao duong type 2": "Đái tháo đường tuýp 2",
       "tieu duong tuyp 1": "Đái tháo đường tuýp 1", "tieu duong type 1": "Đái tháo đường tuýp 1",
       "dai thao duong tuyp 1": "Đái tháo đường tuýp 1", "tang huyet ap": "Tăng huyết áp",
       "cao huyet ap": "Tăng huyết áp", "huyet ap cao": "Tăng huyết áp"}

# các cặp cosine 0,92-0,95 đã duyệt tay (bản -> bản chuẩn). Cặp tên khác bệnh (vd. mạch máu ngoại biên) giữ riêng.
MANUAL_MERGE = {"Hút thuốc": "Hút thuốc lá", "Bệnh thận": "Bệnh lý thận", "Tiểu nhiều": "Đi tiểu nhiều",
                "Nhiễm trùng sinh dục": "Nhiễm trùng đường sinh dục", "Bệnh thận mạn tính": "Bệnh thận mạn",
                "Thường xuyên tập luyện thể dục hàng ngày": "Tập thể dục thường xuyên",
                "Vận động thường xuyên": "Tập thể dục thường xuyên",
                "Tăng cường vận động thể lực": "Tăng cường vận động", "Vận động thể lực": "Tăng cường vận động",
                "Khám sức khỏe định kỳ": "Thăm khám định kỳ", "Đường huyết đói": "Đường huyết lúc đói"}

# BELONGS_TO chỉ thêm khi chính trang thuốc nói rõ nhóm thuốc (câu trích tìm trong chunk)
BELONGS = [("Metformin", "Biguanid", "metformin"), ("Forxiga", "Thuốc ức chế SGLT2", "sglt2"),
           ("Dorocron", "Sulfonylurea", "sulfonylurea")]

# đặc trưng của mô hình -> thực thể tri thức (loại, regex tên không dấu)
FEATURES = {"HbA1c_level": (None, r"hba1c"), "blood_glucose_level": ("Test", r"duong huyet|glucose"),
            "hypertension": (None, r"^tang huyet ap$"), "heart_disease": (None, r"tim mach|dong mach|mach vanh|nhoi mau"),
            "bmi": ("RiskFactor", r"beo phi|thua can|\bbmi\b"), "age": ("RiskFactor", r"tuoi"),
            "smoking_history": ("RiskFactor", r"hut thuoc"), "gender": ("RiskFactor", r"gioi")}


def canon(name: str, typ: str) -> str:
    k = alnum(name)
    if typ == "Disease" and k in SYN:
        name = SYN[k]
    name = name.strip()
    return name[:1].upper() + name[1:]


def embedding_merge(names_by_type: dict, hi=0.95, lo=0.92):
    """Gộp thực thể cùng loại có cosine bge-m3 >= hi; cặp trong [lo, hi) ghi ra để duyệt tay."""
    from common.embed import embed
    keys = [(n, t) for t, ns in names_by_type.items() for n in ns]
    vec = embed([k[0] for k in keys])
    parent = list(range(len(keys)))

    def find(x):
        while parent[x] != x:
            parent[x] = parent[parent[x]]
            x = parent[x]
        return x

    review = []
    for typ in names_by_type:
        idx = [i for i, k in enumerate(keys) if k[1] == typ]
        S = vec[idx] @ vec[idx].T
        for a in range(len(idx)):
            for b in range(a + 1, len(idx)):
                if S[a, b] >= hi:
                    parent[find(idx[b])] = find(idx[a])
                elif S[a, b] >= lo:
                    review.append((typ, keys[idx[a]][0], keys[idx[b]][0], round(float(S[a, b]), 3)))
    return {keys[i]: keys[find(i)][0] for i in range(len(keys))}, review


def main(embed_merge: bool = True):
    kb = config.KB_DIR
    good = json.load(open(kb / "triples_valid.json", encoding="utf-8"))
    chunks = read_jsonl(kb / "chunks_final.jsonl")
    TH = extract_thresholds(chunks)
    print("Ngưỡng chẩn đoán trích được:", len(TH))

    # 1) chuẩn hóa tên (từ đồng nghĩa)
    for t in good:
        t["subject"], t["object"] = canon(t["subject"], t["subject_type"]), canon(t["object"], t["object_type"])

    # 2) gộp theo embedding
    review = []
    if embed_merge:
        by_type: dict = {}
        for t in good:
            by_type.setdefault(t["subject_type"], set()).add(t["subject"])
            by_type.setdefault(t["object_type"], set()).add(t["object"])
        by_type = {k: sorted(v) for k, v in by_type.items()}
        rep, review = embedding_merge(by_type)
        for t in good:
            t["subject"] = rep.get((t["subject"], t["subject_type"]), t["subject"])
            t["object"] = rep.get((t["object"], t["object_type"]), t["object"])
        print("Cặp chờ duyệt tay:", len(review))
    with open(kb / "merge_decisions.csv", "w", encoding="utf-8", newline="") as f:
        csv.writer(f).writerows([("type", "a", "b", "cosine"), *review])

    # 3) gộp đã duyệt tay + bỏ trùng
    M = lambda n: MANUAL_MERGE.get(n, n)
    for t in good:
        t["subject"], t["object"] = M(t["subject"]), M(t["object"])
    seen, dedup = set(), []
    for t in good:
        k = (t["subject"], t["relation"], t["object"])
        if t["subject"] != t["object"] and k not in seen:
            seen.add(k)
            dedup.append(t)
    good = dedup

    # 4) BELONGS_TO từ chính văn bản trang thuốc
    for drug, cls, kw in BELONGS:
        for c in chunks:
            if "/thuoc/" in c["url"] and norm(drug) in norm(c["page"]):
                ev = next((s for s in sentences(c["text"]) if kw in norm(s) and ("nhom" in norm(s) or "thuoc" in norm(s))), None)
                if ev:
                    good.append({"subject": drug, "subject_type": "Drug", "relation": "BELONGS_TO", "object": cls,
                                 "object_type": "DrugClass", "evidence": ev, "url": c["url"], "chunk_id": c["id"], "mode": "rule"})
                    print("BELONGS_TO", drug, "->", cls)
                    break
        else:
            print("không có nguồn nêu nhóm thuốc của", drug, "-> bỏ qua")

    # 5) dựng đồ thị
    G = nx.MultiDiGraph()

    def node(name, typ):
        if name not in G or G.nodes[name]["type"] != "Disease":      # Disease được ưu tiên khi một tên có nhiều kiểu
            G.add_node(name, type=typ)

    for t in good:
        node(t["subject"], t["subject_type"])
        node(t["object"], t["object_type"])
        G.add_edge(t["subject"], t["object"], relation=t["relation"], evidence=t["evidence"], url=t["url"])
    for t in TH:                                                      # DIAGNOSED_BY có ngưỡng số
        d, x = M(canon(t["disease"], "Disease")), M(t["test"])
        node(d, "Disease")
        node(x, "Test")
        G.add_edge(d, x, relation="DIAGNOSED_BY", evidence=t["evidence"], url=t["url"], op=t["op"], value=t["value"],
                   unit=t["unit"], **({"value_max": t["value_max"]} if t.get("value_max") else {}))
    for feat, (typ, pat) in FEATURES.items():                          # cầu nối dữ liệu - tri thức
        node(feat, "Feature")
        hits = [n for n, d in G.nodes(data=True) if d["type"] != "Feature" and (typ is None or d["type"] == typ)
                and re.search(pat, norm(n))]
        for n in hits:
            G.add_edge(feat, n, relation="MAPS_TO")
        print(f"  {feat:22} -> {hits[:4] or 'KHÔNG CÓ node tri thức'}")

    pickle.dump(G, open(kb / "kg.pkl", "wb"))
    json.dump(good, open(kb / "kg_triples.json", "w", encoding="utf-8"), ensure_ascii=False)
    print("\nThực thể:", G.number_of_nodes(), Counter(d["type"] for _, d in G.nodes(data=True)).most_common())
    print("Quan hệ:", G.number_of_edges(), Counter(d["relation"] for *_, d in G.edges(data=True)).most_common())
    for a, b, d in G.edges(data=True):
        if d.get("op"):
            print(f"  ngưỡng: {a} | {b} {d['op']} {d['value']}{'-' + str(d['value_max']) if 'value_max' in d else ''} {d['unit']}")

    # 6) mẫu 50 quan hệ để TỰ chấm precision (cột dung(1)/sai(0))
    random.seed(7)
    smp = random.sample([t for t in good if t["relation"] != "MAPS_TO"], min(50, len(good)))
    with open(kb / "precision_sample.csv", "w", encoding="utf-8", newline="") as f:
        w = csv.writer(f)
        w.writerow(["#", "subject", "relation", "object", "evidence", "url", "dung(1)/sai(0)", "ghi_chu"])
        for i, t in enumerate(smp, 1):
            w.writerow([i, t["subject"], t["relation"], t["object"], t["evidence"], t["url"], "", ""])

    # 7) embedding cho công cụ truy xuất
    if embed_merge:
        from common.embed import embed
        ents = [n for n, d in G.nodes(data=True) if d["type"] != "Feature"]
        np.savez(kb / "emb.npz", E_ent=embed(ents), E_chunk=embed([f"{c['page']}. {c['section']}. {c['text']}" for c in chunks]))
        json.dump(ents, open(kb / "ents.json", "w", encoding="utf-8"), ensure_ascii=False)
        print("Đã lưu emb.npz, ents.json")


if __name__ == "__main__":
    import argparse
    ap = argparse.ArgumentParser()
    ap.add_argument("--no-embed", action="store_true", help="bỏ gộp bằng embedding và không tạo emb.npz (không cần Ollama)")
    main(not ap.parse_args().no_embed)
