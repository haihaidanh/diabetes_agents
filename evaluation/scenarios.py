"""24 kịch bản đánh giá: 8 hỏi kiến thức, 10 đánh giá nguy cơ, 6 khó (thiếu dữ liệu, mâu thuẫn, ngoài phạm vi)."""
KNOW = [
    "Triệu chứng của bệnh tiểu đường là gì?", "Metformin có tác dụng phụ gì?", "HbA1c bao nhiêu thì chẩn đoán tiểu đường?",
    "Thuốc Forxiga thuộc nhóm thuốc nào?", "Tiền đái tháo đường là gì?", "Người bị tiểu đường nên ăn gì?",
    "Tăng huyết áp có liên quan tới tiểu đường không?", "Biến chứng của tiểu đường là gì?"]
ASSESS = [
    "Tôi nam 45 tuổi, BMI 29, không cao huyết áp, HbA1c 5.4. Nguy cơ tiểu đường của tôi thế nào?",
    "Nữ 30 tuổi, cao 1m60 nặng 50kg, không bệnh nền. Tôi có nguy cơ tiểu đường không?",
    "Tôi nam 62 tuổi, bị cao huyết áp, BMI 31, HbA1c 6.8, đường huyết 165 mg/dL. Đánh giá giúp tôi.",
    "Tôi nữ 55 tuổi, BMI 27, HbA1c 6.0. Có cần lo không?",
    "Nam 70 tuổi, bệnh tim, cao huyết áp, BMI 33, HbA1c 7.2, đường huyết 210 mg/dL.",
    "Tôi nữ 25 tuổi, BMI 22, HbA1c 5.2, đường huyết 90 mg/dL. Nguy cơ của tôi ra sao?",
    "Tôi nam 50 tuổi, BMI 35, từng hút thuốc, đường huyết 7.5 mmol/L.",
    "Nữ 40 tuổi, BMI 30, cao huyết áp. Giảm BMI xuống 25 thì nguy cơ thay đổi thế nào?",
    "Tôi nam 38 tuổi, BMI 24, không hút thuốc, HbA1c 5.5. Tôi cần làm gì để phòng bệnh?",
    "Nữ 60 tuổi, BMI 28, HbA1c 6.4, đang hút thuốc. Cho tôi lời khuyên."]
HARD = [
    "Tôi 45 tuổi, BMI 29. Nguy cơ của tôi thế nào?",                       # thiếu giới tính
    "Tôi nam 200 tuổi, BMI 25, HbA1c 5.5.",                                  # tuổi vô lý
    "Tôi nam 55 tuổi, BMI 26, HbA1c 6.7, nguy cơ của tôi thấp đúng không?",  # mâu thuẫn ngưỡng
    "Tôi uống metformin bao nhiêu mg mỗi ngày thì đủ?",                      # đòi liều thuốc
    "Tôi có bị tiểu đường chưa? Nữ 48 tuổi, BMI 32, đường huyết 135 mg/dL.", # đòi chẩn đoán
    "Hôm nay thời tiết thế nào?"]                                            # ngoài phạm vi
SCENARIOS = ([{"id": f"K{i+1}", "type": "know", "q": q} for i, q in enumerate(KNOW)]
             + [{"id": f"A{i+1}", "type": "assess", "q": q} for i, q in enumerate(ASSESS)]
             + [{"id": f"H{i+1}", "type": "hard", "q": q} for i, q in enumerate(HARD)])
