MERGE (source:DiabetesSource {id: "nhathuoclongchau_ha_duong_huyet"})
SET source += {id: "nhathuoclongchau_ha_duong_huyet", title: "Ha duong huyet", publisher: "Nhà thuốc Long Châu", url: "https://nhathuoclongchau.com.vn/benh/ha-duong-huyet-294.html", language: "vi", title_requires_review: true}
WITH source
CALL {
  WITH source
  UNWIND [
    {id: "ha_duong_huyet", name: "Hạ đường huyết", category: "disease"},
    {id: "met", name: "Mệt", category: "symptom"},
    {id: "dau_dau", name: "Đau đầu", category: "symptom"},
    {id: "chong_mat", name: "Chóng mặt", category: "symptom"},
    {id: "xiu", name: "Xỉu", category: "symptom"},
    {id: "va_mo_hoi", name: "Vã mồ hôi", category: "symptom"},
    {id: "da_xanh", name: "Da xanh", category: "symptom"},
    {id: "hoi_hop", name: "Hồi hộp", category: "symptom"},
    {id: "trong_nguc", name: "Trống ngực", category: "symptom"},
    {id: "run_tay", name: "Run tay", category: "symptom"},
    {id: "cam_giac_lanh", name: "Cảm giác lạnh", category: "symptom"},
    {id: "tang_tiet_nuoc_bot", name: "Tăng tiết nước bọt", category: "symptom"},
    {id: "nhip_nhanh_tren_that", name: "Nhịp nhanh trên thất", category: "symptom"},
    {id: "nhip_nhanh_that", name: "Nhịp nhanh thất", category: "symptom"},
    {id: "tang_huyet_ap_tam_thu", name: "Tăng huyết áp tâm thu", category: "symptom"},
    {id: "dau_nguc", name: "Đau ngực", category: "symptom"},
    {id: "cam_giac_doi", name: "Cảm giác đói", category: "symptom"},
    {id: "dau_vung_thuong_vi", name: "Đau vùng thượng vị", category: "symptom"},
    {id: "di_ngoai", name: "Đi ngoài", category: "symptom"},
    {id: "co_giat", name: "Co giật", category: "symptom"},
    {id: "dong_kinh_khu_tru", name: "Động kinh khu trú", category: "symptom"},
    {id: "dong_kinh_toan_the", name: "Động kinh toàn thể", category: "symptom"},
    {id: "liet_1_2_nguoi", name: "Liệt ½ người", category: "symptom"},
    {id: "ton_thuong_than_kinh_so", name: "Tổn thương thần kinh sọ", category: "symptom"},
    {id: "roi_loan_cam_giac_van_dong", name: "Rối loạn cảm giác vận động", category: "symptom"},
    {id: "hoi_chung_tieu_nao", name: "Hội chứng tiểu não", category: "symptom"},
    {id: "nhin_doi", name: "Nhìn đôi", category: "symptom"},
    {id: "kich_dong", name: "Kích động", category: "symptom"},
    {id: "hung_du", name: "Hung dữ", category: "symptom"},
    {id: "noi_cuoi_vo_co", name: "Nói cười vô cớ", category: "symptom"},
    {id: "roi_loan_nhan_cach", name: "Rối loạn nhân cách", category: "symptom"},
    {id: "ao_giac", name: "Ảo giác", category: "symptom"},
    {id: "ao_khuu", name: "Ảo khứu", category: "symptom"},
    {id: "buon_non", name: "Buồn nôn", category: "side_effect"},
    {id: "non", name: "Nôn", category: "side_effect"},
    {id: "hon_me_ha_duong_huyet", name: "Hôn mê hạ đường huyết", category: "disease"},
    {id: "hon_me_yen_lang", name: "Hôn mê yên lặng", category: "disease"},
    {id: "tang_truong_luc_co_va_co_giat", name: "Tăng trương lực cơ và co giật", category: "disease"},
    {id: "xet_nghiem_mau", name: "Xét nghiệm máu", category: "test"},
    {id: "suy_than", name: "Suy thận", category: "disease"},
    {id: "suy_gan", name: "Suy gan", category: "disease"},
    {id: "insulinoma", name: "Insulinoma", category: "disease"},
    {id: "u_ngoai_tuy", name: "U ngoại tụy", category: "disease"},
    {id: "suy_tim", name: "Suy tim", category: "disease"},
    {id: "benh_tieu_duong", name: "Bệnh tiểu đường", category: "risk_factor"},
    {id: "khong_theo_chi_dinh_cua_bac_si", name: "Không theo chỉ định của bác sĩ", category: "risk_factor"},
    {id: "qua_lieu_insulin", name: "Quá liều insulin", category: "risk_factor"},
    {id: "hap_thu_insulin_qua_nhanh_hoac_qua_keo_dai", name: "Hấp thu insulin quá nhanh hoặc quá kéo dài", category: "risk_factor"},
    {id: "sai_lam_che_do_an", name: "Sai lầm chế độ ăn", category: "risk_factor"},
    {id: "hoat_dong_the_luc_khong_thuong_xuyen", name: "Hoạt động thể lực không thường xuyên", category: "risk_factor"},
    {id: "khong_giam_lieu_insulin_sau_nhiem_trung_phau_thuat", name: "Không giảm liều insulin sau nhiễm trùng, phẫu thuật", category: "risk_factor"},
    {id: "nham_lieu_thuoc_sulfonylurea", name: "Nhầm liều thuốc Sulfonylurea", category: "risk_factor"},
    {id: "sai_lam_che_va_an", name: "Sai lầm chế và ăn", category: "risk_factor"},
    {id: "ton_thuong_gan_nang", name: "Tổn thương gan nặng", category: "risk_factor"},
    {id: "suy_thuong_than", name: "Suy thượng thận", category: "risk_factor"},
    {id: "suy_thuy_truoc_tuyen_yen", name: "Suy thùy trước tuyến yên", category: "risk_factor"},
    {id: "suy_giap", name: "Suy giáp", category: "risk_factor"},
    {id: "nhiem_trung_nang", name: "Nhiễm trùng nặng", category: "risk_factor"},
    {id: "soc", name: "Sốc", category: "risk_factor"},
    {id: "ha_duong_huyet_do_than_kinh_thuc_vat", name: "Hạ đường huyết do thần kinh thực vật", category: "risk_factor"},
    {id: "an_qua_nhieu_glucid", name: "Ăn quá nhiều glucid", category: "risk_factor"},
    {id: "cat_da_day", name: "Cắt dạ dày", category: "risk_factor"},
    {id: "suy_tuyen_yen", name: "Suy tuyến yên", category: "risk_factor"},
    {id: "nghien_ruou", name: "Nghiện rượu", category: "risk_factor"},
    {id: "dieu_tri_tieu_duong", name: "Điều trị tiểu đường", category: "risk_factor"},
    {id: "vien_glucose", name: "Viên glucose", category: "drug"},
    {id: "glucagon", name: "Glucagon", category: "drug"},
    {id: "duong", name: "Đường", category: "risk_factor"},
    {id: "nuoc_trai_cay_ngot", name: "Nước trái cây ngọt", category: "lifestyle"},
    {id: "tap_the_duc_thuong_xuyen", name: "Tập thể dục thường xuyên", category: "lifestyle"},
    {id: "che_do_an_uong_dinh_duong_va_khoa_hoc", name: "Chế độ ăn uống dinh dưỡng và khoa học", category: "lifestyle"},
    {id: "can_than_khi_lai_xe", name: "Cẩn thận khi lái xe", category: "lifestyle"},
    {id: "chu_y_khi_bi_ha_duong_huyet_khi_ra_ngoai", name: "Chú ý khi bị hạ đường huyết khi ra ngoài", category: "lifestyle"}
  ] AS row
  MERGE (n:DiabetesConcept {id: row.id})
  SET n += row
  MERGE (source)-[:MENTIONS]->(n)
  RETURN count(*) AS concept_count
}
CALL {
  WITH source
  UNWIND [
    {a: "ha_duong_huyet", b: "met", fact_id: "76d5a78b2db4", evidence: "Dấu hiệu chung: Mệt xuất hiện đột ngột không giải thích được, đau đầu chóng mặt, xỉu."},
    {a: "ha_duong_huyet", b: "dau_dau", fact_id: "8d20a0219157", evidence: "Dấu hiệu chung: Mệt xuất hiện đột ngột không giải thích được, đau đầu chóng mặt, xỉu."},
    {a: "ha_duong_huyet", b: "chong_mat", fact_id: "0600de52f37d", evidence: "Mệt xuất hiện đột ngột không giải thích được, đau đầu chóng mặt, xỉu."},
    {a: "ha_duong_huyet", b: "xiu", fact_id: "0614896c9507", evidence: "Dấu hiệu chung: Mệt xuất hiện đột ngột không giải thích được, đau đầu chóng mặt, xỉu."},
    {a: "ha_duong_huyet", b: "va_mo_hoi", fact_id: "97e3555492f4", evidence: "Dấu hiệu thần kinh thực vật: Vã mồ hôi, da xanh, hồi hộp, trống ngực, run tay , cảm giác lạnh, tăng tiết nước bọt."},
    {a: "ha_duong_huyet", b: "da_xanh", fact_id: "c1eec89703e1", evidence: "Dấu hiệu thần kinh thực vật: Vã mồ hôi, da xanh, hồi hộp, trống ngực, run tay , cảm giác lạnh, tăng tiết nước bọt."},
    {a: "ha_duong_huyet", b: "hoi_hop", fact_id: "bbd5221c12f6", evidence: "Dấu hiệu thần kinh thực vật: Vã mồ hôi, da xanh, hồi hộp, trống ngực, run tay , cảm giác lạnh, tăng tiết nước bọt."},
    {a: "ha_duong_huyet", b: "trong_nguc", fact_id: "9405c05a1aaa", evidence: "Dấu hiệu thần kinh thực vật: Vã mồ hôi, da xanh, hồi hộp, trống ngực, run tay , cảm giác lạnh, tăng tiết nước bọt."},
    {a: "ha_duong_huyet", b: "run_tay", fact_id: "3aa78122cb46", evidence: "Dấu hiệu thần kinh thực vật: Vã mồ hôi, da xanh, hồi hộp, trống ngực, run tay , cảm giác lạnh, tăng tiết nước bọt."},
    {a: "ha_duong_huyet", b: "cam_giac_lanh", fact_id: "04fc577d590b", evidence: "Dấu hiệu thần kinh thực vật: Vã mồ hôi, da xanh, hồi hộp, trống ngực, run tay , cảm giác lạnh, tăng tiết nước bọt."},
    {a: "ha_duong_huyet", b: "tang_tiet_nuoc_bot", fact_id: "423a9e7c7489", evidence: "Dấu hiệu thần kinh thực vật: Vã mồ hôi, da xanh, hồi hộp, trống ngực, run tay , cảm giác lạnh, tăng tiết nước bọt."},
    {a: "ha_duong_huyet", b: "nhip_nhanh_tren_that", fact_id: "de76e158de0b", evidence: "Dấu hiệu tim mạch: Nhịp nhanh trên thất, có thể gặp nhịp nhanh thất, tăng huyết áp tâm thu, đau ngực (ít gặp)."},
    {a: "ha_duong_huyet", b: "nhip_nhanh_that", fact_id: "ae7cc231f000", evidence: "Dấu hiệu tim mạch: Nhịp nhanh trên thất, có thể gặp nhịp nhanh thất, tăng huyết áp tâm thu, đau ngực (ít gặp)."},
    {a: "ha_duong_huyet", b: "tang_huyet_ap_tam_thu", fact_id: "33a0c641ea63", evidence: "Dấu hiệu tim mạch: Nhịp nhanh trên thất, có thể gặp nhịp nhanh thất, tăng huyết áp tâm thu, đau ngực (ít gặp)."},
    {a: "ha_duong_huyet", b: "dau_nguc", fact_id: "3541bfc5eb28", evidence: "Dấu hiệu tim mạch: Nhịp nhanh trên thất, có thể gặp nhịp nhanh thất, tăng huyết áp tâm thu, đau ngực (ít gặp)."},
    {a: "ha_duong_huyet", b: "cam_giac_doi", fact_id: "425c26cf95a9", evidence: "Dấu hiệu tiêu hóa: Cảm giác đói, đau vùng thượng vị, buồn nôn, nôn, đi ngoài có thể gặp."},
    {a: "ha_duong_huyet", b: "dau_vung_thuong_vi", fact_id: "90c3a7bb1e2f", evidence: "Dấu hiệu tiêu hóa: Cảm giác đói, đau vùng thượng vị, buồn nôn, nôn, đi ngoài có thể gặp."},
    {a: "ha_duong_huyet", b: "di_ngoai", fact_id: "ab9df639bcc1", evidence: "Dấu hiệu tiêu hóa: Cảm giác đói, đau vùng thượng vị, buồn nôn, nôn, đi ngoài có thể gặp."},
    {a: "ha_duong_huyet", b: "co_giat", fact_id: "9bb6c4587530", evidence: "Dấu hiệu thần kinh: Co giật , kiểu động kinh khu trú hoặc toàn thể, dấu hiệu thần kinh khu trú: Liệt ½ người, tổn thương thần kinh sọ, rối loạn cảm giác vận động, hội chứng tiểu não (có thể gặp), nhìn đôi."},
    {a: "ha_duong_huyet", b: "dong_kinh_khu_tru", fact_id: "73ebd913d0cb", evidence: "Dấu hiệu thần kinh: Co giật , kiểu động kinh khu trú hoặc toàn thể, dấu hiệu thần kinh khu trú: Liệt ½ người, tổn thương thần kinh sọ, rối loạn cảm giác vận động, hội chứng tiểu não (có thể gặp), nhìn đôi."},
    {a: "ha_duong_huyet", b: "dong_kinh_toan_the", fact_id: "37b7c2da628e", evidence: "Dấu hiệu thần kinh: Co giật , kiểu động kinh khu trú hoặc toàn thể, dấu hiệu thần kinh khu trú: Liệt ½ người, tổn thương thần kinh sọ, rối loạn cảm giác vận động, hội chứng tiểu não (có thể gặp), nhìn đôi."},
    {a: "ha_duong_huyet", b: "liet_1_2_nguoi", fact_id: "c77e82e47f2c", evidence: "Dấu hiệu thần kinh: Co giật , kiểu động kinh khu trú hoặc toàn thể, dấu hiệu thần kinh khu trú: Liệt ½ người, tổn thương thần kinh sọ, rối loạn cảm giác vận động, hội chứng tiểu não (có thể gặp), nhìn đôi."},
    {a: "ha_duong_huyet", b: "ton_thuong_than_kinh_so", fact_id: "f2140520d377", evidence: "Dấu hiệu thần kinh: Co giật , kiểu động kinh khu trú hoặc toàn thể, dấu hiệu thần kinh khu trú: Liệt ½ người, tổn thương thần kinh sọ, rối loạn cảm giác vận động, hội chứng tiểu não (có thể gặp), nhìn đôi."},
    {a: "ha_duong_huyet", b: "roi_loan_cam_giac_van_dong", fact_id: "dcfe40199685", evidence: "Dấu hiệu thần kinh: Co giật , kiểu động kinh khu trú hoặc toàn thể, dấu hiệu thần kinh khu trú: Liệt ½ người, tổn thương thần kinh sọ, rối loạn cảm giác vận động, hội chứng tiểu não (có thể gặp), nhìn đôi."},
    {a: "ha_duong_huyet", b: "hoi_chung_tieu_nao", fact_id: "1ac0cadd05f9", evidence: "Dấu hiệu thần kinh: Co giật , kiểu động kinh khu trú hoặc toàn thể, dấu hiệu thần kinh khu trú: Liệt ½ người, tổn thương thần kinh sọ, rối loạn cảm giác vận động, hội chứng tiểu não (có thể gặp), nhìn đôi."},
    {a: "ha_duong_huyet", b: "nhin_doi", fact_id: "93b7852211a8", evidence: "Dấu hiệu thần kinh: Co giật , kiểu động kinh khu trú hoặc toàn thể, dấu hiệu thần kinh khu trú: Liệt ½ người, tổn thương thần kinh sọ, rối loạn cảm giác vận động, hội chứng tiểu não (có thể gặp), nhìn đôi."},
    {a: "ha_duong_huyet", b: "kich_dong", fact_id: "64ef20df5645", evidence: "Dấu hiệu tâm thần là biểu hiện nặng của giảm đường huyết: Kích động, hung dữ, nói cười vô cớ, rối loạn nhân cách, ảo giác, ảo khứu."},
    {a: "ha_duong_huyet", b: "hung_du", fact_id: "9ac062d79be4", evidence: "Dấu hiệu tâm thần là biểu hiện nặng của giảm đường huyết: Kích động, hung dữ, nói cười vô cớ, rối loạn nhân cách, ảo giác, ảo khứu."},
    {a: "ha_duong_huyet", b: "noi_cuoi_vo_co", fact_id: "79f56ca8cb58", evidence: "Dấu hiệu tâm thần là biểu hiện nặng của giảm đường huyết: Kích động, hung dữ, nói cười vô cớ, rối loạn nhân cách, ảo giác, ảo khứu."},
    {a: "ha_duong_huyet", b: "roi_loan_nhan_cach", fact_id: "03dfd6ba0d35", evidence: "Dấu hiệu tâm thần là biểu hiện nặng của giảm đường huyết: Kích động, hung dữ, nói cười vô cớ, rối loạn nhân cách, ảo giác, ảo khứu."},
    {a: "ha_duong_huyet", b: "ao_giac", fact_id: "fa0a680f4020", evidence: "Dấu hiệu tâm thần là biểu hiện nặng của giảm đường huyết: Kích động, hung dữ, nói cười vô cớ, rối loạn nhân cách, ảo giác, ảo khứu."},
    {a: "ha_duong_huyet", b: "ao_khuu", fact_id: "fb31ba319c96", evidence: "Dấu hiệu tâm thần là biểu hiện nặng của giảm đường huyết: Kích động, hung dữ, nói cười vô cớ, rối loạn nhân cách, ảo giác, ảo khứu."},
    {a: "ha_duong_huyet", b: "buon_non", fact_id: "124fae1a986c", evidence: "Dấu hiệu tiêu hóa: Cảm giác đói, đau vùng thượng vị, buồn nôn, nôn, đi ngoài có thể gặp."},
    {a: "ha_duong_huyet", b: "non", fact_id: "364e0e570013", evidence: "Dấu hiệu tiêu hóa: Cảm giác đói, đau vùng thượng vị, buồn nôn, nôn, đi ngoài có thể gặp."}
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
    {a: "ha_duong_huyet", b: "hon_me_ha_duong_huyet", fact_id: "2bac5789b4da", evidence: "Hôn mê hạ đường huyết là giai đoạn cuối của hạ đường huyết, xuất hiện ngay lập tức, đôi khi không có tiền triệu hoặc nối tiếp các triệu chứng có trước."},
    {a: "ha_duong_huyet", b: "hon_me_yen_lang", fact_id: "11d636beccf8", evidence: "Hôn mê yên lặng, hôn mê sâu có thể gặp hội chứng bó tháp một hoặc hai bên: Babinski (+), phản xạ gân xương nhanh nhạy, trong một số trường hợp có thể mất phản xạ gân xương."},
    {a: "ha_duong_huyet", b: "tang_truong_luc_co_va_co_giat", fact_id: "792a235e7cca", evidence: "Tăng trương lực cơ và co giật khu trú hoặc toàn thể có thể gặp."}
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
    {a: "ha_duong_huyet", b: "xet_nghiem_mau", fact_id: "2ffedf03ba6b", evidence: "Khi thấy các dấu hiệu trên, các bác sĩ sẽ tiến hành xét nghiệm máu , lượng đường trong máu ở mức <70mg/dl (< 3.9mmol/l) thì được xác định là hạ đường huyết."}
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
    {a: "ha_duong_huyet", b: "suy_than", fact_id: "a59bde5da266", evidence: "Suy thận , uống rượu."},
    {a: "ha_duong_huyet", b: "suy_gan", fact_id: "4eb5ba028da0", evidence: "Suy gan, suy thận."},
    {a: "ha_duong_huyet", b: "insulinoma", fact_id: "ba4a9239bd98", evidence: "Insulinoma (u tiết insulin)."},
    {a: "ha_duong_huyet", b: "u_ngoai_tuy", fact_id: "ba7c018bd882", evidence: "U ngoại tụy: Các khối u fibrosarcoma, neurofibroma ở ngực, bụng, sau phúc mạc. Hiếm gặp hơn: Leucemie, ung thư buồng trứng, gan, thận, phổi."},
    {a: "ha_duong_huyet", b: "suy_tim", fact_id: "67b9e619d049", evidence: "Nguyên nhân gặp trong hồi sức cấp cứu: Suy gan, suy thận, suy tim, nhiễm trùng nặng, sốc."},
    {a: "ha_duong_huyet", b: "benh_tieu_duong", fact_id: "55df83cf81ed", evidence: "Bệnh xảy ra khi người mắc bệnh tiểu đường không có đủ đường (glucose) trong máu."},
    {a: "ha_duong_huyet", b: "khong_theo_chi_dinh_cua_bac_si", fact_id: "59270807ec90", evidence: "Triệu chứng hạ đường huyết thường gặp ở người bệnh tiểu đường đang được điều trị bằng insulin hoặc các thuốc tiểu đường khác nhưng không theo chỉ định của bác sĩ."},
    {a: "ha_duong_huyet", b: "qua_lieu_insulin", fact_id: "2af063f043f4", evidence: "Quá liều insulin."},
    {a: "ha_duong_huyet", b: "hap_thu_insulin_qua_nhanh_hoac_qua_keo_dai", fact_id: "1bbc8eba93ef", evidence: "Hấp thu insulin quá nhanh hoặc quá kéo dài: Loạn dưỡng mỡ dưới da do tiêm những vùng hoạt động nhiều, chườm nóng sau tiêm insulin."},
    {a: "ha_duong_huyet", b: "sai_lam_che_do_an", fact_id: "545596118845", evidence: "Sai lầm chế độ ăn: Ăn quá muộn sau tiêm, ăn không đủ, bỏ bữa ăn, thiếu bữa ăn phụ."},
    {a: "ha_duong_huyet", b: "hoat_dong_the_luc_khong_thuong_xuyen", fact_id: "67ad3e37e905", evidence: "Hoạt động thể lực không thường xuyên."},
    {a: "ha_duong_huyet", b: "khong_giam_lieu_insulin_sau_nhiem_trung_phau_thuat", fact_id: "52f356bbf932", evidence: "Không giảm liều insulin (sau khi tăng tạm thời) sau nhiễm trùng, phẫu thuật."},
    {a: "ha_duong_huyet", b: "nham_lieu_thuoc_sulfonylurea", fact_id: "ee79ff368b37", evidence: "Nhầm liều thuốc Sulfonylurea, phối hợp thuốc gây hạ đường huyết."},
    {a: "ha_duong_huyet", b: "sai_lam_che_va_an", fact_id: "6ebd65298171", evidence: "Sai lầm chế độ ăn: Giảm thành phần glucid, hoạt động thể lực quá sức."},
    {a: "ha_duong_huyet", b: "ton_thuong_gan_nang", fact_id: "788138dd8ffc", evidence: "Nguyên nhân tại gan: Tổn thương gan nặng: Viêm gan virus, xơ gan, ung thư gan, viêm gan do nhiễm trùng."},
    {a: "ha_duong_huyet", b: "suy_thuong_than", fact_id: "95b8df5a7fa1", evidence: "Nguyên nhân nội tiết: Suy thượng thận, suy thùy trước tuyến yên, suy giáp."},
    {a: "ha_duong_huyet", b: "suy_thuy_truoc_tuyen_yen", fact_id: "e32f1fe4ef94", evidence: "Nguyên nhân nội tiết: Suy thượng thận, suy thùy trước tuyến yên, suy giáp."},
    {a: "ha_duong_huyet", b: "suy_giap", fact_id: "9889cbc736f2", evidence: "Nguyên nhân nội tiết: Suy thượng thận, suy thùy trước tuyến yên, suy giáp."},
    {a: "ha_duong_huyet", b: "nhiem_trung_nang", fact_id: "e1aef6d69201", evidence: "Nguyên nhân gặp trong hồi sức cấp cứu: Suy gan, suy thận, suy tim, nhiễm trùng nặng, sốc."},
    {a: "ha_duong_huyet", b: "soc", fact_id: "d25077514dd3", evidence: "Nguyên nhân gặp trong hồi sức cấp cứu: Suy gan, suy thận, suy tim, nhiễm trùng nặng, sốc."},
    {a: "ha_duong_huyet", b: "ha_duong_huyet_do_than_kinh_thuc_vat", fact_id: "d727e7758eeb", evidence: "Hạ đường huyết do thần kinh thực vật."},
    {a: "ha_duong_huyet", b: "an_qua_nhieu_glucid", fact_id: "e4398ac86ebd", evidence: "Hạ đường huyết do ăn quá nhiều glucid (đường đơn) gây tăng insulin quá nhiều sau ăn."},
    {a: "ha_duong_huyet", b: "cat_da_day", fact_id: "14565fdf8b7d", evidence: "Hạ đường huyết sau khi cắt dạ dày."},
    {a: "ha_duong_huyet", b: "suy_tuyen_yen", fact_id: "901a3012862f", evidence: "Các đối tượng sau đây có tỷ lệ mắc bệnh hạ đường huyết cao hơn những người bình thường: Tiền sử mắc các rối loạn nội tiết như suy tuyến thượng thận, suy tuyến yên ."},
    {a: "ha_duong_huyet", b: "nghien_ruou", fact_id: "c0d96e852bd5", evidence: "Người nghiện rượu, bia."},
    {a: "ha_duong_huyet", b: "dieu_tri_tieu_duong", fact_id: "dbd96be8ebcf", evidence: "Đang điều trị tiểu đường."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:HAS_RISK_FACTOR {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_4
}
CALL {
  WITH source
  UNWIND [
    {a: "ha_duong_huyet", b: "vien_glucose", fact_id: "f72a247c04aa", evidence: "Uống viên glucose."},
    {a: "ha_duong_huyet", b: "glucagon", fact_id: "9edff0efa006", evidence: "Nên biết cách tiêm hoặc hướng dẫn cách tiêm glucagon khi có người hạ đường huyết bất tỉnh."},
    {a: "ha_duong_huyet", b: "duong", fact_id: "c6e3788af24e", evidence: "Phương pháp điều trị khá đơn giản, đối với từng đợt hạ đường huyết như vậy bạn nên bổ sung đường ngay lập tức, bằng nhiều cách: Đơn giản nhất là ngậm kẹo."},
    {a: "ha_duong_huyet", b: "nuoc_trai_cay_ngot", fact_id: "465e959261af", evidence: "Uống nước trái cây ngọt."}
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
    {a: "ha_duong_huyet", b: "tap_the_duc_thuong_xuyen", fact_id: "87ee7c8ce58f", evidence: "Vận động thường xuyên để nâng cao sức khỏe nhưng nên có các bữa ăn nhẹ trước các buổi tập nếu thấy cần thiết."},
    {a: "ha_duong_huyet", b: "che_do_an_uong_dinh_duong_va_khoa_hoc", fact_id: "268b15e5f5d8", evidence: "Có chế độ ăn uống dinh dưỡng và khoa học."},
    {a: "ha_duong_huyet", b: "can_than_khi_lai_xe", fact_id: "9605b8cb495e", evidence: "Cẩn thận khi lái xe vì hạ đường huyết có thể gây nguy hiểm đến cơ thể tức thì."},
    {a: "ha_duong_huyet", b: "chu_y_khi_bi_ha_duong_huyet_khi_ra_ngoai", fact_id: "2bb20fa9c25a", evidence: "Ghi chú: Hạ đường huyết có thể gây biểu hiện rất nhanh và dễ dàng được điều trị bằng chất ngọt. Nhưng nếu không điều trị kịp thời, hạ đường huyết có thể dẫn đến choáng váng, ngất xỉu, hôn mê. Cần đặc biệt chú ý khi bản thân hoặc người thân bị hạ đường huyết khi ra ngoài."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:PREVENTED_BY {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_6
}
RETURN source.id AS source_id, concept_count,
       rel_count_1 + rel_count_2 + rel_count_3 + rel_count_4 + rel_count_5 + rel_count_6 AS fact_count;
