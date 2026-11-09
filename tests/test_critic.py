from agents.critic import rule_issues

BASE = {"patient": {"HbA1c_level": 6.8, "age": 60}, "risk": {"probability": 0.109, "threshold": 0.3},
        "evidence": [{"id": 1, "claim": "ĐTĐ", "quote": "HbA1c từ 6,5% trở lên", "url": "u"}], "lab_checks": []}


def test_good():
    assert rule_issues(BASE, "Nguy cơ khoảng 10,9% [1]. Bạn nên gặp bác sĩ.") == []


def test_bad_citation_dose_diag():
    iss = rule_issues(BASE, "Bạn bị tiểu đường, uống 500 mg [3] với 77%.")
    assert len(iss) >= 4


def test_threshold_required():
    s = dict(BASE, lab_checks=[{"met": True, "disease": "Đái tháo đường", "test": "HbA1c", "condition": "≥ 6,5%", "assumption": ""}])
    assert any("đạt ngưỡng" in i for i in rule_issues(s, "Nguy cơ thấp [1]. Gặp bác sĩ."))
    assert not any("đạt ngưỡng" in i for i in rule_issues(s, "HbA1c của bạn đạt ngưỡng 6,5% [1], hãy gặp bác sĩ."))
