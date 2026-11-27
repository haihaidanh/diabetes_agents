MERGE (source:DiabetesSource {id: "nhathuoclongchau_tieu_duong_tuyp_2"})
SET source += {id: "nhathuoclongchau_tieu_duong_tuyp_2", title: "Tieu duong tuyp 2", publisher: "Nhà thuốc Long Châu", url: "https://nhathuoclongchau.com.vn/benh/tieu-duong-tuyp-2.html", language: "vi", title_requires_review: true}
WITH source
CALL {
  WITH source
  UNWIND [
    {id: "dai_thao_duong_tuyp_2", name: "Đái tháo đường tuýp 2", category: "disease"},
    {id: "may_do_huyet_ap", name: "Máy đo huyết áp", category: "symptom"},
    {id: "bien_chung_ve_than_kinh", name: "Biến chứng về thần kinh", category: "symptom"},
    {id: "bien_chung_ve_mach_mau", name: "Biến chứng về mạch máu", category: "symptom"},
    {id: "bien_chung_ve_mat", name: "Biến chứng về mắt", category: "symptom"},
    {id: "bien_chung_ve_than", name: "Biến chứng về thận", category: "symptom"},
    {id: "an_nhieu", name: "Ăn nhiều", category: "symptom"},
    {id: "uong_nhieu", name: "Uống nhiều", category: "symptom"},
    {id: "gay_nhieu", name: "Gầy nhiều", category: "symptom"},
    {id: "te_hai_ban_tay_hay_hai_ban_chan", name: "Tê hai bàn tay hay hai bàn chân", category: "symptom"},
    {id: "nhin_mo", name: "Nhìn mờ", category: "symptom"},
    {id: "di_tieu_nhieu", name: "Đi tiểu nhiều", category: "side_effect"},
    {id: "benh_dong_mach_ngoai_bien", name: "Bệnh động mạch ngoại biên", category: "disease"},
    {id: "benh_ly_vong_mac", name: "Bệnh lý võng mạc", category: "disease"},
    {id: "benh_ly_than_kinh", name: "Bệnh lý thần kinh", category: "disease"},
    {id: "dau_that_nguc_va_nhoi_mau_co_tim", name: "Đau thắt ngực và nhồi máu cơ tim", category: "disease"},
    {id: "thieu_mau_nao_thoang_qua_va_dot_quy", name: "Thiếu máu não thoáng qua và đột quỵ", category: "disease"},
    {id: "duong_huyet_luc_doi", name: "Đường huyết lúc đói", category: "test"},
    {id: "bac_si", name: "Bác sĩ", category: "test"},
    {id: "duong_huyet_sau_dung_nap_75g_duong", name: "Đường huyết sau dung nạp 75g đường", category: "test"},
    {id: "duong_huyet_bat_ky", name: "Đường huyết bất kỳ", category: "test"},
    {id: "metformin", name: "Metformin", category: "drug"},
    {id: "tzd", name: "TZD", category: "drug"},
    {id: "sglt2", name: "SGLT2", category: "drug"},
    {id: "dpp_4i", name: "DPP-4i", category: "drug"},
    {id: "uc_che_glp_1", name: "Ức chế GLP-1", category: "drug"},
    {id: "tuan_thu_cac_huong_dan_cua_bac_si", name: "Tuân thủ các hướng dẫn của bác sĩ", category: "lifestyle"},
    {id: "duy_tri_loi_song_tich_cuc", name: "Duy trì lối sống tích cực", category: "lifestyle"},
    {id: "tai_kham_thuong_xuyen", name: "Tái khám thường xuyên", category: "lifestyle"},
    {id: "tai_kham_ngay_khi_co_the_co_nhung_bat_thuong", name: "Tái khám ngay khi cơ thể có những bất thường", category: "lifestyle"},
    {id: "kiem_soat_can_nang", name: "Kiểm soát cân nặng", category: "lifestyle"},
    {id: "khong_hut_thuoc", name: "Không hút thuốc", category: "lifestyle"},
    {id: "bo_hut_thuoc", name: "Bỏ hút thuốc", category: "lifestyle"},
    {id: "tang_cuong_hoat_dong_the_chat", name: "Tăng cường hoạt động thể chất", category: "lifestyle"},
    {id: "van_dong", name: "Vận động", category: "lifestyle"},
    {id: "an_chat_beo_khong_bao_hoa", name: "Ăn chất béo không bão hòa", category: "lifestyle"},
    {id: "an_rau_xanh_va_hat", name: "Ăn rau xanh và hạt", category: "lifestyle"},
    {id: "uong_ruou_bia_gioi_han", name: "Uống rượu/bia giới hạn", category: "lifestyle"},
    {id: "han_che_ruou_bia", name: "Hạn chế rượu/bia", category: "lifestyle"},
    {id: "tang_huyet_ap", name: "Tăng huyết áp", category: "disease"},
    {id: "roi_loan_lipid_mau", name: "Rối loạn lipid máu", category: "side_effect"},
    {id: "hoi_chung_buong_trung_da_nang", name: "Hội chứng buồng trứng đa nang", category: "risk_factor"},
    {id: "thua_can_hoac_beo_phi", name: "Thừa cân hoặc béo phì", category: "risk_factor"},
    {id: "loi_song_it_van_dong", name: "Lối sống ít vận động", category: "risk_factor"},
    {id: "sinh_hoat", name: "Sinh hoạt", category: "risk_factor"},
    {id: "yeu_to_gen", name: "Yếu tố gen", category: "risk_factor"},
    {id: "tren_35_tuoi", name: "Trên 35 tuổi", category: "risk_factor"},
    {id: "tien_su_gia_dinh_co_nguoi_mac_benh", name: "Tiền sử gia đình có người mắc bệnh", category: "risk_factor"},
    {id: "tien_su_tien_dai_thao_duong", name: "Tiền sử tiền đái tháo đường", category: "risk_factor"},
    {id: "dai_thao_duong_thai_ky_hoac_can_nang_tre_sau_sinh_4_1kg", name: "Đái tháo đường thai kỳ hoặc cân nặng trẻ sau sinh >4.1kg", category: "risk_factor"},
    {id: "benh_gan_nhiem_mo", name: "Bệnh gan nhiễm mỡ", category: "risk_factor"},
    {id: "che_do_an_uong", name: "Chế độ ăn uống", category: "lifestyle"},
    {id: "tang_glucose_mau", name: "Tăng glucose máu", category: "disease"}
  ] AS row
  MERGE (n:DiabetesConcept {id: row.id})
  SET n += row
  MERGE (source)-[:MENTIONS]->(n)
  RETURN count(*) AS concept_count
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong_tuyp_2", b: "may_do_huyet_ap", fact_id: "42574175fc48", evidence: "Thiết bị y tế Theo dõi sức khoẻ Sơ cứu, giảm đau tại chỗ Bảo hộ - Phòng ngừa Hỗ trợ hô hấp, tai mũi họng Chăm sóc mắt Phục hồi & Giảm đau cơ khớp Vận động - Chỉnh hình Dụng cụ tiêm & Lấy mẫu Chăm sóc tiêu hoá tại nhà Dụng cụ y tế Máy đo huyết áp Máy, que thử đường huyết Nhiệt kế Que thử thai, rụng trứng Kit xét nghiệm nhanh Máy đo SpO2 Bán chạy nhất Xem tất cả -15% Que thử thai hcg giúp xác định tuần tuổi thai kỳ Accufast (1 kít) 80.750đ / Hộp 95.000đ Máy đo huyết áp bắp tay omron ez 7183 hỗ trợ đo huyết áp,nhịp tim 1.090.000đ / Hộp -15% Máy đo huyết áp bắp tay Omron Ez BT Large Hem 7183T1-L (vòng bít lớn) hỗ trợ đo huyết áp,nhịp tim 1.147.500đ / Hộp 1.350.000đ Kim lấy máu Lancets Medicleen BL-28 (100 cái) 32.000đ / Hộp Nhiệt kế điện tử đo thân nhiệt Fuji DT007 69.000đ / Hộp"},
    {a: "dai_thao_duong_tuyp_2", b: "bien_chung_ve_than_kinh", fact_id: "6d867d01ba28", evidence: "Bệnh có nhiều biến chứng nghiêm trọng về thần kinh, mạch máu, mắt hay thận."},
    {a: "dai_thao_duong_tuyp_2", b: "bien_chung_ve_mach_mau", fact_id: "ae477cdf374e", evidence: "Bệnh có nhiều biến chứng nghiêm trọng về thần kinh, mạch máu, mắt hay thận."},
    {a: "dai_thao_duong_tuyp_2", b: "bien_chung_ve_mat", fact_id: "c9008e08a694", evidence: "Bệnh có nhiều biến chứng nghiêm trọng về thần kinh, mạch máu, mắt hay thận."},
    {a: "dai_thao_duong_tuyp_2", b: "bien_chung_ve_than", fact_id: "d39181d09153", evidence: "Bệnh có nhiều biến chứng nghiêm trọng về thần kinh, mạch máu, mắt hay thận."},
    {a: "dai_thao_duong_tuyp_2", b: "an_nhieu", fact_id: "4034c2785a85", evidence: "Bốn triệu chứng điển hình của tăng đường huyết là: Ăn nhiều, uống nhiều, tiểu nhiều, gầy nhiều."},
    {a: "dai_thao_duong_tuyp_2", b: "uong_nhieu", fact_id: "fd272b817931", evidence: "Bốn triệu chứng điển hình của tăng đường huyết là: Ăn nhiều, uống nhiều, tiểu nhiều, gầy nhiều."},
    {a: "dai_thao_duong_tuyp_2", b: "gay_nhieu", fact_id: "f6e6bbbc3f42", evidence: "Bốn triệu chứng điển hình của tăng đường huyết là: Ăn nhiều, uống nhiều, tiểu nhiều, gầy nhiều."},
    {a: "dai_thao_duong_tuyp_2", b: "te_hai_ban_tay_hay_hai_ban_chan", fact_id: "31d9c3a7daf4", evidence: "nhưng đa phần các bệnh nhân tiểu đường type 2 không có các triệu chứng trên mà lại có các triệu chứng muộn của các biến chứng như: Tê hai bàn tay hay hai bàn chân, nhìn mờ,..."},
    {a: "dai_thao_duong_tuyp_2", b: "nhin_mo", fact_id: "310fd2ea17b1", evidence: "nhưng đa phần các bệnh nhân tiểu đường type 2 không có các triệu chứng trên mà lại có các triệu chứng muộn của các biến chứng như: Tê hai bàn tay hay hai bàn chân, nhìn mờ,..."},
    {a: "dai_thao_duong_tuyp_2", b: "di_tieu_nhieu", fact_id: "f2217b9e22ff", evidence: "Bốn triệu chứng điển hình của tăng đường huyết là: Ăn nhiều, uống nhiều, tiểu nhiều, gầy nhiều."}
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
    {a: "dai_thao_duong_tuyp_2", b: "benh_dong_mach_ngoai_bien", fact_id: "31ae382c0fab", evidence: "Các biến chứng mạn tính như: Bệnh võng mạc, bệnh thận, bệnh lý thần kinh, đau thắt ngực và nhồi máu cơ tim , thiếu máu não thoáng qua và đột quỵ, bệnh động mạch ngoại biên."},
    {a: "dai_thao_duong_tuyp_2", b: "benh_ly_vong_mac", fact_id: "7c593dce5228", evidence: "Các biến chứng mạn tính như: Bệnh võng mạc, bệnh thận, bệnh lý thần kinh, đau thắt ngực và nhồi máu cơ tim , thiếu máu não thoáng qua và đột quỵ, bệnh động mạch ngoại biên."},
    {a: "dai_thao_duong_tuyp_2", b: "benh_ly_than_kinh", fact_id: "0f6c801c1a97", evidence: "Các biến chứng mạn tính như: Bệnh võng mạc, bệnh thận, bệnh lý thần kinh, đau thắt ngực và nhồi máu cơ tim , thiếu máu não thoáng qua và đột quỵ, bệnh động mạch ngoại biên."},
    {a: "dai_thao_duong_tuyp_2", b: "dau_that_nguc_va_nhoi_mau_co_tim", fact_id: "46a2503d9db7", evidence: "Các biến chứng mạn tinh như: Bệnh võng mạc, bệnh thận, bệnh lý thần kinh, đau thắt ngực và nhồi máu cơ tim , thiếu máu não thoáng qua và đột quỵ, bệnh động mạch ngoại biên."},
    {a: "dai_thao_duong_tuyp_2", b: "thieu_mau_nao_thoang_qua_va_dot_quy", fact_id: "bb009b5dec64", evidence: "Các biến chứng mạn tính như: Bệnh võng mạc, bệnh thận, bệnh lý thần kinh, đau thắt ngực và nhồi máu cơ tim , thiếu máu não thoáng qua và đột quỵ, bệnh động mạch ngoại biên."}
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
    {a: "dai_thao_duong_tuyp_2", b: "duong_huyet_luc_doi", fact_id: "fbe1eab4417a", evidence: "Đường huyết đói:"},
    {a: "dai_thao_duong_tuyp_2", b: "bac_si", fact_id: "8c53d5f32080", evidence: "Nếu có yếu tố nguy cơ mắc bệnh hay các triệu chứng nêu trên xảy ra, bạn nên liên hệ ngay với bác sĩ để được kiểm tra và tư vấn."},
    {a: "dai_thao_duong_tuyp_2", b: "duong_huyet_sau_dung_nap_75g_duong", fact_id: "b31c5d6e09a7", evidence: "Đường huyết sau dung nạp 75g đường được hiểu là chỉ số đường huyết tĩnh mạch đo được sau khi bệnh nhân uống 75g glucose 2 giờ."},
    {a: "dai_thao_duong_tuyp_2", b: "duong_huyet_bat_ky", fact_id: "3ce7168b4329", evidence: "Đường huyết bất kỳ được hiểu là chỉ số đường tĩnh mạch đo được ở bất kỳ thời điểm nào mà không cần quan tâm đến bữa ăn."}
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
    {a: "dai_thao_duong_tuyp_2", b: "metformin", fact_id: "283a7e3fe22d", evidence: "Metformin , SU, TZD, SGLT2, DPP-4i,..."},
    {a: "dai_thao_duong_tuyp_2", b: "tzd", fact_id: "3102a0c3f623", evidence: "Metformin , SU, TZD, SGLT2, DPP-4i,..."},
    {a: "dai_thao_duong_tuyp_2", b: "sglt2", fact_id: "47bb3250ecb9", evidence: "Metformin , SU, TZD, SGLT2, DPP-4i,..."},
    {a: "dai_thao_duong_tuyp_2", b: "dpp_4i", fact_id: "23dcd775c7a0", evidence: "Metformin , SU, TZD, SGLT2, DPP-4i,..."},
    {a: "dai_thao_duong_tuyp_2", b: "uc_che_glp_1", fact_id: "4962c7b9bfde", evidence: "Insulin, ức chế GLP-1."},
    {a: "dai_thao_duong_tuyp_2", b: "tuan_thu_cac_huong_dan_cua_bac_si", fact_id: "11bbd5de54e4", evidence: "Tuân thủ các hướng dẫn của bác sĩ trong quá trình điều trị."},
    {a: "dai_thao_duong_tuyp_2", b: "duy_tri_loi_song_tich_cuc", fact_id: "2dbbbfad16b3", evidence: "Duy trì lối sống tích cực, hạn chế sự căng thẳng, tăng cường các hoạt động thể lực."},
    {a: "dai_thao_duong_tuyp_2", b: "tai_kham_thuong_xuyen", fact_id: "115da859ec81", evidence: "Tái khám thường xuyên để theo dõi diễn tiến bệnh."},
    {a: "dai_thao_duong_tuyp_2", b: "tai_kham_ngay_khi_co_the_co_nhung_bat_thuong", fact_id: "efa90fea849d", evidence: "Tái khám ngay khi cơ thể có những bất thường."}
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
    {a: "dai_thao_duong_tuyp_2", b: "kiem_soat_can_nang", fact_id: "c08146a5d202", evidence: "Kiểm soát cân nặng"},
    {a: "dai_thao_duong_tuyp_2", b: "khong_hut_thuoc", fact_id: "d5e9721f0f5e", evidence: "Không hút thuốc"},
    {a: "dai_thao_duong_tuyp_2", b: "bo_hut_thuoc", fact_id: "3e04756a728d", evidence: "Hút thuốc lá làm tăng nguy cơ mắc đái tháo đường trên 50% so với người không hút thuốc. Vì thế, nên bỏ hút thuốc hoặc không hút lá chủ động và thụ động giúp giảm đáng kể nguy cơ mắc đái tháo đường."},
    {a: "dai_thao_duong_tuyp_2", b: "tang_cuong_hoat_dong_the_chat", fact_id: "f72b963fb47e", evidence: "Tăng cường hoạt động thể lực"},
    {a: "dai_thao_duong_tuyp_2", b: "van_dong", fact_id: "749f2f4ddfda", evidence: "Mục tiêu vận động: Tăng dần các bài tập có mức tiêu thụ năng lượng từ trung bình đến cao như: Đi bộ nhanh, bơi lội, đạp xe,... nên tập luyện ít nhất 30 phút mỗi ngày hoặc ít nhất 150 phút mỗi tuần. Duy trì các bài tập có cường độ mạnh mang tính đối kháng như đá bánh, chạy bộ,… ít nhất 2 đến 3 lần/tuần, giúp tăng sức mạnh, khả năng giữ thăng bằng và duy trì một cuộc sống năng động."},
    {a: "dai_thao_duong_tuyp_2", b: "an_chat_beo_khong_bao_hoa", fact_id: "5fe26914d0f3", evidence: "Ăn chất béo tốt Tiểu đường type 2 nên ăn gì ? Chế độ ăn uống nên bao gồm nhiều loại thực phẩm có chất béo không bão hòa và hạn chế tối đa các chất béo không bão hòa giúp giảm cholesterol xấu trong máu và giảm nguy cơ mắc các bệnh lý về tim mạch."},
    {a: "dai_thao_duong_tuyp_2", b: "an_rau_xanh_va_hat", fact_id: "1344d75288cf", evidence: "Rau xanh và các loại hạt là những thực phẩm chứa ít đường, ít tinh bột và nhiều chất xơ, vitamin, khoáng chất,... giúp ngừa bệnh tiểu đường."},
    {a: "dai_thao_duong_tuyp_2", b: "uong_ruou_bia_gioi_han", fact_id: "56cd2cc208f3", evidence: "Uống rượu hay bia trong giới hạn cho phép"},
    {a: "dai_thao_duong_tuyp_2", b: "han_che_ruou_bia", fact_id: "aa8d03617277", evidence: "Lượng cồn vừa phải ở nữ giới là khoảng 1 đơn vị mỗi ngày đối với nữ và tối đa 2 đơn vị mỗi ngày đối với nam. Trong đó một đơn vị cồn tương đương 1 lon bia 330ml."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:PREVENTED_BY {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_5
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong_tuyp_2", b: "tang_huyet_ap", fact_id: "92a07868227c", evidence: "Tăng huyết áp;"},
    {a: "dai_thao_duong_tuyp_2", b: "roi_loan_lipid_mau", fact_id: "83ae3e39291e", evidence: "Rối loạn lipid máu ;"},
    {a: "dai_thao_duong_tuyp_2", b: "hoi_chung_buong_trung_da_nang", fact_id: "683906f5b934", evidence: "Hội chứng buồng trứng đa nang;"},
    {a: "dai_thao_duong_tuyp_2", b: "thua_can_hoac_beo_phi", fact_id: "1d5a418ebf8a", evidence: "Thừa cân hoặc béo phì;"},
    {a: "dai_thao_duong_tuyp_2", b: "loi_song_it_van_dong", fact_id: "04939fd54114", evidence: "Lối sống ít vận động;"},
    {a: "dai_thao_duong_tuyp_2", b: "sinh_hoat", fact_id: "6b57e8f00183", evidence: "Nguyên nhân gây bệnh tiểu đường tuýp 2 chưa được xác minh rõ ràng, nhưng người ta cho rằng có sự tương tác giữa yếu tố gen và yếu tố môi trường như chế độ ăn uống, sinh hoạt,... góp phần hình thành nguyên nhân bệnh."},
    {a: "dai_thao_duong_tuyp_2", b: "yeu_to_gen", fact_id: "c67a99b9f93f", evidence: "Nguyên nhân gây bệnh tiểu đường tuýp 2 chưa được xác minh rõ ràng, nhưng người ta cho rằng có sự tương tác giữa yếu tố gen và yếu tố môi trường như chế độ ăn uống, sinh hoạt,... góp phần hình thành nguyên nhân bệnh."},
    {a: "dai_thao_duong_tuyp_2", b: "tren_35_tuoi", fact_id: "902b1c1654eb", evidence: "Sau 35 tuổi;"},
    {a: "dai_thao_duong_tuyp_2", b: "tien_su_gia_dinh_co_nguoi_mac_benh", fact_id: "0da0993f2360", evidence: "Tiền sử gia đình có người thân trực hệ mắc đái tháo đường type 2;"},
    {a: "dai_thao_duong_tuyp_2", b: "tien_su_tien_dai_thao_duong", fact_id: "ac2dddc25cd7", evidence: "Tiền sử tiền đái tháo đường;"},
    {a: "dai_thao_duong_tuyp_2", b: "dai_thao_duong_thai_ky_hoac_can_nang_tre_sau_sinh_4_1kg", fact_id: "831d73f95e19", evidence: "Đái tháo đường thai kì hoặc cân nặng trẻ sau sinh hơn 4,1 kg;"},
    {a: "dai_thao_duong_tuyp_2", b: "benh_gan_nhiem_mo", fact_id: "7b049e0959b2", evidence: "Bệnh gan nhiễm mỡ;"},
    {a: "dai_thao_duong_tuyp_2", b: "che_do_an_uong", fact_id: "ce100b14eb87", evidence: "Nguyên nhân gây bệnh tiểu đường tuýp 2 chưa được xác minh rõ ràng, nhưng người ta cho rằng có sự tương tác giữa yếu tố gen và yếu tố môi trường như chế độ ăn uống, sinh hoạt,... góp phần hình thành nguyên nhân bệnh."},
    {a: "tang_glucose_mau", b: "dai_thao_duong_tuyp_2", fact_id: "234ac535fe37", evidence: "Tiểu đường tuýp 2 (đái tháo đường type 2) là tình trạng bệnh xảy ra khi lượng glucose trong máu, còn gọi là đường huyết, cao quá mức."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:HAS_RISK_FACTOR {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_6
}
RETURN source.id AS source_id, concept_count,
       rel_count_1 + rel_count_2 + rel_count_3 + rel_count_4 + rel_count_5 + rel_count_6 AS fact_count;
