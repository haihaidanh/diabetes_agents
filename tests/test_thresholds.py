from kb.thresholds import plausible
import inspect


def test_signature():
    assert callable(plausible) and len(inspect.signature(plausible).parameters) >= 1
