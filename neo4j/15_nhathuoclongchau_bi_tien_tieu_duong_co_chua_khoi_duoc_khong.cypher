MERGE (source:DiabetesSource {id: "nhathuoclongchau_bi_tien_tieu_duong_co_chua_khoi_duoc_khong"})
SET source += {id: "nhathuoclongchau_bi_tien_tieu_duong_co_chua_khoi_duoc_khong", title: "Bi tien tieu duong co chua khoi duoc khong", publisher: "Nhà thuốc Long Châu", url: "https://nhathuoclongchau.com.vn/bai-viet/bi-tien-tieu-duong-co-chua-khoi-duoc-khong-59485.html", language: "vi", title_requires_review: true}
WITH source
CALL {
  WITH source
  UNWIND [
    {id: "dai_thao_duong_tuyp_2", name: "Đái tháo đường tuýp 2", category: "disease"},
    {id: "tien_tieu_duong", name: "Tiền tiểu đường", category: "disease"},
    {id: "mau_da_toi_hon", name: "Màu da tối hơn", category: "symptom"},
    {id: "buon_ngu", name: "Buồn ngủ", category: "symptom"},
    {id: "thua_can", name: "Thừa cân", category: "risk_factor"},
    {id: "benh_tieu_duong_tuyp_2", name: "Bệnh tiểu đường tuýp 2", category: "disease"},
    {id: "tang_huyet_ap", name: "Tăng huyết áp", category: "disease"},
    {id: "roi_loan_lipid_mau", name: "Rối loạn lipid máu", category: "side_effect"},
    {id: "insulin_khong_duoc_tao_ra_du_sau_khi_an", name: "Insulin không được tạo ra đủ sau khi ăn", category: "risk_factor"},
    {id: "co_the_khong_hap_thu_duoc_insulin", name: "Cơ thể không hấp thụ được insulin", category: "risk_factor"},
    {id: "beo_phi", name: "Béo phì", category: "risk_factor"},
    {id: "chi_so_mo_trong_mau_cao_hon_binh_thuong", name: "Chỉ số mỡ trong máu cao hơn bình thường", category: "risk_factor"},
    {id: "nguoi_than_trong_gia_dinh_da_mac_benh_dai_thao_duong", name: "Người thân trong gia đình đã mắc bệnh đái tháo đường", category: "risk_factor"},
    {id: "it_van_dong", name: "Ít vận động", category: "risk_factor"},
    {id: "khong_hoat_dong_the_luc", name: "Không hoạt động thể lực", category: "risk_factor"},
    {id: "roi_loan_mo_mau", name: "Rối loạn mỡ máu", category: "risk_factor"},
    {id: "hoi_chung_buong_trung_da_nang", name: "Hội chứng buồng trứng đa nang", category: "risk_factor"},
    {id: "kinh_nguyet_khong_deu", name: "Kinh nguyệt không đều", category: "risk_factor"},
    {id: "tang_triglycerid", name: "Tăng triglycerid", category: "risk_factor"},
    {id: "giam_hdl_cholesterol", name: "Giảm HDL cholesterol", category: "risk_factor"},
    {id: "chi_so_bmi_25", name: "Chỉ số BMI > 25", category: "risk_factor"},
    {id: "tim_mach", name: "Tim mạch", category: "disease"},
    {id: "dot_quy", name: "Đột quỵ", category: "disease"},
    {id: "tien_dai_thao_duong", name: "Tiền đái tháo đường", category: "disease"},
    {id: "duong_huyet_luc_doi", name: "Đường huyết lúc đói", category: "test"}
  ] AS row
  MERGE (n:DiabetesConcept {id: row.id})
  SET n += row
  MERGE (source)-[:MENTIONS]->(n)
  RETURN count(*) AS concept_count
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong_tuyp_2", b: "tien_tieu_duong", fact_id: "587c9f71620a", evidence: "Tiền tiểu đường không phải là bệnh lý mà là một dấu hiệu cảnh báo rằng bạn sẽ có nguy cơ mắc bệnh tiểu đường tuýp 2."},
    {a: "tien_tieu_duong", b: "tang_huyet_ap", fact_id: "747a196130cd", evidence: "Mắc một số bệnh nguy cơ khác như tăng huyết áp hoặc rối loạn mỡ máu."},
    {a: "tien_tieu_duong", b: "roi_loan_lipid_mau", fact_id: "717e2e80ae6f", evidence: "Người đã từng bị rối loạn lipid máu (tăng triglycerid, giảm HDL cholesterol,...)."},
    {a: "tien_tieu_duong", b: "insulin_khong_duoc_tao_ra_du_sau_khi_an", fact_id: "610fd5ee1496", evidence: "Nguyên nhân là do insulin không được tạo ra đủ sau khi ăn hoặc do cơ thể không hấp thụ được insulin."},
    {a: "tien_tieu_duong", b: "co_the_khong_hap_thu_duoc_insulin", fact_id: "e8a4f7dfc533", evidence: "Nguyên nhân là do insulin không được tạo ra đủ sau khi ăn hoặc do cơ thể không hấp thụ được insulin."},
    {a: "tien_tieu_duong", b: "beo_phi", fact_id: "03484a0506a3", evidence: "Người mắc bệnh béo phì , thừa cân hoặc chỉ số mỡ trong máu cao hơn bình thường."},
    {a: "tien_tieu_duong", b: "thua_can", fact_id: "e93c52611f9e", evidence: "Người mắc bệnh béo phì , thừa cân hoặc chỉ số mỡ trong máu cao hơn bình thường."},
    {a: "tien_tieu_duong", b: "chi_so_mo_trong_mau_cao_hon_binh_thuong", fact_id: "7e29578d8d9d", evidence: "Người mắc bệnh béo phì , thừa cân hoặc chỉ số mỡ trong máu cao hơn bình thường."},
    {a: "tien_tieu_duong", b: "nguoi_than_trong_gia_dinh_da_mac_benh_dai_thao_duong", fact_id: "e2df4ae505eb", evidence: "Có người thân trong gia đình đã mắc bệnh đái tháo đường."},
    {a: "tien_tieu_duong", b: "it_van_dong", fact_id: "bf3189666d9a", evidence: "Người ít vận động, không hoạt động thể lực."},
    {a: "tien_tieu_duong", b: "khong_hoat_dong_the_luc", fact_id: "e4fd6c2dd546", evidence: "Người ít vận động, không hoạt động thể lực."},
    {a: "tien_tieu_duong", b: "roi_loan_mo_mau", fact_id: "e250a5ec69e3", evidence: "Mắc một số bệnh nguy cơ khác như tăng huyết áp hoặc rối loạn mỡ máu."},
    {a: "tien_tieu_duong", b: "hoi_chung_buong_trung_da_nang", fact_id: "31c1ab0dfbe2", evidence: "Phụ nữ mắc hội chứng buồng trứng đa nang hoặc kinh nguyệt không đều."},
    {a: "tien_tieu_duong", b: "kinh_nguyet_khong_deu", fact_id: "6faf6930824b", evidence: "Phụ nữ mắc hội chứng buồng trứng đa nang hoặc kinh nguyệt không đều."},
    {a: "tien_tieu_duong", b: "tang_triglycerid", fact_id: "d5a90e9dc7de", evidence: "Người đã từng bị rối loạn lipid máu (tăng triglycerid, giảm HDL cholesterol,...)."},
    {a: "tien_tieu_duong", b: "giam_hdl_cholesterol", fact_id: "40a032678c2c", evidence: "Người đã từng bị rối loạn lipid máu (tăng triglycerid, giảm HDL cholesterol,...)."},
    {a: "tien_tieu_duong", b: "chi_so_bmi_25", fact_id: "812db564f4b7", evidence: "Một số đối tượng có chỉ số BMI > 25."}
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
    {a: "tien_tieu_duong", b: "mau_da_toi_hon", fact_id: "ae059f3ab0aa", evidence: "Bên cạnh đó, tiền tiểu đường không gây ra triệu chứng hay dấu hiệu gì cụ thể, thường có xu hướng màu da tối hơn, buồn ngủ, thừa cân,..."},
    {a: "tien_tieu_duong", b: "buon_ngu", fact_id: "8be9a9996ea6", evidence: "Bên cạnh đó, tiền tiểu đường không gây ra triệu chứng hay dấu hiệu gì cụ thể, thường có xu hướng màu da tối hơn, buồn ngủ, thừa cân,..."},
    {a: "tien_tieu_duong", b: "thua_can", fact_id: "2d1dd2b366fa", evidence: "Bên cạnh đó, tiền tiểu đường không gây ra triệu chứng hay dấu hiệu gì cụ thể, thường có xu hướng màu da tối hơn, buồn ngủ, thừa cân,..."}
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
    {a: "tien_tieu_duong", b: "benh_tieu_duong_tuyp_2", fact_id: "b32b4ddb5137", evidence: "Trong trường hợp bạn mắc tiền tiểu đường và gặp các triệu chứng như khát nước nhiều, đi tiểu nhiều lần , mờ mắt, mệt mỏi,... thì đó là những dấu hiệu sớm cho thấy tiền tiểu đường đã tiến triển thành bệnh tiểu đường tuýp 2 ."},
    {a: "tim_mach", b: "tien_tieu_duong", fact_id: "b2c56a1fd90a", evidence: "Điều này không chỉ có ích cải thiện tình trạng tiền tiểu đường mà còn hạn chế nguy cơ mắc các bệnh như tim mạch hay đột quỵ."},
    {a: "dot_quy", b: "tien_tieu_duong", fact_id: "980f273a58fc", evidence: "Điều này không chỉ có ích cải thiện tình trạng tiền tiểu đường mà còn hạn chế nguy cơ mắc các bệnh như tim mạch hay đột quỵ."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:HAS_COMPLICATION {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_3
}
CALL {
  WITH source
  UNWIND [
    {a: "tien_dai_thao_duong", b: "duong_huyet_luc_doi", fact_id: "02726c5b7fa2", op: "range", value: 100, value_max: 125, unit: "mg/dl", evidence: "Tiền tiểu đường là tình trạng rối loạn glucose khi đói (rối loạn dung nạp glucose), với chỉ số đường huyết khi đói lên đến 100 - 125 mg/dl, trong khi chỉ số đó ở người bình thường là 70 - 100 mg/dl."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:DIAGNOSED_BY {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_4
}
RETURN source.id AS source_id, concept_count,
       rel_count_1 + rel_count_2 + rel_count_3 + rel_count_4 AS fact_count;
