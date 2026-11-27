MERGE (source:DiabetesSource {id: "vinmec_benh_tieu_duong_bieu_hien_nhu_nao_vi"})
SET source += {id: "vinmec_benh_tieu_duong_bieu_hien_nhu_nao_vi", title: "Benh tieu duong bieu hien nhu nao vi", publisher: "Vinmec", url: "https://www.vinmec.com/vie/bai-viet/benh-tieu-duong-bieu-hien-nhu-nao-vi", language: "vi", title_requires_review: true}
WITH source
CALL {
  WITH source
  UNWIND [
    {id: "dai_thao_duong", name: "Đái tháo đường", category: "disease"},
    {id: "nghiem_phap_dung_nap_duong", name: "Nghiệm pháp dung nạp đường", category: "test"},
    {id: "tien_dai_thao_duong", name: "Tiền đái tháo đường", category: "disease"}
  ] AS row
  MERGE (n:DiabetesConcept {id: row.id})
  SET n += row
  MERGE (source)-[:MENTIONS]->(n)
  RETURN count(*) AS concept_count
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong", b: "nghiem_phap_dung_nap_duong", fact_id: "2a4f5ee7fdea", evidence: "Đường huyết sáng đói, đường huyết sau ăn và HbA1C, hoặc nếu cần thiết làm nghiệm pháp dung nạp đường để chẩn đoán."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:DIAGNOSED_BY {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_1
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong", b: "tien_dai_thao_duong", fact_id: "55f90ed01724", evidence: "Bệnh đái tháo đường có tiêu chuẩn chẩn đoán: Đái tháo đường , tiền đái tháo đường và có liên quan đến tiền căn bản thân, tiền căn gia đình cũng như các dấu hiệu bác sĩ sẽ kiểm tra khi khám bệnh trực tiếp."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:HAS_RISK_FACTOR {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_2
}
RETURN source.id AS source_id, concept_count,
       rel_count_1 + rel_count_2 AS fact_count;
