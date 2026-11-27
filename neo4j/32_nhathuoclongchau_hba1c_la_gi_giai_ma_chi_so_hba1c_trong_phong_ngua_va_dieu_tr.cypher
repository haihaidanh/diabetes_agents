MERGE (source:DiabetesSource {id: "nhathuoclongchau_hba1c_la_gi_giai_ma_chi_so_hba1c_trong_phong_ngua_va_dieu_tr"})
SET source += {id: "nhathuoclongchau_hba1c_la_gi_giai_ma_chi_so_hba1c_trong_phong_ngua_va_dieu_tr", title: "Hba1c la gi giai ma chi so hba1c trong phong ngua va dieu tri tieu duong", publisher: "Nhà thuốc Long Châu", url: "https://nhathuoclongchau.com.vn/bai-viet/hba1c-la-gi-giai-ma-chi-so-hba1c-trong-phong-ngua-va-dieu-tri-tieu-duong-69472.html", language: "vi", title_requires_review: true}
WITH source
CALL {
  WITH source
  UNWIND [
    {id: "dai_thao_duong", name: "Đái tháo đường", category: "disease"},
    {id: "hba1c__test", name: "HbA1C", category: "test"},
    {id: "dai_thao_duong_tuyp_2", name: "Đái tháo đường tuýp 2", category: "disease"},
    {id: "tien_dai_thao_duong", name: "Tiền đái tháo đường", category: "disease"},
    {id: "dai_thao_duong_tuyp_1", name: "Đái tháo đường tuýp 1", category: "disease"},
    {id: "hba1c", name: "HbA1c", category: "disease"},
    {id: "xet_nghiem_hba1c", name: "Xét nghiệm HbA1c", category: "test"},
    {id: "uong_thuoc_theo_chi_dinh_cua_bac_si", name: "Uống thuốc theo chỉ định của bác sĩ", category: "lifestyle"}
  ] AS row
  MERGE (n:DiabetesConcept {id: row.id})
  SET n += row
  MERGE (source)-[:MENTIONS]->(n)
  RETURN count(*) AS concept_count
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong", b: "hba1c__test", fact_id: "d693ab2799c4", evidence: "Chỉ số HbA1c có ý nghĩa vô cùng quan trọng với những người mắc bệnh đái tháo đường."},
    {a: "dai_thao_duong_tuyp_2", b: "hba1c__test", fact_id: "1b2858a10fe8", evidence: "Nếu bị tiểu đường tuýp 2 , bạn nên kiểm tra HbA1c 2- 4 lần/năm."},
    {a: "tien_dai_thao_duong", b: "hba1c__test", fact_id: "0d5aaed2cf26", evidence: "Nếu bị tiền đái tháo đường, bạn nên xét nghiệm HbA1c 1 lần/năm."},
    {a: "dai_thao_duong_tuyp_1", b: "hba1c__test", fact_id: "72b9229b2913", evidence: "Nếu bị tiểu đường tuýp 1, bạn nên xét nghiệm HbA1c 3 - 4 lần/năm."},
    {a: "hba1c", b: "xet_nghiem_hba1c", fact_id: "23fde936faf2", evidence: "Tóm lại, chỉ số HbA1c là gì ? HbA1c có mặt trong hồng cầu của con người và đóng vai trò quan trọng trong điều hòa đường huyết. Vì vậy, bạn nên xét nghiệm HbA1c để kiểm tra sức khỏe định kỳ và thiết lập lối sống lành mạnh nhé!"}
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
    {a: "hba1c", b: "uong_thuoc_theo_chi_dinh_cua_bac_si", fact_id: "8299647dba26", evidence: "Uống thuốc theo chỉ định của bác sĩ."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:TREATED_BY {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_2
}
RETURN source.id AS source_id, concept_count,
       rel_count_1 + rel_count_2 AS fact_count;
