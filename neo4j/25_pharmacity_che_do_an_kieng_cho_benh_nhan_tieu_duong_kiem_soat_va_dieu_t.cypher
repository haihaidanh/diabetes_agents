MERGE (source:DiabetesSource {id: "pharmacity_che_do_an_kieng_cho_benh_nhan_tieu_duong_kiem_soat_va_dieu_t"})
SET source += {id: "pharmacity_che_do_an_kieng_cho_benh_nhan_tieu_duong_kiem_soat_va_dieu_t", title: "Che do an kieng cho benh nhan tieu duong kiem soat va dieu tri benh hieu qua", publisher: "Pharmacity", url: "https://www.pharmacity.vn/che-do-an-kieng-cho-benh-nhan-tieu-duong-kiem-soat-va-dieu-tri-benh-hieu-qua.htm", language: "vi", title_requires_review: true}
WITH source
CALL {
  WITH source
  UNWIND [
    {id: "dai_thao_duong", name: "Đái tháo đường", category: "disease"},
    {id: "ha_duong_huyet_vao_buoi_chieu", name: "Hạ đường huyết vào buổi chiều", category: "symptom"},
    {id: "thuc_pham_lam_tang_duong_huyet_nhanh", name: "Thực phẩm làm tăng đường huyết nhanh", category: "symptom"},
    {id: "ket_hop_tinh_bot_voi_chat_xo_va_protein", name: "Kết hợp tinh bột với chất xơ và protein", category: "lifestyle"},
    {id: "bua_sang", name: "Bữa sáng", category: "lifestyle"},
    {id: "khoang_cach_deu_giua_cac_bua_an", name: "Khoảng cách đều giữa các bữa ăn", category: "lifestyle"},
    {id: "tinh_bot_cham_tieu_hoa", name: "Tinh bột chậm tiêu hóa", category: "lifestyle"},
    {id: "chat_dam_protein", name: "Chất đạm (protein)", category: "lifestyle"},
    {id: "chat_beo_lanh_manh", name: "Chất béo lành mạnh", category: "lifestyle"},
    {id: "hat_oc_cho_hanh_nhan", name: "Hạt óc chó, hạnh nhân", category: "lifestyle"},
    {id: "sua_chua_khong_duong_trai_cay_it_ngot", name: "Sữa chua không đường, trái cây ít ngọt", category: "lifestyle"},
    {id: "duong", name: "Đường", category: "risk_factor"},
    {id: "tinh_bot", name: "Tinh bột", category: "risk_factor"},
    {id: "dai_thao_duong_tuyp_2", name: "Đái tháo đường tuýp 2", category: "disease"},
    {id: "khang_insulin", name: "Kháng insulin", category: "disease"},
    {id: "benh_man_tinh", name: "Bệnh mãn tính", category: "disease"},
    {id: "thuc_pham", name: "Thực phẩm", category: "disease"},
    {id: "chi_so_duong_huyet", name: "Chỉ số đường huyết", category: "symptom"}
  ] AS row
  MERGE (n:DiabetesConcept {id: row.id})
  SET n += row
  MERGE (source)-[:MENTIONS]->(n)
  RETURN count(*) AS concept_count
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong", b: "ha_duong_huyet_vao_buoi_chieu", fact_id: "6f698baac7bf", evidence: "\"Tôi thường xuyên bị hạ đường huyết vào buổi chiều. Sau khi thêm bữa phụ với hạt chia và sữa chua, tôi thấy cơ thể dễ chịu hơn, không còn cảm giác mệt mỏi.\" "},
    {a: "dai_thao_duong", b: "thuc_pham_lam_tang_duong_huyet_nhanh", fact_id: "564cc5df5bdc", evidence: "Để kiểm soát tốt đường huyết, người bệnh tiểu đường cần hạn chế tối đa các thực phẩm làm tăng đường huyết nhanh hoặc có hại cho sức khỏe."},
    {a: "thuc_pham", b: "chi_so_duong_huyet", fact_id: "156da71ecaa5", evidence: "Thực phẩm bạn ăn hàng ngày có ảnh hưởng trực tiếp đến chỉ số đường huyết (GI) – chỉ số phản ánh tốc độ làm tăng đường huyết sau khi ăn."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:HAS_SYMPTOM {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_1
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong", b: "ket_hop_tinh_bot_voi_chat_xo_va_protein", fact_id: "31d379768bcc", evidence: "Mẹo nhỏ : Kết hợp tinh bột với chất xơ và protein giúp làm chậm quá trình hấp thu đường, duy trì năng lượng lâu dài."},
    {a: "dai_thao_duong", b: "bua_sang", fact_id: "31d19f5f90c2", evidence: "Một chế độ ăn kiêng hiệu quả cho bệnh nhân tiểu đường cần được duy trì đúng giờ và đủ chất : Không bỏ bữa, đặc biệt là bữa sáng."},
    {a: "dai_thao_duong", b: "khoang_cach_deu_giua_cac_bua_an", fact_id: "0bc5b4d0ffd4", evidence: "Giữ khoảng cách đều giữa các bữa ăn (3–4 giờ)."},
    {a: "dai_thao_duong", b: "tinh_bot_cham_tieu_hoa", fact_id: "58424592a369", evidence: "40% tinh bột chậm tiêu hóa ."},
    {a: "dai_thao_duong", b: "chat_dam_protein", fact_id: "b9b8ad35e14d", evidence: "30% chất đạm (protein) ."},
    {a: "dai_thao_duong", b: "chat_beo_lanh_manh", fact_id: "93cea3380576", evidence: "30% chất béo lành mạnh ."},
    {a: "dai_thao_duong", b: "hat_oc_cho_hanh_nhan", fact_id: "13e328a95a45", evidence: "Hạt óc chó, hạnh nhân."},
    {a: "dai_thao_duong", b: "sua_chua_khong_duong_trai_cay_it_ngot", fact_id: "80c1182b3edd", evidence: "Sữa chua không đường, trái cây ít ngọt."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:TREATED_BY {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_2
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong", b: "duong", fact_id: "6d0b21370a3a", evidence: "Tinh bột và đường là hai yếu tố trực tiếp làm tăng đường huyết."},
    {a: "dai_thao_duong", b: "tinh_bot", fact_id: "464b312fbf2a", evidence: "Tinh bột và đường là hai yếu tố trực tiếp làm tăng đường huyết."},
    {a: "dai_thao_duong_tuyp_2", b: "khang_insulin", fact_id: "144c1e4da589", evidence: "Khi ăn thực phẩm có chỉ số GI cao, đường huyết sẽ tăng nhanh khiến tuyến tụy phải sản xuất nhiều insulin để cân bằng, gây áp lực lên cơ thể và dễ dẫn đến kháng insulin – nguyên nhân chính gây tiểu đường type 2."},
    {a: "benh_man_tinh", b: "dai_thao_duong", fact_id: "9c9454b069cb", evidence: "Bệnh tiểu đường là một trong những bệnh mãn tính phổ biến nhất hiện nay, ảnh hưởng nghiêm trọng đến sức khỏe và chất lượng cuộc sống của người bệnh."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:HAS_RISK_FACTOR {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_3
}
RETURN source.id AS source_id, concept_count,
       rel_count_1 + rel_count_2 + rel_count_3 AS fact_count;
