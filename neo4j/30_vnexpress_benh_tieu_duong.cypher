MERGE (source:DiabetesSource {id: "vnexpress_benh_tieu_duong"})
SET source += {id: "vnexpress_benh_tieu_duong", title: "Benh tieu duong", publisher: "VnExpress", url: "https://vnexpress.net/benh-tieu-duong-4798125.html", language: "vi", title_requires_review: true}
WITH source
CALL {
  WITH source
  UNWIND [
    {id: "dai_thao_duong", name: "Đái tháo đường", category: "disease"},
    {id: "tang_duong_huyet_man_tinh", name: "Tăng đường huyết mạn tính", category: "symptom"},
    {id: "an_uong_lanh_manh", name: "Ăn uống lành mạnh", category: "lifestyle"},
    {id: "giam_can_neu_bi_thua_can_hoac_beo_phi", name: "Giảm cân nếu bị thừa cân hoặc béo phì", category: "lifestyle"},
    {id: "tang_cuong_hoat_dong_the_chat", name: "Tăng cường hoạt động thể chất", category: "lifestyle"},
    {id: "tham_kham_dinh_ky", name: "Thăm khám định kỳ", category: "test"},
    {id: "tren_35_tuoi", name: "Trên 35 tuổi", category: "risk_factor"},
    {id: "gan_nhiem_mo_khong_do_ruou_nafld", name: "Gan nhiễm mỡ không do rượu (NAFLD)", category: "risk_factor"},
    {id: "gene_benh_noi_tiet_benh_ly_khac", name: "Gene, bệnh nội tiết, bệnh lý khác", category: "risk_factor"},
    {id: "tien_tieu_duong", name: "Tiền tiểu đường", category: "disease"},
    {id: "dai_thao_duong_tuyp_2", name: "Đái tháo đường tuýp 2", category: "disease"}
  ] AS row
  MERGE (n:DiabetesConcept {id: row.id})
  SET n += row
  MERGE (source)-[:MENTIONS]->(n)
  RETURN count(*) AS concept_count
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong", b: "tang_duong_huyet_man_tinh", fact_id: "51b167d31d41", evidence: "Bệnh tiểu đường (đái tháo đường) đặc trưng bởi tình trạng tăng đường huyết mạn tính."}
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
    {a: "dai_thao_duong", b: "an_uong_lanh_manh", fact_id: "3452d121ee40", evidence: "Tuy nhiên, một số yếu tố thay đổi được góp phần làm giảm nguy cơ tiểu đường type 2 và tiểu đường thai kỳ gồm tăng cường hoạt động thể chất, ăn uống lành mạnh, giảm cân nếu bị thừa cân hoặc béo phì."},
    {a: "dai_thao_duong", b: "giam_can_neu_bi_thua_can_hoac_beo_phi", fact_id: "3eacdf966a04", evidence: "Tuy nhiên, một số yếu tố thay đổi được góp phần làm giảm nguy cơ tiểu đường type 2 và tiểu đường thai kỳ gồm tăng cường hoạt động thể chất, ăn uống lành mạnh, giảm cân nếu bị thừa cân hoặc béo phì."},
    {a: "dai_thao_duong", b: "tang_cuong_hoat_dong_the_chat", fact_id: "872fa5a53d33", evidence: "Tuy nhiên, một số yếu tố thay đổi được góp phần làm giảm nguy cơ tiểu đường type 2 và tiểu đường thai kỳ gồm tăng cường hoạt động thể chất, ăn uống lành mạnh, giảm cân nếu bị thừa cân hoặc béo phì."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:PREVENTED_BY {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_2
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong", b: "tham_kham_dinh_ky", fact_id: "f25c2760cb1c", evidence: "Khám sức khỏe định kỳ ít nhất 6-12 tháng một lần để phát hiện bệnh, điều trị và phòng ngừa biến chứng sớm."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:DIAGNOSED_BY {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_3
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong", b: "tren_35_tuoi", fact_id: "a09437b6ee95", evidence: "Trên 35 tuổi."},
    {a: "dai_thao_duong", b: "gan_nhiem_mo_khong_do_ruou_nafld", fact_id: "3b46e236d607", evidence: "Mắc bệnh gan nhiễm mỡ không do rượu (NAFLD)."},
    {a: "dai_thao_duong", b: "gene_benh_noi_tiet_benh_ly_khac", fact_id: "862ef8eec2d4", evidence: "Bệnh tiểu đường có thể do nguyên nhân khác như gene, bệnh nội tiết, bệnh lý khác."},
    {a: "tien_tieu_duong", b: "dai_thao_duong_tuyp_2", fact_id: "6ca195a10449", evidence: "Người bị tiền tiểu đường có nguy cơ cao tiến triển thành tiểu đường type 2."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:HAS_RISK_FACTOR {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_4
}
RETURN source.id AS source_id, concept_count,
       rel_count_1 + rel_count_2 + rel_count_3 + rel_count_4 AS fact_count;
