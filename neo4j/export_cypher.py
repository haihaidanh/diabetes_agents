"""Export the generated NetworkX graph as standalone Cypher.

Run from the repository root:
    python neo4j/export_cypher.py

The generated file can be pasted into Neo4j Browser or run with cypher-shell
against a local Neo4j instance. It does not read or modify Aura.
"""
import json
import pickle
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

import config


SAFE_IDENTIFIER = re.compile(r"^[A-Za-z_][A-Za-z0-9_]*$")
OUT = Path(__file__).resolve().parent / "02_load_graph.cypher"


def cypher_string(value) -> str:
    """Return a Cypher string literal, preserving Vietnamese text."""
    return json.dumps(str(value), ensure_ascii=False)


def property_literal(value) -> str:
    if isinstance(value, bool):
        return "true" if value else "false"
    if isinstance(value, (int, float)):
        return repr(value)
    return cypher_string(value)


def main() -> None:
    graph_path = config.KB_DIR / "kg.pkl"
    if not graph_path.exists():
        raise FileNotFoundError(
            f"Không thấy {graph_path}; hãy chạy 'python main.py kg' trước."
        )

    graph = pickle.load(open(graph_path, "rb"))
    lines = [
        "// Generated from artifacts/kb/kg.pkl. Do not edit manually.",
        "// Load after 01_schema.cypher in a local Neo4j database.",
        "MATCH (n) DETACH DELETE n;",
        "",
    ]

    for name, data in graph.nodes(data=True):
        typ = data.get("type", "Entity")
        props = {"name": name, "type": typ}
        assignments = ", ".join(
            f"n.{key} = {property_literal(value)}"
            for key, value in props.items()
        )
        lines.append(
            f"MERGE (n:Entity {{name: {cypher_string(name)}}}) "
            f"SET {assignments};"
        )

    lines.append("")
    for subject, obj, data in graph.edges(data=True):
        relation = data.get("relation")
        if not isinstance(relation, str) or not SAFE_IDENTIFIER.fullmatch(relation):
            raise ValueError(f"Quan hệ không hợp lệ: {relation!r}")
        props = {
            key: value
            for key, value in data.items()
            if key != "relation" and value is not None
        }
        assignments = ", ".join(
            f"r.{key} = {property_literal(value)}"
            for key, value in props.items()
        )
        set_clause = f" SET {assignments}" if assignments else ""
        lines.append(
            f"MATCH (a:Entity {{name: {cypher_string(subject)}}}), "
            f"(b:Entity {{name: {cypher_string(obj)}}}) "
            f"CREATE (a)-[r:{relation}]->(b){set_clause};"
        )

    OUT.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"Created {OUT}: {graph.number_of_nodes()} nodes, {graph.number_of_edges()} relationships")


if __name__ == "__main__":
    main()
