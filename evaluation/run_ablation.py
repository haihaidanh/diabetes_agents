"""Ablation 4 cấu hình x 24 kịch bản -> artifacts/eval/ablation.csv (+ answers.jsonl)."""
import json
import time

import pandas as pd

import config
from agents.graph import run_case
from agents.settings import SETTINGS

from .metrics import score
from .scenarios import SCENARIOS
from .single_agent import run_single

CONFIGS = {
    "single_agent": None,
    "multi_rag": dict(use_critic=False, knowledge_mode="rag", use_llm_critic=False),
    "multi_kg": dict(use_critic=False, knowledge_mode="kg", use_llm_critic=False),
    "multi_kg_critic": dict(use_critic=True, knowledge_mode="kg", use_llm_critic=True),
}


def main(limit: int | None = None):
    rows, f = [], open(config.EVAL_DIR / "answers.jsonl", "w", encoding="utf-8")
    for name, cfg in CONFIGS.items():
        if cfg:
            SETTINGS.update(cfg)
        for s in SCENARIOS[:limit]:
            t = time.time()
            try:
                out = run_single(s["q"]) if cfg is None else run_case(s["q"])
            except Exception as e:
                out = {"answer": f"LỖI: {e}", "trace": []}
            m = score(out) | {"config": name, "id": s["id"], "type": s["type"]}
            rows.append(m)
            f.write(json.dumps({"config": name, "id": s["id"], "q": s["q"], "answer": out.get("answer")}, ensure_ascii=False) + "\n")
            print(f"{name:16s} {s['id']:4s} {time.time()-t:5.1f}s issues={m['rule_issues']}")
    df = pd.DataFrame(rows)
    df.to_csv(config.EVAL_DIR / "ablation_raw.csv", index=False)
    summary = df.groupby("config").agg(rule_issues=("rule_issues", "mean"), dosage=("has_dosage", "sum"),
                                       diagnosis=("claims_diagnosis", "sum"), doctor=("advises_doctor", "mean"),
                                       cited=("n_cited", "mean"), llm_calls=("llm_calls", "mean"), seconds=("seconds", "mean")).round(2)
    summary.to_csv(config.EVAL_DIR / "ablation.csv")
    print(summary)
    return summary


if __name__ == "__main__":
    main()
