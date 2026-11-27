MERGE (source:DiabetesSource {id: "nhathuoclongchau_tang_huyet_ap"})
SET source += {id: "nhathuoclongchau_tang_huyet_ap", title: "Tang huyet ap", publisher: "Nhà thuốc Long Châu", url: "https://nhathuoclongchau.com.vn/benh/tang-huyet-ap.html", language: "vi", title_requires_review: true}
WITH source
CALL {
  WITH source
  UNWIND [
    {id: "tang_huyet_ap", name: "Tăng huyết áp", category: "disease"},
    {id: "dau_dau", name: "Đau đầu", category: "symptom"},
    {id: "dau_nguc", name: "Đau ngực", category: "symptom"},
    {id: "dau_dau_vao_buoi_sang", name: "Đau đầu vào buổi sáng", category: "symptom"},
    {id: "chay_mau_cam", name: "Chảy máu cam", category: "symptom"},
    {id: "do_phung_mat", name: "Đỏ phừng mặt", category: "symptom"},
    {id: "chong_mat_u_tai", name: "Chóng mặt, ù tai", category: "symptom"},
    {id: "hoi_hop_danh_trong_nguc", name: "Hồi hộp, đánh trống ngực", category: "symptom"},
    {id: "nhoi_mau_co_tim", name: "Nhồi máu cơ tim", category: "disease"},
    {id: "suy_tim", name: "Suy tim", category: "disease"},
    {id: "xuat_huyet_nao", name: "Xuất huyết não", category: "disease"},
    {id: "nhoi_mau_nao", name: "Nhồi máu não", category: "disease"},
    {id: "sa_sut_tri_tue", name: "Sa sút trí tuệ", category: "disease"},
    {id: "xuat_huyet_vong_mac", name: "Xuất huyết võng mạc", category: "disease"},
    {id: "phu_gai_thi", name: "Phù gai thị", category: "disease"},
    {id: "rung_nhi", name: "Rung nhĩ", category: "disease"},
    {id: "hoi_chung_mach_vanh_man", name: "Hội chứng mạch vành mạn", category: "disease"},
    {id: "benh_than_man", name: "Bệnh thận mạn", category: "disease"},
    {id: "hep_hoac_tac_mach_mau_o_hai_chan", name: "Hẹp hoặc tắc mạch máu ở hai chân", category: "disease"},
    {id: "hba1c__test", name: "HbA1C", category: "test"},
    {id: "huyet_ap_tam_thu", name: "Huyết áp tâm thu", category: "test"},
    {id: "huyet_ap_tam_truong", name: "Huyết áp tâm trương", category: "test"},
    {id: "cong_thuc_mau", name: "Công thức máu", category: "test"},
    {id: "bo_mo_mau", name: "Bộ mỡ máu", category: "test"},
    {id: "dien_giai_do", name: "Điện giải đồ", category: "test"},
    {id: "acid_uric_mau", name: "Acid uric máu", category: "test"},
    {id: "duong_huyet_luc_doi", name: "Đường huyết lúc đói", category: "test"},
    {id: "creatinine_mau", name: "Creatinine máu", category: "test"},
    {id: "men_gan", name: "Men gan", category: "test"},
    {id: "tong_phan_tich_nuoc_tieu", name: "Tổng phân tích nước tiểu", category: "test"},
    {id: "ti_le_albumin_tren_creatinine_nuoc_tieu", name: "Tỉ lệ albumin trên creatinine nước tiểu", category: "test"},
    {id: "do_dien_tim", name: "Đo điện tim", category: "test"},
    {id: "x_quang_nguc_thang", name: "X quang ngực thẳng", category: "test"},
    {id: "sieu_am_tim", name: "Siêu âm tim", category: "test"},
    {id: "do_van_toc_song_mach_pwv", name: "Đo vận tốc sóng mạch (PWV)", category: "test"},
    {id: "chi_so_huyet_ap_co_chan_canh_tay_abi", name: "Chỉ số huyết áp cổ chân/cánh tay (ABI)", category: "test"},
    {id: "soi_day_mat", name: "Soi đáy mắt", category: "test"},
    {id: "hinh_anh_nao_ct_hoac_mri", name: "Hình ảnh não (CT hoặc MRI)", category: "test"},
    {id: "benh_ly_than", name: "Bệnh lý thận", category: "disease"},
    {id: "hoi_chung_cushing", name: "Hội chứng Cushing", category: "disease"},
    {id: "tang_huyet_ap_thu_phat", name: "Tăng huyết áp thứ phát", category: "disease"},
    {id: "che_do_an_khong_lanh_manh", name: "Chế độ ăn không lành mạnh", category: "risk_factor"},
    {id: "hut_thuoc_la", name: "Hút thuốc lá", category: "risk_factor"},
    {id: "thua_can_beo_phi", name: "Thừa cân, béo phì", category: "risk_factor"},
    {id: "u_tuy_thuong_than", name: "U tủy thượng thận", category: "risk_factor"},
    {id: "hoi_chung_conn", name: "Hội chứng Conn", category: "risk_factor"},
    {id: "benh_ly_tuyen_giap", name: "Bệnh lý tuyến giáp", category: "risk_factor"},
    {id: "ngung_tho_khi_ngu", name: "Ngưng thở khi ngủ", category: "risk_factor"},
    {id: "thuoc_tranh_thai", name: "Thuốc tránh thai", category: "risk_factor"},
    {id: "thuoc_khang_viem", name: "Thuốc kháng viêm", category: "risk_factor"},
    {id: "thuoc_giam_dau", name: "Thuốc giảm đau", category: "risk_factor"},
    {id: "hep_eo_dong_mach_chu", name: "Hẹp eo động mạch chủ", category: "risk_factor"},
    {id: "nguoi_lon_tuoi", name: "Người lớn tuổi", category: "risk_factor"},
    {id: "nam_gioi_phu_nu_sau_man_kinh", name: "Nam giới, phụ nữ sau mãn kinh", category: "risk_factor"},
    {id: "tien_su_gia_dinh_co_nguoi_mac_cac_benh_tim_mach", name: "Tiền sử gia đình có người mắc các bệnh tim mạch", category: "risk_factor"},
    {id: "loi_song_tinh_tai_it_hoat_dong_the_luc", name: "Lối sống tĩnh tại, ít hoạt động thể lực", category: "risk_factor"},
    {id: "uong_nhieu_ruou", name: "Uống nhiều rượu", category: "risk_factor"},
    {id: "thuong_xuyen_cang_thang_lo_lang", name: "Thường xuyên căng thẳng, lo lắng", category: "risk_factor"},
    {id: "khong_hut_thuoc", name: "Không hút thuốc", category: "lifestyle"},
    {id: "che_do_an_dash", name: "Chế độ ăn DASH", category: "lifestyle"},
    {id: "giam_luong_muoi", name: "Giảm lượng muối", category: "lifestyle"},
    {id: "tang_cuong_kali", name: "Tăng cường kali", category: "lifestyle"},
    {id: "duy_tri_can_nang_hop_ly", name: "Duy trì cân nặng hợp lý", category: "lifestyle"},
    {id: "han_che_ruou_bia_thuoc_la", name: "Hạn chế rượu bia, thuốc lá", category: "lifestyle"},
    {id: "tang_cuong_hoat_dong_the_chat", name: "Tăng cường hoạt động thể chất", category: "lifestyle"},
    {id: "quan_ly_cang_thang_ngu_du_giac", name: "Quản lý căng thẳng, ngủ đủ giấc", category: "lifestyle"},
    {id: "su_dung_ruou_bia_dieu_do", name: "Sử dụng rượu bia điều độ", category: "lifestyle"},
    {id: "duy_tri_can_nang_ly_tuong", name: "Duy trì cân nặng lý tưởng", category: "lifestyle"},
    {id: "han_che_cang_thang", name: "Hạn chế căng thẳng", category: "lifestyle"},
    {id: "bo_sung_nhieu_rau_cu_qua", name: "Bổ sung nhiều rau củ quả", category: "lifestyle"},
    {id: "tham_kham_dinh_ky", name: "Thăm khám định kỳ", category: "test"},
    {id: "kiem_tra_huyet_ap_tai_nha", name: "Kiểm tra huyết áp tại nhà", category: "lifestyle"}
  ] AS row
  MERGE (n:DiabetesConcept {id: row.id})
  SET n += row
  MERGE (source)-[:MENTIONS]->(n)
  RETURN count(*) AS concept_count
}
CALL {
  WITH source
  UNWIND [
    {a: "tang_huyet_ap", b: "dau_dau", fact_id: "477512fa3e86", evidence: "Đau đầu có thể gặp trong bệnh tăng huyết áp"},
    {a: "tang_huyet_ap", b: "dau_nguc", fact_id: "59aee71c2131", evidence: "Đau ngực ;"},
    {a: "tang_huyet_ap", b: "dau_dau_vao_buoi_sang", fact_id: "f1373cc7dc8c", evidence: "Một số triệu chứng có thể xảy ra ở người bệnh tăng huyết áp gồm: Đau đầu vào buổi sáng;"},
    {a: "tang_huyet_ap", b: "chay_mau_cam", fact_id: "890289bb650c", evidence: "Chảy máu cam;"},
    {a: "tang_huyet_ap", b: "do_phung_mat", fact_id: "9a63919fb788", evidence: "Đỏ phừng mặt;"},
    {a: "tang_huyet_ap", b: "chong_mat_u_tai", fact_id: "6bb04ce44a01", evidence: "Chóng mặt, ù tai;"},
    {a: "tang_huyet_ap", b: "hoi_hop_danh_trong_nguc", fact_id: "c57368a1ffa4", evidence: "Hồi hộp, đánh trống ngực;"}
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
    {a: "tang_huyet_ap", b: "nhoi_mau_co_tim", fact_id: "647fd760056a", evidence: "Biến chứng tại tim: Suy tim , rung nhĩ, nhồi máu cơ tim, hội chứng mạch vành mạn."},
    {a: "tang_huyet_ap", b: "suy_tim", fact_id: "148dd702f1c5", evidence: "Biến chứng tại tim: Suy tim , rung nhĩ, nhồi máu cơ tim, hội chứng mạch vành mạn."},
    {a: "tang_huyet_ap", b: "xuat_huyet_nao", fact_id: "685d452f32ab", evidence: "Biến chứng tại não: Xuất huyết não , nhồi máu não, sa sút trí tuệ."},
    {a: "tang_huyet_ap", b: "nhoi_mau_nao", fact_id: "52f149e41baf", evidence: "Biến chứng tại não: Xuất huyết não , nhồi máu não, sa sút trí tuệ."},
    {a: "tang_huyet_ap", b: "sa_sut_tri_tue", fact_id: "855c0a92e54a", evidence: "Biến chứng tại não: Xuất huyết não , nhồi máu não, sa sút trí tuệ."},
    {a: "tang_huyet_ap", b: "xuat_huyet_vong_mac", fact_id: "17c911ea89d8", evidence: "Biến chứng tại mắt: Xuất huyết hoặc xuất huyết võng mạc, phù gai thị."},
    {a: "tang_huyet_ap", b: "phu_gai_thi", fact_id: "5e0101271b95", evidence: "Biến chứng tại mắt: Xuất huyết hoặc xuất huyết võng mạc, phù gai thị."},
    {a: "tang_huyet_ap", b: "rung_nhi", fact_id: "92d076ec23a6", evidence: "Biến chứng tại tim: Suy tim , rung nhĩ, nhồi máu cơ tim, hội chứng mạch vành mạn."},
    {a: "tang_huyet_ap", b: "hoi_chung_mach_vanh_man", fact_id: "88685059f25d", evidence: "Biến chứng tại tim: Suy tim , rung nhĩ, nhồi máu cơ tim, hội chứng mạch vành mạn."},
    {a: "tang_huyet_ap", b: "benh_than_man", fact_id: "9738eeac3693", evidence: "Biến chứng tại thận: Bệnh thận mạn."},
    {a: "tang_huyet_ap", b: "hep_hoac_tac_mach_mau_o_hai_chan", fact_id: "857882f5b2db", evidence: "Biến chứng bệnh động mạch ngoại biên: Hẹp hoặc tắc mạch máu ở hai chân."}
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
    {a: "tang_huyet_ap", b: "hba1c__test", fact_id: "e110670c0c4a", evidence: "Các xét nghiệm thường quy và chuyên sâu đánh giá ảnh hưởng của tăng huyết áp lên các cơ quan khác: Xét nghiệm máu: Công thức máu, bộ mỡ máu (cholesterol toàn phần, LDL-c, triglyceride), điện giải đồ, acid uric máu, đường huyết đói hoặc HbA1c, creatinine máu, men gan (AST, ALT)."},
    {a: "tang_huyet_ap", b: "huyet_ap_tam_thu", fact_id: "8748797bed89", evidence: "Tăng huyết áp tâm thu đơn độc | ≥ 140 | và | < 90"},
    {a: "tang_huyet_ap", b: "huyet_ap_tam_truong", fact_id: "45751133eb7a", evidence: "Theo khuyến cáo của Phân hội Tăng huyết áp - Hội Tim Mạch Học Quốc Gia Việt Nam năm 2022, chẩn đoán tăng huyết áp theo ngưỡng huyết áp (HA) đo tại phòng khám như sau:"},
    {a: "tang_huyet_ap", b: "cong_thuc_mau", fact_id: "fc0c0a058dbc", evidence: "Các xét nghiệm thường quy và chuyên sâu đánh giá ảnh hưởng của tăng huyết áp lên các cơ quan khác: Xét nghiệm máu: Công thức máu, bộ mỡ máu (cholesterol toàn phần, LDL-c, triglyceride), điện giải đồ, acid uric máu, đường huyết đói hoặc HbA1c, creatinine máu, men gan (AST, ALT)."},
    {a: "tang_huyet_ap", b: "bo_mo_mau", fact_id: "597bbc00350b", evidence: "Các xét nghiệm thường quy và chuyên sâu đánh giá ảnh hưởng của tăng huyết áp lên các cơ quan khác: Xét nghiệm máu: Công thức máu, bộ mỡ máu (cholesterol toàn phần, LDL-c, triglyceride), điện giải đồ, acid uric máu, đường huyết đói hoặc HbA1c, creatinine máu, men gan (AST, ALT)."},
    {a: "tang_huyet_ap", b: "dien_giai_do", fact_id: "a0f25f36234c", evidence: "Các xét nghiệm thường quy và chuyên sâu đánh giá ảnh hưởng của tăng huyết áp lên các cơ quan khác: Xét nghiệm máu: Công thức máu, bộ mỡ máu (cholesterol toàn phần, LDL-c, triglyceride), điện giải đồ, acid uric máu, đường huyết đói hoặc HbA1c, creatinine máu, men gan (AST, ALT)."},
    {a: "tang_huyet_ap", b: "acid_uric_mau", fact_id: "cdc4d402e906", evidence: "Các xét nghiệm thường quy và chuyên sâu đánh giá ảnh hưởng của tăng huyết áp lên các cơ quan khác: Xét nghiệm máu: Công thức máu, bộ mỡ máu (cholesterol toàn phần, LDL-c, triglyceride), điện giải đồ, acid uric máu, đường huyết đói hoặc HbA1c, creatinine máu, men gan (AST, ALT)."},
    {a: "tang_huyet_ap", b: "duong_huyet_luc_doi", fact_id: "0dd797273459", evidence: "Các xét nghiệm thường quy và chuyên sâu đánh giá ảnh hưởng của tăng huyết áp lên các cơ quan khác: Xét nghiệm máu: Công thức máu, bộ mỡ máu (cholesterol toàn phần, LDL-c, triglyceride), điện giải đồ, acid uric máu, đường huyết đói hoặc HbA1c, creatinine máu, men gan (AST, ALT)."},
    {a: "tang_huyet_ap", b: "creatinine_mau", fact_id: "989fd8fa34da", evidence: "Các xét nghiệm thường quy và chuyên sâu đánh giá ảnh hưởng của tăng huyết áp lên các cơ quan khác: Xét nghiệm máu: Công thức máu, bộ mỡ máu (cholesterol toàn phần, LDL-c, triglyceride), điện giải đồ, acid uric máu, đường huyết đói hoặc HbA1c, creatinine máu, men gan (AST, ALT)."},
    {a: "tang_huyet_ap", b: "men_gan", fact_id: "7b6fe93523e0", evidence: "Các xét nghiệm thường quy và chuyên sâu đánh giá ảnh hưởng của tăng huyết áp lên các cơ quan khác: Xét nghiệm máu: Công thức máu, bộ mỡ máu (cholesterol toàn phần, LDL-c, triglyceride), điện giải đồ, acid uric máu, đường huyết đói hoặc HbA1c, creatinine máu, men gan (AST, ALT)."},
    {a: "tang_huyet_ap", b: "tong_phan_tich_nuoc_tieu", fact_id: "fbb574c16267", evidence: "Tổng phân tích nước tiểu, tỉ lệ albumin trên creatinine nước tiểu: Đánh giá ảnh hưởng của tăng huyết áp đến chức năng thận."},
    {a: "tang_huyet_ap", b: "ti_le_albumin_tren_creatinine_nuoc_tieu", fact_id: "32394d12772e", evidence: "Tổng phân tích nước tiểu, tỉ lệ albumin trên creatinine nước tiểu: Đánh giá ảnh hưởng của tăng huyết áp đến chức năng thận."},
    {a: "tang_huyet_ap", b: "do_dien_tim", fact_id: "ccd0ea5c9f56", evidence: "Đo điện tim, X quang ngực thẳng, siêu âm tim: Đánh giá ảnh hưởng của tăng huyết áp đến cấu trúc và chức năng tim."},
    {a: "tang_huyet_ap", b: "x_quang_nguc_thang", fact_id: "729eebdea842", evidence: "Đo điện tim, X quang ngực thẳng, siêu âm tim: Đánh giá ảnh hưởng của tăng huyết áp đến cấu trúc và chức năng tim."},
    {a: "tang_huyet_ap", b: "sieu_am_tim", fact_id: "aaa960f94929", evidence: "Đo điện tim, X quang ngực thẳng, siêu âm tim: Đánh giá ảnh hưởng của tăng huyết áp đến cấu trúc và chức năng tim."},
    {a: "tang_huyet_ap", b: "do_van_toc_song_mach_pwv", fact_id: "82e389a08dfb", evidence: "Đo vận tốc sóng mạch (PWV): Đánh giá độ xơ cứng của mạch máu."},
    {a: "tang_huyet_ap", b: "chi_so_huyet_ap_co_chan_canh_tay_abi", fact_id: "608ab533647e", evidence: "Chỉ số huyết áp cổ chân/cánh tay (ABI): Đánh giá động mạch ngoại biên ở 2 chân."},
    {a: "tang_huyet_ap", b: "soi_day_mat", fact_id: "7c07d4f2bf05", evidence: "Soi đáy mắt: Đánh giá ảnh hưởng của tăng huyết áp đến mạch máu đáy mắt."},
    {a: "tang_huyet_ap", b: "hinh_anh_nao_ct_hoac_mri", fact_id: "45b943502271", evidence: "Hình ảnh não (CT hoặc MRI): Tổn thương thiếu máu hoặc xuất huyết não."}
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
    {a: "tang_huyet_ap", b: "benh_ly_than", fact_id: "ef2c2cbb804c", evidence: "Các bệnh lý thận như viêm cầu thận, hội chứng thận hư, bệnh thận mạn, hẹp động mạch thận,..."},
    {a: "tang_huyet_ap", b: "hoi_chung_cushing", fact_id: "4ade499c8af2", evidence: "Hội chứng Cushing"},
    {a: "tang_huyet_ap", b: "tang_huyet_ap_thu_phat", fact_id: "5a1fedf0b5ba", evidence: "Tăng huyết áp thứ phát"},
    {a: "tang_huyet_ap", b: "che_do_an_khong_lanh_manh", fact_id: "2aa2968e5f3e", evidence: "Chế độ ăn uống không lành mạnh:"},
    {a: "tang_huyet_ap", b: "hut_thuoc_la", fact_id: "ae3c1fac829c", evidence: "Một số yếu tố sau làm tăng nguy cơ mắc tăng huyết áp, bao gồm: Hút thuốc lá;"},
    {a: "tang_huyet_ap", b: "thua_can_beo_phi", fact_id: "39ce9bd5154a", evidence: "Thừa cân, béo phì ;"},
    {a: "tang_huyet_ap", b: "u_tuy_thuong_than", fact_id: "182e7035656a", evidence: "U tủy thượng thận"},
    {a: "tang_huyet_ap", b: "hoi_chung_conn", fact_id: "7767fc47dad5", evidence: "Hội chứng Conn"},
    {a: "tang_huyet_ap", b: "benh_ly_tuyen_giap", fact_id: "8d241bca8f4e", evidence: "Các bệnh lý tuyến giáp"},
    {a: "tang_huyet_ap", b: "ngung_tho_khi_ngu", fact_id: "a53a97f853bf", evidence: "Ngưng thở khi ngủ"},
    {a: "tang_huyet_ap", b: "thuoc_tranh_thai", fact_id: "2f65a4d80997", evidence: "Một số loại thuốc như thuốc tránh thai, thuốc kháng viêm, thuốc giảm đau,..."},
    {a: "tang_huyet_ap", b: "thuoc_khang_viem", fact_id: "a42cc28d9769", evidence: "Một số loại thuốc như thuốc tránh thai, thuốc kháng viêm, thuốc giảm đau,..."},
    {a: "tang_huyet_ap", b: "thuoc_giam_dau", fact_id: "8ea76d180b34", evidence: "Một số loại thuốc như thuốc tránh thai, thuốc kháng viêm, thuốc giảm đau,..."},
    {a: "tang_huyet_ap", b: "hep_eo_dong_mach_chu", fact_id: "d9fc359f62e9", evidence: "Hẹp eo động mạch chủ"},
    {a: "tang_huyet_ap", b: "nguoi_lon_tuoi", fact_id: "7fccb585477f", evidence: "Một số đối tượng có nguy cơ mắc bệnh tăng huyết áp cần được lưu ý: Người lớn tuổi;"},
    {a: "tang_huyet_ap", b: "nam_gioi_phu_nu_sau_man_kinh", fact_id: "0dbd5fa2cdb7", evidence: "Nam giới, phụ nữ sau mãn kinh;"},
    {a: "tang_huyet_ap", b: "tien_su_gia_dinh_co_nguoi_mac_cac_benh_tim_mach", fact_id: "697aab44f02b", evidence: "Tiền sử gia đình có người mắc các bệnh tim mạch ."},
    {a: "tang_huyet_ap", b: "loi_song_tinh_tai_it_hoat_dong_the_luc", fact_id: "0a77ca2da5ae", evidence: "Lối sống tĩnh tại, ít vận động;"},
    {a: "tang_huyet_ap", b: "uong_nhieu_ruou", fact_id: "f79e36b354de", evidence: "Uống nhiều rượu;"},
    {a: "tang_huyet_ap", b: "thuong_xuyen_cang_thang_lo_lang", fact_id: "286830b0cd25", evidence: "Thường xuyên căng thẳng, lo lắng."}
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
    {a: "tang_huyet_ap", b: "khong_hut_thuoc", fact_id: "bf5eb0863af8", evidence: "Không hút thuốc lá (chủ động và bị động);"},
    {a: "tang_huyet_ap", b: "che_do_an_dash", fact_id: "fdb84c2915ee", evidence: "Chế độ ăn DASH"},
    {a: "tang_huyet_ap", b: "giam_luong_muoi", fact_id: "3f289db76d54", evidence: "Giảm lượng muối ăn vào: Hạn chế lượng muối ăn, đồ muối mặn;"},
    {a: "tang_huyet_ap", b: "tang_cuong_kali", fact_id: "8be4465ee561", evidence: "Tăng cường kali: Từ thực phẩm tự nhiên như chuối, rau xanh, khoai... (trừ khi có bệnh thận);"},
    {a: "tang_huyet_ap", b: "duy_tri_can_nang_hop_ly", fact_id: "03fe6fc45194", evidence: "Duy trì cân nặng hợp lý: Giảm cân nếu thừa cân, béo phì;"},
    {a: "tang_huyet_ap", b: "han_che_ruou_bia_thuoc_la", fact_id: "a61ad43f29d7", evidence: "Hạn chế rượu bia, thuốc lá: Nên giảm thiểu tiêu thụ rượu và bia, tránh hút thuốc lá (kể cả hút thụ động);"},
    {a: "tang_huyet_ap", b: "tang_cuong_hoat_dong_the_chat", fact_id: "eaf242462ea2", evidence: "Tăng cường vận động thể lực: Với hoạt động vừa phải như đi bộ nhanh, bơi, đạp xe;"},
    {a: "tang_huyet_ap", b: "quan_ly_cang_thang_ngu_du_giac", fact_id: "c017a240ff84", evidence: "Quản lý căng thẳng, ngủ đủ giấc: Thực hiện các biện pháp giảm stress và đảm bảo giấc ngủ chất lượng."},
    {a: "tang_huyet_ap", b: "su_dung_ruou_bia_dieu_do", fact_id: "9e61a71ed970", evidence: "Sử dụng rượu bia điều độ, có kiểm soát;"},
    {a: "tang_huyet_ap", b: "duy_tri_can_nang_ly_tuong", fact_id: "8ff3f6f915e7", evidence: "Duy trì cân nặng lý tưởng, giảm cân nếu thừa cân, béo phì ;"},
    {a: "tang_huyet_ap", b: "han_che_cang_thang", fact_id: "2f0e19a177d3", evidence: "Hạn chế căng thẳng, xây dựng thời gian làm việc và nghỉ ngơi hợp lý."},
    {a: "tang_huyet_ap", b: "bo_sung_nhieu_rau_cu_qua", fact_id: "83abf7ed76fc", evidence: "Bổ sung nhiều rau củ quả, trái cây, hạn chế tối đa các loại thực phẩm chứa nhiều chất béo bão hòa, chất béo chuyển hóa."}
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
    {a: "tang_huyet_ap", b: "tham_kham_dinh_ky", fact_id: "ff598024f2d4", evidence: "Việc khám sức khỏe định kỳ để theo dõi chỉ số huyết áp cũng như một số bệnh lý làm tăng nguy cơ tăng huyết áp là rất quan trọng."},
    {a: "tang_huyet_ap", b: "kiem_tra_huyet_ap_tai_nha", fact_id: "f90758422865", evidence: "Nếu được chẩn đoán tăng huyết áp, bạn cần tuân thủ nghiêm ngặt phác đồ điều trị của bác sĩ, thường xuyên kiểm tra huyết áp tại nhà và tái khám đúng lịch hẹn."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:PREVENTED_BY {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_6
}
RETURN source.id AS source_id, concept_count,
       rel_count_1 + rel_count_2 + rel_count_3 + rel_count_4 + rel_count_5 + rel_count_6 AS fact_count;
