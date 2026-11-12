"""Lưu / truy vấn Knowledge Graph bằng Neo4j (AuraDB Free chạy được từ Kaggle).

Biến môi trường: NEO4J_URI (neo4j+s://xxxx.databases.neo4j.io), NEO4J_USER (mặc định neo4j), NEO4J_PASSWORD.
  python main.py neo4j-push      nạp artifacts/kb/kg.pkl lên Neo4j
  KG_BACKEND=neo4j               khiến kg_tools truy vấn Neo4j thay vì kg.pkl
"""
import os
import pickle
import re

import config

_SAFE = re.compile(r"^[A-Za-z_][A-Za-z0-9_]*$")


def _driver():
    from neo4j import GraphDatabase
    uri, pw = os.getenv("NEO4J_URI"), os.getenv("NEO4J_PASSWORD")
    if not uri or not pw:
        raise RuntimeError("Thiếu NEO4J_URI / NEO4J_PASSWORD")
    return GraphDatabase.driver(uri, auth=(os.getenv("NEO4J_USER", "neo4j"), pw))


def _ident(s: str) -> str:
    if not _SAFE.match(s):
        raise ValueError(f"định danh không hợp lệ: {s!r}")
    return s


def push(G=None, clear: bool = True, batch: int = 500):
    """Nạp NetworkX MultiDiGraph lên Neo4j."""
    if G is None:
        G = pickle.load(open(config.KB_DIR / "kg.pkl", "rb"))
    drv = _driver()
    with drv.session() as s:
        if clear:
            s.run("MATCH (n:Entity) DETACH DELETE n")
        s.run("CREATE CONSTRAINT entity_name IF NOT EXISTS FOR (n:Entity) REQUIRE n.name IS UNIQUE")
        by_type: dict = {}
        for n, d in G.nodes(data=True):
            by_type.setdefault(d["type"], []).append({"name": n, "type": d["type"]})
        for typ, rows in by_type.items():
            for i in range(0, len(rows), batch):
                s.run(f"UNWIND $rows AS r MERGE (n:Entity {{name: r.name}}) SET n:{_ident(typ)}, n.type = r.type",
                      rows=rows[i:i + batch])
        by_rel: dict = {}
        for a, b, d in G.edges(data=True):
            props = {k: v for k, v in d.items() if k != "relation" and v is not None}
            by_rel.setdefault(d["relation"], []).append({"a": a, "b": b, "p": props})
        for rel, rows in by_rel.items():
            for i in range(0, len(rows), batch):
                s.run(f"UNWIND $rows AS r MATCH (x:Entity {{name: r.a}}), (y:Entity {{name: r.b}}) "
                      f"CREATE (x)-[e:{_ident(rel)}]->(y) SET e = r.p", rows=rows[i:i + batch])
        n_nodes = s.run("MATCH (n:Entity) RETURN count(n) AS c").single()["c"]
        n_edges = s.run("MATCH (:Entity)-[r]->(:Entity) RETURN count(r) AS c").single()["c"]
    drv.close()
    print(f"Đã nạp lên Neo4j: {n_nodes} thực thể, {n_edges} quan hệ")


class _Nodes(dict):
    pass


class Neo4jGraph:
    """Mô phỏng phần NetworkX mà kg_tools dùng (in, nodes[x], out_edges, in_edges, edges), truy vấn bằng Cypher."""

    def __init__(self, driver=None):
        self.drv = driver or _driver()
        rows = self._run("MATCH (n:Entity) RETURN n.name AS name, n.type AS type")
        self.nodes = _Nodes({r["name"]: {"type": r["type"]} for r in rows})

    def _run(self, q, **kw):
        with self.drv.session() as s:
            return [dict(r) for r in s.run(q, **kw)]

    def __contains__(self, name):
        return name in self.nodes

    def degree(self, name=None):
        """Return the number of incoming and outgoing relationships for an entity."""
        if name is None:
            return {entity: self.degree(entity) for entity in self.nodes}
        rows = self._run(
            "MATCH (n:Entity {name:$n}) "
            "OPTIONAL MATCH (n)-[r]-() "
            "RETURN count(r) AS c",
            n=name,
        )
        return int(rows[0]["c"]) if rows else 0

    @staticmethod
    def _edge(r):
        return r["a"], r["b"], {**r["p"], "relation": r["rel"]}

    def out_edges(self, n, data=True):
        return [self._edge(r) for r in self._run(
            "MATCH (x:Entity {name:$n})-[e]->(y:Entity) RETURN x.name AS a, y.name AS b, type(e) AS rel, properties(e) AS p", n=n)]

    def in_edges(self, n, data=True):
        return [self._edge(r) for r in self._run(
            "MATCH (x:Entity)-[e]->(y:Entity {name:$n}) RETURN x.name AS a, y.name AS b, type(e) AS rel, properties(e) AS p", n=n)]

    def edges(self, data=True):
        """Chỉ các quan hệ có ngưỡng số (op), là phần duy nhất kg_tools quét toàn đồ thị."""
        return [self._edge(r) for r in self._run(
            "MATCH (x:Entity)-[e]->(y:Entity) WHERE e.op IS NOT NULL "
            "RETURN x.name AS a, y.name AS b, type(e) AS rel, properties(e) AS p")]