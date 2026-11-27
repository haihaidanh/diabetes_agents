MERGE (source:DiabetesSource {id: "nhathuoclongchau_bien_chung_ban_chan_dai_thao_duong_nguyen_nhan_do_dau"})
SET source += {id: "nhathuoclongchau_bien_chung_ban_chan_dai_thao_duong_nguyen_nhan_do_dau", title: "Bien chung ban chan dai thao duong nguyen nhan do dau", publisher: "Nhà thuốc Long Châu", url: "https://nhathuoclongchau.com.vn/bai-viet/bien-chung-ban-chan-dai-thao-duong-nguyen-nhan-do-dau.html", language: "vi", title_requires_review: true}
WITH source
CALL {
  WITH source
  UNWIND [
    {id: "dai_thao_duong", name: "Đái tháo đường", category: "disease"},
    {id: "bien_chung_ban_chan_dai_thao_duong", name: "Biến chứng bàn chân đái tháo đường", category: "disease"},
    {id: "ban_chan_dai_thao_duong", name: "Bàn chân đái tháo đường", category: "disease"},
    {id: "ban_chan_tieu_duong", name: "Bàn chân tiểu đường", category: "disease"},
    {id: "viec_su_dung_khang_sinh", name: "Việc sử dụng kháng sinh", category: "test"},
    {id: "thoi_quen_di_chan_tran", name: "Thói quen đi chân trần", category: "risk_factor"},
    {id: "kiem_soat_duong_huyet_va_cac_benh_nen", name: "Kiểm soát đường huyết và các bệnh nền", category: "lifestyle"},
    {id: "vet_loet_don_gian", name: "Vết loét đơn giản", category: "symptom"},
    {id: "nhiem_trung", name: "Nhiễm trùng", category: "risk_factor"},
    {id: "vet_tray_xuoc", name: "Vết trầy xước", category: "risk_factor"},
    {id: "mat_da", name: "Mất da", category: "risk_factor"},
    {id: "ton_thuong_mach_mau", name: "Tổn thương mạch máu", category: "risk_factor"},
    {id: "giam_luu_thong_mau", name: "Giảm lưu thông máu", category: "risk_factor"},
    {id: "ton_thuong_than_kinh", name: "Tổn thương thần kinh", category: "risk_factor"},
    {id: "roi_loan_cam_giac", name: "Rối loạn cảm giác", category: "risk_factor"},
    {id: "loet_ban_chan_dai_thao_duong", name: "Loét bàn chân đái tháo đường", category: "disease"},
    {id: "bien_chung_ve_mach_mau_va_than_kinh", name: "Biến chứng về mạch máu và thần kinh", category: "risk_factor"},
    {id: "kiem_soat_duong_huyet_va_cac_yeu_to_xo_vua_mach_mau", name: "Kiểm soát đường huyết và các yếu tố xơ vữa mạch máu", category: "risk_factor"},
    {id: "khong_cham_soc_ve_sinh_ban_chan_dung_cach", name: "Không chăm sóc vệ sinh bàn chân đúng cách", category: "risk_factor"},
    {id: "thoi_quen_hut_thuoc_la", name: "Thói quen hút thuốc lá", category: "risk_factor"}
  ] AS row
  MERGE (n:DiabetesConcept {id: row.id})
  SET n += row
  MERGE (source)-[:MENTIONS]->(n)
  RETURN count(*) AS concept_count
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong", b: "bien_chung_ban_chan_dai_thao_duong", fact_id: "bc0ee05cd4bb", evidence: "Biến chứng bàn chân đái tháo đường là một vấn đề nghiêm trọng mà những người mắc bệnh đái tháo đường phải đối mặt."},
    {a: "dai_thao_duong", b: "ban_chan_dai_thao_duong", fact_id: "97ce244b5fd5", evidence: "Bàn chân đái tháo đường là một biến chứng phức tạp của bệnh đái tháo đường, mang đến những vấn đề nghiêm trọng và ảnh hưởng đáng kể đến chất lượng cuộc sống, sinh hoạt và thậm chí tính mạng của những người bị mắc bệnh."},
    {a: "dai_thao_duong", b: "ban_chan_tieu_duong", fact_id: "6f7c1c05280f", evidence: "Bàn chân tiểu đường là một biến chứng phức tạp của bệnh đái tháo đường, vì vậy việc phòng ngừa rất quan trọng để tránh tình trạng này."}
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
    {a: "bien_chung_ban_chan_dai_thao_duong", b: "viec_su_dung_khang_sinh", fact_id: "5cbc6230a54a", evidence: "Việc sử dụng kháng sinh thường được căn cứ vào yếu tố dịch tễ tại từng địa phương và đơn vị."}
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
    {a: "bien_chung_ban_chan_dai_thao_duong", b: "thoi_quen_di_chan_tran", fact_id: "29f6a8db6b1f", evidence: "Thói quen đi chân trần cũng ảnh hưởng đến tình trạng bàn chân đái tháo đường"},
    {a: "ban_chan_dai_thao_duong", b: "nhiem_trung", fact_id: "03f28a22bf12", evidence: "Những yếu tố như vết trầy xước, mất da và nhiễm trùng cũng đóng vai trò quan trọng trong sự phát triển của biến chứng này."},
    {a: "ban_chan_dai_thao_duong", b: "vet_tray_xuoc", fact_id: "c33f129c3668", evidence: "Những yếu tố như vết trầy xước, mất da và nhiễm trùng cũng đóng vai trò quan trọng trong sự phát triển của biến chứng này."},
    {a: "ban_chan_dai_thao_duong", b: "mat_da", fact_id: "19f7709e442e", evidence: "Những yếu tố như vết trầy xước, mất da và nhiễm trùng cũng đóng vai trò quan trọng trong sự phát triển của biến chứng này."},
    {a: "ban_chan_dai_thao_duong", b: "ton_thuong_mach_mau", fact_id: "4bc60afdb0ae", evidence: "Các yếu tố như tổn thương mạch máu, giảm lưu thông máu và tổn thương thần kinh với các rối loạn cảm giác cũng góp phần làm cho người bệnh khó chịu, đôi khi không thể chịu đựng được và làm giảm chất lượng cuộc sống."},
    {a: "ban_chan_dai_thao_duong", b: "giam_luu_thong_mau", fact_id: "622f829b36c2", evidence: "Các yếu tố như tổn thương mạch máu, giảm lưu thông máu và tổn thương thần kinh với các rối loạn cảm giác cũng góp phần làm cho người bệnh khó chịu, đôi khi không thể chịu đựng được và làm giảm chất lượng cuộc sống."},
    {a: "ban_chan_dai_thao_duong", b: "ton_thuong_than_kinh", fact_id: "1ad906a74741", evidence: "Các yếu tố như tổn thương mạch máu, giảm lưu thông máu và tổn thương thần kinh với các rối loạn cảm giác cũng góp phần làm cho người bệnh khó chịu, đôi khi không thể chịu đựng được và làm giảm chất lượng cuộc sống."},
    {a: "ban_chan_dai_thao_duong", b: "roi_loan_cam_giac", fact_id: "00df36d2e8a1", evidence: "Các yếu tố như tổn thương mạch máu, giảm lưu thông máu và tổn thương thần kinh với các rối loạn cảm giác cũng góp phần làm cho người bệnh khó chịu, đôi khi không thể chịu đựng được và làm giảm chất lượng cuộc sống."},
    {a: "loet_ban_chan_dai_thao_duong", b: "bien_chung_ve_mach_mau_va_than_kinh", fact_id: "b5d016727430", evidence: "Loét bàn chân đái tháo đường thường xuất hiện ở nhóm người đái tháo đường có các biến chứng về mạch máu và thần kinh"},
    {a: "loet_ban_chan_dai_thao_duong", b: "kiem_soat_duong_huyet_va_cac_yeu_to_xo_vua_mach_mau", fact_id: "632a852e0575", evidence: "Những biến chứng này thường liên quan đến việc kiểm soát đường huyết và các yếu tố xơ vữa mạch máu trong thời gian dài"},
    {a: "loet_ban_chan_dai_thao_duong", b: "khong_cham_soc_ve_sinh_ban_chan_dung_cach", fact_id: "961b4f983971", evidence: "Có một số yếu tố thuận lợi có thể góp phần gây tổn thương cho bàn chân đái tháo đường, bao gồm: Không chăm sóc vệ sinh bàn chân đúng cách"},
    {a: "loet_ban_chan_dai_thao_duong", b: "thoi_quen_hut_thuoc_la", fact_id: "f7bfd09357bc", evidence: "Các yếu tố cũng có ảnh hưởng đến vết thương, tình trạng loét và nhiễm trùng ở bệnh nhân đái tháo đường, bao gồm: Thói quen hút thuốc lá"}
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
    {a: "bien_chung_ban_chan_dai_thao_duong", b: "kiem_soat_duong_huyet_va_cac_benh_nen", fact_id: "b78d93169d56", evidence: "Việc kiểm soát đường huyết và các bệnh nền của người bệnh đái tháo đường là vô cùng cần thiết và phải được thực hiện một cách tích cực và kịp thời."}
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
    {a: "ban_chan_dai_thao_duong", b: "vet_loet_don_gian", fact_id: "e9e818e08c0f", evidence: "Biến chứng này ban đầu được mô tả bởi sự xuất hiện các vết loét đơn giản, nhiễm trùng và khó lành, gây ra hệ quả lớn."},
    {a: "ban_chan_dai_thao_duong", b: "nhiem_trung", fact_id: "b4e07d6165a1", evidence: "Biến chứng này ban đầu được mô tả bởi sự xuất hiện các vết loét đơn giản, nhiễm trùng và khó lành, gây ra hệ quả lớn."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:HAS_SYMPTOM {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_5
}
RETURN source.id AS source_id, concept_count,
       rel_count_1 + rel_count_2 + rel_count_3 + rel_count_4 + rel_count_5 AS fact_count;
