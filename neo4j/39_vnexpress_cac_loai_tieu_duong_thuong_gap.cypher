MERGE (source:DiabetesSource {id: "vnexpress_cac_loai_tieu_duong_thuong_gap"})
SET source += {id: "vnexpress_cac_loai_tieu_duong_thuong_gap", title: "Cac loai tieu duong thuong gap", publisher: "VnExpress", url: "https://vnexpress.net/cac-loai-tieu-duong-thuong-gap-4356257.html", language: "vi", title_requires_review: true}
WITH source
CALL {
  WITH source
  UNWIND [
    {id: "bien_chung_tim_mach", name: "Biến chứng tim mạch", category: "disease"},
    {id: "tien_tieu_duong", name: "Tiền tiểu đường", category: "disease"}
  ] AS row
  MERGE (n:DiabetesConcept {id: row.id})
  SET n += row
  MERGE (source)-[:MENTIONS]->(n)
  RETURN count(*) AS concept_count
}
CALL {
  WITH source
  UNWIND [
    {a: "bien_chung_tim_mach", b: "tien_tieu_duong", fact_id: "314bdde7628b", evidence: "Khoảng 5-10% người tiền tiểu đường sẽ trở thành người bệnh tiểu đường hàng năm và tổng cộng 70% người tiền tiểu đường sẽ thành tiểu đường thực sự và có nguy cơ dẫn đến nhiều biến chứng nguy hiểm nếu người bệnh không được điều trị đúng cách, cũng như không điều chỉnh lối sống và chế độ dinh dưỡng ở mức hợp lý."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:HAS_COMPLICATION {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_1
}
RETURN source.id AS source_id, concept_count,
       rel_count_1 AS fact_count;
