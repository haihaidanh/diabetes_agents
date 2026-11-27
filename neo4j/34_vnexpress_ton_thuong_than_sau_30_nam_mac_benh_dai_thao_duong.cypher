MERGE (source:DiabetesSource {id: "vnexpress_ton_thuong_than_sau_30_nam_mac_benh_dai_thao_duong"})
SET source += {id: "vnexpress_ton_thuong_than_sau_30_nam_mac_benh_dai_thao_duong", title: "Ton thuong than sau 30 nam mac benh dai thao duong", publisher: "VnExpress", url: "https://vnexpress.net/ton-thuong-than-sau-30-nam-mac-benh-dai-thao-duong-5141045.html", language: "vi", title_requires_review: true}
WITH source
CALL {
  WITH source
  UNWIND [
    {id: "dai_thao_duong", name: "Đái tháo đường", category: "disease"},
    {id: "ton_thuong_than_cap", name: "Tổn thương thận cấp", category: "disease"},
    {id: "kiem_tra_chuc_nang_than_va_albumin_nieu_dinh_ky", name: "Kiểm tra chức năng thận và albumin niệu định kỳ", category: "test"},
    {id: "benh_than_dai_thao_duong", name: "Bệnh thận đái tháo đường", category: "disease"},
    {id: "tang_huyet_ap", name: "Tăng huyết áp", category: "disease"},
    {id: "thuoc_huyet_ap", name: "Thuốc huyết áp", category: "drug"},
    {id: "ton_thuong_than_sau_30_nam_mac_benh_dai_thao_duong", name: "Tổn thương thận sau 30 năm mắc bệnh đái tháo đường", category: "disease"},
    {id: "tai_kham_dinh_ky", name: "Tái khám định kỳ", category: "test"}
  ] AS row
  MERGE (n:DiabetesConcept {id: row.id})
  SET n += row
  MERGE (source)-[:MENTIONS]->(n)
  RETURN count(*) AS concept_count
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong", b: "ton_thuong_than_cap", fact_id: "f3b410f6275c", evidence: "TP HCM Sau 30 năm bệnh đái tháo đường, bà Quỳnh, 70 tuổi, bị tổn thương thận cấp, chức năng lọc giảm mạnh, phù hai chân, tiểu nhiều bọt."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:HAS_COMPLICATION {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_1
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong", b: "kiem_tra_chuc_nang_than_va_albumin_nieu_dinh_ky", fact_id: "f8933fcf2dfa", evidence: "Người mắc đái tháo đường lâu năm nên kiểm tra chức năng thận và albumin niệu định kỳ, không tự ý ngưng thuốc hoặc dùng thuốc giảm đau kháng viêm hay các loại lá cây không rõ nguồn gốc."},
    {a: "ton_thuong_than_sau_30_nam_mac_benh_dai_thao_duong", b: "tai_kham_dinh_ky", fact_id: "ae949e7b37b7", evidence: "Bác sĩ lưu ý bà tái khám định kỳ để đánh giá toàn diện chức năng thận và các bệnh nền liên quan."}
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
    {a: "benh_than_dai_thao_duong", b: "tang_huyet_ap", fact_id: "53191ab377ef", evidence: "Tăng huyết áp, rối loạn chuyển hóa và béo phì làm gia tăng nguy cơ tim mạch, đồng thời khiến việc kiểm soát bệnh thận khó khăn hơn."}
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
    {a: "benh_than_dai_thao_duong", b: "thuoc_huyet_ap", fact_id: "e9f33fcc0aa6", evidence: "Bà Quỳnh dùng 5 loại thuốc điều trị đái tháo đường mỗi ngày kèm thuốc huyết áp và thường xuyên uống nước lá cây."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:TREATED_BY {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_4
}
RETURN source.id AS source_id, concept_count,
       rel_count_1 + rel_count_2 + rel_count_3 + rel_count_4 AS fact_count;
