MERGE (source:DiabetesSource {id: "tamanhhospital_benh_tieu_duong_co_lay_khong"})
SET source += {id: "tamanhhospital_benh_tieu_duong_co_lay_khong", title: "Benh tieu duong co lay khong", publisher: "Bệnh viện Tâm Anh", url: "https://tamanhhospital.vn/benh-tieu-duong-co-lay-khong/", language: "vi", title_requires_review: true}
WITH source
CALL {
  WITH source
  UNWIND [
    {id: "dai_thao_duong", name: "Đái tháo đường", category: "disease"},
    {id: "xet_nghiem_tam_soat_duong_huyet_dinh_ky", name: "Xét nghiệm tầm soát đường huyết định kỳ", category: "test"},
    {id: "tien_su_gia_dinh", name: "Tiền sử gia đình", category: "risk_factor"},
    {id: "loi_song_tinh_tai_it_hoat_dong_the_luc", name: "Lối sống tĩnh tại, ít hoạt động thể lực", category: "risk_factor"},
    {id: "tien_su_benh_ca_nhan", name: "Tiền sử bệnh cá nhân", category: "risk_factor"}
  ] AS row
  MERGE (n:DiabetesConcept {id: row.id})
  SET n += row
  MERGE (source)-[:MENTIONS]->(n)
  RETURN count(*) AS concept_count
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong", b: "xet_nghiem_tam_soat_duong_huyet_dinh_ky", fact_id: "03c950531fd7", evidence: "Theo Hướng dẫn từ Hiệp hội Đái tháo đường Hoa Kỳ (ADA), tất cả những người trưởng thành từ 35 tuổi trở lên đều nên bắt đầu thực hiện xét nghiệm tầm soát đường huyết định kỳ mỗi 1 – 3 năm một lần, ngay cả khi cơ thể khỏe mạnh và không có triệu chứng."}
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
    {a: "dai_thao_duong", b: "tien_su_gia_dinh", fact_id: "d5d310c7b673", evidence: "Người có tiền sử gia đình: Như đã nhấn mạnh, bộ gen quyết định rất lớn. Nguy cơ của bạn sẽ tăng theo cấp số nhân nếu có cha mẹ hoặc anh chị em ruột đã được chẩn đoán bệnh tiểu đường."},
    {a: "dai_thao_duong", b: "loi_song_tinh_tai_it_hoat_dong_the_luc", fact_id: "a088b154994a", evidence: "Lối sống tĩnh tại, ít hoạt động thể lực: Khi bạn vận động, các tế bào cơ bắp sẽ phải mở cửa đón nhận glucose từ máu để chuyển hóa thành năng lượng. Ngược lại, việc lười vận động sẽ khiến lượng glucose dư thừa ứ đọng lại trong lòng mạch, làm tăng áp lực làm việc cho tuyến tụy lâu ngày dẫn đến suy kiệt."},
    {a: "dai_thao_duong", b: "tien_su_benh_ca_nhan", fact_id: "8c3e4184fe21", evidence: "Tiền sử bệnh cá nhân: Những phụ nữ từng được chẩn đoán bị tiểu đường thai kỳ, phụ nữ mắc hội chứng buồng trứng đa nang (PCOS) hoặc những người có tiền sử rối loạn mỡ máu (Triglyceride cao, HDL thấp) và tăng huyết áp đều nằm trong nhóm có rủi ro cao tiến triển thành tiểu đường type 2."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:HAS_RISK_FACTOR {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_2
}
RETURN source.id AS source_id, concept_count,
       rel_count_1 + rel_count_2 AS fact_count;
