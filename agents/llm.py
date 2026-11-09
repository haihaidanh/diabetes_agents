"""Gọi LLM qua Ollama: văn bản, đầu ra có cấu trúc (qua công cụ + Pydantic) và vòng gọi công cụ."""
import json
import re

from pydantic import ValidationError

import config

CALLS = 0            # tổng số lượt gọi LLM (để đo trong vết chạy)


def _chat(messages, tools=None, think=False):
    global CALLS
    import ollama
    CALLS += 1
    kw = dict(model=config.LLM_MODEL, messages=messages, options={"temperature": 0.2, "num_ctx": 8192})
    if tools:
        kw["tools"] = tools
    try:
        return ollama.chat(**kw, think=think)
    except TypeError:
        return ollama.chat(**kw)


def strip_think(s) -> str:
    return re.sub(r"<think>.*?</think>", "", s or "", flags=re.S).strip()


def text(system: str, user: str) -> str:
    r = _chat([{"role": "system", "content": system}, {"role": "user", "content": user}])
    return strip_think(r.message.content)


def submit(system: str, user: str, cls, retries: int = 2):
    """Đầu ra có cấu trúc qua công cụ submit_result, kiểm bằng Pydantic, hỏi lại tối đa `retries` lần."""
    tool = {"type": "function", "function": {"name": "submit_result", "description": "Nộp kết quả.",
                                             "parameters": cls.model_json_schema()}}
    for _ in range(retries + 1):
        r = _chat([{"role": "system", "content": system}, {"role": "user", "content": user}], tools=[tool])
        for c in r.message.tool_calls or []:
            try:
                return cls(**dict(c.function.arguments))
            except (ValidationError, TypeError):
                pass
        user += "\n\nBắt buộc gọi submit_result đúng schema."
    return None


def run_tools(system: str, user: str, tools: list, max_steps: int = 5, with_text: bool = False):
    """Vòng gọi công cụ tự viết (kiểm soát số bước, đếm lượt LLM). Trả về nhật ký các lần gọi
    (kèm câu trả lời cuối của model nếu with_text=True)."""
    registry = {f.__name__: f for f in tools}
    msgs = [{"role": "system", "content": system}, {"role": "user", "content": user}]
    log, final = [], ""
    for _ in range(max_steps):
        r = _chat(msgs, tools=tools)
        calls = r.message.tool_calls or []
        if not calls:
            final = strip_think(r.message.content)
            break
        msgs.append(r.message)
        for c in calls:
            fn = registry.get(c.function.name)
            args = dict(c.function.arguments)
            try:
                res = fn(**args) if fn else {"error": f"không có công cụ {c.function.name}"}
            except Exception as e:                      # trả lỗi về cho model tự sửa tham số
                res = {"error": f"{type(e).__name__}: {e}"}
            log.append({"tool": c.function.name, "args": args, "result": res})
            msgs.append({"role": "tool", "tool_name": c.function.name,
                         "content": json.dumps(res, ensure_ascii=False, default=str)[:5000]})
    return (log, final) if with_text else log
