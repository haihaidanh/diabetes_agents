MERGE (source:DiabetesSource {id: "vinmec_cham_soc_cac_van_de_tim_mach_o_nguoi_benh_tieu_duong_va_tien"})
SET source += {id: "vinmec_cham_soc_cac_van_de_tim_mach_o_nguoi_benh_tieu_duong_va_tien", title: "Cham soc cac van de tim mach o nguoi benh tieu duong va tien tieu duong vi", publisher: "Vinmec", url: "https://www.vinmec.com/vie/bai-viet/cham-soc-cac-van-de-tim-mach-o-nguoi-benh-tieu-duong-va-tien-tieu-duong-vi", language: "vi", title_requires_review: true}
WITH source
CALL {
  WITH source
  UNWIND [
    {id: "dai_thao_duong", name: "Đái tháo đường", category: "disease"},
    {id: "tien_tieu_duong", name: "Tiền tiểu đường", category: "disease"},
    {id: "dot_quy", name: "Đột quỵ", category: "disease"},
    {id: "nhoi_mau_co_tim", name: "Nhồi máu cơ tim", category: "disease"},
    {id: "benh_than_kinh", name: "Bệnh thần kinh", category: "disease"},
    {id: "tai_bien_tim_mach", name: "Tai biến tim mạch", category: "disease"},
    {id: "benh_ly_cau_than", name: "Bệnh lý cầu thận", category: "disease"},
    {id: "che_do_an_lanh_manh_va_luyen_tap_the_luc_thuong_xuyen", name: "Chế độ ăn lành mạnh và luyện tập thể lực thường xuyên", category: "lifestyle"},
    {id: "cai_thuoc_la", name: "Cai thuốc lá", category: "lifestyle"},
    {id: "kiem_tra_suc_khoe_moi_6_12_thang", name: "Kiểm tra sức khỏe mỗi 6-12 tháng", category: "test"},
    {id: "kiem_tra_danh_gia_lai_hang_nam", name: "Kiểm tra đánh giá lại hằng năm", category: "test"},
    {id: "thuoc_nhom_uc_che_sglt2", name: "Thuốc nhóm ức chế SGLT2", category: "drug_class"},
    {id: "roi_loan_mo_mau", name: "Rối loạn mỡ máu", category: "risk_factor"},
    {id: "bo_me_hoac_anh_chi_em_ruot_mac_tieu_duong", name: "Bố mẹ hoặc anh chị em ruột mắc tiểu đường", category: "risk_factor"},
    {id: "chung_toc_nguy_co_cao", name: "Chủng tộc nguy cơ cao", category: "risk_factor"},
    {id: "tien_su_tai_bien_tim_mach", name: "Tiền sử tai biến tim mạch", category: "risk_factor"},
    {id: "triglycerid_cao", name: "Triglycerid cao", category: "risk_factor"},
    {id: "hdl_thap", name: "HDL thấp", category: "risk_factor"},
    {id: "tien_dai_thao_duong", name: "Tiền đái tháo đường", category: "disease"},
    {id: "hba1c", name: "HbA1c", category: "disease"},
    {id: "roi_loan_chuyen_hoa_carbohyrate", name: "Rối loạn chuyển hóa carbohyrate", category: "disease"},
    {id: "benh_tim_mach_do_tieu_duong", name: "Bệnh tim mạch do tiểu đường", category: "disease"},
    {id: "ha_huyet_ap", name: "Hạ huyết áp", category: "test"},
    {id: "tai_kham_thuong_xuyen", name: "Tái khám thường xuyên", category: "lifestyle"},
    {id: "lang_nghe_tu_van_tu_nhan_vien_y_te", name: "Lắng nghe tư vấn từ nhân viên y tế", category: "lifestyle"}
  ] AS row
  MERGE (n:DiabetesConcept {id: row.id})
  SET n += row
  MERGE (source)-[:MENTIONS]->(n)
  RETURN count(*) AS concept_count
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong", b: "tien_tieu_duong", fact_id: "e961b281f164", evidence: "Tiền tiểu đường là tình trạng tăng đường máu nhưng chưa tới ngưỡng để chẩn đoán bệnh tiểu đường với đặc trưng là đường máu đói từ 5,6-6,9mmol/l và/hoặc đường máu sau 2 giờ thử nghiệm uống 75g đường (thử nghiệm dung nạp đường huyết) nằm trong khoảng 7,8-11mmol/l và/hoặc HbA1C nằm trong khoảng 5,7-6,5%."},
    {a: "dai_thao_duong", b: "dot_quy", fact_id: "76d89098b828", evidence: "Lối sống lành mạnh không chỉ giúp giảm nguy cơ và trì hoãn khởi phát tiểu đường mà còn giúp bệnh nhân tiểu đường giảm thiểu nguy cơ mắc các tai biến tim mạch như nhồi máu cơ tim và đột quỵ ."},
    {a: "dai_thao_duong", b: "nhoi_mau_co_tim", fact_id: "ff001f78e66d", evidence: "Lối sống lành mạnh không chỉ giúp giảm nguy cơ và trì hoãn khởi phát tiểu đường mà còn giúp bệnh nhân tiểu đường giảm thiểu nguy cơ mắc các tai biến tim mạch như nhồi máu cơ tim và đột quỵ ."},
    {a: "dai_thao_duong", b: "benh_than_kinh", fact_id: "bced0bf81c65", evidence: "Đường máu cao còn dẫn tới các bệnh mạch máu nhỏ như bệnh lý võng mạc, bệnh lý cầu thận và bệnh thần kinh ."},
    {a: "dai_thao_duong", b: "tai_bien_tim_mach", fact_id: "4488beab9c50", evidence: "Bệnh tiểu đường là yếu tố nguy cơ độc lập làm tăng gấp 2 lần nguy cơ tai biến tim mạch (bao gồm tử vong do bệnh mạch máu, nhồi máu cơ tim và đột quỵ)."},
    {a: "dai_thao_duong", b: "benh_ly_cau_than", fact_id: "69c3f2f80db1", evidence: "Đường máu cao còn dẫn tới các bệnh mạch máu nhỏ như bệnh lý võng mạc, bệnh lý cầu thận và bệnh thần kinh ."}
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
    {a: "dai_thao_duong", b: "che_do_an_lanh_manh_va_luyen_tap_the_luc_thuong_xuyen", fact_id: "4605a16c7315", evidence: "Để phòng tránh bệnh tiểu đường, bạn nên thực hiện chế độ ăn lành mạnh và luyện tập thể lực thường xuyên , duy trì mức cân nặng tối ưu hoặc giảm cân nếu BMI ≥23kg/m2 hoặc vòng bụng ≥94cm ở nam và ≥80cm ở nữ."},
    {a: "dai_thao_duong", b: "cai_thuoc_la", fact_id: "017bb38e0e64", evidence: "Cai thuốc lá có thể làm giảm nguy cơ tiểu đường do giảm đáp ứng viêm hệ thống."},
    {a: "benh_tim_mach_do_tieu_duong", b: "tai_kham_thuong_xuyen", fact_id: "cd25e5eb3c1a", evidence: "Lắng nghe tư vấn từ nhân viên y tế, tuân thủ điều trị và tái khám định kỳ là chìa khóa để bệnh nhân tiểu đường sống khỏe mạnh và hạnh phúc hơn."},
    {a: "benh_tim_mach_do_tieu_duong", b: "lang_nghe_tu_van_tu_nhan_vien_y_te", fact_id: "1def39469227", evidence: "Lắng nghe tư vấn từ nhân viên y tế, tuân thủ điều trị và tái khám định kỳ là chìa khóa để bệnh nhân tiểu đường sống khỏe mạnh và hạnh phúc hơn."}
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
    {a: "dai_thao_duong", b: "kiem_tra_suc_khoe_moi_6_12_thang", fact_id: "fd70dc71bd28", evidence: "Người khỏe mạnh nên đi kiểm tra sức khỏe mỗi 6-12 tháng để tầm soát nguy cơ và phát hiện sớm bệnh tiểu đường ."},
    {a: "dai_thao_duong", b: "kiem_tra_danh_gia_lai_hang_nam", fact_id: "bc6698a74208", evidence: "Người mắc tiền tiểu đường nên được kiểm tra đánh giá lại hằng năm."},
    {a: "tien_dai_thao_duong", b: "hba1c", fact_id: "d999ec960a0c", op: "range", value: 7, value_max: 7.5, unit: "%", evidence: "Người lớn tuổi có nhiều bệnh mắc kèm, HbA1C có thể cân nhắc để 7,0-7,5% để tránh tụt đường huyết."},
    {a: "benh_tim_mach_do_tieu_duong", b: "ha_huyet_ap", fact_id: "190ffb1a3d12", evidence: "Trong trường hợp bệnh nhân tiểu đường mắc kèm tăng huyết áp, bác sĩ sẽ tư vấn mục tiêu hạ huyết áp tối ưu trên từng bệnh nhân cụ thể, cân nhắc dựa trên nguy cơ tim mạch, tuổi, khả năng dung nạp thuốc..."}
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
    {a: "dai_thao_duong", b: "thuoc_nhom_uc_che_sglt2", fact_id: "7ca9a7e0f379", evidence: "Metformin, liraglutide và các thuốc thuộc nhóm ức chế SGLT2 như dapagliflozin hoặc empagliflozin có thể được cân nhắc lựa chọn kiểm soát đường huyết đơn độc hoặc phối hợp từ đầu trên các đối tượng bệnh nhân dựa trên đánh giá nguy cơ tim mạch. Trong đó, với các bằng chứng khoa học hiện tại, lợi ích giảm nguy cơ biến cố tim mạch, nhập viện do suy tim và giảm tiến triển bệnh thận mạn, các thuốc nhóm ức chế SGLT2 đang trở thành lựa chọn đầu tay ở bệnh nhân tiểu đường có nguy cơ tim mạch cao đến rất cao."}
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
    {a: "dai_thao_duong", b: "roi_loan_mo_mau", fact_id: "4664189a0327", evidence: "Rối loạn mỡ máu"},
    {a: "dai_thao_duong", b: "bo_me_hoac_anh_chi_em_ruot_mac_tieu_duong", fact_id: "f279e8543d77", evidence: "Bố mẹ hoặc anh chị em ruột mắc tiểu đường"},
    {a: "dai_thao_duong", b: "chung_toc_nguy_co_cao", fact_id: "778caf73cc6a", evidence: "Chủng tộc nguy cơ cao (Người Châu Á được coi là chủng tộc nguy cơ cao)"},
    {a: "dai_thao_duong", b: "tien_su_tai_bien_tim_mach", fact_id: "95d7b2d6f2ff", evidence: "Tiền sử tai biến tim mạch"},
    {a: "tien_tieu_duong", b: "triglycerid_cao", fact_id: "670cfff7ea01", evidence: "Những người dễ bị tiền tiểu đường bao gồm những người béo phì, tăng huyết áp , triglycerid cao, HDL thấp, có bố mẹ hoặc anh chị em ruột mắc bệnh tiểu đường..."},
    {a: "tien_tieu_duong", b: "hdl_thap", fact_id: "e98790e3c697", evidence: "Những người dễ bị tiền tiểu đường bao gồm những người béo phì, tăng huyết áp , triglycerid cao, HDL thấp, có bố mẹ hoặc anh chị em ruột mắc bệnh tiểu đường..."},
    {a: "tien_tieu_duong", b: "bo_me_hoac_anh_chi_em_ruot_mac_tieu_duong", fact_id: "6812a77f1a97", evidence: "Những người dễ bị tiền tiểu đường bao gồm những người béo phì, tăng huyết áp , triglycerid cao, HDL thấp, có bố mẹ hoặc anh chị em ruột mắc bệnh tiểu đường..."},
    {a: "roi_loan_chuyen_hoa_carbohyrate", b: "dai_thao_duong", fact_id: "669d83202a79", evidence: "Bệnh tiểu đường hay còn gọi là bệnh đái tháo đường là một bệnh lý mạn tính có liên quan tới rối loạn chuyển hóa carbohyrate trong cơ thể với đặc trưng là chỉ số đường trong máu cao."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:HAS_RISK_FACTOR {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_5
}
RETURN source.id AS source_id, concept_count,
       rel_count_1 + rel_count_2 + rel_count_3 + rel_count_4 + rel_count_5 AS fact_count;
