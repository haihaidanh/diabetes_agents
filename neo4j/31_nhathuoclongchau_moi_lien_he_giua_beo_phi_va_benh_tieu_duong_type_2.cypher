MERGE (source:DiabetesSource {id: "nhathuoclongchau_moi_lien_he_giua_beo_phi_va_benh_tieu_duong_type_2"})
SET source += {id: "nhathuoclongchau_moi_lien_he_giua_beo_phi_va_benh_tieu_duong_type_2", title: "Moi lien he giua beo phi va benh tieu duong type 2", publisher: "Nhà thuốc Long Châu", url: "https://nhathuoclongchau.com.vn/bai-viet/moi-lien-he-giua-beo-phi-va-benh-tieu-duong-type-2.html", language: "vi", title_requires_review: true}
WITH source
CALL {
  WITH source
  UNWIND [
    {id: "dai_thao_duong_tuyp_2", name: "Đái tháo đường tuýp 2", category: "disease"},
    {id: "khang_insulin", name: "Kháng insulin", category: "disease"},
    {id: "tam_soat_benh_tieu_duong_moi_nam", name: "Tầm soát bệnh tiểu đường mỗi năm", category: "test"},
    {id: "giam_can", name: "Giảm cân", category: "side_effect"},
    {id: "kiem_soat_can_nang", name: "Kiểm soát cân nặng", category: "lifestyle"},
    {id: "tang_cuong_van_dong", name: "Tăng cường vận động", category: "lifestyle"},
    {id: "tuan_thu_dieu_tri", name: "Tuân thủ điều trị", category: "lifestyle"},
    {id: "tap_luyen_the_duc_the_thao_deu_dan", name: "Tập luyện thể dục thể thao đều đặn", category: "lifestyle"},
    {id: "phong_ngua_chu_dong", name: "Phòng ngừa chủ động", category: "lifestyle"},
    {id: "beo_phi", name: "Béo phì", category: "risk_factor"}
  ] AS row
  MERGE (n:DiabetesConcept {id: row.id})
  SET n += row
  MERGE (source)-[:MENTIONS]->(n)
  RETURN count(*) AS concept_count
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong_tuyp_2", b: "khang_insulin", fact_id: "1cffb04ecb0c", evidence: "Khi cơ thể tích tụ quá nhiều mỡ, đặc biệt là mỡ nội tạng, tình trạng kháng insulin dễ xảy ra, nghĩa là insulin vẫn có mặt nhưng không hoạt động hiệu quả để chuyển đổi glucose (đường) thành năng lượng."}
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
    {a: "dai_thao_duong_tuyp_2", b: "tam_soat_benh_tieu_duong_moi_nam", fact_id: "383ea7d52e31", evidence: "Người thừa cân, béo phì trên 30 tuổi nên tầm soát bệnh tiểu đường mỗi năm."}
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
    {a: "dai_thao_duong_tuyp_2", b: "giam_can", fact_id: "fc6c1aa4d3ae", evidence: "Người béo phì nên giảm cân để giảm lượng mỡ tích trữ trong cơ thể, từ đó cải thiện tình trạng kháng insulin và giúp kiểm soát đường huyết hiệu quả hơn."},
    {a: "dai_thao_duong_tuyp_2", b: "kiem_soat_can_nang", fact_id: "8c28f28a7295", evidence: "Kiểm soát cân nặng: Tránh tăng cân ngoài ý muốn, duy trì cân nặng ổn định. Giảm 5 - 10% trọng lượng cơ thể giúp cải thiện tình trạng kháng insulin và kiểm soát đường huyết hiệu quả."},
    {a: "dai_thao_duong_tuyp_2", b: "tang_cuong_van_dong", fact_id: "c3e87d49d0f9", evidence: "Tăng cường vận động: Tập luyện thể dục thể thao đều đặn như đi bộ, đạp xe, bơi lội, cầu lông,... Duy trì thói quen vận động hằng ngày để hỗ trợ tiêu hao năng lượng dư thừa."},
    {a: "dai_thao_duong_tuyp_2", b: "tuan_thu_dieu_tri", fact_id: "4c736711318c", evidence: "Tuân thủ điều trị: Thực hiện đúng theo hướng dẫn và phác đồ điều trị từ bác sĩ chuyên khoa."},
    {a: "dai_thao_duong_tuyp_2", b: "tap_luyen_the_duc_the_thao_deu_dan", fact_id: "287b149483ca", evidence: "Tập luyện thể dục thể thao đều đặn là cách cải thiện tình trạng tiểu đường cho người béo phì"}
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
    {a: "dai_thao_duong_tuyp_2", b: "phong_ngua_chu_dong", fact_id: "c240fcc51d50", evidence: "Phòng ngừa chủ động: Người béo phì dù chưa mắc tiểu đường vẫn thuộc nhóm nguy cơ cao do kháng insulin. Cần có kế hoạch ăn uống điều độ kết hợp luyện tập hợp lý để ngăn ngừa bệnh hiệu quả."}
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
    {a: "dai_thao_duong_tuyp_2", b: "beo_phi", fact_id: "96d0a3536479", evidence: "Béo phì và tiểu đường type 2 là hai vấn đề sức khỏe phổ biến hiện nay, đặc biệt ở người trưởng thành."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:HAS_RISK_FACTOR {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_5
}
RETURN source.id AS source_id, concept_count,
       rel_count_1 + rel_count_2 + rel_count_3 + rel_count_4 + rel_count_5 AS fact_count;
