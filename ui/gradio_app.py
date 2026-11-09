"""Giao diện Gradio: chat + form hồ sơ + vết chạy các agent."""
from agents.graph import run_case
from agents.settings import SETTINGS


def chat_fn(message, history, age, gender, bmi, hba1c, glucose, patient_state):
    form = {k: v for k, v in {"age": age, "gender": gender, "bmi": bmi,
                              "HbA1c_level": hba1c, "blood_glucose_level": glucose}.items() if v not in (None, "", 0)}
    out = run_case(message, form=form, patient=patient_state or {})
    trace = "\n".join(f"{t['agent']:<10} {t['sec']:>5}s  llm={t['llm']}  {t['decision']}" for t in out["trace"])
    return out["answer"], out.get("patient") or {}, trace


def launch(share: bool = True):
    import gradio as gr
    with gr.Blocks(title="Tư vấn nguy cơ tiểu đường") as demo:
        gr.Markdown("## Tư vấn nguy cơ tiểu đường (đa agent)")
        state = gr.State({})
        with gr.Row():
            with gr.Column(scale=1):
                age = gr.Number(label="Tuổi")
                gender = gr.Dropdown(["", "Male", "Female"], label="Giới tính", value="")
                bmi = gr.Number(label="BMI")
                hba1c = gr.Number(label="HbA1c (%)")
                glucose = gr.Number(label="Đường huyết (mg/dL)")
                src = gr.Checkbox(label="Hiện nguồn", value=SETTINGS["show_sources"])
                src.change(lambda v: SETTINGS.update(show_sources=v), src, None)
            with gr.Column(scale=2):
                q = gr.Textbox(label="Câu hỏi", lines=3)
                btn = gr.Button("Gửi", variant="primary")
                ans = gr.Markdown()
                tr = gr.Textbox(label="Vết chạy các agent", lines=8)
        btn.click(chat_fn, [q, gr.State([]), age, gender, bmi, hba1c, glucose, state], [ans, state, tr])
    demo.launch(share=share)
