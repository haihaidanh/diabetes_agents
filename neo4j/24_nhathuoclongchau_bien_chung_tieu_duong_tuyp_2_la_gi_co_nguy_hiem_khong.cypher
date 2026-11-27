MERGE (source:DiabetesSource {id: "nhathuoclongchau_bien_chung_tieu_duong_tuyp_2_la_gi_co_nguy_hiem_khong"})
SET source += {id: "nhathuoclongchau_bien_chung_tieu_duong_tuyp_2_la_gi_co_nguy_hiem_khong", title: "Bien chung tieu duong tuyp 2 la gi co nguy hiem khong", publisher: "Nhà thuốc Long Châu", url: "https://nhathuoclongchau.com.vn/bai-viet/bien-chung-tieu-duong-tuyp-2-la-gi-co-nguy-hiem-khong.html", language: "vi", title_requires_review: true}
WITH source
CALL {
  WITH source
  UNWIND [
    {id: "dai_thao_duong_tuyp_2", name: "Đái tháo đường tuýp 2", category: "disease"},
    {id: "tim", name: "Tim", category: "disease"},
    {id: "mach_mau", name: "Mạch máu", category: "disease"},
    {id: "than", name: "Thận", category: "disease"},
    {id: "than_kinh", name: "Thần kinh", category: "disease"},
    {id: "rang", name: "Răng", category: "disease"},
    {id: "xuong_khop", name: "Xương khớp", category: "disease"},
    {id: "nao_bo", name: "Não bộ", category: "disease"},
    {id: "suy_giam_tri_nho", name: "Suy giảm trí nhớ", category: "disease"},
    {id: "cac_benh_ve_da", name: "Các bệnh về da", category: "disease"},
    {id: "giam_can", name: "Giảm cân", category: "side_effect"},
    {id: "roi_loan_chuyen_hoa_khong_dong_nhat", name: "Rối loạn chuyển hóa không đồng nhất", category: "disease"},
    {id: "bien_chung_tieu_duong_tuyp_2_cap_tinh", name: "Biến chứng tiểu đường tuýp 2 cấp tính", category: "disease"},
    {id: "tang_ap_luc_tham_thau", name: "Tăng áp lực thẩm thấu", category: "disease"},
    {id: "ha_duong_huyet", name: "Hạ đường huyết", category: "disease"},
    {id: "hon_me", name: "Hôn mê", category: "symptom"},
    {id: "tu_vong", name: "Tử vong", category: "symptom"},
    {id: "bien_chung_tieu_duong_tuyp_2", name: "Biến chứng tiểu đường tuýp 2", category: "disease"},
    {id: "thay_doi_loi_song_lanh_manh", name: "Thay đổi lối sống lành mạnh", category: "lifestyle"}
  ] AS row
  MERGE (n:DiabetesConcept {id: row.id})
  SET n += row
  MERGE (source)-[:MENTIONS]->(n)
  RETURN count(*) AS concept_count
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong_tuyp_2", b: "tim", fact_id: "022afa57014d", evidence: "Lâu dần, tình trạng này sẽ gây tổn thương các cơ quan trong cơ thể (mà thuật ngữ chuyên ngành gọi là biến chứng) điển hình phải kể đến tim, mạch máu, thận, mắt, thần kinh và răng."},
    {a: "dai_thao_duong_tuyp_2", b: "mach_mau", fact_id: "bc2c15ff9dcd", evidence: "Lâu dần, tình trạng này sẽ gây tổn thương các cơ quan trong cơ thể (mà thuật ngữ chuyên ngành gọi là biến chứng) điển hình phải kể đến tim, mạch máu, thận, mắt, thần kinh và răng."},
    {a: "dai_thao_duong_tuyp_2", b: "than", fact_id: "19528d53deff", evidence: "Lâu dần, tình trạng này sẽ gây tổn thương các cơ quan trong cơ thể (mà thuật ngữ chuyên ngành gọi là biến chứng) điển hình phải kể đến tim, mạch máu, thận, mắt, thần kinh và răng."},
    {a: "dai_thao_duong_tuyp_2", b: "than_kinh", fact_id: "4d9a2fb1917c", evidence: "Lâu dần, tình trạng này sẽ gây tổn thương các cơ quan trong cơ thể (mà thuật ngữ chuyên ngành gọi là biến chứng) điển hình phải kể đến tim, mạch máu, thận, mắt, thần kinh và răng."},
    {a: "dai_thao_duong_tuyp_2", b: "rang", fact_id: "de7e29ba4b3b", evidence: "Lâu dần, tình trạng này sẽ gây tổn thương các cơ quan trong cơ thể (mà thuật ngữ chuyên ngành gọi là biến chứng) điển hình phải kể đến tim, mạch máu, thận, mắt, thần kinh và răng."},
    {a: "dai_thao_duong_tuyp_2", b: "xuong_khop", fact_id: "7e97a1b584b7", evidence: "Ngoài các biến chứng tiểu đường tuýp 2 kể trên, đường huyết tăng cao có thể dẫn đến những tổn thương cơ thể khác như xương khớp, não bộ, suy giảm trí nhớ, mắc các bệnh về da,..."},
    {a: "dai_thao_duong_tuyp_2", b: "nao_bo", fact_id: "3fa855b34a1e", evidence: "Ngoài các biến chứng tiểu đường tuýp 2 kể trên, đường huyết tăng cao có thể dẫn đến những tổn thương cơ thể khác như xương khớp, não bộ, suy giảm trí nhớ, mắc các bệnh về da,..."},
    {a: "dai_thao_duong_tuyp_2", b: "suy_giam_tri_nho", fact_id: "6734d93a9ae7", evidence: "Ngoài các biến chứng tiểu đường tuýp 2 kể trên, đường huyết tăng cao có thể dẫn đến những tổn thương cơ thể khác như xương khớp, não bộ, suy giảm trí nhớ, mắc các bệnh về da,..."},
    {a: "dai_thao_duong_tuyp_2", b: "cac_benh_ve_da", fact_id: "952632199002", evidence: "Ngoài các biến chứng tiểu đường tuýp 2 kể trên, đường huyết tăng cao có thể dẫn đến những tổn thương cơ thể khác như xương khớp, não bộ, suy giảm trí nhớ, mắc các bệnh về da,..."},
    {a: "bien_chung_tieu_duong_tuyp_2_cap_tinh", b: "tang_ap_luc_tham_thau", fact_id: "fb7dcbe21d93", evidence: "Tăng áp lực thẩm thấu: Đường huyết cao quá mức cho phép có thể gây hôn mê. Đây là biến chứng tiểu đường tuýp 2 nặng nhất, đòi hỏi người bệnh phải được cấp cứu ngay lập tức."},
    {a: "bien_chung_tieu_duong_tuyp_2_cap_tinh", b: "ha_duong_huyet", fact_id: "bb5980d4fc08", evidence: "Hạ đường huyết: Nguyên nhân của tình trạng này là dùng quá thuốc hạ đường huyết quá liều, ăn uống kiêng khem không khoa học, nhịn ăn, tập luyện quá sức, uống quá nhiều rượu. Dấu hiệu của hạ đường huyết là mệt mỏi, chân tay run, vã mồ hôi, choáng váng, hồi hộp, bụng đói cồn cào. Nếu không được điều trị kịp thời, bệnh nhân có thể rơi vào trạng thái hôn mê, nguy kịch hơn là dẫn đến tử vong. Biến chứng tiểu đường tuýp 2 cấp tính rất nguy hiểm, thậm chí gây tử vong nếu không được cấp cứu kịp thời"}
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
    {a: "dai_thao_duong_tuyp_2", b: "giam_can", fact_id: "f927afb662c2", evidence: "Nếu bạn mới mắc tiểu đường tuýp 1 thì hãy tích cực giảm cân để ngăn cho bệnh phát tiến triển lên tuýp 2."},
    {a: "bien_chung_tieu_duong_tuyp_2", b: "thay_doi_loi_song_lanh_manh", fact_id: "a85135cac474", evidence: "Để hạn chế biến chứng tiểu đường tuýp 2, bạn cần duy trì lượng glucose máu và huyết áp ở mức ổn định. Và để làm được việc này, bạn cần thay đổi lối sống lành mạnh."}
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
    {a: "roi_loan_chuyen_hoa_khong_dong_nhat", b: "dai_thao_duong_tuyp_2", fact_id: "454315ba61a6", evidence: "Bệnh tiểu đường tuýp 2 hay còn gọi là đái tháo đường tuýp 2 là căn bệnh rối loạn chuyển hóa không đồng nhất khiến tăng lượng glucose trong máu."}
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
    {a: "ha_duong_huyet", b: "hon_me", fact_id: "6a21f94ec8c2", evidence: "Hạ đường huyết: Nguyên nhân của tình trạng này là dùng quá thuốc hạ đường huyết quá liều, ăn uống kiêng khem không khoa học, nhịn ăn, tập luyện quá sức, uống quá nhiều rượu. Dấu hiệu của hạ đường huyết là mệt mỏi, chân tay run, vã mồ hôi, choáng váng, hồi hộp, bụng đói cồn cào. Nếu không được điều trị kịp thời, bệnh nhân có thể rơi vào trạng thái hôn mê, nguy kịch hơn là dẫn đến tử vong. Biến chứng tiểu đường tuýp 2 cấp tính rất nguy hiểm, thậm chí gây tử vong nếu không được cấp cứu kịp thời"},
    {a: "ha_duong_huyet", b: "tu_vong", fact_id: "34dc7454b8a4", evidence: "Hạ đường huyết: Nguyên nhân của tình trạng này là dùng quá thuốc hạ đường huyết quá liều, ăn uống kiêng khem không khoa học, nhịn ăn, tập luyện quá sức, uống quá nhiều rượu. Dấu hiệu của hạ đường huyết là mệt mỏi, chân tay run, vã mồ hôi, choáng váng, hồi hộp, bụng đói cồn cào. Nếu không được điều trị kịp thời, bệnh nhân có thể rơi vào trạng thái hôn mê, nguy kịch hơn là dẫn đến tử vong. Biến chứng tiểu đường tuýp 2 cấp tính rất nguy hiểm, thậm chí gây tử vong nếu không được cấp cứu kịp thời"}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:HAS_SYMPTOM {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_4
}
RETURN source.id AS source_id, concept_count,
       rel_count_1 + rel_count_2 + rel_count_3 + rel_count_4 AS fact_count;
