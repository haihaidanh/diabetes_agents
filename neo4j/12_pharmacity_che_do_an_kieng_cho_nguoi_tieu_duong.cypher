MERGE (source:DiabetesSource {id: "pharmacity_che_do_an_kieng_cho_nguoi_tieu_duong"})
SET source += {id: "pharmacity_che_do_an_kieng_cho_nguoi_tieu_duong", title: "Che do an kieng cho nguoi tieu duong", publisher: "Pharmacity", url: "https://www.pharmacity.vn/che-do-an-kieng-cho-nguoi-tieu-duong.htm", language: "vi", title_requires_review: true}
WITH source
CALL {
  WITH source
  UNWIND [
    {id: "dai_thao_duong", name: "Đái tháo đường", category: "disease"},
    {id: "giam_duong_huyet", name: "Giảm đường huyết", category: "symptom"},
    {id: "thoi_quen_an_uong_khoa_hoc", name: "Thói quen ăn uống khoa học", category: "lifestyle"},
    {id: "rau_xanh", name: "Rau xanh", category: "lifestyle"},
    {id: "ngu_coc_nguyen_hat", name: "Ngũ cốc nguyên hạt", category: "lifestyle"},
    {id: "ca_beo", name: "Cá béo", category: "lifestyle"},
    {id: "can_bang_giua_cac_nhom_duong_chat", name: "Cân bằng giữa các nhóm dưỡng chất", category: "lifestyle"},
    {id: "chia_nho_bua_an_trong_ngay", name: "Chia nhỏ bữa ăn trong ngày", category: "lifestyle"},
    {id: "an_uong_dung_gio", name: "Ăn uống đúng giờ", category: "lifestyle"},
    {id: "trai_cay_it_duong", name: "Trái cây ít đường", category: "lifestyle"},
    {id: "nguon_dam_nac_nhu_ca_thit_gia_cam_hoac_dau", name: "Nguồn đạm nạc như cá, thịt gia cầm hoặc đậu", category: "lifestyle"},
    {id: "chat_beo_lanh_manh_tu_dau_thuc_vat", name: "Chất béo lành mạnh từ dầu thực vật", category: "lifestyle"},
    {id: "cac_loai_hat", name: "Các loại hạt", category: "lifestyle"},
    {id: "che_do_an_khong_lanh_manh", name: "Chế độ ăn không lành mạnh", category: "risk_factor"},
    {id: "tien_su_gia_dinh_co_nguoi_mac_benh", name: "Tiền sử gia đình có người mắc bệnh", category: "risk_factor"},
    {id: "yeu_to_di_truyen", name: "Yếu tố di truyền", category: "risk_factor"},
    {id: "cang_thang_keo_dai", name: "Căng thẳng kéo dài", category: "risk_factor"},
    {id: "roi_loan_noi_tiet", name: "Rối loạn nội tiết", category: "risk_factor"},
    {id: "che_do_an_nhieu_duong_nhieu_chat_beo", name: "Chế độ ăn nhiều đường, nhiều chất béo", category: "risk_factor"},
    {id: "tuoi_tac", name: "Tuổi tác", category: "risk_factor"},
    {id: "phu_nu_tung_mac_tieu_duong_thai_ky", name: "Phụ nữ từng mắc tiểu đường thai kỳ", category: "risk_factor"},
    {id: "nguoi_co_hoi_chung_chuyen_hoa", name: "Người có hội chứng chuyển hóa", category: "risk_factor"},
    {id: "duong_tinh_luyen", name: "Đường tinh luyện", category: "risk_factor"},
    {id: "thuc_uong_co_con", name: "Thức uống có cồn", category: "risk_factor"},
    {id: "dai_thao_duong_tuyp_2", name: "Đái tháo đường tuýp 2", category: "disease"},
    {id: "thuc_pham_che_bien_san", name: "Thực phẩm chế biến sẵn", category: "risk_factor"},
    {id: "phu_gia_thuc_pham", name: "Phụ gia thực phẩm", category: "risk_factor"}
  ] AS row
  MERGE (n:DiabetesConcept {id: row.id})
  SET n += row
  MERGE (source)-[:MENTIONS]->(n)
  RETURN count(*) AS concept_count
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong", b: "giam_duong_huyet", fact_id: "49a40d087d88", evidence: "Trong một số trường hợp, rượu có thể làm giảm đường huyết, đặc biệt khi uống khi bụng đói hoặc kết hợp với thuốc hạ đường huyết."}
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
    {a: "dai_thao_duong", b: "thoi_quen_an_uong_khoa_hoc", fact_id: "d25a633653e2", evidence: "Việc lựa chọn thực phẩm phù hợp, duy trì thói quen ăn uống khoa học không chỉ giúp ổn định sức khỏe mà còn cải thiện chất lượng cuộc sống lâu dài."}
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
    {a: "dai_thao_duong", b: "rau_xanh", fact_id: "024b4d068f9e", evidence: "Người mắc tiểu đường nên ưu tiên các loại thực phẩm như ngũ cốc nguyên hạt, rau xanh, trái cây ít đường và nguồn đạm nạc như cá, thịt gia cầm hoặc đậu."},
    {a: "dai_thao_duong", b: "ngu_coc_nguyen_hat", fact_id: "51fb94f3986c", evidence: "Người mắc tiểu đường nên ưu tiên các loại thực phẩm như ngũ cốc nguyên hạt, rau xanh, trái cây ít đường và nguồn đạm nạc như cá, thịt gia cầm hoặc đậu."},
    {a: "dai_thao_duong", b: "ca_beo", fact_id: "8b09b92d5a21", evidence: "Ngoài ra, chất béo lành mạnh từ dầu thực vật, các loại hạt và cá béo cũng nên được bổ sung với lượng hợp lý để hỗ trợ sức khỏe tim mạch."},
    {a: "dai_thao_duong", b: "can_bang_giua_cac_nhom_duong_chat", fact_id: "271c7c6c9d88", evidence: "Chế độ ăn kiêng cho người tiểu đường cần đảm bảo cân bằng giữa các nhóm dưỡng chất, đồng thời kiểm soát lượng carbohydrate nạp vào cơ thể."},
    {a: "dai_thao_duong", b: "chia_nho_bua_an_trong_ngay", fact_id: "b19b0d4e7c02", evidence: "Việc chia nhỏ bữa ăn trong ngày giúp duy trì mức đường huyết ổn định và hạn chế tăng đột ngột sau ăn."},
    {a: "dai_thao_duong", b: "an_uong_dung_gio", fact_id: "941cc61f37b0", evidence: "Đồng thời, cần duy trì thói quen ăn uống đúng giờ để hỗ trợ quá trình chuyển hóa hiệu quả hơn."},
    {a: "dai_thao_duong", b: "trai_cay_it_duong", fact_id: "b59116ce4f13", evidence: "Người mắc tiểu đường nên ưu tiên các loại thực phẩm như ngũ cốc nguyên hạt, rau xanh, trái cây ít đường và nguồn đạm nạc như cá, thịt gia cầm hoặc đậu."},
    {a: "dai_thao_duong", b: "nguon_dam_nac_nhu_ca_thit_gia_cam_hoac_dau", fact_id: "e8337e707cbf", evidence: "Người mắc tiểu đường nên ưu tiên các loại thực phẩm như ngũ cốc nguyên hạt, rau xanh, trái cây ít đường và nguồn đạm nạc như cá, thịt gia cầm hoặc đậu."},
    {a: "dai_thao_duong", b: "chat_beo_lanh_manh_tu_dau_thuc_vat", fact_id: "d855df50094d", evidence: "Ngoài ra, chất béo lành mạnh từ dầu thực vật, các loại hạt và cá béo cũng nên được bổ sung với lượng hợp lý để hỗ trợ sức khỏe tim mạch."},
    {a: "dai_thao_duong", b: "cac_loai_hat", fact_id: "c5935f28f2b5", evidence: "Ngoài ra, chất béo lành mạnh từ dầu thực vật, các loại hạt và cá béo cũng nên được bổ sung với lượng hợp lý để hỗ trợ sức khỏe tim mạch."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:TREATED_BY {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_3
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong", b: "che_do_an_khong_lanh_manh", fact_id: "0a2bef6bf4d3", evidence: "Nguyên nhân gây bệnh có thể đến từ yếu tố di truyền, lối sống ít vận động, chế độ ăn uống không lành mạnh hoặc tình trạng thừa cân, béo phì."},
    {a: "dai_thao_duong", b: "tien_su_gia_dinh_co_nguoi_mac_benh", fact_id: "378b20ad3621", evidence: "Một số yếu tố nguy cơ phổ biến có thể làm tăng khả năng mắc tiểu đường bao gồm tiền sử gia đình có người mắc bệnh, thừa cân hoặc béo phì, ít vận động thể chất và chế độ ăn nhiều đường, nhiều chất béo."},
    {a: "dai_thao_duong", b: "yeu_to_di_truyen", fact_id: "19206c5b8717", evidence: "Nguyên nhân gây bệnh có thể đến từ yếu tố di truyền, lối sống ít vận động, chế độ ăn uống không lành mạnh hoặc tình trạng thừa cân, béo phì."},
    {a: "dai_thao_duong", b: "cang_thang_keo_dai", fact_id: "ae7ea273ab67", evidence: "Ngoài ra, căng thẳng kéo dài và rối loạn nội tiết cũng có thể góp phần làm tăng nguy cơ mắc bệnh."},
    {a: "dai_thao_duong", b: "roi_loan_noi_tiet", fact_id: "a8813eefc887", evidence: "Ngoài ra, căng thẳng kéo dài và rối loạn nội tiết cũng có thể góp phần làm tăng nguy cơ mắc bệnh."},
    {a: "dai_thao_duong", b: "che_do_an_nhieu_duong_nhieu_chat_beo", fact_id: "ec2f33f23bec", evidence: "Một số yếu tố nguy cơ phổ biến có thể làm tăng khả năng mắc tiểu đường bao gồm tiền sử gia đình có người mắc bệnh, thừa cân hoặc béo phì, ít vận động thể chất và chế độ ăn nhiều đường, nhiều chất béo."},
    {a: "dai_thao_duong", b: "tuoi_tac", fact_id: "0a8b04659ac5", evidence: "Bên cạnh đó, tuổi tác cũng là yếu tố quan trọng. Người trên 40 tuổi có nguy cơ cao hơn do quá trình chuyển hóa trong cơ thể suy giảm theo thời gian."},
    {a: "dai_thao_duong", b: "phu_nu_tung_mac_tieu_duong_thai_ky", fact_id: "a1187b894aff", evidence: "Ngoài ra, phụ nữ từng mắc tiểu đường thai kỳ hoặc người có hội chứng chuyển hóa cũng cần chú ý theo dõi sức khỏe thường xuyên."},
    {a: "dai_thao_duong", b: "nguoi_co_hoi_chung_chuyen_hoa", fact_id: "077c7031209c", evidence: "Ngoài ra, phụ nữ từng mắc tiểu đường thai kỳ hoặc người có hội chứng chuyển hóa cũng cần chú ý theo dõi sức khỏe thường xuyên."},
    {a: "dai_thao_duong", b: "duong_tinh_luyen", fact_id: "3ee84d1fa95e", evidence: "Các loại bánh kẹo, nước ngọt, siro hoặc thực phẩm có chứa nhiều đường tinh luyện có thể làm tăng đường huyết nhanh chóng."},
    {a: "dai_thao_duong", b: "thuc_uong_co_con", fact_id: "20bf24828bc9", evidence: "Thức uống có cồn như rượu, bia có thể ảnh hưởng đến khả năng kiểm soát đường huyết của người tiểu đường theo nhiều cách khác nhau."},
    {a: "dai_thao_duong_tuyp_2", b: "thuc_pham_che_bien_san", fact_id: "94db2c228b05", evidence: "Đồ ăn nhanh và thực phẩm chế biến sẵn thường được nhiều người lựa chọn vì tính tiện lợi, tuy nhiên lại tiềm ẩn nhiều yếu tố không có lợi cho người tiểu đường."},
    {a: "dai_thao_duong_tuyp_2", b: "phu_gia_thuc_pham", fact_id: "bdcf324aefa6", evidence: "Một số sản phẩm còn chứa phụ gia thực phẩm hoặc chất bảo quản, có thể ảnh hưởng đến sức khỏe nếu sử dụng lâu dài."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:HAS_RISK_FACTOR {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_4
}
RETURN source.id AS source_id, concept_count,
       rel_count_1 + rel_count_2 + rel_count_3 + rel_count_4 AS fact_count;
