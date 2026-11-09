"""Embedding bge-m3 qua Ollama."""
import numpy as np

import config


def embed(texts: list[str], batch: int = 32) -> np.ndarray:
    import ollama
    out = []
    for i in range(0, len(texts), batch):
        out += ollama.embed(model=config.EMBED_MODEL, input=texts[i:i + batch]).embeddings
    return unit(np.array(out, dtype="float32"))


def unit(v: np.ndarray) -> np.ndarray:
    v = np.atleast_2d(v)
    return v / np.linalg.norm(v, axis=1, keepdims=True)
