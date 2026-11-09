from common.text import fmt, pct, norm


def test_fmt_pct():
    assert fmt(6.5) == "6,5"
    assert pct(0.109) == "10,9%"


def test_norm():
    assert norm("Đường Huyết") == "duong huyet"
