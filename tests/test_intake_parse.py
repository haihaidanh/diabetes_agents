from agents.agents import parse_rules, parse_labs, glu


def test_profile():
    p = parse_rules("Tôi nam 45 tuổi, cao 1m70 nặng 80kg, không cao huyết áp, HbA1c 6,5")
    assert p["age"] == 45 and p["gender"] == "Male"
    assert p["bmi"] == 27.7 and p["hypertension"] == 0 and p["HbA1c_level"] == 6.5


def test_decimal_height_without_trailing_zero():
    assert parse_rules("cao 1m6 nặng 100kg")["bmi"] == 39.1


def test_glucose_mmol():
    assert parse_labs("đường huyết 7.5 mmol/l")["blood_glucose_level"] == 135
    assert glu(165, "mg/dL") == 165
