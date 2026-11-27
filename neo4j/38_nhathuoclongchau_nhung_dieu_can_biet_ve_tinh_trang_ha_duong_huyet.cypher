MERGE (source:DiabetesSource {id: "nhathuoclongchau_nhung_dieu_can_biet_ve_tinh_trang_ha_duong_huyet"})
SET source += {id: "nhathuoclongchau_nhung_dieu_can_biet_ve_tinh_trang_ha_duong_huyet", title: "Nhung dieu can biet ve tinh trang ha duong huyet", publisher: "Nhà thuốc Long Châu", url: "https://nhathuoclongchau.com.vn/bai-viet/nhung-dieu-can-biet-ve-tinh-trang-ha-duong-huyet-42126.html", language: "vi", title_requires_review: true}
WITH source
CALL {
  WITH source
  UNWIND [
    {id: "ha_duong_huyet", name: "Hạ đường huyết", category: "disease"},
    {id: "dai_thao_duong", name: "Đái tháo đường", category: "disease"}
  ] AS row
  MERGE (n:DiabetesConcept {id: row.id})
  SET n += row
  MERGE (source)-[:MENTIONS]->(n)
  RETURN count(*) AS concept_count
}
CALL {
  WITH source
  UNWIND [
    {a: "ha_duong_huyet", b: "dai_thao_duong", fact_id: "3d84c8455756", evidence: "Bệnh hạ đường huyết không phải là một bệnh lý phổ biến ở người bình thường. Đối tượng hay mắc bệnh này là những người bị tiểu đường khi cơ thể họ phải có một chế độ kiêng khem tinh bột và đường ở mức độ cao."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:HAS_RISK_FACTOR {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_1
}
RETURN source.id AS source_id, concept_count,
       rel_count_1 AS fact_count;
