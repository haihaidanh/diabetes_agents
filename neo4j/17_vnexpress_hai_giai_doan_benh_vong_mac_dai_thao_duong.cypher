MERGE (source:DiabetesSource {id: "vnexpress_hai_giai_doan_benh_vong_mac_dai_thao_duong"})
SET source += {id: "vnexpress_hai_giai_doan_benh_vong_mac_dai_thao_duong", title: "Hai giai doan benh vong mac dai thao duong", publisher: "VnExpress", url: "https://vnexpress.net/hai-giai-doan-benh-vong-mac-dai-thao-duong-5134936.html", language: "vi", title_requires_review: true}
WITH source
CALL {
  WITH source
  UNWIND [
    {id: "benh_vong_mac_dai_thao_duong", name: "Bệnh võng mạc đái tháo đường", category: "disease"},
    {id: "nhin_mo", name: "Nhìn mờ", category: "symptom"},
    {id: "mo_mat_tham_chi_mu_loa", name: "Mờ mắt, thâm chi mu loa", category: "symptom"},
    {id: "khong_gay_dau", name: "Không gây đau", category: "symptom"},
    {id: "hinh_anh_meo", name: "Hình ảnh méo", category: "symptom"},
    {id: "xuat_hien_cham_den", name: "Xuất hiện chấm đen", category: "symptom"},
    {id: "chop_sang", name: "Chớp sáng", category: "symptom"},
    {id: "vung_toi_hoac_khoang_trong_trong_tam_nhin", name: "Vùng tối hoặc khoảng trống trong tầm nhìn", category: "symptom"},
    {id: "kham_mat", name: "Khám mắt", category: "test"},
    {id: "chup_day_mat", name: "Chụp đáy mắt", category: "test"},
    {id: "chup_cat_lop_quang_hoc_vong_mac_oct", name: "Chụp cắt lớp quang học võng mạc (OCT)", category: "test"},
    {id: "chup_mach_huynh_quang", name: "Chụp mạch huỳnh quang", category: "test"},
    {id: "dai_thao_duong", name: "Đái tháo đường", category: "disease"},
    {id: "dai_thao_duong_type_1_hoac_2", name: "Đái tháo đường type 1 hoặc 2", category: "risk_factor"},
    {id: "kiem_soat_duong_huyet_huyet_ap_va_mo_mau", name: "Kiểm soát đường huyết, huyết áp và mỡ máu", category: "lifestyle"},
    {id: "dung_thuoc_theo_chi_dinh", name: "Dùng thuốc theo chỉ định", category: "lifestyle"},
    {id: "tranh_hut_thuoc", name: "Tránh hút thuốc", category: "lifestyle"},
    {id: "kham_mat_it_nhat_moi_nam_mot_lan", name: "Khám mắt ít nhất mỗi năm một lần", category: "lifestyle"},
    {id: "tap_the_duc_thuong_xuyen", name: "Tập thể dục thường xuyên", category: "lifestyle"},
    {id: "vong_mac_dai_thao_duong", name: "Võng mạc đái tháo đường", category: "disease"},
    {id: "phu_hoang_diem_do_dai_thao_duong", name: "Phù hoàng điểm do đái tháo đường", category: "symptom"},
    {id: "benh_vong_mac_dai_thao_duong_tang_sinh", name: "Bệnh võng mạc đái tháo đường tăng sinh", category: "disease"},
    {id: "thieu_mau", name: "Thiếu máu", category: "risk_factor"},
    {id: "thieu_mau_va_oxy", name: "Thiếu máu và oxy", category: "risk_factor"}
  ] AS row
  MERGE (n:DiabetesConcept {id: row.id})
  SET n += row
  MERGE (source)-[:MENTIONS]->(n)
  RETURN count(*) AS concept_count
}
CALL {
  WITH source
  UNWIND [
    {a: "benh_vong_mac_dai_thao_duong", b: "nhin_mo", fact_id: "c158a8ae6ced", evidence: "Khi tổn thương tiến triển, người bệnh có thể nhìn mờ, hình ảnh méo, xuất hiện chấm đen, chớp sáng, vùng tối hoặc khoảng trống trong tầm nhìn; thị lực có thể giảm dần hoặc đột ngột."},
    {a: "benh_vong_mac_dai_thao_duong", b: "mo_mat_tham_chi_mu_loa", fact_id: "8b87a6f7a5f2", evidence: "Bệnh võng mạc đái tháo đường gồm hai giai đoạn tăng sinh và không tăng sinh, có thể gây mờ mắt, thậm chí mù lòa."},
    {a: "benh_vong_mac_dai_thao_duong", b: "khong_gay_dau", fact_id: "5fb8006c02b2", evidence: "Bác sĩ Huyền cho biết bệnh thường không gây đau và có thể chưa ảnh hưởng rõ đến thị lực trong giai đoạn đầu."},
    {a: "benh_vong_mac_dai_thao_duong", b: "hinh_anh_meo", fact_id: "53c6456a335f", evidence: "Khi tổn thương tiến triển, người bệnh có thể nhìn mờ, hình ảnh méo, xuất hiện chấm đen, chớp sáng, vùng tối hoặc khoảng trống trong tầm nhìn; thị lực có thể giảm dần hoặc đột ngột."},
    {a: "benh_vong_mac_dai_thao_duong", b: "xuat_hien_cham_den", fact_id: "d2d2cd1bc025", evidence: "Khi tổn thương tiến triển, người bệnh có thể nhìn mờ, hình ảnh méo, xuất hiện chấm đen, chớp sáng, vùng tối hoặc khoảng trống trong tầm nhìn; thị lực có thể giảm dần hoặc đột ngột."},
    {a: "benh_vong_mac_dai_thao_duong", b: "chop_sang", fact_id: "6334672a0269", evidence: "Khi tổn thương tiến triển, người bệnh có thể nhìn mờ, hình ảnh méo, xuất hiện chấm đen, chớp sáng, vùng tối hoặc khoảng trống trong tầm nhìn; thị lực có thể giảm dần hoặc đột ngột."},
    {a: "benh_vong_mac_dai_thao_duong", b: "vung_toi_hoac_khoang_trong_trong_tam_nhin", fact_id: "9eb909f3dd90", evidence: "Khi tổn thương tiến triển, người bệnh có thể nhìn mờ, hình ảnh méo, xuất hiện chấm đen, chớp sáng, vùng tối hoặc khoảng trống trong tầm nhìn; thị lực có thể giảm dần hoặc đột ngột."},
    {a: "vong_mac_dai_thao_duong", b: "phu_hoang_diem_do_dai_thao_duong", fact_id: "9df3e89f2237", evidence: "Một biến chứng có thể xuất hiện ngay ở giai đoạn này là phù hoàng điểm do đái tháo đường."}
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
    {a: "benh_vong_mac_dai_thao_duong", b: "kham_mat", fact_id: "d561fe240f92", evidence: "Bác sĩ Huyền khuyến cáo người mắc đái tháo đường nên khám mắt ít nhất mỗi năm một lần, ngay cả khi thị lực bình thường."},
    {a: "benh_vong_mac_dai_thao_duong", b: "chup_day_mat", fact_id: "3a7e64b8ddd9", evidence: "Bác sĩ Huyền khuyến cáo người mắc đái tháo đường nên khám mắt ít nhất mỗi năm một lần, ngay cả khi thị lực bình thường. Tùy tình trạng, bác sĩ có thể chỉ định chụp đáy mắt, chụp cắt lớp quang học võng mạc (OCT) hoặc chụp mạch huỳnh quang để đánh giá tổn thương."},
    {a: "benh_vong_mac_dai_thao_duong", b: "chup_cat_lop_quang_hoc_vong_mac_oct", fact_id: "7b905a8990a6", evidence: "Bác sĩ Huyền khuyến cáo người mắc đái tháo đường nên khám mắt ít nhất mỗi năm một lần, ngay cả khi thị lực bình thường. Tùy tình trạng, bác sĩ có thể chỉ định chụp đáy mắt, chụp cắt lớp quang học võng mạc (OCT) hoặc chụp mạch huỳnh quang để đánh giá tổn thương."},
    {a: "benh_vong_mac_dai_thao_duong", b: "chup_mach_huynh_quang", fact_id: "04ee70f8f33e", evidence: "Bác sĩ Huyền khuyến cáo người mắc đái tháo đường nên khám mắt ít nhất mỗi năm một lần, ngay cả khi thị lực bình thường. Tùy tình trạng, bác sĩ có thể chỉ định chụp đáy mắt, chụp cắt lớp quang học võng mạc (OCT) hoặc chụp mạch huỳnh quang để đánh giá tổn thương."}
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
    {a: "benh_vong_mac_dai_thao_duong", b: "dai_thao_duong", fact_id: "666db6e5b854", evidence: "Ở người mắc đái tháo đường, đường huyết tăng cao kéo dài có thể làm tổn thương các mạch máu nhỏ nuôi võng mạc, khiến thành mạch rò rỉ dịch, chảy máu hoặc tắc nghẽn."},
    {a: "benh_vong_mac_dai_thao_duong", b: "dai_thao_duong_type_1_hoac_2", fact_id: "d3bae3590733", evidence: "Theo ThS.BS Lê Thanh Huyền, Trung tâm Mắt công nghệ cao, Bệnh viện Đa khoa Tâm Anh Hà Nội, bệnh có thể xuất hiện ở người mắc đái tháo đường type 1 hoặc 2."},
    {a: "benh_vong_mac_dai_thao_duong_tang_sinh", b: "thieu_mau", fact_id: "a0bc39076733", evidence: "Đây là giai đoạn tiến triển nặng, xảy ra khi tình trạng thiếu máu kích thích võng mạc hình thành các mạch máu mới bất thường."},
    {a: "benh_vong_mac_dai_thao_duong_tang_sinh", b: "thieu_mau_va_oxy", fact_id: "86a4c4f62458", evidence: "Khi võng mạc thiếu máu và oxy, các mạch máu mới bất thường có thể hình thành."}
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
    {a: "benh_vong_mac_dai_thao_duong", b: "kiem_soat_duong_huyet_huyet_ap_va_mo_mau", fact_id: "7d2bb2f7fc7a", evidence: "Phương pháp điều trị tùy thuộc vào giai đoạn bệnh và mức độ tổn thương. Với bệnh không tăng sinh nhẹ hoặc trung bình, bác sĩ có thể theo dõi định kỳ, kết hợp kiểm soát đường huyết, huyết áp và mỡ máu."},
    {a: "benh_vong_mac_dai_thao_duong", b: "dung_thuoc_theo_chi_dinh", fact_id: "ff16f9b01da7", evidence: "Người bệnh cần kiểm soát đường huyết, huyết áp và mỡ máu, dùng thuốc theo chỉ định, vận động thường xuyên và tránh hút thuốc."},
    {a: "benh_vong_mac_dai_thao_duong", b: "tranh_hut_thuoc", fact_id: "fb90f497cb4d", evidence: "Người bệnh cần kiểm soát đường huyết, huyết áp và mỡ máu, dùng thuốc theo chỉ định, vận động thường xuyên và tránh hút thuốc."},
    {a: "benh_vong_mac_dai_thao_duong", b: "kham_mat_it_nhat_moi_nam_mot_lan", fact_id: "7009f1fbc56e", evidence: "Bác sĩ Huyền khuyến cáo người mắc đái tháo đường nên khám mắt ít nhất mỗi năm một lần, ngay cả khi thị lực bình thường."},
    {a: "benh_vong_mac_dai_thao_duong", b: "tap_the_duc_thuong_xuyen", fact_id: "3ab49801a36d", evidence: "Người bệnh cần kiểm soát đường huyết, huyết áp và mỡ máu, dùng thuốc theo chỉ định, vận động thường xuyên và tránh hút thuốc."}
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
    {a: "vong_mac_dai_thao_duong", b: "benh_vong_mac_dai_thao_duong_tang_sinh", fact_id: "42010412a39c", evidence: "Bệnh võng mạc đái tháo đường tăng sinh"}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:HAS_COMPLICATION {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_5
}
RETURN source.id AS source_id, concept_count,
       rel_count_1 + rel_count_2 + rel_count_3 + rel_count_4 + rel_count_5 AS fact_count;
