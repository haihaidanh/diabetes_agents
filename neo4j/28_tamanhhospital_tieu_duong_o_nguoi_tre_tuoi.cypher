MERGE (source:DiabetesSource {id: "tamanhhospital_tieu_duong_o_nguoi_tre_tuoi"})
SET source += {id: "tamanhhospital_tieu_duong_o_nguoi_tre_tuoi", title: "Tieu duong o nguoi tre tuoi", publisher: "Bệnh viện Tâm Anh", url: "https://tamanhhospital.vn/tieu-duong-o-nguoi-tre-tuoi/", language: "vi", title_requires_review: true}
WITH source
CALL {
  WITH source
  UNWIND [
    {id: "dai_thao_duong", name: "Đái tháo đường", category: "disease"},
    {id: "xet_nghiem_duong_huyet_luc_doi_fpg", name: "Xét nghiệm đường huyết lúc đói (FPG)", category: "test"},
    {id: "nguoi_thua_can_beo_phi", name: "Người thừa cân, béo phì", category: "risk_factor"},
    {id: "dai_thao_duong_tuyp_2", name: "Đái tháo đường tuýp 2", category: "disease"},
    {id: "giam_can_va_duy_tri_muc_can_nang_hop_ly", name: "Giảm cân và duy trì mức cân nặng hợp lý", category: "lifestyle"},
    {id: "kiem_soat_khau_phan_an_de_tranh_du_thua_nang_luong", name: "Kiểm soát khẩu phần ăn để tránh dư thừa năng lượng", category: "lifestyle"},
    {id: "kiem_soat_cang_thang", name: "Kiểm soát căng thẳng", category: "lifestyle"},
    {id: "thay_doi_loi_song", name: "Thay đổi lối sống", category: "lifestyle"},
    {id: "beo_phi_va_khang_insulin", name: "Béo phì và kháng insulin", category: "risk_factor"},
    {id: "dai_thao_duong_tuyp_1", name: "Đái tháo đường tuýp 1", category: "disease"},
    {id: "cau_gat_thay_doi_tam_trang", name: "Cáu gắt, thay đổi tâm trạng", category: "symptom"},
    {id: "nhiem_toan_ceton", name: "Nhiễm toan ceton", category: "disease"},
    {id: "insulin_bo_sung", name: "Insulin bổ sung", category: "drug"},
    {id: "tim_mach_than_mat_va_than_kinh", name: "Tim mạch, thận, mắt và thần kinh", category: "disease"},
    {id: "tieu_duong_o_nguoi_tre", name: "Tiểu đường ở người trẻ", category: "disease"},
    {id: "gai_den", name: "Gai đen", category: "symptom"}
  ] AS row
  MERGE (n:DiabetesConcept {id: row.id})
  SET n += row
  MERGE (source)-[:MENTIONS]->(n)
  RETURN count(*) AS concept_count
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong", b: "xet_nghiem_duong_huyet_luc_doi_fpg", fact_id: "95fe322d8b38", evidence: "Các xét nghiệm quan trọng dùng để chẩn đoán và theo dõi bệnh đái tháo đường : Xét nghiệm đường huyết lúc đói (FPG): Đo lượng đường trong máu sau khi bạn không ăn hoặc uống bất cứ thứ gì (trừ nước lọc) trong ít nhất 8 giờ."}
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
    {a: "dai_thao_duong", b: "nguoi_thua_can_beo_phi", fact_id: "65512a3bffb5", evidence: "Nhóm người nên tầm soát đái tháo đường sớm gồm: Người thừa cân, béo phì."},
    {a: "dai_thao_duong_tuyp_2", b: "beo_phi_va_khang_insulin", fact_id: "cd3236af12a4", evidence: "Tiểu đường type 2: Từng được coi là bệnh của người lớn, nhưng hiện nay đang gia tăng nhanh chóng ở người trẻ do liên quan chặt chẽ đến béo phì và kháng insulin."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:HAS_RISK_FACTOR {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_2
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong_tuyp_2", b: "giam_can_va_duy_tri_muc_can_nang_hop_ly", fact_id: "a433d8d35935", evidence: "Quản lý cân nặng: Giảm cân và duy trì mức cân nặng hợp lý giúp cải thiện đáng kể độ nhạy insulin."},
    {a: "dai_thao_duong_tuyp_2", b: "kiem_soat_khau_phan_an_de_tranh_du_thua_nang_luong", fact_id: "033566530b65", evidence: "Kiểm soát khẩu phần ăn để tránh dư thừa năng lượng."},
    {a: "dai_thao_duong_tuyp_2", b: "kiem_soat_cang_thang", fact_id: "f34f769e8b3b", evidence: "Kiểm soát căng thẳng: Stress có thể làm tăng nồng độ cortisol, từ đó đẩy lượng đường trong máu lên cao. Người trẻ cần học cách quản lý áp lực học tập và cuộc sống thông qua các hoạt động thư giãn, ngủ đủ giấc."},
    {a: "dai_thao_duong_tuyp_1", b: "insulin_bo_sung", fact_id: "6fffae2d430b", evidence: "Người bệnh tiểu đường type 1 phải dùng insulin bổ sung suốt đời."}
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
    {a: "dai_thao_duong_tuyp_2", b: "thay_doi_loi_song", fact_id: "0f4e2755eadf", evidence: "Với tiểu đường type 2, thay đổi lối sống có thể giúp kiểm soát bệnh mà không cần dùng thuốc giai đoạn đầu, hoặc thậm chí làm đảo ngược tình trạng tiền tiểu đường:"}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:PREVENTED_BY {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_4
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong_tuyp_1", b: "cau_gat_thay_doi_tam_trang", fact_id: "94a99bc445ae", evidence: "Cáu gắt, thay đổi tâm trạng: Đường huyết tăng hoặc giảm bất thường ảnh hưởng trực tiếp đến hệ thần kinh và cảm xúc."},
    {a: "tieu_duong_o_nguoi_tre", b: "gai_den", fact_id: "9a57b0795241", evidence: "Gai đen là dấu hiệu đặc trưng của tình trạng kháng insulin thường gặp ở bệnh tiểu đường ở người trẻ ."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:HAS_SYMPTOM {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_5
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong_tuyp_1", b: "nhiem_toan_ceton", fact_id: "941f753a7258", evidence: "Hơi thở có mùi trái cây: Đây là dấu hiệu của nhiễm toan ceton (DKA) – biến chứng cấp tính nguy hiểm thường gặp khi phát hiện tiểu đường tuýp 1."},
    {a: "tim_mach_than_mat_va_than_kinh", b: "dai_thao_duong", fact_id: "9bb6c0f70ae6", evidence: "Người trẻ mắc tiểu đường thường phải sống chung với bệnh trong thời gian dài, làm tăng nguy cơ xuất hiện các biến chứng nguy hiểm ở tim mạch, thận, mắt và thần kinh."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:HAS_COMPLICATION {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_6
}
RETURN source.id AS source_id, concept_count,
       rel_count_1 + rel_count_2 + rel_count_3 + rel_count_4 + rel_count_5 + rel_count_6 AS fact_count;
