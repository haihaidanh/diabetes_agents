MERGE (source:DiabetesSource {id: "nhathuoclongchau_phan_biet_tieu_duong_tuyp_1_va_tuyp_2"})
SET source += {id: "nhathuoclongchau_phan_biet_tieu_duong_tuyp_1_va_tuyp_2", title: "Phan biet tieu duong tuyp 1 va tuyp 2", publisher: "Nhà thuốc Long Châu", url: "https://nhathuoclongchau.com.vn/bai-viet/phan-biet-tieu-duong-tuyp-1-va-tuyp-2.html", language: "vi", title_requires_review: true}
WITH source
CALL {
  WITH source
  UNWIND [
    {id: "dai_thao_duong", name: "Đái tháo đường", category: "disease"},
    {id: "nguy_hiem", name: "Nguy hiểm", category: "symptom"},
    {id: "dai_thao_duong_tuyp_2", name: "Đái tháo đường tuýp 2", category: "disease"},
    {id: "hoi_chung_buong_trung_da_nang", name: "Hội chứng buồng trứng đa nang", category: "risk_factor"},
    {id: "insulin", name: "Insulin", category: "disease"},
    {id: "thuoc_ha_duong_huyet", name: "Thuốc hạ đường huyết", category: "drug"},
    {id: "thay_doi_che_do_an_uong", name: "Thay đổi chế độ ăn uống", category: "lifestyle"},
    {id: "xay_dung_che_do_an_uong_lanh_manh_day_du_duong_chat", name: "Xây dựng chế độ ăn uống lành mạnh, đầy đủ dưỡng chất", category: "lifestyle"},
    {id: "kieng_do_an_nhieu_chat_beo_va_duong", name: "Kiêng đồ ăn nhiều chất béo và đường", category: "lifestyle"},
    {id: "che_do_sinh_hoat_tap_luyen_khoa_hoc", name: "Chế độ sinh hoạt, tập luyện khoa học", category: "lifestyle"},
    {id: "thua_can", name: "Thừa cân", category: "risk_factor"},
    {id: "de_khang_insulin_tai_co_gan_mo_mo", name: "Đề kháng insulin tại cơ, gan, mô mỡ", category: "risk_factor"},
    {id: "khong_tap_the_duc_thuong_xuyen", name: "Không tập thể dục thường xuyên", category: "risk_factor"},
    {id: "beo_phi_dac_biet_beo_bung", name: "Béo phì (đặc biệt béo bụng)", category: "risk_factor"},
    {id: "che_do_an_khong_lanh_manh", name: "Chế độ ăn không lành mạnh", category: "risk_factor"},
    {id: "tien_su_gia_dinh", name: "Tiền sử gia đình", category: "risk_factor"},
    {id: "tuoi_cao", name: "Tuổi cao", category: "risk_factor"},
    {id: "tien_su_dai_thao_duong_thai_ky", name: "Tiền sử đái tháo đường thai kỳ", category: "risk_factor"},
    {id: "buong_trung_da_nang_pcos", name: "Buồng trứng đa nang (PCOS)", category: "risk_factor"},
    {id: "roi_loan_giac_ngu_ngung_tho_khi_ngu", name: "Rối loạn giấc ngủ/ngưng thở khi ngủ", category: "risk_factor"},
    {id: "dung_glucocorticoid_keo_dai", name: "Dùng glucocorticoid kéo dài", category: "risk_factor"},
    {id: "hut_thuoc_la", name: "Hút thuốc lá", category: "risk_factor"},
    {id: "uong_ruou_bia_nhieu", name: "Uống rượu bia nhiều", category: "risk_factor"},
    {id: "dai_thao_duong_tuyp_1", name: "Đái tháo đường tuýp 1", category: "disease"},
    {id: "tac_nhan_moi_truong", name: "Tác nhân môi trường", category: "risk_factor"},
    {id: "bien_co_tim_mach", name: "Biến cố tim mạch", category: "disease"}
  ] AS row
  MERGE (n:DiabetesConcept {id: row.id})
  SET n += row
  MERGE (source)-[:MENTIONS]->(n)
  RETURN count(*) AS concept_count
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong", b: "nguy_hiem", fact_id: "be7b8da1973b", evidence: "Bệnh tiểu đường rất nguy hiểm nếu không được phát hiện sớm và kiểm soát tốt."},
    {a: "dai_thao_duong_tuyp_2", b: "hoi_chung_buong_trung_da_nang", fact_id: "441fbad72e56", evidence: "Bạn có thể căn cứ vào những dấu hiệu của tiểu đường tuýp 2 như da khô, ngứa, mệt mỏi, tê bì tay chân, xuất hiện hội chứng buồng trứng đa nang ,… để sớm phát hiện bệnh."}
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
    {a: "dai_thao_duong_tuyp_2", b: "insulin", fact_id: "ed65adb4fff7", evidence: "Ngoài ra, bệnh nhân tiểu đường tuýp 2 cũng có thể dùng thuốc hạ đường huyết hoặc bổ sung thêm insulin nếu không đáp ứng với thuốc đường uống, có hiện tượng đường huyết tăng cao, men gan cao kèm theo biến chứng suy thận, ốm sốt,…"},
    {a: "dai_thao_duong_tuyp_2", b: "thuoc_ha_duong_huyet", fact_id: "6b56697926d8", evidence: "Ngoài ra, bệnh nhân tiểu đường tuýp 2 cũng có thể dùng thuốc hạ đường huyết hoặc bổ sung thêm insulin nếu không đáp ứng với thuốc đường uống, có hiện tượng đường huyết tăng cao, men gan cao kèm theo biến chứng suy thận, ốm sốt,…"},
    {a: "dai_thao_duong_tuyp_2", b: "thay_doi_che_do_an_uong", fact_id: "be8bb1adba71", evidence: "Trong khi đó, đối với tiểu đường tuýp 2 thì việc thay đổi chế độ ăn uống, có lối sống lành mạnh, tập luyện thể dục thể thao điều độ là những yếu tố cực kỳ quan trọng trong việc điều trị."},
    {a: "dai_thao_duong_tuyp_1", b: "insulin", fact_id: "d794e72399d9", evidence: "Khi chẩn đoán đúng tình trạng bệnh thì phương pháp điều trị của 2 thể bệnh này cũng khác nhau. Với tiểu đường tuýp 1 thì bắt buộc phải dùng insulin, đây là phương pháp điều trị bắt buộc để kiểm soát tốt lượng đường huyết trong cơ thể."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:TREATED_BY {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_2
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong_tuyp_2", b: "xay_dung_che_do_an_uong_lanh_manh_day_du_duong_chat", fact_id: "193eb95902f5", evidence: "Đối với tiểu đường tuýp 2 thì bạn có thể phòng ngừa bằng các cách như sau: xây dựng chế độ ăn uống lành mạnh, đầy đủ dưỡng chất, kiêng đồ ăn nhiều chất béo và đường, bổ sung nhiều rau xanh vào thực đơn cho người tiểu đường tuýp 2 , chú ý tập thể dục và duy trì vận động điều độ mỗi ngày."},
    {a: "dai_thao_duong_tuyp_2", b: "kieng_do_an_nhieu_chat_beo_va_duong", fact_id: "d95a3d1b825a", evidence: "Đối với tiểu đường tuýp 2 thì bạn có thể phòng ngừa bằng các cách như sau: xây dựng chế độ ăn uống lành mạnh, đầy đủ dưỡng chất, kiêng đồ ăn nhiều chất béo và đường, bổ sung nhiều rau xanh vào thực đơn cho người tiểu đường tuýp 2 , chú ý tập thể dục và duy trì vận động điều độ mỗi ngày."},
    {a: "dai_thao_duong_tuyp_2", b: "che_do_sinh_hoat_tap_luyen_khoa_hoc", fact_id: "9552468b769e", evidence: "Kiên trì áp dụng các biện pháp này sẽ giúp đốt cháy lượng mỡ thừa trong cơ thể rất tốt, đồng thời hạn chế được tình trạng kháng insulin. Chế độ sinh hoạt, tập luyện khoa học giúp bạn kiểm soát bệnh hiệu quả"}
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
    {a: "dai_thao_duong_tuyp_2", b: "thua_can", fact_id: "6fa3726c9aa2", evidence: "hoặc người bệnh thiếu hụt sản xuất insulin và cần thay thế insulin. Ngoài ra, một số yếu tố khác liên quan đến thói quen sống như không tập thể dục thường xuyên, thừa cân, béo phì (đặc biệt béo bụng), chế độ ăn không lành mạnh, tiền sử gia đình, tuổi cao, ngoài ra còn gặp ở người có tiền sử đái tháo đường thai kỳ, buồng trứng đa nang (PCOS), rối loạn giấc ngủ/ngưng thở khi ngủ, dùng glucocorticoid kéo dài, hút thuốc, uống rượu bia nhiều là nguy cơ khởi phát bệnh."},
    {a: "dai_thao_duong_tuyp_2", b: "de_khang_insulin_tai_co_gan_mo_mo", fact_id: "f0fcf91c0a38", evidence: "tiểu đường tuýp 2 lại là tình trạng mạn tính phát triển từ từ theo thời gian. Do cơ thể người bệnh không sử dụng insulin đúng cách (đề kháng insulin tại cơ, gan, mô mỡ kèm suy giảm dần chức năng tế bào β theo thời gian), khiến cho lượng đường trong máu tăng cao."},
    {a: "dai_thao_duong_tuyp_2", b: "khong_tap_the_duc_thuong_xuyen", fact_id: "6de458da4c4c", evidence: "hoặc người bệnh thiếu hụt sản xuất insulin và cần thay thế insulin. Ngoài ra, một số yếu tố khác liên quan đến thói quen sống như không tập thể dục thường xuyên, thừa cân, béo phì (đặc biệt béo bụng), chế độ ăn không lành mạnh, tiền sử gia đình, tuổi cao, ngoài ra còn gặp ở người có tiền sử đái tháo đường thai kỳ, buồng trứng đa nang (PCOS), rối loạn giấc ngủ/ngưng thở khi ngủ, dùng glucocorticoid kéo dài, hút thuốc, uống rượu bia nhiều là nguy cơ khởi phát bệnh."},
    {a: "dai_thao_duong_tuyp_2", b: "beo_phi_dac_biet_beo_bung", fact_id: "c7739f41ae18", evidence: "hoặc người bệnh thiếu hụt sản xuất insulin và cần thay thế insulin. Ngoài ra, một số yếu tố khác liên quan đến thói quen sống như không tập thể dục thường xuyên, thừa cân, béo phì (đặc biệt béo bụng), chế độ ăn không lành mạnh, tiền sử gia đình, tuổi cao, ngoài ra còn gặp ở người có tiền sử đái tháo đường thai kỳ, buồng trứng đa nang (PCOS), rối loạn giấc ngủ/ngưng thở khi ngủ, dùng glucocorticoid kéo dài, hút thuốc, uống rượu bia nhiều là nguy cơ khởi phát bệnh."},
    {a: "dai_thao_duong_tuyp_2", b: "che_do_an_khong_lanh_manh", fact_id: "480be30c5a2e", evidence: "hoặc người bệnh thiếu hụt sản xuất insulin và cần thay thế insulin. Ngoài ra, một số yếu tố khác liên quan đến thói quen sống như không tập thể dục thường xuyên, thừa cân, béo phì (đặc biệt béo bụng), chế độ ăn không lành mạnh, tiền sử gia đình, tuổi cao, ngoài ra còn gặp ở người có tiền sử đái tháo đường thai kỳ, buồng trứng đa nang (PCOS), rối loạn giấc ngủ/ngưng thở khi ngủ, dùng glucocorticoid kéo dài, hút thuốc, uống rượu bia nhiều là nguy cơ khởi phát bệnh."},
    {a: "dai_thao_duong_tuyp_2", b: "tien_su_gia_dinh", fact_id: "c67c9d0e0def", evidence: "hoặc người bệnh thiếu hụt sản xuất insulin và cần thay thế insulin. Ngoài ra, một số yếu tố khác liên quan đến thói quen sống như không tập thể dục thường xuyên, thừa cân, béo phì (đặc biệt béo bụng), chế độ ăn không lành mạnh, tiền sử gia đình, tuổi cao, ngoài ra còn gặp ở người có tiền sử đái tháo đường thai kỳ, buồng trứng đa nang (PCOS), rối loạn giấc ngủ/ngưng thở khi ngủ, dùng glucocorticoid kéo dài, hút thuốc, uống rượu bia nhiều là nguy cơ khởi phát bệnh."},
    {a: "dai_thao_duong_tuyp_2", b: "tuoi_cao", fact_id: "741d5fccabf1", evidence: "hoặc người bệnh thiếu hụt sản xuất insulin và cần thay thế insulin. Ngoài ra, một số yếu tố khác liên quan đến thói quen sống như không tập thể dục thường xuyên, thừa cân, béo phì (đặc biệt béo bụng), chế độ ăn không lành mạnh, tiền sử gia đình, tuổi cao, ngoài ra còn gặp ở người có tiền sử đái tháo đường thai kỳ, buồng trứng đa nang (PCOS), rối loạn giấc ngủ/ngưng thở khi ngủ, dùng glucocorticoid kéo dài, hút thuốc, uống rượu bia nhiều là nguy cơ khởi phát bệnh."},
    {a: "dai_thao_duong_tuyp_2", b: "tien_su_dai_thao_duong_thai_ky", fact_id: "80c677b28965", evidence: "hoặc người bệnh thiếu hụt sản xuất insulin và cần thay thế insulin. Ngoài ra, một số yếu tố khác liên quan đến thói quen sống như không tập thể dục thường xuyên, thừa cân, béo phì (đặc biệt béo bụng), chế độ ăn không lành mạnh, tiền sử gia đình, tuổi cao, ngoài ra còn gặp ở người có tiền sử đái tháo đường thai kỳ, buồng trứng đa nang (PCOS), rối loạn giấc ngủ/ngưng thở khi ngủ, dùng glucocorticoid kéo dài, hút thuốc, uống rượu bia nhiều là nguy cơ khởi phát bệnh."},
    {a: "dai_thao_duong_tuyp_2", b: "buong_trung_da_nang_pcos", fact_id: "39b7d3e58b83", evidence: "hoặc người bệnh thiếu hụt sản xuất insulin và cần thay thế insulin. Ngoài ra, một số yếu tố khác liên quan đến thói quen sống như không tập thể dục thường xuyên, thừa cân, béo phì (đặc biệt béo bụng), chế độ ăn không lành mạnh, tiền sử gia đình, tuổi cao, ngoài ra còn gặp ở người có tiền sử đái tháo đường thai kỳ, buồng trứng đa nang (PCOS), rối loạn giấc ngủ/ngưng thở khi ngủ, dùng glucocorticoid kéo dài, hút thuốc, uống rượu bia nhiều là nguy cơ khởi phát bệnh."},
    {a: "dai_thao_duong_tuyp_2", b: "roi_loan_giac_ngu_ngung_tho_khi_ngu", fact_id: "007e7f92b8e8", evidence: "hoặc người bệnh thiếu hụt sản xuất insulin và cần thay thế insulin. Ngoài ra, một số yếu tố khác liên quan đến thói quen sống như không tập thể dục thường xuyên, thừa cân, béo phì (đặc biệt béo bụng), chế độ ăn không lành mạnh, tiền sử gia đình, tuổi cao, ngoài ra còn gặp ở người có tiền sử đái tháo đường thai kỳ, buồng trứng đa nang (PCOS), rối loạn giấc ngủ/ngưng thở khi ngủ, dùng glucocorticoid kéo dài, hút thuốc, uống rượu bia nhiều là nguy cơ khởi phát bệnh."},
    {a: "dai_thao_duong_tuyp_2", b: "dung_glucocorticoid_keo_dai", fact_id: "84d0e1b3d1cf", evidence: "hoặc người bệnh thiếu hụt sản xuất insulin và cần thay thế insulin. Ngoài ra, một số yếu tố khác liên quan đến thói quen sống như không tập thể dục thường xuyên, thừa cân, béo phì (đặc biệt béo bụng), chế độ ăn không lành mạnh, tiền sử gia đình, tuổi cao, ngoài ra còn gặp ở người có tiền sử đái tháo đường thai kỳ, buồng trứng đa nang (PCOS), rối loạn giấc ngủ/ngưng thở khi ngủ, dùng glucocorticoid kéo dài, hút thuốc, uống rượu bia nhiều là nguy cơ khởi phát bệnh."},
    {a: "dai_thao_duong_tuyp_2", b: "hut_thuoc_la", fact_id: "f53ffc479144", evidence: "hoặc người bệnh thiếu hụt sản xuất insulin và cần thay thế insulin. Ngoài ra, một số yếu tố khác liên quan đến thói quen sống như không tập thể dục thường xuyên, thừa cân, béo phì (đặc biệt béo bụng), chế độ ăn không lành mạnh, tiền sử gia đình, tuổi cao, ngoài ra còn gặp ở người có tiền sử đái tháo đường thai kỳ, buồng trứng đa nang (PCOS), rối loạn giấc ngủ/ngưng thở khi ngủ, dùng glucocorticoid kéo dài, hút thuốc, uống rượu bia nhiều là nguy cơ khởi phát bệnh."},
    {a: "dai_thao_duong_tuyp_2", b: "uong_ruou_bia_nhieu", fact_id: "6c414832730c", evidence: "hoặc người bệnh thiếu hụt sản xuất insulin và cần thay thế insulin. Ngoài ra, một số yếu tố khác liên quan đến thói quen sống như không tập thể dục thường xuyên, thừa cân, béo phì (đặc biệt béo bụng), chế độ ăn không lành mạnh, tiền sử gia đình, tuổi cao, ngoài ra còn gặp ở người có tiền sử đái tháo đường thai kỳ, buồng trứng đa nang (PCOS), rối loạn giấc ngủ/ngưng thở khi ngủ, dùng glucocorticoid kéo dài, hút thuốc, uống rượu bia nhiều là nguy cơ khởi phát bệnh."},
    {a: "dai_thao_duong_tuyp_1", b: "tac_nhan_moi_truong", fact_id: "43df657b1967", evidence: "Hiện nguyên nhân gây nên tiểu đường tuýp 1 vẫn được các nhà khoa học tiếp tục nghiên cứu, trong đó không loại trừ khả năng liên quan đến yếu tố di truyền, có thể bị khởi phát bởi tác nhân môi trường (ví dụ: nhiễm siêu vi, rối loạn miễn dịch sau nhiễm)."}
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
    {a: "bien_co_tim_mach", b: "dai_thao_duong_tuyp_2", fact_id: "661b59277646", evidence: "Trong bối cảnh điều trị ngày càng cá thể hóa, hoạt chất semaglutide được tìm thấy trong thuốc tiêm Ozempic ® – là một đồng vận thụ thể GLP‑1 đã được nghiên cứu lâm sàng với hiệu quả rõ rệt trong cải thiện chỉ số HbA1c, hỗ trợ giảm cân và làm giảm nguy cơ biến cố tim mạch ở bệnh nhân đái tháo đường type 2."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:HAS_COMPLICATION {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_5
}
RETURN source.id AS source_id, concept_count,
       rel_count_1 + rel_count_2 + rel_count_3 + rel_count_4 + rel_count_5 AS fact_count;
