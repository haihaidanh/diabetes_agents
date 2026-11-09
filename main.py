"""CLI: python main.py <lệnh>
  train            huấn luyện mô hình ML (thêm --mlp nếu có torch)
  parse            HTML -> chunks
  extract          chunks -> triples (LLM, chậm; --skip-llm để chỉ validate cache)
  thresholds       in các ngưỡng chẩn đoán trích được để duyệt
  kg               xây Knowledge Graph (--no-embed bỏ gộp bằng embedding)
  ask "câu hỏi"    hỏi một câu
  ui               mở giao diện Gradio
  eval             chạy ablation 4 cấu hình x 24 kịch bản
"""
import sys


def main(argv):
    if not argv or argv[0] in ("-h", "--help"):
        print(__doc__)
        return
    cmd, rest = argv[0], argv[1:]
    if cmd == "train":
        from ml.train import main as f
        f(use_mlp="--mlp" in rest)
    elif cmd == "parse":
        from kb.parse_html import main as f
        f()
    elif cmd == "extract":
        from kb.extract import main as f
        f(skip_llm="--skip-llm" in rest)
    elif cmd == "thresholds":
        import runpy
        runpy.run_module("kb.thresholds", run_name="__main__")
    elif cmd == "kg":
        from kb.build_kg import main as f
        f(embed_merge="--no-embed" not in rest)
    elif cmd == "neo4j-push":
        from kb.neo4j_store import push
        push()
    elif cmd == "ask":
        from agents.graph import run_case
        out = run_case(" ".join(rest))
        print("\n".join(f"[{t['agent']}] {t['decision']}" for t in out["trace"]), "\n")
        print(out["answer"])
    # elif cmd == "ui":
    #     from ui.gradio_app import launch
    #     launch()
    elif cmd == "ui":
        from ui.web_app import launch
        launch(tunnel="--tunnel" in rest, block=True)
    elif cmd == "eval":
        from evaluation.run_ablation import main as f
        f()
    else:
        print(__doc__)


if __name__ == "__main__":
    main(sys.argv[1:])
