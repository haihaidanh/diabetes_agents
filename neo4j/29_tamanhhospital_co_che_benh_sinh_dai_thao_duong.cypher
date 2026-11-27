MERGE (source:DiabetesSource {id: "tamanhhospital_co_che_benh_sinh_dai_thao_duong"})
SET source += {id: "tamanhhospital_co_che_benh_sinh_dai_thao_duong", title: "Co che benh sinh dai thao duong", publisher: "Bệnh viện Tâm Anh", url: "https://tamanhhospital.vn/co-che-benh-sinh-dai-thao-duong/", language: "vi", title_requires_review: true}
WITH source
CALL {
  WITH source
  UNWIND [
    {id: "dai_thao_duong_tuyp_2", name: "Đái tháo đường tuýp 2", category: "disease"},
    {id: "de_khang_insulin", name: "Đề kháng insulin", category: "risk_factor"},
    {id: "roi_loan_tiet_insulin_o_tuyen_tuy", name: "Rối loạn tiết insulin ở tuyến tụy", category: "risk_factor"},
    {id: "beo_bung", name: "Béo bụng", category: "risk_factor"},
    {id: "dai_thao_duong_tuyp_1", name: "Đái tháo đường tuýp 1", category: "disease"},
    {id: "tang_duong_huyet", name: "Tăng đường huyết", category: "symptom"},
    {id: "khat_nhieu", name: "Khát nhiều", category: "symptom"},
    {id: "he_mien_dich", name: "Hệ miễn dịch", category: "symptom"},
    {id: "tuyen_tuy_khong_con_kha_nang_san_xuat_insulin", name: "Tuyến tụy không còn khả năng sản xuất insulin", category: "symptom"},
    {id: "de_nhiem_toan_ceton", name: "Dễ nhiễm toan ceton", category: "symptom"},
    {id: "di_tieu_nhieu", name: "Đi tiểu nhiều", category: "side_effect"},
    {id: "dai_thao_duong_thai_ky", name: "Đái tháo đường thai kỳ", category: "disease"},
    {id: "xet_nghiem", name: "Xét nghiệm", category: "test"},
    {id: "nhau_thai", name: "Nhau thai", category: "disease"},
    {id: "dieu_tri_kiem_soat", name: "Điều trị kiểm soát", category: "lifestyle"}
  ] AS row
  MERGE (n:DiabetesConcept {id: row.id})
  SET n += row
  MERGE (source)-[:MENTIONS]->(n)
  RETURN count(*) AS concept_count
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong_tuyp_2", b: "de_khang_insulin", fact_id: "6d4481853b12", evidence: "Đái tháo đường típ 2 chiếm 90%-95% số ca bệnh, chủ yếu do 2 nguyên nhân chính gồm đề kháng insulin và rối loạn tiết insulin ở tuyến tụy."},
    {a: "dai_thao_duong_tuyp_2", b: "roi_loan_tiet_insulin_o_tuyen_tuy", fact_id: "2c5119429791", evidence: "Đái tháo đường típ 2 chiếm 90%-95% số ca bệnh, chủ yếu do 2 nguyên nhân chính gồm đề kháng insulin và rối loạn tiết insulin ở tuyến tụy."},
    {a: "dai_thao_duong_tuyp_2", b: "beo_bung", fact_id: "974bec113279", evidence: "Béo phì (đặc biệt béo bụng) làm tăng tiết các chất gây viêm từ mô mỡ và làm giảm độ nhạy insulin. Đây được xem là yếu tố thúc đẩy quan trọng nhất của đái tháo đường típ 2 trong xã hội hiện nay."},
    {a: "dai_thao_duong_thai_ky", b: "nhau_thai", fact_id: "fcc1fb7825ff", evidence: "Khi mang thai, nhau thai tiết ra các hormone (như hCG, hPL, estrogen, progesterone…) giúp thai nhi phát triển nhưng lại vô tình gây tình trạng đề kháng insulin ở người mẹ."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:HAS_RISK_FACTOR {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_1
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong_tuyp_1", b: "tang_duong_huyet", fact_id: "c758cd779ee9", evidence: "Vì không có insulin, glucose không vào được tế bào, tích tụ trong máu và gây tăng đường huyết, khiến người bệnh phải duy trì tiêm insulin từ bên ngoài."},
    {a: "dai_thao_duong_tuyp_1", b: "khat_nhieu", fact_id: "d05a9fe1704f", evidence: "Triệu chứng của đái tháo đường típ 1 thường khởi phát nhanh chóng, bất ngờ. Các triệu chứng thường gặp gồm khát nhiều, tiểu nhiều, sụt cân rõ, dễ nhiễm toan ceton…"},
    {a: "dai_thao_duong_tuyp_1", b: "he_mien_dich", fact_id: "3af37029f229", evidence: "Bệnh do hệ miễn dịch của người bệnh nhận diện nhầm các tế bào beta tuyến tụy là “tác nhân lạ” và tấn công."},
    {a: "dai_thao_duong_tuyp_1", b: "tuyen_tuy_khong_con_kha_nang_san_xuat_insulin", fact_id: "d556a5554294", evidence: "Khi các tế bào beta bị phá hủy (thường mất từ 60%-90% tại thời điểm phát hiện bệnh), tuyến tụy không còn khả năng sản xuất insulin hoặc sản xuất rất ít."},
    {a: "dai_thao_duong_tuyp_1", b: "de_nhiem_toan_ceton", fact_id: "16b21f1d33fd", evidence: "Triệu chứng của đái tháo đường típ 1 thường khởi phát nhanh chóng, bất ngờ. Các triệu chứng thường gặp gồm khát nhiều, tiểu nhiều, sụt cân rõ, dễ nhiễm toan ceton…"},
    {a: "dai_thao_duong_tuyp_1", b: "di_tieu_nhieu", fact_id: "3db5ade17e22", evidence: "Triệu chứng của đái tháo đường típ 1 thường khởi phát nhanh chóng, bất ngờ. Các triệu chứng thường gặp gồm khát nhiều, tiểu nhiều, sụt cân rõ, dễ nhiễm toan ceton…"}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:HAS_SYMPTOM {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_2
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong_thai_ky", b: "xet_nghiem", fact_id: "95b0bf719787", evidence: "Phụ nữ mang thai cần xét nghiệm để tầm soát đái tháo đường thai kỳ và điều trị kiểm soát nếu cần."}
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
    {a: "dai_thao_duong_thai_ky", b: "dieu_tri_kiem_soat", fact_id: "597206e877f2", evidence: "Phụ nữ mang thai cần xét nghiệm để tầm soát đái tháo đường thai kỳ và điều trị kiểm soát nếu cần."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:TREATED_BY {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_4
}
RETURN source.id AS source_id, concept_count,
       rel_count_1 + rel_count_2 + rel_count_3 + rel_count_4 AS fact_count;
