MERGE (source:DiabetesSource {id: "nhathuoclongchau_benh_tieu_duong"})
SET source += {id: "nhathuoclongchau_benh_tieu_duong", title: "Benh tieu duong", publisher: "Nhà thuốc Long Châu", url: "https://nhathuoclongchau.com.vn/benh/benh-tieu-duong-289.html", language: "vi", title_requires_review: true}
WITH source
CALL {
  WITH source
  UNWIND [
    {id: "dai_thao_duong", name: "Đái tháo đường", category: "disease"},
    {id: "buon_ngu", name: "Buồn ngủ", category: "symptom"},
    {id: "que_thu_thai_hcg", name: "Que thử thai hcg", category: "symptom"},
    {id: "may_do_huyet_ap_bap_tay_omron_ez_7183", name: "Máy đo huyết áp bắp tay omron ez 7183", category: "symptom"},
    {id: "kim_lay_mau_lancets_medicleen_bl_28", name: "Kim lấy máu Lancets Medicleen BL-28", category: "symptom"},
    {id: "nhiet_ke_dien_tu_fuji_dt007", name: "Nhiệt kế điện tử Fuji DT007", category: "symptom"},
    {id: "hau_qua", name: "Hậu quả", category: "symptom"},
    {id: "sut_can_nhieu", name: "Sụt cân nhiều", category: "symptom"},
    {id: "met_moi", name: "Mệt mỏi", category: "symptom"},
    {id: "thieu_nang_luong", name: "Thiếu năng lượng", category: "symptom"},
    {id: "de_bi_nhiem_khuan_ngoai_da", name: "Dễ bị nhiễm khuẩn ngoài da", category: "symptom"},
    {id: "lao_phoi", name: "Lao phổi", category: "symptom"},
    {id: "thoi_gian_lanh_vet_thuong_lau", name: "Thời gian lành vết thương lâu", category: "symptom"},
    {id: "nhiem_nam_men", name: "Nhiễm nấm men", category: "symptom"},
    {id: "khat_nuoc_hon_binh_thuong", name: "Khát nước hơn bình thường", category: "symptom"},
    {id: "di_tieu_thuong_xuyen_hon", name: "Đi tiểu thường xuyên hơn", category: "symptom"},
    {id: "benh_mach_vanh", name: "Bệnh mạch vành", category: "disease"},
    {id: "benh_mach_mau_nao", name: "Bệnh mạch máu não", category: "disease"},
    {id: "benh_mach_mau_ngoai_vi", name: "Bệnh mạch máu ngoại vi", category: "disease"},
    {id: "benh_ly_ban_chan", name: "Bệnh lý bàn chân", category: "disease"},
    {id: "benh_ly_vong_mac", name: "Bệnh lý võng mạc", category: "disease"},
    {id: "duc_thuy_tinh_the", name: "Đục thuỷ tinh thể", category: "disease"},
    {id: "glaucom", name: "Glaucom", category: "disease"},
    {id: "ton_thuong_cau_than", name: "Tổn thương cầu thận", category: "disease"},
    {id: "bien_chung_than_kinh_ngoai_vi", name: "Biến chứng thần kinh ngoại vi", category: "disease"},
    {id: "thay_doi_che_do_an_uong", name: "Thay đổi chế độ ăn uống", category: "lifestyle"},
    {id: "tap_luyen_the_duc", name: "Tập luyện thể dục", category: "lifestyle"},
    {id: "bo_hut_thuoc", name: "Bỏ hút thuốc", category: "lifestyle"},
    {id: "tranh_uong_ruou_bia", name: "Tránh uống rượu bia", category: "lifestyle"},
    {id: "nghiem_phap_dung_nap_glucose_duong_uong", name: "Nghiệm pháp dung nạp glucose đường uống", category: "test"},
    {id: "dinh_luong_glucose_huyet_tuong_ngau_nhien", name: "Định lượng glucose huyết tương ngẫu nhiên", category: "test"},
    {id: "dinh_luong_hba1c", name: "Định lượng HbA1c", category: "test"},
    {id: "duong_huyet_bat_ky", name: "Đường huyết bất kỳ", category: "test"},
    {id: "repaglinide", name: "Repaglinide", category: "drug"},
    {id: "sulfonylureas", name: "Sulfonylureas", category: "drug"},
    {id: "nateglinide", name: "Nateglinide", category: "drug"},
    {id: "metformin", name: "Metformin", category: "drug"},
    {id: "troglitazone", name: "Troglitazone", category: "drug"},
    {id: "rosiglitazone", name: "Rosiglitazone", category: "drug"},
    {id: "alogliptin", name: "Alogliptin", category: "drug"},
    {id: "linagliptin", name: "Linagliptin", category: "drug"},
    {id: "saxagliptin", name: "Saxagliptin", category: "drug"},
    {id: "sitagliptin", name: "Sitagliptin", category: "drug"},
    {id: "canagliflozin", name: "Canagliflozin", category: "drug"},
    {id: "dapagliflozin", name: "Dapagliflozin", category: "drug"},
    {id: "empagliflozin", name: "Empagliflozin", category: "drug"},
    {id: "liraglutide", name: "Liraglutide", category: "drug"},
    {id: "dulaglutide", name: "Dulaglutide", category: "drug"},
    {id: "albiglutide", name: "Albiglutide", category: "drug"},
    {id: "pramlintide", name: "Pramlintide", category: "drug"},
    {id: "tham_kham_dinh_ky", name: "Thăm khám định kỳ", category: "test"},
    {id: "tang_cuong_van_dong", name: "Tăng cường vận động", category: "lifestyle"},
    {id: "che_do_an_uong", name: "Chế độ ăn uống", category: "lifestyle"},
    {id: "loi_song_tich_cuc", name: "Lối sống tích cực", category: "lifestyle"},
    {id: "tam_ly_lac_quan", name: "Tâm lý lạc quan", category: "lifestyle"},
    {id: "che_do_an_it_chat_beo_bao_hoa_va_cholesterol", name: "Chế độ ăn ít chất béo bão hòa và cholesterol", category: "lifestyle"},
    {id: "tang_huyet_ap", name: "Tăng huyết áp", category: "disease"},
    {id: "dai_thao_duong_tuyp_1", name: "Đái tháo đường tuýp 1", category: "disease"},
    {id: "benh_tuy_ngoai_tiet", name: "Bệnh tuỵ ngoại tiết", category: "disease"},
    {id: "benh_to_cuc", name: "Bệnh to cực", category: "disease"},
    {id: "hoi_chung_cushing", name: "Hội chứng Cushing", category: "disease"},
    {id: "nhiem_sieu_vi_gay_ton_thuong_tuyen_tuy", name: "Nhiễm siêu vi gây tổn thương tuyến tuỵ", category: "disease"},
    {id: "roi_loan_lipid_mau", name: "Rối loạn lipid máu", category: "side_effect"},
    {id: "beo_phi", name: "Béo phì", category: "risk_factor"},
    {id: "thua_can", name: "Thừa cân", category: "risk_factor"},
    {id: "it_van_dong", name: "Ít vận động", category: "risk_factor"},
    {id: "hoi_chung_buong_trung_da_nang", name: "Hội chứng buồng trứng đa nang", category: "risk_factor"},
    {id: "hut_thuoc_la", name: "Hút thuốc lá", category: "risk_factor"},
    {id: "do_tuoi_mac_benh", name: "Độ tuổi mắc bệnh", category: "risk_factor"},
    {id: "co_che_tu_mien", name: "Cơ chế tự miễn", category: "risk_factor"},
    {id: "tien_su_ban_than_tung_bi_tieu_duong_thai_ky", name: "Tiền sử bản thân từng bị tiểu đường thai kỳ", category: "risk_factor"},
    {id: "tien_su_benh_tim_mach_do_xo_vua_dong_mach", name: "Tiền sử bệnh tim mạch do xơ vữa động mạch", category: "risk_factor"},
    {id: "it_hoat_dong_the_chat", name: "Ít hoạt động thể chất", category: "risk_factor"},
    {id: "thua_can_beo_phi", name: "Thừa cân, béo phì", category: "risk_factor"},
    {id: "bi_roi_loan_dung_nap_duong_hay_roi_loan_duong_huyet_doi", name: "Bị rối loạn dung nạp đường hay rối loạn đường huyết đói", category: "risk_factor"},
    {id: "phu_nu_bi_hoi_chung_buong_trung_da_nang", name: "Phụ nữ bị hội chứng buồng trứng đa nang", category: "risk_factor"},
    {id: "tien_su_gia_dinh_co_nguoi_mac_benh_tieu_duong", name: "Tiền sử gia đình có người mắc bệnh tiểu đường", category: "risk_factor"},
    {id: "roi_loan_dung_nap_glucose", name: "Rối loạn dung nạp glucose", category: "risk_factor"},
    {id: "tuoi_45", name: "Tuổi ≥ 45", category: "risk_factor"},
    {id: "thua_can_hoac_beo_phi", name: "Thừa cân hoặc béo phì", category: "risk_factor"},
    {id: "loi_song_it_van_dong", name: "Lối sống ít vận động", category: "risk_factor"},
    {id: "tien_su_co_suy_giam_dieu_hoa_glucose", name: "Tiền sử có suy giảm điều hòa glucose", category: "risk_factor"},
    {id: "tien_su_tang_huyet_ap_benh_tim_mach", name: "Tiền sử tăng huyết áp, bệnh tim mạch", category: "risk_factor"},
    {id: "yeu_to_lam_tang_nguy_co_mac_benh_tieu_duong", name: "Yếu tố làm tăng nguy cơ mắc bệnh tiểu đường", category: "risk_factor"},
    {id: "dai_thao_duong_tuyp_2", name: "Đái tháo đường tuýp 2", category: "disease"},
    {id: "suy_giam_chuc_nang_cua_te_bao_beta_tuyen_tuy", name: "Suy giảm chức năng của tế bào beta tuyến tụy", category: "risk_factor"},
    {id: "nguoi_tren_40_tuoi", name: "Người trên 40 tuổi", category: "risk_factor"},
    {id: "90_95_tong_so_cac_truong_hop_mac_benh", name: "90 – 95% tổng số các trường hợp mắc bệnh", category: "risk_factor"},
    {id: "khong_co_dau_hieu_ro_rang", name: "Không có dấu hiệu rõ ràng", category: "risk_factor"},
    {id: "tien_dai_thao_duong", name: "Tiền đái tháo đường", category: "disease"},
    {id: "hba1c", name: "HbA1c", category: "disease"},
    {id: "tieu_duong_phu_thuoc_insulin", name: "Tiểu đường phụ thuộc insulin", category: "symptom"},
    {id: "te_bao_beta_cua_tuyen_tuy_bi_pha_huy", name: "Tế bào beta của tuyến tụy bị phá hủy", category: "risk_factor"},
    {id: "nguoi_tre", name: "Người trẻ", category: "risk_factor"},
    {id: "dai_thao_duong_thai_ky", name: "Đái tháo đường thai kỳ", category: "disease"},
    {id: "phu_nu_mang_thai_tuan_thu_24_tro_len", name: "Phụ nữ mang thai tuần thứ 24 trở lên", category: "risk_factor"}
  ] AS row
  MERGE (n:DiabetesConcept {id: row.id})
  SET n += row
  MERGE (source)-[:MENTIONS]->(n)
  RETURN count(*) AS concept_count
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong", b: "buon_ngu", fact_id: "15d974229050", evidence: "bệnh nhân bị tiểu đường tuýp 1 thường có biểu hiện mệt mỏi, buồn ngủ do glucose không vào được tế bào, cơ thể thiếu năng lượng"},
    {a: "dai_thao_duong", b: "que_thu_thai_hcg", fact_id: "00522aef6a0e", evidence: "Que thử thai hcg giúp xác định tuần tuổi thai kỳ"},
    {a: "dai_thao_duong", b: "may_do_huyet_ap_bap_tay_omron_ez_7183", fact_id: "426f6637b847", evidence: "Máy đo huyết áp bắp tay omron ez 7183 hỗ trợ đo huyết áp,nhịp tim"},
    {a: "dai_thao_duong", b: "kim_lay_mau_lancets_medicleen_bl_28", fact_id: "91c027074bbf", evidence: "Kim lấy máu Lancets Medicleen BL-28 (100 cái)"},
    {a: "dai_thao_duong", b: "nhiet_ke_dien_tu_fuji_dt007", fact_id: "8b9e53bd9168", evidence: "Nhiệt kế điện tử đo thân nhiệt Fuji DT007"},
    {a: "dai_thao_duong", b: "hau_qua", fact_id: "294da86b78c3", evidence: "Với các hậu quả và biến chứng phức tạp, thì đây là căn bệnh cần được quan tâm tìm hiểu để có các biện pháp phòng ngừa, nhận biết cũng như điều trị kịp thời."},
    {a: "dai_thao_duong", b: "sut_can_nhieu", fact_id: "78d7dbe6241e", evidence: "Triệu chứng đái tháo đường tuýp 1 lâm sàng thường được gọi là hội chứng 4 nhiều: Sụt cân nhiều."},
    {a: "dai_thao_duong", b: "met_moi", fact_id: "e005a7d06564", evidence: "bệnh nhân bị tiểu đường tuýp 1 thường có biểu hiện mệt mỏi, buồn ngủ do glucose không vào được tế bào, cơ thể thiếu năng lượng"},
    {a: "dai_thao_duong", b: "thieu_nang_luong", fact_id: "83672e699ed0", evidence: "bệnh nhân bị tiểu đường tuýp 1 thường có biểu hiện mệt mỏi, buồn ngủ do glucose không vào được tế bào, cơ thể thiếu năng lượng"},
    {a: "dai_thao_duong", b: "de_bi_nhiem_khuan_ngoai_da", fact_id: "a15894c59d65", evidence: "dễ bị nhiễm khuẩn ngoài da, lao phổi"},
    {a: "dai_thao_duong", b: "lao_phoi", fact_id: "a05d584d4439", evidence: "dễ bị nhiễm khuẩn ngoài da, lao phổi"},
    {a: "dai_thao_duong", b: "thoi_gian_lanh_vet_thuong_lau", fact_id: "0dfbf9ba3319", evidence: "Thời gian lành vết thương lâu: Lưu lượng máu của toàn cơ thể sẽ bị ảnh hưởng do lượng đường trong máu cao, hệ thần kinh sẽ bị tổn thương, khiến các vết thương khó lành hơn."},
    {a: "dai_thao_duong", b: "nhiem_nam_men", fact_id: "9d115d44f311", evidence: "Nhiễm nấm men : Bệnh nhân tiểu đường tuýp 2 có sức đề kháng yếu nên dễ nhiễm nấm hơn. Nồng độ glucose cao trong máu và nước tiểu sẽ dẫn đến sự phát triển quá mức của nấm ở bất kỳ nếp gấp ẩm của da, ở giữa ngón tay, ngón chân, vùng dưới ngực, thậm chí xung quanh hoặc trong cơ quan sinh dục."},
    {a: "dai_thao_duong", b: "khat_nuoc_hon_binh_thuong", fact_id: "76015d643b82", evidence: "Khát nước hơn bình thường, đi tiểu thường xuyên hơn."},
    {a: "dai_thao_duong", b: "di_tieu_thuong_xuyen_hon", fact_id: "a2d9cff19bb4", evidence: "Khát nước hơn bình thường, đi tiểu thường xuyên hơn."},
    {a: "dai_thao_duong_tuyp_1", b: "tieu_duong_phu_thuoc_insulin", fact_id: "53fa6ccc6451", evidence: "Đái tháo đường tuýp 1 còn gọi là tiểu đường phụ thuộc insulin."}
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
    {a: "dai_thao_duong", b: "benh_mach_vanh", fact_id: "359556592b5f", evidence: "Biến chứng mạn tính gồm: Biến chứng mạch máu lớn: Bệnh mạch vành , bệnh mạch máu não, bệnh mạch máu ngoại vi."},
    {a: "dai_thao_duong", b: "benh_mach_mau_nao", fact_id: "e0641dc25a09", evidence: "Biến chứng mạn tính gồm: Biến chứng mạch máu lớn: Bệnh mạch vành , bệnh mạch máu não, bệnh mạch máu ngoại vi."},
    {a: "dai_thao_duong", b: "benh_mach_mau_ngoai_vi", fact_id: "def56d714a4c", evidence: "Biến chứng mạn tính gồm: Biến chứng mạch máu lớn: Bệnh mạch vành , bệnh mạch máu não, bệnh mạch máu ngoại vi."},
    {a: "dai_thao_duong", b: "benh_ly_ban_chan", fact_id: "1d1f6dc604e5", evidence: "Bệnh lý bàn chân, biến chứng ở mắt như bệnh lý võng mạc, đục thuỷ tinh thể và glaucom;"},
    {a: "dai_thao_duong", b: "benh_ly_vong_mac", fact_id: "f1093b6ef96f", evidence: "Bệnh lý bàn chân, biến chứng ở mắt như bệnh lý võng mạc, đục thuỷ tinh thể và glaucom;"},
    {a: "dai_thao_duong", b: "duc_thuy_tinh_the", fact_id: "a2d12c23494f", evidence: "Bệnh lý bàn chân, biến chứng ở mắt như bệnh lý võng mạc, đục thuỷ tinh thể và glaucom;"},
    {a: "dai_thao_duong", b: "glaucom", fact_id: "8e61c9f68801", evidence: "Bệnh lý bàn chân, biến chứng ở mắt như bệnh lý võng mạc, đục thuỷ tinh thể và glaucom;"},
    {a: "dai_thao_duong", b: "ton_thuong_cau_than", fact_id: "3ddf1eb00c2d", evidence: "biến chứng ở thận gây tổn thương cầu thận, biến chứng thần kinh ngoại vi."},
    {a: "dai_thao_duong", b: "bien_chung_than_kinh_ngoai_vi", fact_id: "04269874db82", evidence: "biến chứng ở thận gây tổn thương cầu thận, biến chứng thần kinh ngoại vi."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:HAS_COMPLICATION {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_2
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong", b: "thay_doi_che_do_an_uong", fact_id: "2d09b1ea2efe", evidence: "Điều chỉnh chế độ ăn uống hợp lý."},
    {a: "dai_thao_duong", b: "tap_luyen_the_duc", fact_id: "4c20f74610cf", evidence: "Thường xuyên tập luyện thể dục nâng cao sức khoẻ, duy trì cân nặng hợp lý."},
    {a: "dai_thao_duong", b: "bo_hut_thuoc", fact_id: "c4ea7dabb122", evidence: "Bỏ thuốc lá, tránh uống nhiều rượu bia."},
    {a: "dai_thao_duong", b: "tranh_uong_ruou_bia", fact_id: "6160b6276066", evidence: "Bỏ thuốc lá, tránh uống nhiều rượu bia."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:PREVENTED_BY {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_3
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong", b: "nghiem_phap_dung_nap_glucose_duong_uong", fact_id: "12ae8cfbaf3b", evidence: "Định lượng sau khi đói từ 8-12 giờ (FPG) hoặc sau 2 giờ uống 75 g (người lớn) hoặc 1,75 g (trẻ em) dung dịch glucose đậm đặc (nghiệm pháp dung nạp glucose đường uống) là tốt nhất."},
    {a: "dai_thao_duong", b: "dinh_luong_glucose_huyet_tuong_ngau_nhien", fact_id: "0597c1525ec4", evidence: "Trong thực hành, đái tháo đường hoặc rối loạn glucose lúc đói thường được chẩn đoán bằng sử dụng định lượng glucose huyết tương ngẫu nhiên hoặc HbA1c."},
    {a: "dai_thao_duong", b: "dinh_luong_hba1c", fact_id: "0e8a2cc5e684", evidence: "Định lượng HbA1c phản ánh nồng độ glucose trong 3 tháng trước. Định lượng HbA1c hiện được đưa vào tiêu chuẩn chẩn đoán đái tháo đường:"},
    {a: "dai_thao_duong", b: "duong_huyet_bat_ky", fact_id: "f406b2fb9d10", op: ">=", value: 200, unit: "mg/dl", evidence: "Đường huyết bất kỳ ≥ 200 mg/dL (11,1 mmol/L) kết hợp với các triệu chứng tăng đường huyết."},
    {a: "tien_dai_thao_duong", b: "hba1c", fact_id: "dccbee87ff19", op: "range", value: 5.7, value_max: 6.4, unit: "%", evidence: "HbA1c 5,7 đến 6,4%:"}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:DIAGNOSED_BY {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_4
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong", b: "repaglinide", fact_id: "a11890db1686", evidence: "Các thuốc kích thích tiết insulin tác dụng ngắn như (repaglinide, nateglinide) kích thích tiết insulin tương tự như sulfonylureas."},
    {a: "dai_thao_duong", b: "sulfonylureas", fact_id: "7e602608401e", evidence: "Các thuốc hạ đường huyết đường uống bao gồm: Sulfonylureas là thuốc kích thích tụy tiết insulin. Các thuốc này làm hạ glucose máu bằng cách kích thích tế bào beta của tụy tiết insulin và tăng nhạy cảm insulin với các mô ngoại vi và tại gan."},
    {a: "dai_thao_duong", b: "nateglinide", fact_id: "9cb27ae9f47f", evidence: "Các thuốc kích thích tiết insulin tác dụng ngắn như (repaglinide, nateglinide) kích thích tiết insulin tương tự như sulfonylureas."},
    {a: "dai_thao_duong", b: "metformin", fact_id: "27955056ce20", evidence: "Biguanides (metformin) làm giảm lượng glucose trong huyết tương bằng cách giảm sản xuất glucose ở gan (tạo gluconeogenesis và glycogenolysis)."},
    {a: "dai_thao_duong", b: "troglitazone", fact_id: "19817ecdb71f", evidence: "Thiazolidinediones (TZDs) (bao gồm troglitazone, rosiglitazone, pioglitazone) làm giảm đề kháng insulin ở mô ngoại vi (chất nhạy cảm với insulin), nhưng đi kèm với nhiều tác dụng phụ nguy hiểm."},
    {a: "dai_thao_duong", b: "rosiglitazone", fact_id: "0ca11f1774db", evidence: "Thiazolidinediones (TZDs) (bao gồm troglitazone, rosiglitazone, pioglitazone) làm giảm đề kháng insulin ở mô ngoại vi (chất nhạy cảm với insulin), nhưng đi kèm với nhiều tác dụng phụ nguy hiểm."},
    {a: "dai_thao_duong", b: "alogliptin", fact_id: "dcd8da678c1a", evidence: "Chất ức chế dipeptidyl peptidase-4 (ví dụ, alogliptin, linagliptin , saxagliptin, sitagliptin)."},
    {a: "dai_thao_duong", b: "linagliptin", fact_id: "4d6182674207", evidence: "Chất ức chế dipeptidyl peptidase-4 (ví dụ, alogliptin, linagliptin , saxagliptin, sitagliptin)."},
    {a: "dai_thao_duong", b: "saxagliptin", fact_id: "5da65eb92876", evidence: "Chất ức chế dipeptidyl peptidase-4 (ví dụ, alogliptin, linagliptin , saxagliptin, sitagliptin)."},
    {a: "dai_thao_duong", b: "sitagliptin", fact_id: "9c3cb8fc50df", evidence: "Chất ức chế dipeptidyl peptidase-4 (ví dụ, alogliptin, linagliptin , saxagliptin, sitagliptin)."},
    {a: "dai_thao_duong", b: "canagliflozin", fact_id: "8e89f2823e9d", evidence: "Thuốc ức chế SGLT2 như canagliflozin, dapagliflozin, empagliflozin ức chế SGLT2 ở phần gần ống thận, nó ức chế tái hấp thu glucose bởi vậy nó gây ra glucose niệu và làm giảm glucose máu."},
    {a: "dai_thao_duong", b: "dapagliflozin", fact_id: "66da45b1a532", evidence: "Thuốc ức chế SGLT2 như canagliflozin, dapagliflozin, empagliflozin ức chế SGLT2 ở phần gần ống thận, nó ức chế tái hấp thu glucose bởi vậy nó gây ra glucose niệu và làm giảm glucose máu."},
    {a: "dai_thao_duong", b: "empagliflozin", fact_id: "eacb2d1b4d4f", evidence: "Thuốc ức chế SGLT2 như canagliflozin, dapagliflozin, empagliflozin ức chế SGLT2 ở phần gần ống thận, nó ức chế tái hấp thu glucose bởi vậy nó gây ra glucose niệu và làm giảm glucose máu."},
    {a: "dai_thao_duong", b: "liraglutide", fact_id: "605190bdf03b", evidence: "Liraglutide, dulaglutide, albiglutide, làm tiết insulin phụ thuộc glucose và chậm làm trống dạ dày."},
    {a: "dai_thao_duong", b: "dulaglutide", fact_id: "d7300e976d40", evidence: "Liraglutide, dulaglutide, albiglutide, làm tiết insulin phụ thuộc glucose và chậm làm trống dạ dày."},
    {a: "dai_thao_duong", b: "albiglutide", fact_id: "dd32b5bbf26a", evidence: "Liraglutide, dulaglutide, albiglutide, làm tiết insulin phụ thuộc glucose và chậm làm trống dạ dày."},
    {a: "dai_thao_duong", b: "pramlintide", fact_id: "ad20ed4952c5", evidence: "Pramlintide tương tự amylin là một hormon do tế bào beta tụy tiết ra, giúp làm giảm nồng độ glucose sau ăn."},
    {a: "dai_thao_duong", b: "tham_kham_dinh_ky", fact_id: "9e27335c9500", evidence: "Thăm khám định kỳ để được theo dõi tình trạng sức khỏe, diễn tiến của bệnh và để bác sĩ tìm hướng điều trị phù hợp trong thời gian tiếp theo nếu bệnh chưa có dấu hiệu thuyên giảm."},
    {a: "dai_thao_duong", b: "tang_cuong_van_dong", fact_id: "44a35399d118", evidence: "Vận động thể lực: Giúp cải thiện tình trạng kháng insulin, kiểm soát đường huyết và giảm nguy cơ mắc các bệnh tim mạch, bằng cách giảm hoặc duy trì cân nặng, vận động 30 - 45 phút mỗi ngày x 3 - 5 ngày/tuần hoặc 150 phút/tuần với cường độ tập trung bình."},
    {a: "dai_thao_duong", b: "che_do_an_uong", fact_id: "9b7328dc64a3", evidence: "Chế độ ăn – dinh dưỡng: Xây dựng chế độ dinh dưỡng phù hợp với mức độ thừa cân, nhu cầu, thói quen, phác đồ điều trị,… của từng bệnh nhân, thông thường gồm 45 - 65% carbohydrate, 25 - 35% chất béo (chất béo bão hoà < 7%) và 10 - 35% protein."},
    {a: "dai_thao_duong", b: "loi_song_tich_cuc", fact_id: "b01ef908de10", evidence: "Duy trì lối sống tích cực, hạn chế sự căng thẳng."},
    {a: "dai_thao_duong", b: "tam_ly_lac_quan", fact_id: "5452e26c7faf", evidence: "Bệnh nhân tiểu đường cần lạc quan. Tâm lý có ảnh hưởng rất lớn đến điều trị, hãy nói chuyện với những người đáng tin cậy, chia sẻ với những thành viên trong gia đình, nuôi thú cưng hay đơn giản là đọc sách, làm bất cứ thứ gì khiến bạn thấy thoải mái."},
    {a: "dai_thao_duong", b: "che_do_an_it_chat_beo_bao_hoa_va_cholesterol", fact_id: "11d11b3fb7be", evidence: "Chế độ ăn ít chất béo bão hòa và cholesterol và lượng carbohydrate trung bình, tốt nhất là từ các nguồn ngũ cốc nguyên hạt có hàm lượng chất xơ cao hơn."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:TREATED_BY {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_5
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong", b: "tang_huyet_ap", fact_id: "01c32b100378", evidence: "Tăng huyết áp."},
    {a: "dai_thao_duong", b: "dai_thao_duong_tuyp_1", fact_id: "a78fd202d73d", evidence: "Trong số các trường hợp bị đái tháo đường tuýp 1 thì đến 95% là do cơ chế tự miễn (type 1A) và 5% không xác định được nguyên nhân (type 1B)."},
    {a: "dai_thao_duong", b: "benh_tuy_ngoai_tiet", fact_id: "3d75f5e42f25", evidence: "Ngoài ra, còn có đái tháo đường thai kỳ do rối loạn dung nạp glucose thường gặp trong 3 tháng cuối thai kỳ ở 3-5% phụ nữ có thai và các dạng đái tháo đường thứ cấp gồm đái tháo đường của người trẻ khởi phát ở độ tuổi trưởng thành (MODY), bệnh tuỵ ngoại tiết; bệnh to cực, hội chứng Cushing; nhiễm siêu vi gây tổn thương tuyến tuỵ."},
    {a: "dai_thao_duong", b: "benh_to_cuc", fact_id: "ae765f5221b4", evidence: "Ngoài ra, còn có đái tháo đường thai kỳ do rối loạn dung nạp glucose thường gặp trong 3 tháng cuối thai kỳ ở 3-5% phụ nữ có thai và các dạng đái tháo đường thứ cấp gồm đái tháo đường của người trẻ khởi phát ở độ tuổi trưởng thành (MODY), bệnh tuỵ ngoại tiết; bệnh to cực, hội chứng Cushing; nhiễm siêu vi gây tổn thương tuyến tuỵ."},
    {a: "dai_thao_duong", b: "hoi_chung_cushing", fact_id: "64ce18b2112a", evidence: "Ngoài ra, còn có đái tháo đường thai kỳ do rối loạn dung nạp glucose thường gặp trong 3 tháng cuối thai kỳ ở 3-5% phụ nữ có thai và các dạng đái tháo đường thứ cấp gồm đái tháo đường của người trẻ khởi phát ở độ tuổi trưởng thành (MODY), bệnh tuỵ ngoại tiết; bệnh to cực, hội chứng Cushing; nhiễm siêu vi gây tổn thương tuyến tuỵ."},
    {a: "dai_thao_duong", b: "nhiem_sieu_vi_gay_ton_thuong_tuyen_tuy", fact_id: "fec7a8230f71", evidence: "Ngoài ra, còn có đái tháo đường thai kỳ do rối loạn dung nạp glucose thường gặp trong 3 tháng cuối thai kỳ ở 3-5% phụ nữ có thai và các dạng đái tháo đường thứ cấp gồm đái tháo đường của người trẻ khởi phát ở độ tuổi trưởng thành (MODY), bệnh tuỵ ngoại tiết; bệnh to cực, hội chứng Cushing; nhiễm siêu vi gây tổn thương tuyến tuỵ."},
    {a: "dai_thao_duong", b: "roi_loan_lipid_mau", fact_id: "0f06da8f48ca", evidence: "Rối loạn lipid máu;"},
    {a: "dai_thao_duong", b: "beo_phi", fact_id: "23784eb06bd4", evidence: "Béo phì, ít vận động;"},
    {a: "dai_thao_duong", b: "thua_can", fact_id: "9681c55619ac", evidence: "Phụ nữ mang thai bị thừa cân, có tiền sử gia đình mắc bệnh tiểu đường hoặc đã được chẩn đoán bị rối loạn dung nạp glucose đều có nguy cơ cao bị đái tháo đường thai kỳ."},
    {a: "dai_thao_duong", b: "it_van_dong", fact_id: "fe7d3d4ee1fe", evidence: "Béo phì, ít vận động;"},
    {a: "dai_thao_duong", b: "hoi_chung_buong_trung_da_nang", fact_id: "6fee317852a5", evidence: "Hội chứng buồng trứng đa nang;"},
    {a: "dai_thao_duong", b: "hut_thuoc_la", fact_id: "137ad019ffcd", evidence: "Hút thuốc lá;"},
    {a: "dai_thao_duong", b: "do_tuoi_mac_benh", fact_id: "1f16e67624b6", evidence: "Đái tháo đường là căn bệnh ngày càng phổ biến và đang trẻ hoá dần về độ tuổi mắc bệnh"},
    {a: "dai_thao_duong", b: "co_che_tu_mien", fact_id: "64580b3cf6ec", evidence: "Trong số các trường hợp bị đái tháo đường tuýp 1 thì đến 95% là do cơ chế tự miễn (type 1A) và 5% không xác định được nguyên nhân (type 1B)."},
    {a: "dai_thao_duong", b: "tien_su_ban_than_tung_bi_tieu_duong_thai_ky", fact_id: "6e9c2ca71285", evidence: "Tiền sử bản thân từng bị tiểu đường thai kỳ."},
    {a: "dai_thao_duong", b: "tien_su_benh_tim_mach_do_xo_vua_dong_mach", fact_id: "77d4b0830852", evidence: "Tiền sử bệnh tim mạch do xơ vữa động mạch."},
    {a: "dai_thao_duong", b: "it_hoat_dong_the_chat", fact_id: "92522e738d15", evidence: "Ít hoạt động thể lực."},
    {a: "dai_thao_duong", b: "thua_can_beo_phi", fact_id: "e8d892e4c11c", evidence: "Thừa cân, béo phì."},
    {a: "dai_thao_duong", b: "bi_roi_loan_dung_nap_duong_hay_roi_loan_duong_huyet_doi", fact_id: "112ebc31cd19", evidence: "Bị rối loạn dung nạp đường hay rối loạn đường huyết đói."},
    {a: "dai_thao_duong", b: "phu_nu_bi_hoi_chung_buong_trung_da_nang", fact_id: "0fb5de5525cc", evidence: "Phụ nữ bị hội chứng buồng trứng đa nang."},
    {a: "dai_thao_duong", b: "tien_su_gia_dinh_co_nguoi_mac_benh_tieu_duong", fact_id: "1d684a4941db", evidence: "Phụ nữ mang thai bị thừa cân, có tiền sử gia đình mắc bệnh tiểu đường hoặc đã được chẩn đoán bị rối loạn dung nạp glucose đều có nguy cơ cao bị đái tháo đường thai kỳ."},
    {a: "dai_thao_duong", b: "roi_loan_dung_nap_glucose", fact_id: "2ea12ea9ca35", evidence: "Phụ nữ mang thai bị thừa cân, có tiền sử gia đình mắc bệnh tiểu đường hoặc đã được chẩn đoán bị rối loạn dung nạp glucose đều có nguy cơ cao bị đái tháo đường thai kỳ."},
    {a: "dai_thao_duong", b: "tuoi_45", fact_id: "d6e6aa20de64", evidence: "Tuổi ≥ 45;"},
    {a: "dai_thao_duong", b: "thua_can_hoac_beo_phi", fact_id: "00dec4f80ff7", evidence: "Thừa cân hoặc béo phì ;"},
    {a: "dai_thao_duong", b: "loi_song_it_van_dong", fact_id: "e2ebb841e5b6", evidence: "Lối sống ít vận động;"},
    {a: "dai_thao_duong", b: "tien_su_co_suy_giam_dieu_hoa_glucose", fact_id: "c863f1b9ef0a", evidence: "Tiền sử có suy giảm điều hòa glucose;"},
    {a: "dai_thao_duong", b: "tien_su_tang_huyet_ap_benh_tim_mach", fact_id: "37cd966b3900", evidence: "Tiền sử tăng huyết áp, bệnh tim mạch ;"},
    {a: "dai_thao_duong", b: "yeu_to_lam_tang_nguy_co_mac_benh_tieu_duong", fact_id: "8629ec72a596", evidence: "Yếu tố làm tăng nguy cơ mắc bệnh tiểu đường (Đái tháo đường)."},
    {a: "dai_thao_duong_tuyp_2", b: "suy_giam_chuc_nang_cua_te_bao_beta_tuyen_tuy", fact_id: "565b3eb0df75", evidence: "Người bệnh đái tháo đường tuýp 2 mặc dù cơ thể vẫn có khả năng sản xuất insulin, nhưng insulin không thể chuyển hóa (điều hòa) được lượng đường trong máu, do suy giảm chức năng của tế bào beta tuyến tụy tiến triển trên nền tảng đề kháng insulin."},
    {a: "dai_thao_duong_tuyp_2", b: "nguoi_tren_40_tuoi", fact_id: "8653234ebe4a", evidence: "Đa phần bệnh thường gặp ở những người trên 40 tuổi nhưng hiện nay đang có xu hướng dần trẻ hóa."},
    {a: "dai_thao_duong_tuyp_2", b: "90_95_tong_so_cac_truong_hop_mac_benh", fact_id: "a3bde4293015", evidence: "Số bệnh nhân tiểu đường tuýp 2 chiếm đến 90 – 95% tổng số các trường hợp mắc bệnh."},
    {a: "dai_thao_duong_tuyp_2", b: "khong_co_dau_hieu_ro_rang", fact_id: "42b644b298dc", evidence: "Do bệnh không có dấu hiệu rõ ràng nên khó có thể phát hiện được bệnh ở giai đoạn sớm."},
    {a: "dai_thao_duong_tuyp_1", b: "te_bao_beta_cua_tuyen_tuy_bi_pha_huy", fact_id: "78835996eb5e", evidence: "Nguyên nhân là do tế bào beta của tuyến tụy bị phá hủy gây giảm tiết insulin hoặc không tiết ra insulin dẫn đến việc thiếu hụt nghiêm trọng insulin trong máu, dẫn đến lượng đường trong máu không được điều hòa gây nhiều nguy hiểm cho sức khỏe."},
    {a: "dai_thao_duong_tuyp_1", b: "nguoi_tre", fact_id: "b25016777fb5", evidence: "Thông thường, đái tháo đường tuýp 1 hiếm gặp hơn tuýp 2 và thường xảy ra ở người trẻ."},
    {a: "dai_thao_duong_thai_ky", b: "phu_nu_mang_thai_tuan_thu_24_tro_len", fact_id: "c543da42dc62", evidence: "Bệnh đái tháo đường thai kỳ là tình trạng kháng insulin xảy ra trong quá trình mang thai, thường xuất hiện ở phụ nữ mang thai tuần thứ 24 trở lên."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:HAS_RISK_FACTOR {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_6
}
RETURN source.id AS source_id, concept_count,
       rel_count_1 + rel_count_2 + rel_count_3 + rel_count_4 + rel_count_5 + rel_count_6 AS fact_count;
