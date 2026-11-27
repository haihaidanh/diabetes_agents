MERGE (source:DiabetesSource {id: "vinmec_nhung_cau_nguoi_benh_tieu_duong_nen_hoi_bac_si_khi_di_kham_v"})
SET source += {id: "vinmec_nhung_cau_nguoi_benh_tieu_duong_nen_hoi_bac_si_khi_di_kham_v", title: "Nhung cau nguoi benh tieu duong nen hoi bac si khi di kham vi", publisher: "Vinmec", url: "https://www.vinmec.com/vie/bai-viet/nhung-cau-nguoi-benh-tieu-duong-nen-hoi-bac-si-khi-di-kham-vi", language: "vi", title_requires_review: true}
WITH source
CALL {
  WITH source
  UNWIND [
    {id: "dai_thao_duong", name: "Đái tháo đường", category: "disease"},
    {id: "hon_me", name: "Hôn mê", category: "symptom"},
    {id: "nong_do_glucose_trong_mau", name: "Nồng độ glucose trong máu", category: "symptom"},
    {id: "dinh_duong", name: "Dinh dưỡng", category: "lifestyle"},
    {id: "tap_luyen_deu_dan_30_phut_den_1_tieng_moi_ngay", name: "Tập luyện đều đặn 30 phút đến 1 tiếng mỗi ngày", category: "lifestyle"},
    {id: "che_do_an_phu_hop", name: "Chế độ ăn phù hợp", category: "lifestyle"},
    {id: "microalbumin_nieu", name: "Microalbumin niệu", category: "test"},
    {id: "goi_sang_loc_dai_thao_duong", name: "Gói sàng lọc đái tháo đường", category: "test"},
    {id: "rau_cu_qua", name: "Rau củ quả", category: "lifestyle"},
    {id: "hoa_qua_tuoi", name: "Hoa quả tươi", category: "lifestyle"},
    {id: "cac_loai_qua_co_chua_nhieu_duong", name: "Các loại quả có chứa nhiều đường", category: "lifestyle"},
    {id: "cac_loai_hoa_qua_say", name: "Các loại hoa quả sấy", category: "lifestyle"},
    {id: "the_duc_the_thao", name: "Thể dục thể thao", category: "lifestyle"},
    {id: "thit_nac", name: "Thịt nạc", category: "lifestyle"},
    {id: "che_do_an_hop_ly", name: "Chế độ ăn hợp lý", category: "lifestyle"},
    {id: "rau_cu", name: "Rau củ", category: "lifestyle"},
    {id: "dau_do", name: "Đậu đỗ", category: "lifestyle"},
    {id: "thit_gia_cam_bo_da", name: "Thịt gia cầm bỏ da", category: "lifestyle"},
    {id: "dau_dau_nanh", name: "Dầu đậu nành", category: "lifestyle"},
    {id: "dau_me", name: "Dầu mè", category: "lifestyle"},
    {id: "dau_huong_duong", name: "Dầu hướng dương", category: "lifestyle"},
    {id: "microalbumin_nieu_cao_keo_dai_dai_dang", name: "Microalbumin niệu cao kéo dài dai dẳng", category: "risk_factor"}
  ] AS row
  MERGE (n:DiabetesConcept {id: row.id})
  SET n += row
  MERGE (source)-[:MENTIONS]->(n)
  RETURN count(*) AS concept_count
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong", b: "hon_me", fact_id: "f1a27a4c39c0", evidence: "Ăn uống đúng giờ, điều độ: Khi bạn quá đói và sử dụng thuốc giảm đường máu khiến cho đường máu của bạn bị giảm thấp. Đường máu giảm quá thấp có thể dẫn đến tình trạng hôn mê."},
    {a: "dai_thao_duong", b: "nong_do_glucose_trong_mau", fact_id: "523f2935b59d", evidence: "Dựa vào HbA1c có thể đánh giá được nồng độ glucose trong máu khoảng 3 tháng trước ngày xét nghiệm."}
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
    {a: "dai_thao_duong", b: "dinh_duong", fact_id: "8dbf3e36e551", evidence: "Bệnh đái tháo đường có liên quan rất nhiều đến dinh dưỡng, vận động và lối sống của mỗi người."},
    {a: "dai_thao_duong", b: "tap_luyen_deu_dan_30_phut_den_1_tieng_moi_ngay", fact_id: "9a838a52cfa1", evidence: "Tăng cường tập luyện, thể dục, thể thao: Không nên ngồi nhiều, nằm xem tivi. Nên tham gia các hoạt động thể dục phù hợp với sức khỏe của mình, tránh các hoạt động quá sức với bản thân. Tập luyện đều đặn 30 phút đến 1 tiếng mỗi ngày."},
    {a: "dai_thao_duong", b: "che_do_an_phu_hop", fact_id: "e469f08a771b", evidence: "Cần xây dựng một chế độ ăn phù hợp cho bản thân và gia đình: Giảm lượng chất béo và đường trong bữa ăn hằng ngày, ăn nhiều rau và quả tươi, không nên bỏ bữa hoặc ăn quá no. Hạn chế rượu bia, các chất kích thích,...."}
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
    {a: "dai_thao_duong", b: "microalbumin_nieu", fact_id: "ce52b2bda987", evidence: "Dựa vào tỉ lệ giữa microalbumin niệu/ creatinin niệu lấy lúc sáng sớm mà ta có các giá trị sau"},
    {a: "dai_thao_duong", b: "goi_sang_loc_dai_thao_duong", fact_id: "9abcd2402f05", evidence: "Tại bệnh viện Đa khoa Quốc tế Vinmec luôn triển khai Gói sàng lọc đái tháo đường, rối loạn mỡ máu nhằm giúp phát hiện sớm tình trạng tiền đái tháo đường, phân loại chính xác type tiểu đường, xây dựng chế độ dinh dưỡng, theo dõi giảm thiểu các nguy cơ, biến chứng do tiểu đường gây ra."}
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
    {a: "dai_thao_duong", b: "rau_cu_qua", fact_id: "9f4b68752887", evidence: "Nhóm rau củ quả: Bệnh nhân nên ăn nhiều chất xơ với các phương pháp chế biến là hấp, luộc,salad... Hoa quả: Nên ăn nhiều hoa quả tươi. Cần hạn chế các loại quả có chứa nhiều đường như mía, sầu riêng,..., các loại hoa quả sấy."},
    {a: "dai_thao_duong", b: "hoa_qua_tuoi", fact_id: "b29ad36f0c56", evidence: "Nhóm rau củ quả: Bệnh nhân nên ăn nhiều chất xơ với các phương pháp chế biến là hấp, luộc,salad... Hoa quả: Nên ăn nhiều hoa quả tươi. Cần hạn chế các loại quả có chứa nhiều đường như mía, sầu riêng,..., các loại hoa quả sấy."},
    {a: "dai_thao_duong", b: "cac_loai_qua_co_chua_nhieu_duong", fact_id: "a0466977d21a", evidence: "Nhóm rau củ quả: Bệnh nhân nên ăn nhiều chất xơ với các phương pháp chế biến là hấp, luộc,salad... Hoa quả: Nên ăn nhiều hoa quả tươi. Cần hạn chế các loại quả có chứa nhiều đường như mía, sầu riêng,..., các loại hoa quả sấy."},
    {a: "dai_thao_duong", b: "cac_loai_hoa_qua_say", fact_id: "ab5d0fe9ebea", evidence: "Nhóm rau củ quả: Bệnh nhân nên ăn nhiều chất xơ với các phương pháp chế biến là hấp, luộc,salad... Hoa quả: Nên ăn nhiều hoa quả tươi. Cần hạn chế các loại quả có chứa nhiều đường như mía, sầu riêng,..., các loại hoa quả sấy."},
    {a: "dai_thao_duong", b: "the_duc_the_thao", fact_id: "d1206633c717", evidence: "Cần vận động nhẹ nhàng sau khi ăn kết hợp thể dục thể thao hằng ngày để đảm bảo sức khỏe và hỗ trợ điều trị bệnh"},
    {a: "dai_thao_duong", b: "thit_nac", fact_id: "670a52611028", evidence: "Nhóm thịt cá: Bệnh nhân nên ăn cá, thịt nạc, thịt gia cầm bỏ da, nên chế biến bằng hấp, luộc hay nướng. Không nên ăn các thực phẩm xào, chiên, rán,... Không nên ăn thịt lợn mỡ, phủ tạng động vật, da của gia cầm,..."},
    {a: "dai_thao_duong", b: "che_do_an_hop_ly", fact_id: "462b3edbe321", evidence: "Đối với bệnh tiểu đường , ngoài việc dùng thuốc làm giảm đường máu thì chế độ ăn hợp lý cũng góp một nửa vào hiệu quả điều trị."},
    {a: "dai_thao_duong", b: "rau_cu", fact_id: "5d44ee68f60d", evidence: "Nhóm đường bột: Ngũ cốc nguyên hạt, rau củ, đậu đỗ,...được chế biến bằng hấp, luộc hay nướng hạn chế không xào, chiên, rán...Hạn chế các thực phẩm chứa nhiều tinh bột như cơm, các chế phẩm từ gạo như bún, phở,...các loại củ như khoai, sắn."},
    {a: "dai_thao_duong", b: "dau_do", fact_id: "0bc76190c70e", evidence: "Nhóm đường bột: Ngũ cốc nguyên hạt, rau củ, đậu đỗ,...được chế biến bằng hấp, luộc hay nướng hạn chế không xào, chiên, rán...Hạn chế các thực phẩm chứa nhiều tinh bột như cơm, các chế phẩm từ gạo như bún, phở,...các loại củ như khoai, sắn."},
    {a: "dai_thao_duong", b: "thit_gia_cam_bo_da", fact_id: "008c3119f327", evidence: "Nhóm thịt cá: Bệnh nhân nên ăn cá, thịt nạc, thịt gia cầm bỏ da, nên chế biến bằng hấp, luộc hay nướng. Không nên ăn các thực phẩm xào, chiên, rán,... Không nên ăn thịt lợn mỡ, phủ tạng động vật, da của gia cầm,..."},
    {a: "dai_thao_duong", b: "dau_dau_nanh", fact_id: "99ed33e77537", evidence: "Nhóm chất béo: Thực phẩm chứa chất béo không bão hòa được ưu tiên trong bữa ăn của người đái tháo đường. Ví dụ như: dầu đậu nành, dầu mè, dầu hướng dương,.. Hạn chế các thực phẩm chứa chất béo bão hòa, nhiều cholesterol."},
    {a: "dai_thao_duong", b: "dau_me", fact_id: "16dfd55c6bb3", evidence: "Nhóm chất béo: Thực phẩm chứa chất béo không bão hòa được ưu tiên trong bữa ăn của người đái tháo đường. Ví dụ như: dầu đậu nành, dầu mè, dầu hướng dương,.. Hạn chế các thực phẩm chứa chất béo bão hòa, nhiều cholesterol."},
    {a: "dai_thao_duong", b: "dau_huong_duong", fact_id: "01aad5bcf627", evidence: "Nhóm chất béo: Thực phẩm chứa chất béo không bão hòa được ưu tiên trong bữa ăn của người đái tháo đường. Ví dụ như: dầu đậu nành, dầu mè, dầu hướng dương,.. Hạn chế các thực phẩm chứa chất béo bão hòa, nhiều cholesterol."}
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
    {a: "dai_thao_duong", b: "microalbumin_nieu_cao_keo_dai_dai_dang", fact_id: "1575523163c4", evidence: "Microalbumin niệu cao kéo dài dai dẳng phải được coi là một yếu tố nguy cơ cao không chỉ đối với các biến chứng về thận mà còn được phản ánh về biến chứng tim mạch của bệnh đái tháo đường."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:HAS_RISK_FACTOR {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_5
}
RETURN source.id AS source_id, concept_count,
       rel_count_1 + rel_count_2 + rel_count_3 + rel_count_4 + rel_count_5 AS fact_count;
