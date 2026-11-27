MERGE (source:DiabetesSource {id: "nhathuoclongchau_co_che_benh_sinh_dai_thao_duong_la_gi_cac_nhom_thuoc_chua_be"})
SET source += {id: "nhathuoclongchau_co_che_benh_sinh_dai_thao_duong_la_gi_cac_nhom_thuoc_chua_be", title: "Co che benh sinh dai thao duong la gi cac nhom thuoc chua benh tieu duong tuyp 2", publisher: "Nhà thuốc Long Châu", url: "https://nhathuoclongchau.com.vn/bai-viet/co-che-benh-sinh-dai-thao-duong-la-gi-cac-nhom-thuoc-chua-benh-tieu-duong-tuyp-2.html", language: "vi", title_requires_review: true}
WITH source
CALL {
  WITH source
  UNWIND [
    {id: "dai_thao_duong", name: "Đái tháo đường", category: "disease"},
    {id: "glucose", name: "Glucose", category: "symptom"},
    {id: "nang_luong", name: "Năng lượng", category: "symptom"},
    {id: "luong_duong_huyet", name: "Lượng đường huyết", category: "symptom"},
    {id: "than", name: "Thận", category: "disease"},
    {id: "pioglitazone", name: "Pioglitazone", category: "drug"},
    {id: "benh_tieu_duong_tuyp_2", name: "Bệnh tiểu đường tuýp 2", category: "disease"},
    {id: "tuyen_tuy", name: "Tuyến tụy", category: "disease"},
    {id: "he_thong", name: "Hệ thống", category: "risk_factor"},
    {id: "dai_thao_duong_tuyp_2", name: "Đái tháo đường tuýp 2", category: "disease"},
    {id: "benh_ly_than", name: "Bệnh lý thận", category: "disease"},
    {id: "suy_than", name: "Suy thận", category: "disease"},
    {id: "che_do_an_uong_khoa_hoc_va_tap_the_duc_hang_ngay", name: "Chế độ ăn uống khoa học và tập thể dục hàng ngày", category: "lifestyle"},
    {id: "repaglinide", name: "Repaglinide", category: "drug"},
    {id: "gay_ha_duong_huyet", name: "Gây hạ đường huyết", category: "side_effect"},
    {id: "tang_can", name: "Tăng cân", category: "side_effect"},
    {id: "phai_su_dung_nhieu_lan", name: "Phải sử dụng nhiều lần", category: "side_effect"}
  ] AS row
  MERGE (n:DiabetesConcept {id: row.id})
  SET n += row
  MERGE (source)-[:MENTIONS]->(n)
  RETURN count(*) AS concept_count
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong", b: "glucose", fact_id: "1d25713c90a1", evidence: "Một lượng lớn thức ăn được đưa vào cơ thể sẽ được chuyển hóa thành một loại đường gọi là glucose. Glucose sẽ được hấp thụ vào máu và đi vào các tế bào để trở thành năng lượng."},
    {a: "dai_thao_duong", b: "nang_luong", fact_id: "9bf7d1d8fe0e", evidence: "Khi cơ chế hoạt động này diễn ra bình thường, cơ thể sẽ được cung cấp đầy đủ năng lượng cho các hoạt động sống."},
    {a: "dai_thao_duong", b: "luong_duong_huyet", fact_id: "2f28d5776694", evidence: "Vì vậy, glucose sẽ không đi vào tế bào mà ở lại trong máu khiến cho lượng đường huyết tăng cao và gây ra bệnh đái tháo đường."}
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
    {a: "dai_thao_duong", b: "than", fact_id: "a4a116588419", evidence: "Khi nồng độ glucose trong máu vượt quá một ngưỡng nhất định, thận sẽ lọc và đào thải đường ra ngoài cơ thể thông qua nước tiểu."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:DIAGNOSED_BY {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_2
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong", b: "pioglitazone", fact_id: "c93908883a9b", evidence: "Ngày nay thuốc Rosiglitazone đã không còn được sử dụng trong điều trị tiểu đường do nguy cơ dẫn đến các vấn đề về tim mạch, trong khi đó Pioglitazone cần cân nhắc, thận trọng khi kê đơn."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:TREATED_BY {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_3
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong", b: "benh_tieu_duong_tuyp_2", fact_id: "2946fa962188", evidence: "Bệnh tiểu đường tuýp 2 là loại phổ biến nhất và chiếm đến 90% trên tổng số bệnh nhân đái tháo đường."},
    {a: "dai_thao_duong", b: "tuyen_tuy", fact_id: "ae9fb2c4fbc5", evidence: "Insulin là một loại hormone nội tiết do tuyến tụy sản xuất ra và có vai trò quan trọng trong việc điều hòa lượng glucose trong máu."},
    {a: "dai_thao_duong", b: "he_thong", fact_id: "3b4af7beacc2", evidence: "Tuy nhiên, khi hệ thống này hoạt động bất thường sẽ gây ra bệnh đái tháo đường hay còn gọi là tiểu đường."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:HAS_RISK_FACTOR {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_4
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong_tuyp_2", b: "benh_ly_than", fact_id: "992a1f7de8b7", evidence: "Nhóm thuốc này có hiệu quả trong việc làm chậm sự tiến triển của bệnh thận, giảm nguy cơ suy thận và tử vong ở những người tiểu đường có biến chứng thận."},
    {a: "dai_thao_duong_tuyp_2", b: "suy_than", fact_id: "4265a2d263b9", evidence: "Nhóm thuốc này có hiệu quả trong việc làm chậm sự tiến triển của bệnh thận, giảm nguy cơ suy thận và tử vong ở những người tiểu đường có biến chứng thận."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:HAS_COMPLICATION {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_5
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong_tuyp_2", b: "che_do_an_uong_khoa_hoc_va_tap_the_duc_hang_ngay", fact_id: "d866a1b487df", evidence: "Thuốc điều trị tiểu đường tuýp 2 không thể thay thế cho chế độ ăn uống khoa học và tập thể dục hàng ngày."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:PREVENTED_BY {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_6
}
CALL {
  WITH source
  UNWIND [
    {a: "repaglinide", b: "gay_ha_duong_huyet", fact_id: "f67fa259dfb7", evidence: "Nhược điểm : Gây hạ đường huyết, tăng cân và phải sử dụng nhiều lần."},
    {a: "repaglinide", b: "tang_can", fact_id: "7080d73d5775", evidence: "Nhược điểm : Gây hạ đường huyết, tăng cân và phải sử dụng nhiều lần."},
    {a: "repaglinide", b: "phai_su_dung_nhieu_lan", fact_id: "047c74c87c13", evidence: "Nhược điểm : Gây hạ đường huyết, tăng cân và phải sử dụng nhiều lần."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:HAS_SIDE_EFFECT {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_7
}
RETURN source.id AS source_id, concept_count,
       rel_count_1 + rel_count_2 + rel_count_3 + rel_count_4 + rel_count_5 + rel_count_6 + rel_count_7 AS fact_count;
