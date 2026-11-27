MERGE (source:DiabetesSource {id: "nhathuoclongchau_tieu_duong_tuyp_1"})
SET source += {id: "nhathuoclongchau_tieu_duong_tuyp_1", title: "Tieu duong tuyp 1", publisher: "Nhà thuốc Long Châu", url: "https://nhathuoclongchau.com.vn/benh/tieu-duong-tuyp-1.html", language: "vi", title_requires_review: true}
WITH source
CALL {
  WITH source
  UNWIND [
    {id: "dai_thao_duong", name: "Đái tháo đường", category: "disease"},
    {id: "hba1c", name: "HbA1c", category: "disease"},
    {id: "duong_huyet_luc_doi", name: "Đường huyết lúc đói", category: "test"},
    {id: "duong_huyet_sau_2_gio_ogtt", name: "Đường huyết sau 2 giờ (OGTT)", category: "test"},
    {id: "dai_thao_duong_tuyp_1", name: "Đái tháo đường tuýp 1", category: "disease"},
    {id: "que_thu_duong_huyet", name: "Que thử đường huyết", category: "symptom"},
    {id: "ban_chan_tieu_duong", name: "Bàn chân tiểu đường", category: "disease"},
    {id: "benh_mach_vanh", name: "Bệnh mạch vành", category: "disease"},
    {id: "nhoi_mau_co_tim", name: "Nhồi máu cơ tim", category: "disease"},
    {id: "benh_vong_mac_do_tieu_duong", name: "Bệnh võng mạc do tiểu đường", category: "disease"},
    {id: "benh_than_do_dai_thao_duong", name: "Bệnh thận do đái tháo đường", category: "disease"},
    {id: "bien_chung_than_kinh", name: "Biến chứng thần kinh", category: "disease"},
    {id: "benh_mach_mau_ngoai_bien", name: "Bệnh mạch máu ngoại biên", category: "disease"},
    {id: "giam_thi_luc", name: "Giảm thị lực", category: "disease"},
    {id: "dinh_luong_nong_do_insulin_mau", name: "Định lượng nồng độ insulin máu", category: "test"},
    {id: "nghiem_phap_glucagon", name: "Nghiệm pháp glucagon", category: "test"},
    {id: "xet_nghiem_tu_khang_the", name: "Xét nghiệm tự kháng thể", category: "test"},
    {id: "dinh_luong_peptid_c", name: "Định lượng peptid C", category: "test"},
    {id: "bat_thuong_mien_dich", name: "Bất thường miễn dịch", category: "risk_factor"},
    {id: "di_truyen", name: "Di truyền", category: "risk_factor"},
    {id: "do_tuoi", name: "Độ tuổi", category: "risk_factor"},
    {id: "benh_tu_mien", name: "Bệnh tự miễn", category: "risk_factor"},
    {id: "virus", name: "Virus", category: "risk_factor"},
    {id: "insulin_ngoai_sinh", name: "Insulin ngoại sinh", category: "drug"},
    {id: "thay_doi_loi_song", name: "Thay đổi lối sống", category: "lifestyle"},
    {id: "khong_hut_thuoc", name: "Không hút thuốc", category: "lifestyle"},
    {id: "tap_luyen_the_duc", name: "Tập luyện thể dục", category: "lifestyle"},
    {id: "han_che_ruou", name: "Hạn chế rượu", category: "lifestyle"},
    {id: "phong_ngua_tieu_duong_tuyp_1", name: "Phòng ngừa tiểu đường tuýp 1", category: "lifestyle"}
  ] AS row
  MERGE (n:DiabetesConcept {id: row.id})
  SET n += row
  MERGE (source)-[:MENTIONS]->(n)
  RETURN count(*) AS concept_count
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong", b: "hba1c", fact_id: "0c7e3ff604d8", op: ">=", value: 6.5, unit: "%", evidence: "Tiểu đường được chẩn đoán khi HbA1c ≥ 6,5%."},
    {a: "dai_thao_duong", b: "duong_huyet_luc_doi", fact_id: "39f39f49b2d5", op: ">=", value: 126, unit: "mg/dl", evidence: "Bệnh nhân nhịn ăn ít nhất 8 giờ, tiểu đường được chẩn đoán khi chỉ số đường huyết ≥ 126mg/dL (7,0 mmol/L)."},
    {a: "dai_thao_duong", b: "duong_huyet_sau_2_gio_ogtt", fact_id: "b577430a6add", op: ">=", value: 200, unit: "mg/dl", evidence: "Tiểu đường được chẩn đoán nếu sau 2 giờ chỉ số glucose ghi nhận ≥ 200mg/dL (11,1 mmol/L)."},
    {a: "dai_thao_duong_tuyp_1", b: "dinh_luong_nong_do_insulin_mau", fact_id: "16dca499bc9f", evidence: "Định lượng nồng độ insulin máu : Sự phá hủy các tế bào đảo tụy dẫn đến sự thiếu hụt trầm trọng insulin máu ở bệnh nhân tiểu đường tuýp 1, trong khi nồng độ này lại bình thường ở bệnh nhân tiểu đường tuýp 2."},
    {a: "dai_thao_duong_tuyp_1", b: "nghiem_phap_glucagon", fact_id: "896c4874a8a1", evidence: "Nghiệm pháp glucagon: Thực hiện bằng cách tiêm 1mg glucagon tĩnh mạch lúc đói, sau đó 6 phút sẽ tiến hành định lượng peptid C."},
    {a: "dai_thao_duong_tuyp_1", b: "xet_nghiem_tu_khang_the", fact_id: "b5c4d6b1526b", evidence: "Xét nghiệm tự kháng thể (ICA, GADA, IA - 2A, IAA): Bệnh nhân tiểu đường tuýp 1 có các tự kháng thể kháng tế bào beta đảo tụy."},
    {a: "dai_thao_duong_tuyp_1", b: "dinh_luong_peptid_c", fact_id: "a627acf42e5c", evidence: "Định lượng peptid C:"}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:DIAGNOSED_BY {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_1
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong_tuyp_1", b: "que_thu_duong_huyet", fact_id: "f2b2156a6aeb", evidence: "Thiết bị y tế Theo dõi sức khoẻ Sơ cứu, giảm đau tại chỗ Bảo hộ - Phòng ngừa Hỗ trợ hô hấp, tai mũi họng Chăm sóc mắt Phục hồi & Giảm đau cơ khớp Vận động - Chỉnh hình Dụng cụ tiêm & Lấy mẫu Chăm sóc tiêu hoá tại nhà Dụng cụ y tế Máy đo huyết áp Máy, que thử đường huyết Nhiệt kế Que thử thai, rụng trứng Kit xét nghiệm nhanh Máy đo SpO2 Bán chạy nhất Xem tất cả -15% Que thử thai hcg giúp xác định tuần tuổi thai kỳ Accufast (1 kít) 80.750đ / Hộp 95.000đ Máy đo huyết áp bắp tay omron ez 7183 hỗ trợ đo huyết áp,nhịp tim 1.090.000đ / Hộp -15% Máy đo huyết áp bắp tay Omron Ez BT Large Hem 7183T1-L (vòng bít lớn) hỗ trợ đo huyết áp,nhịp tim 1.147.500đ / Hộp 1.350.000đ Kim lấy máu Lancets Medicleen BL-28 (100 cái) 32.000đ / Hộp Nhiệt kế điện tử đo thân nhiệt Fuji DT007 69.000đ / Hộp"}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:HAS_SYMPTOM {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_2
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong_tuyp_1", b: "ban_chan_tieu_duong", fact_id: "8989f341bd3c", evidence: "Bàn chân tiểu đường"},
    {a: "dai_thao_duong_tuyp_1", b: "benh_mach_vanh", fact_id: "a94c0d47099e", evidence: "Tiểu đường làm tăng nguy cơ mắc bệnh mạch vành , nhất là bệnh lý nhồi máu cơ tim."},
    {a: "dai_thao_duong_tuyp_1", b: "nhoi_mau_co_tim", fact_id: "c80d0b36680b", evidence: "Khoảng 55% bệnh nhân tiểu đường tử vong do nhồi máu cơ tim."},
    {a: "dai_thao_duong_tuyp_1", b: "benh_vong_mac_do_tieu_duong", fact_id: "277dc79781ca", evidence: "Bệnh võng mạc do tiểu đường"},
    {a: "dai_thao_duong_tuyp_1", b: "benh_than_do_dai_thao_duong", fact_id: "de16fc6f7ec1", evidence: "Bệnh thận do đái tháo đường"},
    {a: "dai_thao_duong_tuyp_1", b: "bien_chung_than_kinh", fact_id: "5c674f266d33", evidence: "Biến chứng thần kinh"},
    {a: "dai_thao_duong_tuyp_1", b: "benh_mach_mau_ngoai_bien", fact_id: "89819dc36723", evidence: "Bệnh mạch máu ngoại biên"},
    {a: "dai_thao_duong_tuyp_1", b: "giam_thi_luc", fact_id: "c0d2d90d81e2", evidence: "Giảm thị lực là một trong những biến chứng thường gặp của bệnh nhân bị tiểu đường"}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:HAS_COMPLICATION {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_3
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong_tuyp_1", b: "bat_thuong_mien_dich", fact_id: "24409852c92c", evidence: "Điều này có nghĩa là tồn tại một bất thường miễn dịch bên trong cơ thể bệnh nhân tiểu đường tuýp 1, sinh ra các tự kháng thể gây rối loạn khả năng kiểm soát đường huyết."},
    {a: "dai_thao_duong_tuyp_1", b: "di_truyen", fact_id: "5715c1250531", evidence: "Di truyền: Nguy cơ mắc tiểu đường tuýp 1 sẽ tăng cao một khi trong gia đình có bố mẹ hoặc ông bà bị tiểu đường tuýp 1."},
    {a: "dai_thao_duong_tuyp_1", b: "do_tuoi", fact_id: "de6519c90f5a", evidence: "Độ tuổi: Đối tượng thường gặp của bệnh tiểu đường tuýp 1 chủ yếu là trẻ em, người trẻ dưới 30 tuổi, nhất là trong độ tuổi vị thành niên."},
    {a: "dai_thao_duong_tuyp_1", b: "benh_tu_mien", fact_id: "9aa1e494ec35", evidence: "Mắc một số bệnh tự miễn khác: Nguy cơ mắc tiểu đường tuýp 1 cũng tăng cao ở những bệnh nhân mắc các bệnh tự miễn khác như xơ cứng bì, basedow …"},
    {a: "dai_thao_duong_tuyp_1", b: "virus", fact_id: "2d4f74221b65", evidence: "Virus: Tiếp xúc với một số virus như virus rubella , cytomegalovirus… có thể gây hủy hoại hệ thống miễn dịch của tế bào tiểu đảo tụy."}
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
    {a: "dai_thao_duong_tuyp_1", b: "insulin_ngoai_sinh", fact_id: "ec9cf1ef019c", evidence: "Điều trị bằng insulin ngoại sinh là cách tốt nhất để bù lại lượng insulin thiếu hụt và giúp kiểm soát đường huyết ở bệnh nhân tiểu đường tuýp 1."},
    {a: "dai_thao_duong_tuyp_1", b: "thay_doi_loi_song", fact_id: "27a76af61a66", evidence: "Thay đổi lối sống:"},
    {a: "dai_thao_duong_tuyp_1", b: "khong_hut_thuoc", fact_id: "e3acf76e5fa6", evidence: "Không hút thuốc lá vì nó làm tăng nguy cơ mắc bệnh tim mạch, góp phần dẫn đến biến chứng tim mạch ở bệnh nhân tiểu đường."},
    {a: "dai_thao_duong_tuyp_1", b: "tap_luyen_the_duc", fact_id: "17ff11c4ff9c", evidence: "Bệnh nhân nên luyện tập thể dục phù hợp với sức khỏe, tuổi tác để rèn luyện sự dẻo dai, cải thiện hoạt động của tim mạch và cải thiện tâm lý."},
    {a: "dai_thao_duong_tuyp_1", b: "han_che_ruou", fact_id: "bba837a4cfaa", evidence: "Hạn chế rượu vì rượu làm lu mờ các triệu chứng hạ đường huyết."}
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
    {a: "dai_thao_duong_tuyp_1", b: "phong_ngua_tieu_duong_tuyp_1", fact_id: "e919ee630508", evidence: "Theo cơ chế bệnh sinh về bất thường trong cơ chế sản xuất kháng thể nên tiểu đường tuýp 1 không có phương pháp phòng ngừa."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:PREVENTED_BY {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_6
}
RETURN source.id AS source_id, concept_count,
       rel_count_1 + rel_count_2 + rel_count_3 + rel_count_4 + rel_count_5 + rel_count_6 AS fact_count;
