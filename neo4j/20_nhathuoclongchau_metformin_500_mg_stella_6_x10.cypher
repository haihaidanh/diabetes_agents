MERGE (source:DiabetesSource {id: "nhathuoclongchau_metformin_500_mg_stella_6_x10"})
SET source += {id: "nhathuoclongchau_metformin_500_mg_stella_6_x10", title: "Metformin 500 mg stella 6 x10", publisher: "Nhà thuốc Long Châu", url: "https://nhathuoclongchau.com.vn/thuoc/metformin-500-mg-stella-6-x10.html", language: "vi", title_requires_review: true}
WITH source
CALL {
  WITH source
  UNWIND [
    {id: "metformin", name: "Metformin", category: "drug"},
    {id: "buon_non", name: "Buồn nôn", category: "side_effect"},
    {id: "non", name: "Nôn", category: "side_effect"},
    {id: "dau_bung", name: "Đau bụng", category: "side_effect"},
    {id: "ngua", name: "Ngứa", category: "side_effect"},
    {id: "noi_may_day", name: "Nổi mày đay", category: "side_effect"},
    {id: "viem_gan", name: "Viêm gan", category: "side_effect"},
    {id: "tieu_chay", name: "Tiêu chảy", category: "side_effect"},
    {id: "chan_an", name: "Chán ăn", category: "side_effect"},
    {id: "roi_loan_vi_giac", name: "Rối loạn vị giác", category: "side_effect"},
    {id: "nhiem_toan_lactic", name: "Nhiễm toan lactic", category: "side_effect"},
    {id: "giam_hap_thu_vitamin_b", name: "Giảm hấp thu vitamin B", category: "side_effect"},
    {id: "ban_do", name: "Ban đỏ", category: "side_effect"},
    {id: "suy_gan", name: "Suy gan", category: "disease"},
    {id: "tien_hon_me_do_dai_thao_duong", name: "Tiền hôn mê do đái tháo đường", category: "disease"},
    {id: "suy_than_nang", name: "Suy thận nặng", category: "disease"},
    {id: "qua_man_voi_metformin", name: "Quá mẫn với metformin", category: "disease"},
    {id: "toan_chuyen_hoa", name: "Toan chuyển hóa", category: "disease"},
    {id: "tinh_trang_cap_tinh_anh_huong_den_chuc_nang_than", name: "Tình trạng cấp tính ảnh hưởng đến chức năng thận", category: "disease"},
    {id: "thieu_oxy_mo", name: "Thiếu oxy mô", category: "disease"},
    {id: "biguanid", name: "Biguanid", category: "drug_class"}
  ] AS row
  MERGE (n:DiabetesConcept {id: row.id})
  SET n += row
  MERGE (source)-[:MENTIONS]->(n)
  RETURN count(*) AS concept_count
}
CALL {
  WITH source
  UNWIND [
    {a: "metformin", b: "buon_non", fact_id: "fa1bb8743eba", evidence: "Rất thường gặp (ADR ≥ 1/10) Tiêu hóa: Các rối loạn tiêu hóa như buồn nôn, nôn, tiêu chảy, đau bụng, chán ăn."},
    {a: "metformin", b: "non", fact_id: "d39cbe7bd3a0", evidence: "Rất thường gặp (ADR ≥ 1/10) Tiêu hóa: Các rối loạn tiêu hóa như buồn nôn, nôn, tiêu chảy, đau bụng, chán ăn."},
    {a: "metformin", b: "dau_bung", fact_id: "e3cc1df88106", evidence: "Rất thường gặp (ADR ≥ 1/10) Tiêu hóa: Các rối loạn tiêu hóa như buồn nôn, nôn, tiêu chảy, đau bụng, chán ăn."},
    {a: "metformin", b: "ngua", fact_id: "220f4e35e07c", evidence: "Da và mô dưới da: Các phản ứng da như ban đỏ, ngứa, nổi mày đay."},
    {a: "metformin", b: "noi_may_day", fact_id: "9d412f387f0c", evidence: "Da và mô dưới da: Các phản ứng da như ban đỏ, ngứa, nổi mày đay."},
    {a: "metformin", b: "viem_gan", fact_id: "795034d073db", evidence: "Gan - mật: Các báo cáo riêng biệt về việc tự phục hồi sau khi ngưng metformin ở những trường hợp bất thường xét nghiệm chức năng gan hoặc viêm gan."},
    {a: "metformin", b: "tieu_chay", fact_id: "166be7ffd38d", evidence: "Rất thường gặp (ADR ≥ 1/10) Tiêu hóa: Các rối loạn tiêu hóa như buồn nôn, nôn, tiêu chảy, đau bụng, chán ăn."},
    {a: "metformin", b: "chan_an", fact_id: "3f9cca3ac7ca", evidence: "Các rối loạn tiêu hóa như buồn nôn, nôn, tiêu chảy, đau bụng, chán ăn."},
    {a: "metformin", b: "roi_loan_vi_giac", fact_id: "b0ee1074fb35", evidence: "Thường gặp (1/100 ≤ ADR < 1/10) Thần kinh: Rối loạn vị giác."},
    {a: "metformin", b: "nhiem_toan_lactic", fact_id: "cc7a55165f8b", evidence: "Rất hiếm gặp (ADR < 1/10.000) Chuyển hóa và dinh dưỡng: Nhiễm toan lactic, giảm hấp thu vitamin B làm giảm nồng độ trong huyết thanh khi sử dụng metformin lâu dài."},
    {a: "metformin", b: "giam_hap_thu_vitamin_b", fact_id: "52242d18c948", evidence: "Rất hiếm gặp (ADR < 1/10.000) Chuyển hóa và dinh dưỡng: Nhiễm toan lactic, giảm hấp thu vitamin B làm giảm nồng độ trong huyết thanh khi sử dụng metformin lâu dài."},
    {a: "metformin", b: "ban_do", fact_id: "0be25e387de5", evidence: "Da và mô dưới da: Các phản ứng da như ban đỏ, ngứa, nổi mày đay."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:HAS_SIDE_EFFECT {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_1
}
CALL {
  WITH source
  UNWIND [
    {a: "metformin", b: "suy_gan", fact_id: "229ac5ac295f", evidence: "Suy gan, ngộ độc rượu cấp tính, nghiện rượu."},
    {a: "metformin", b: "tien_hon_me_do_dai_thao_duong", fact_id: "5065c3b03cb8", evidence: "Tiền hôn mê do đái tháo đường."},
    {a: "metformin", b: "suy_than_nang", fact_id: "d9e2a43667a2", evidence: "Bệnh nhân suy thận nặng (eGFR < 30 ml/phút/1,73 m 2 )."},
    {a: "metformin", b: "qua_man_voi_metformin", fact_id: "3dd90d0e8d67", evidence: "Bệnh nhân đã có tiền sử quá mẫn với metformin hoặc bất kỳ thành phần tá dược nào của thuốc."},
    {a: "metformin", b: "toan_chuyen_hoa", fact_id: "7dea77a21e1d", evidence: "Bệnh nhân toan chuyển hóa cấp tính hoặc mạn tính, bao gồm cả nhiễm toan ceton do đái tháo đường."},
    {a: "metformin", b: "tinh_trang_cap_tinh_anh_huong_den_chuc_nang_than", fact_id: "cbe8818fcc8a", evidence: "Tình trạng cấp tính có khả năng thay đổi chức năng thận như: Mất nước, nhiễm trùng nặng, sốc."},
    {a: "metformin", b: "thieu_oxy_mo", fact_id: "6728759f3ec7", evidence: "Các bệnh có thể gây thiếu oxy mô (đặc biệt là bệnh cấp tính, hoặc tình trạng nặng hơn của bệnh mạn tính) như: Suy tim mất bù, suy hô hấp, nhồi máu cơ tim gần đây, sốc"}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:CONTRAINDICATED_IN {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_2
}
CALL {
  WITH source
  UNWIND [
    {a: "metformin", b: "biguanid", fact_id: "84a085448f80", evidence: "Thuốc Mertformin 500 mg là sản phẩm của Stella Pharm, có thành phần chính là Metformin."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:BELONGS_TO {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_3
}
RETURN source.id AS source_id, concept_count,
       rel_count_1 + rel_count_2 + rel_count_3 AS fact_count;
