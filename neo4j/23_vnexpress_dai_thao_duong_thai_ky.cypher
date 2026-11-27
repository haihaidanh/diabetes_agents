MERGE (source:DiabetesSource {id: "vnexpress_dai_thao_duong_thai_ky"})
SET source += {id: "vnexpress_dai_thao_duong_thai_ky", title: "Dai thao duong thai ky", publisher: "VnExpress", url: "https://vnexpress.net/dai-thao-duong-thai-ky-4435785.html", language: "vi", title_requires_review: true}
WITH source
CALL {
  WITH source
  UNWIND [
    {id: "dai_thao_duong_thai_ky", name: "Đái tháo đường thai kỳ", category: "disease"},
    {id: "khat_nuoc_lien_tuc", name: "Khát nước liên tục", category: "symptom"},
    {id: "tieu_nhieu_lan_trong_ngay", name: "Tiểu nhiều lần trong ngày", category: "symptom"},
    {id: "mo_mat", name: "Mờ mắt", category: "symptom"},
    {id: "ngu_ngay", name: "Ngủ ngáy", category: "symptom"},
    {id: "tang_can_qua_nhanh_so_voi_khuyen_nghi", name: "Tăng cân quá nhanh so với khuyến nghị", category: "symptom"},
    {id: "luong_duong_trong_mau_thap", name: "Lượng đường trong máu thấp", category: "symptom"},
    {id: "kiem_tra_luong_duong_trong_mau", name: "Kiểm tra lượng đường trong máu", category: "test"},
    {id: "lap_bieu_do_su_phat_trien_cua_thai_nhi", name: "Lập biểu đồ sự phát triển của thai nhi", category: "test"},
    {id: "beo_phi", name: "Béo phì", category: "risk_factor"},
    {id: "thua_can_truoc_khi_mang_thai", name: "Thừa cân trước khi mang thai", category: "risk_factor"},
    {id: "che_do_an_co_loi", name: "Chế độ ăn có lợi", category: "lifestyle"},
    {id: "duy_tri_luong_duong_trong_mau_o_gioi_han_an_toan", name: "Duy trì lượng đường trong máu ở giới hạn an toàn", category: "lifestyle"},
    {id: "tap_the_duc_nhieu_hon", name: "Tập thể dục nhiều hơn", category: "lifestyle"},
    {id: "thuoc_tieu_duong", name: "Thuốc tiểu đường", category: "drug"},
    {id: "tap_luyen_the_duc", name: "Tập luyện thể dục", category: "lifestyle"},
    {id: "duy_tri_can_nang_hop_ly", name: "Duy trì cân nặng hợp lý", category: "lifestyle"},
    {id: "kiem_soat_luong_duong_trong_mau", name: "Kiểm soát lượng đường trong máu", category: "lifestyle"}
  ] AS row
  MERGE (n:DiabetesConcept {id: row.id})
  SET n += row
  MERGE (source)-[:MENTIONS]->(n)
  RETURN count(*) AS concept_count
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong_thai_ky", b: "khat_nuoc_lien_tuc", fact_id: "7e8426a8cbbc", evidence: "Bệnh đái tháo đường thai kỳ hiếm khi biểu hiện triệu chứng rõ rệt. Bệnh chỉ được phát hiện trong những lần thăm khám định kỳ của thai phụ nếu có xuất hiện triệu chứng, bao gồm: tiểu nhiều lần trong ngày, mệt mỏi, mờ mắt, khát nước liên tục, ngủ ngáy, tăng cân quá nhanh so với khuyến nghị."},
    {a: "dai_thao_duong_thai_ky", b: "tieu_nhieu_lan_trong_ngay", fact_id: "5ffe98f3aae4", evidence: "Bệnh đái tháo đường thai kỳ hiếm khi biểu hiện triệu chứng rõ rệt. Bệnh chỉ được phát hiện trong những lần thăm khám định kỳ của thai phụ nếu có xuất hiện triệu chứng, bao gồm: tiểu nhiều lần trong ngày, mệt mỏi, mờ mắt, khát nước liên tục, ngủ ngáy, tăng cân quá nhanh so với khuyến nghị."},
    {a: "dai_thao_duong_thai_ky", b: "mo_mat", fact_id: "749880ff8d6a", evidence: "Bệnh đái tháo đường thai kỳ hiếm khi biểu hiện triệu chứng rõ rệt. Bệnh chỉ được phát hiện trong những lần thăm khám định kỳ của thai phụ nếu có xuất hiện triệu chứng, bao gồm: tiểu nhiều lần trong ngày, mệt mỏi, mờ mắt, khát nước liên tục, ngủ ngáy, tăng cân quá nhanh so với khuyến nghị."},
    {a: "dai_thao_duong_thai_ky", b: "ngu_ngay", fact_id: "d20786b13eeb", evidence: "Bệnh đái tháo đường thai kỳ hiếm khi biểu hiện triệu chứng rõ rệt. Bệnh chỉ được phát hiện trong những lần thăm khám định kỳ của thai phụ nếu có xuất hiện triệu chứng, bao gồm: tiểu nhiều lần trong ngày, mệt mỏi, mờ mắt, khát nước liên tục, ngủ ngáy, tăng cân quá nhanh so với khuyến nghị."},
    {a: "dai_thao_duong_thai_ky", b: "tang_can_qua_nhanh_so_voi_khuyen_nghi", fact_id: "f2dfe61280da", evidence: "Bệnh đái tháo đường thai kỳ hiếm khi biểu hiện triệu chứng rõ rệt. Bệnh chỉ được phát hiện trong những lần thăm khám định kỳ của thai phụ nếu có xuất hiện triệu chứng, bao gồm: tiểu nhiều lần trong ngày, mệt mỏi, mờ mắt, khát nước liên tục, ngủ ngáy, tăng cân quá nhanh so với khuyến nghị."},
    {a: "dai_thao_duong_thai_ky", b: "luong_duong_trong_mau_thap", fact_id: "d21eb438db4a", evidence: "Lượng đường trong máu thấp (hạ đường huyết): Đôi khi, em bé sinh ra từ mẹ bị tiểu đường khi mang thai sẽ đối diện với tình trạng lượng đường trong máu thấp ngay sau khi chào đời."}
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
    {a: "dai_thao_duong_thai_ky", b: "kiem_tra_luong_duong_trong_mau", fact_id: "6fb9a4cccfa4", evidence: "Bác sĩ Trần Đỗ Lan Phương cho biết, để chẩn đoán các bác sĩ sẽ tiến hành kiểm tra lượng đường trong máu của thai phụ."},
    {a: "dai_thao_duong_thai_ky", b: "lap_bieu_do_su_phat_trien_cua_thai_nhi", fact_id: "7fb3dd59dd1a", evidence: "Lập biểu đồ sự phát triển của thai nhi"}
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
    {a: "dai_thao_duong_thai_ky", b: "beo_phi", fact_id: "441eb892fdc1", evidence: "Nguy cơ mắc đái tháo đường trong lúc mang bầu sẽ tăng lên nếu thai phụ: - Bị thừa cân - béo phì trước khi mang thai."},
    {a: "dai_thao_duong_thai_ky", b: "thua_can_truoc_khi_mang_thai", fact_id: "c15db46c7b00", evidence: "Thừa cân trước khi mang thai làm tăng nguy cơ tiểu đường thai kỳ."}
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
    {a: "dai_thao_duong_thai_ky", b: "che_do_an_co_loi", fact_id: "2c324d05fca5", evidence: "Tuân thủ chế độ ăn có lợi cho người bệnh đái tháo đường"},
    {a: "dai_thao_duong_thai_ky", b: "duy_tri_luong_duong_trong_mau_o_gioi_han_an_toan", fact_id: "7ff7cd703de9", evidence: "Chế độ ăn này phải đáp ứng được hai yêu cầu: duy trì lượng đường trong máu ở giới hạn an toàn, nhưng vẫn cung cấp đủ calo và chất dinh dưỡng cho sự phát triển của thai nhi."},
    {a: "dai_thao_duong_thai_ky", b: "tap_the_duc_nhieu_hon", fact_id: "b5ab29808c57", evidence: "Tập thể dục nhiều hơn"},
    {a: "dai_thao_duong_thai_ky", b: "thuoc_tieu_duong", fact_id: "0cc430575f86", evidence: "Nếu lượng đường trong máu của các thai phụ vẫn cao dù đã thay đổi lối sống và chế độ ăn, bác sĩ sẽ được kê toa thuốc tiểu đường nhằm kiểm soát lượng đường trong máu và bảo vệ thai nhi. Tiêm insulin cũng là liệu pháp được cân nhắc sử dụng."},
    {a: "dai_thao_duong_thai_ky", b: "tap_luyen_the_duc", fact_id: "595eba7cc055", evidence: "Nếu sức khỏe của bạn và em bé đều ổn, bác sĩ có thể đề nghị bạn tập thể dục nhiều hơn. Điều này sẽ giúp cơ thể bạn sản xuất và sử dụng insulin hiệu quả hơn, từ đó kiểm soát tốt lượng đường trong máu."},
    {a: "dai_thao_duong_thai_ky", b: "duy_tri_can_nang_hop_ly", fact_id: "83be7c5bdee7", evidence: "Bên cạnh đó, bạn nên duy trì cân nặng hợp lý, tránh tăng cân quá mức trong thai kỳ bằng cách dung nạp lượng calo vừa đủ, từ 2.200 - 2.500/ngày nếu có cân nặng trung bình. Nếu bạn thừa cân, con số này sẽ giảm xuống khoảng 1.800 calo/ngày."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:TREATED_BY {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_4
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong_thai_ky", b: "kiem_soat_luong_duong_trong_mau", fact_id: "af144192c983", evidence: "Bác sĩ Trần Đỗ Lan Phương nhấn mạnh, những đối tượng được chẩn đoán đái tháo đường thai kỳ cần kiểm soát lượng đường trong máu của mình và duy trì ở mức an toàn."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:PREVENTED_BY {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_5
}
RETURN source.id AS source_id, concept_count,
       rel_count_1 + rel_count_2 + rel_count_3 + rel_count_4 + rel_count_5 AS fact_count;
