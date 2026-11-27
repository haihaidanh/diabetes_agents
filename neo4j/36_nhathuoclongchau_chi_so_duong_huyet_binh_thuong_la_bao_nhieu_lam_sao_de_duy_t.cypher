MERGE (source:DiabetesSource {id: "nhathuoclongchau_chi_so_duong_huyet_binh_thuong_la_bao_nhieu_lam_sao_de_duy_t"})
SET source += {id: "nhathuoclongchau_chi_so_duong_huyet_binh_thuong_la_bao_nhieu_lam_sao_de_duy_t", title: "Chi so duong huyet binh thuong la bao nhieu lam sao de duy tri muc duong huyet on dinh", publisher: "Nhà thuốc Long Châu", url: "https://nhathuoclongchau.com.vn/bai-viet/chi-so-duong-huyet-binh-thuong-la-bao-nhieu-lam-sao-de-duy-tri-muc-duong-huyet-on-dinh.html", language: "vi", title_requires_review: true}
WITH source
CALL {
  WITH source
  UNWIND [
    {id: "dai_thao_duong", name: "Đái tháo đường", category: "disease"},
    {id: "chi_so_duong_huyet", name: "Chỉ số đường huyết", category: "symptom"},
    {id: "duong_huyet_on_dinh", name: "Đường huyết ổn định", category: "disease"},
    {id: "ngu_coc_nguyen_chat", name: "Ngũ cốc nguyên chất", category: "lifestyle"},
    {id: "nuoc_loc_tra_thao_moc_tra_den_khong_duong", name: "Nước lọc, trà thảo mộc, trà đen không đường", category: "lifestyle"}
  ] AS row
  MERGE (n:DiabetesConcept {id: row.id})
  SET n += row
  MERGE (source)-[:MENTIONS]->(n)
  RETURN count(*) AS concept_count
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong", b: "chi_so_duong_huyet", fact_id: "00940b72a957", evidence: "Chỉ số đường huyết là giá trị thể hiện lượng glucose có trong máu, nguồn năng lượng chính cho các cơ quan, đặc biệt là não bộ và hệ thần kinh."}
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
    {a: "duong_huyet_on_dinh", b: "ngu_coc_nguyen_chat", fact_id: "2077093e1476", evidence: "Thay vì dùng đường tinh luyện, bạn nên chọn các nguồn ngọt tự nhiên an toàn hơn như các loại ngũ cốc nguyên chất."},
    {a: "duong_huyet_on_dinh", b: "nuoc_loc_tra_thao_moc_tra_den_khong_duong", fact_id: "5f2bd73a7ccb", evidence: "Khi chọn đồ uống, hãy gắn bó với nước lọc, trà thảo mộc, trà đen không đường."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:PREVENTED_BY {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_2
}
RETURN source.id AS source_id, concept_count,
       rel_count_1 + rel_count_2 AS fact_count;
