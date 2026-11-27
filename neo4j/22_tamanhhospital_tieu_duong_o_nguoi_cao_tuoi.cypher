MERGE (source:DiabetesSource {id: "tamanhhospital_tieu_duong_o_nguoi_cao_tuoi"})
SET source += {id: "tamanhhospital_tieu_duong_o_nguoi_cao_tuoi", title: "Tieu duong o nguoi cao tuoi", publisher: "Bệnh viện Tâm Anh", url: "https://tamanhhospital.vn/tieu-duong-o-nguoi-cao-tuoi/", language: "vi", title_requires_review: true}
WITH source
CALL {
  WITH source
  UNWIND [
    {id: "dai_thao_duong", name: "Đái tháo đường", category: "disease"},
    {id: "khang_insulin", name: "Kháng insulin", category: "disease"},
    {id: "mat_thi_luc", name: "Mất thị lực", category: "symptom"},
    {id: "thi_luc_mo_hoac_duc", name: "Thị lực mờ hoặc đục", category: "symptom"},
    {id: "cao_huyet_ap_benh_mach_vanh_nhoi_mau_co_tim_suy_tim", name: "Cao huyết áp, bệnh mạch vành, nhồi máu cơ tim, suy tim", category: "disease"},
    {id: "nhiem_toan_ceton", name: "Nhiễm toan ceton", category: "disease"},
    {id: "dot_quy", name: "Đột quỵ", category: "disease"},
    {id: "benh_than_man", name: "Bệnh thận mạn", category: "disease"},
    {id: "benh_tim_mach", name: "Bệnh tim mạch", category: "disease"},
    {id: "giam_co_tang_mo", name: "Giảm cơ, tăng mỡ", category: "risk_factor"},
    {id: "sa_sut_tri_tue", name: "Sa sút trí tuệ", category: "disease"},
    {id: "benh_alzheimer", name: "Bệnh Alzheimer", category: "disease"},
    {id: "chay_than_nhan_tao", name: "Chạy thận nhân tạo", category: "test"},
    {id: "bien_chung_tren_da", name: "Biến chứng trên da", category: "disease"},
    {id: "he_mien_dich_suy_yeu", name: "Hệ miễn dịch suy yếu", category: "risk_factor"},
    {id: "tieu_duong_o_nguoi_cao_tuoi", name: "Tiểu đường ở người cao tuổi", category: "disease"},
    {id: "benh_rang_mieng", name: "Bệnh răng miệng", category: "disease"},
    {id: "tieu_duong_suy_giam_thinh_luc", name: "Tiểu đường suy giảm thính lực", category: "disease"},
    {id: "suy_giam_thinh_luc", name: "Suy giảm thính lực", category: "symptom"},
    {id: "ha_duong_huyet_bat_thuong", name: "Hạ đường huyết bất thường", category: "disease"},
    {id: "co_giat", name: "Co giật", category: "symptom"},
    {id: "lu_lan", name: "Lú lẫn", category: "symptom"},
    {id: "mat_y_thuc", name: "Mất ý thức", category: "symptom"}
  ] AS row
  MERGE (n:DiabetesConcept {id: row.id})
  SET n += row
  MERGE (source)-[:MENTIONS]->(n)
  RETURN count(*) AS concept_count
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong", b: "khang_insulin", fact_id: "1d2c22237986", evidence: "Tăng đề kháng insulin theo độ tuổi: Insulin là hormone giúp đưa glucose từ máu vào tế bào để tạo năng lượng. Khi già đi, các tế bào trong cơ thể giảm đáp ứng với insulin, tình trạng này gọi là kháng insulin. Kháng insulin khiến đường huyết tăng cao dù tuyến tụy vẫn sản xuất insulin."},
    {a: "dai_thao_duong", b: "mat_thi_luc", fact_id: "0d5f719e6c1f", evidence: "Bệnh tiểu đường là nguyên nhân hàng đầu gây mất thị lực ở người từ 18-64 tuổi, thường không có dấu hiệu hoặc triệu chứng rõ ràng."},
    {a: "dai_thao_duong", b: "thi_luc_mo_hoac_duc", fact_id: "dd75c5488322", evidence: "Bệnh tiểu đường ảnh hưởng đến các mạch máu và dây thần kinh mắt, dẫn đến thị lực mờ hoặc đục."},
    {a: "tieu_duong_suy_giam_thinh_luc", b: "suy_giam_thinh_luc", fact_id: "6cd9786377bb", evidence: "Tiểu đường suy giảm thính lực : Người bệnh tiểu đường có nguy cơ mất thính lực cao hơn 30% so với người có đường huyết bình thường ."},
    {a: "ha_duong_huyet_bat_thuong", b: "co_giat", fact_id: "b3f03aa5c8da", evidence: "Người cao tuổi mắc đái tháo đường cần được cấp cứu hoặc đưa đến cơ sở y tế nếu: Hạ đường huyết bất thường (đường huyết <70mg/dL hoặc 3.9mmol/L): Các dấu hiệu phổ biến thường gồm lú lẫn, co giật, mất ý thức…"},
    {a: "ha_duong_huyet_bat_thuong", b: "lu_lan", fact_id: "2158b66dd652", evidence: "Người cao tuổi mắc đái tháo đường cần được cấp cứu hoặc đưa đến cơ sở y tế nếu: Hạ đường huyết bất thường (đường huyết <70mg/dL hoặc 3.9mmol/L): Các dấu hiệu phổ biến thường gồm lú lẫn, co giật, mất ý thức…"},
    {a: "ha_duong_huyet_bat_thuong", b: "mat_y_thuc", fact_id: "5566d3b8ba90", evidence: "Người cao tuổi mắc đái tháo đường cần được cấp cứu hoặc đưa đến cơ sở y tế nếu: Hạ đường huyết bất thường (đường huyết <70mg/dL hoặc 3.9mmol/L): Các dấu hiệu phổ biến thường gồm lú lẫn, co giật, mất ý thức…"}
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
    {a: "dai_thao_duong", b: "cao_huyet_ap_benh_mach_vanh_nhoi_mau_co_tim_suy_tim", fact_id: "dab470ca560f", evidence: "Người bệnh (đặc biệt người cao tuổi) có nguy cơ cao mắc cao huyết áp, bệnh mạch vành, nhồi máu cơ tim, suy tim…"},
    {a: "dai_thao_duong", b: "nhiem_toan_ceton", fact_id: "d7ff07160b86", evidence: "Nhiễm toan ceton do đái tháo đường (diabetic ketoacidosis – DKA) là biến chứng nghiêm trọng, đe dọa tính mạng người bệnh nếu không được cấp cứu hoặc điều trị kịp thời."},
    {a: "sa_sut_tri_tue", b: "benh_alzheimer", fact_id: "f5dae3d78ed9", evidence: "Người già bị tiểu đường có nguy cơ cao hơn với bệnh Alzheimer và sa sút trí tuệ do mạch máu."},
    {a: "tieu_duong_o_nguoi_cao_tuoi", b: "sa_sut_tri_tue", fact_id: "ae88e45f2c81", evidence: "Sa sút trí tuệ: Người già bị tiểu đường có nguy cơ cao hơn với bệnh Alzheimer và sa sút trí tuệ do mạch máu."},
    {a: "tieu_duong_o_nguoi_cao_tuoi", b: "benh_rang_mieng", fact_id: "c30090a55c81", evidence: "Bệnh răng miệng: Người tiểu đường dễ mắc bệnh răng miệng như viêm nướu, viêm nha chu, khô miệng…"}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:HAS_COMPLICATION {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_2
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong", b: "dot_quy", fact_id: "786a56a36397", evidence: "Cũng theo ADA, nguy cơ đột quỵ ở người mắc tiểu đường cao gấp 2 lần so với người bình thường."},
    {a: "dai_thao_duong", b: "benh_than_man", fact_id: "5447a8eba049", evidence: "Tiểu đường là nguyên nhân hàng đầu gây bệnh thận mạn (chronic kidney disease – CKD) trên toàn thế giới."},
    {a: "dai_thao_duong", b: "benh_tim_mach", fact_id: "8a1e4670bcd5", evidence: "Theo Hiệp hội Đái tháo đường Hoa Kỳ (ADA), người mắc đái tháo đường có nguy cơ tử vong do bệnh tim mạch cao gấp khoảng 2 lần so với người không mắc bệnh."},
    {a: "dai_thao_duong", b: "giam_co_tang_mo", fact_id: "5ed4b04ebc95", evidence: "Giảm cơ, tăng mỡ: Người cao tuổi thường bị mất cơ, tăng mỡ (đặc biệt mỡ nội tạng). Cơ bắp là nơi dùng glucose chủ yếu, còn mỡ nội tạng lại thúc đẩy tình trạng viêm mạn tính và kháng insulin."},
    {a: "bien_chung_tren_da", b: "he_mien_dich_suy_yeu", fact_id: "17ffcd61db89", evidence: "Biến chứng trên da: Tiểu đường làm hệ miễn dịch suy yếu, khiến da dễ nhiễm trùng do vi khuẩn, nấm, mụn nhọt, lở loét…"}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:HAS_RISK_FACTOR {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_3
}
CALL {
  WITH source
  UNWIND [
    {a: "benh_than_man", b: "chay_than_nhan_tao", fact_id: "9bdd3fe5c7a4", evidence: "Người bệnh có nguy cơ cao hơn phải chạy thận nhân tạo."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:DIAGNOSED_BY {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_4
}
RETURN source.id AS source_id, concept_count,
       rel_count_1 + rel_count_2 + rel_count_3 + rel_count_4 AS fact_count;
