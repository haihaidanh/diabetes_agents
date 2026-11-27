MERGE (source:DiabetesSource {id: "tamanhhospital_trieu_chung_benh_tieu_duong_giai_doan_dau"})
SET source += {id: "tamanhhospital_trieu_chung_benh_tieu_duong_giai_doan_dau", title: "Trieu chung benh tieu duong giai doan dau", publisher: "Bệnh viện Tâm Anh", url: "https://tamanhhospital.vn/trieu-chung-benh-tieu-duong-giai-doan-dau/", language: "vi", title_requires_review: true}
WITH source
CALL {
  WITH source
  UNWIND [
    {id: "dai_thao_duong", name: "Đái tháo đường", category: "disease"},
    {id: "khat_nuoc_nhieu", name: "Khát nước nhiều", category: "symptom"},
    {id: "di_tieu_thuong_xuyen", name: "Đi tiểu thường xuyên", category: "symptom"},
    {id: "sut_can_khong_ro_nguyen_nhan", name: "Sụt cân không rõ nguyên nhân", category: "symptom"},
    {id: "de_cau_gat_hoac_thay_doi_tam_trang", name: "Dễ cáu gắt hoặc thay đổi tâm trạng", category: "symptom"},
    {id: "xet_nghiem", name: "Xét nghiệm", category: "test"},
    {id: "xet_nghiem_duong_huyet", name: "Xét nghiệm đường huyết", category: "test"},
    {id: "chan_doan_va_tu_van_boi_nhan_vien_y_te", name: "Chẩn đoán và tư vấn bởi nhân viên y tế", category: "test"},
    {id: "duong_huyet_cao", name: "Đường huyết cao", category: "risk_factor"},
    {id: "nhom_nguy_co", name: "Nhóm nguy cơ", category: "risk_factor"},
    {id: "dai_thao_duong_tuyp_2", name: "Đái tháo đường tuýp 2", category: "disease"},
    {id: "it_van_dong", name: "Ít vận động", category: "risk_factor"},
    {id: "roi_loan_mo_mau", name: "Rối loạn mỡ máu", category: "risk_factor"},
    {id: "gan_nhiem_mo", name: "Gan nhiễm mỡ", category: "risk_factor"},
    {id: "benh_tieu_duong_giai_doan_dau", name: "Bệnh tiểu đường giai đoạn đầu", category: "disease"},
    {id: "met_moi", name: "Mệt mỏi", category: "symptom"},
    {id: "nhin_mo", name: "Nhìn mờ", category: "symptom"},
    {id: "vet_thuong_lau_lanh", name: "Vết thương lâu lành", category: "symptom"},
    {id: "di_tieu_nhieu_hon_binh_thuong", name: "Đi tiểu nhiều hơn bình thường", category: "symptom"},
    {id: "sut_can_khong_chu_y", name: "Sụt cân không chủ ý", category: "symptom"},
    {id: "te_hoac_cham_chich_o_ban_tay_ban_chan", name: "Tê hoặc châm chích ở bàn tay, bàn chân", category: "symptom"},
    {id: "nhiem_trung_tai_dien", name: "Nhiễm trùng tái diễn", category: "symptom"},
    {id: "tieu_duong_giai_doan_dau", name: "Tiểu đường giai đoạn đầu", category: "disease"},
    {id: "khat_nuoc_lien_tuc", name: "Khát nước liên tục", category: "symptom"},
    {id: "nhanh_doi", name: "Nhanh đói", category: "symptom"},
    {id: "di_tieu_nhieu", name: "Đi tiểu nhiều", category: "side_effect"},
    {id: "beo_phi", name: "Béo phì", category: "risk_factor"},
    {id: "thua_can", name: "Thừa cân", category: "risk_factor"},
    {id: "co_nguoi_than_mac_benh_tieu_duong", name: "Có người thân mắc bệnh tiểu đường", category: "risk_factor"}
  ] AS row
  MERGE (n:DiabetesConcept {id: row.id})
  SET n += row
  MERGE (source)-[:MENTIONS]->(n)
  RETURN count(*) AS concept_count
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong", b: "khat_nuoc_nhieu", fact_id: "a942ce1b1358", evidence: "Các triệu chứng bệnh tiểu đường giai đoạn đầu thường không rõ ràng. Tuy nhiên, khi đường huyết tăng cao , cơ thể có thể xuất hiện một số thay đổi đáng chú ý như khát nước nhiều, đi tiểu thường xuyên, nhanh đói, mệt mỏi, nhìn mờ hoặc sụt cân không rõ nguyên nhân."},
    {a: "dai_thao_duong", b: "di_tieu_thuong_xuyen", fact_id: "d80996461427", evidence: "Các triệu chứng bệnh tiểu đường giai đoạn đầu thường không rõ ràng. Tuy nhiên, khi đường huyết tăng cao , cơ thể có thể xuất hiện một số thay đổi đáng chú ý như khát nước nhiều, đi tiểu thường xuyên, nhanh đói, mệt mỏi, nhìn mờ hoặc sụt cân không rõ nguyên nhân."},
    {a: "dai_thao_duong", b: "sut_can_khong_ro_nguyen_nhan", fact_id: "c3d6891218e3", evidence: "Các triệu chứng bệnh tiểu đường giai đoạn đầu thường không rõ ràng. Tuy nhiên, khi đường huyết tăng cao , cơ thể có thể xuất hiện một số thay đổi đáng chú ý như khát nước nhiều, đi tiểu thường xuyên, nhanh đói, mệt mỏi, nhìn mờ hoặc sụt cân không rõ nguyên nhân."},
    {a: "dai_thao_duong", b: "de_cau_gat_hoac_thay_doi_tam_trang", fact_id: "147d5d74d251", evidence: "Đường huyết tăng hoặc thay đổi thất thường có thể khiến một số người cảm thấy mệt mỏi, khó tập trung, dễ cáu gắt hoặc thay đổi tâm trạng."},
    {a: "benh_tieu_duong_giai_doan_dau", b: "met_moi", fact_id: "4bb80982f74c", evidence: "Người bệnh có thể xuất hiện triệu chứng thường xuyên khát nước, đi tiểu nhiều hơn bình thường, nhanh đói, mệt mỏi, nhìn mờ hoặc sụt cân không chủ ý, vết thương lâu lành, tê hoặc châm chích ở bàn tay, bàn chân hay nhiễm trùng tái diễn."},
    {a: "benh_tieu_duong_giai_doan_dau", b: "nhin_mo", fact_id: "c633c7a03cba", evidence: "Người bệnh có thể xuất hiện triệu chứng thường xuyên khát nước, đi tiểu nhiều hơn bình thường, nhanh đói, mệt mỏi, nhìn mờ hoặc sụt cân không chủ ý, vết thương lâu lành, tê hoặc châm chích ở bàn tay, bàn chân hay nhiễm trùng tái diễn."},
    {a: "benh_tieu_duong_giai_doan_dau", b: "vet_thuong_lau_lanh", fact_id: "618c654653d0", evidence: "Người bệnh có thể xuất hiện triệu chứng thường xuyên khát nước, đi tiểu nhiều hơn bình thường, nhanh đói, mệt mỏi, nhìn mờ hoặc sụt cân không chủ ý, vết thương lâu lành, tê hoặc châm chích ở bàn tay, bàn chân hay nhiễm trùng tái diễn."},
    {a: "benh_tieu_duong_giai_doan_dau", b: "di_tieu_nhieu_hon_binh_thuong", fact_id: "e08c3abab5ed", evidence: "Người bệnh có thể xuất hiện triệu chứng thường xuyên khát nước, đi tiểu nhiều hơn bình thường, nhanh đói, mệt mỏi, nhìn mờ hoặc sụt cân không chủ ý, vết thương lâu lành, tê hoặc châm chích ở bàn tay, bàn chân hay nhiễm trùng tái diễn."},
    {a: "benh_tieu_duong_giai_doan_dau", b: "sut_can_khong_chu_y", fact_id: "b24b51ee9a3c", evidence: "Người bệnh có thể xuất hiện triệu chứng thường xuyên khát nước, đi tiểu nhiều hơn bình thường, nhanh đói, mệt mỏi, nhìn mờ hoặc sụt cân không chủ ý, vết thương lâu lành, tê hoặc châm chích ở bàn tay, bàn chân hay nhiễm trùng tái diễn."},
    {a: "benh_tieu_duong_giai_doan_dau", b: "te_hoac_cham_chich_o_ban_tay_ban_chan", fact_id: "b9505bc71401", evidence: "Người bệnh có thể xuất hiện triệu chứng thường xuyên khát nước, đi tiểu nhiều hơn bình thường, nhanh đói, mệt mỏi, nhìn mờ hoặc sụt cân không chủ ý, vết thương lâu lành, tê hoặc châm chích ở bàn tay, bàn chân hay nhiễm trùng tái diễn."},
    {a: "benh_tieu_duong_giai_doan_dau", b: "nhiem_trung_tai_dien", fact_id: "56d5495de128", evidence: "Người bệnh có thể xuất hiện triệu chứng thường xuyên khát nước, đi tiểu nhiều hơn bình thường, nhanh đói, mệt mỏi, nhìn mờ hoặc sụt cân không chủ ý, vết thương lâu lành, tê hoặc châm chích ở bàn tay, bàn chân hay nhiễm trùng tái diễn."},
    {a: "tieu_duong_giai_doan_dau", b: "met_moi", fact_id: "8c26971767f5", evidence: "Người có các dấu hiệu như tiểu nhiều, khát nước liên tục, nhanh đói, mệt mỏi, sụt cân không chủ ý hoặc nhìn mờ nên đi khám và xét nghiệm đường huyết, đặc biệt khi nhiều triệu chứng bệnh tiểu đường giai đoạn đầu xuất hiện cùng lúc hoặc kéo dài không rõ nguyên nhân."},
    {a: "tieu_duong_giai_doan_dau", b: "nhin_mo", fact_id: "60e7eaa3f06c", evidence: "Người có các dấu hiệu như tiểu nhiều, khát nước liên tục, nhanh đói, mệt mỏi, sụt cân không chủ ý hoặc nhìn mờ nên đi khám và xét nghiệm đường huyết, đặc biệt khi nhiều triệu chứng bệnh tiểu đường giai đoạn đầu xuất hiện cùng lúc hoặc kéo dài không rõ nguyên nhân."},
    {a: "tieu_duong_giai_doan_dau", b: "sut_can_khong_chu_y", fact_id: "98bf6df2708b", evidence: "Người có các dấu hiệu như tiểu nhiều, khát nước liên tục, nhanh đói, mệt mỏi, sụt cân không chủ ý hoặc nhìn mờ nên đi khám và xét nghiệm đường huyết, đặc biệt khi nhiều triệu chứng bệnh tiểu đường giai đoạn đầu xuất hiện cùng lúc hoặc kéo dài không rõ nguyên nhân."},
    {a: "tieu_duong_giai_doan_dau", b: "khat_nuoc_lien_tuc", fact_id: "48a4b4f9498c", evidence: "Người có các dấu hiệu như tiểu nhiều, khát nước liên tục, nhanh đói, mệt mỏi, sụt cân không chủ ý hoặc nhìn mờ nên đi khám và xét nghiệm đường huyết, đặc biệt khi nhiều triệu chứng bệnh tiểu đường giai đoạn đầu xuất hiện cùng lúc hoặc kéo dài không rõ nguyên nhân."},
    {a: "tieu_duong_giai_doan_dau", b: "nhanh_doi", fact_id: "7a9afea84c08", evidence: "Người có các dấu hiệu như tiểu nhiều, khát nước liên tục, nhanh đói, mệt mỏi, sụt cân không chủ ý hoặc nhìn mờ nên đi khám và xét nghiệm đường huyết, đặc biệt khi nhiều triệu chứng bệnh tiểu đường giai đoạn đầu xuất hiện cùng lúc hoặc kéo dài không rõ nguyên nhân."},
    {a: "tieu_duong_giai_doan_dau", b: "di_tieu_nhieu", fact_id: "558a3a656c38", evidence: "Người có các dấu hiệu như tiểu nhiều, khát nước liên tục, nhanh đói, mệt mỏi, sụt cân không chủ ý hoặc nhìn mờ nên đi khám và xét nghiệm đường huyết, đặc biệt khi nhiều triệu chứng bệnh tiểu đường giai đoạn đầu xuất hiện cùng lúc hoặc kéo dài không rõ nguyên nhân."}
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
    {a: "dai_thao_duong", b: "xet_nghiem", fact_id: "23c0798d6136", evidence: "Tuy nhiên, đây không phải triệu chứng bệnh tiểu đường giai đoạn đầu đặc hiệu nên cần xét nghiệm để xác định nguyên nhân."},
    {a: "dai_thao_duong", b: "xet_nghiem_duong_huyet", fact_id: "9026d5b6fb7c", evidence: "Tuy nhiên, nhiễm trùng tái phát không phải dấu hiệu đặc hiệu của bệnh đái tháo đường nên cần kết hợp với các triệu chứng khác và xét nghiệm đường huyết để xác định nguyên nhân."},
    {a: "dai_thao_duong", b: "chan_doan_va_tu_van_boi_nhan_vien_y_te", fact_id: "9fcc7505c28e", evidence: "Người bệnh không nên tự dùng thuốc, thực phẩm bổ sung hoặc áp dụng chế độ ăn kiêng quá mức khi chưa được chẩn đoán và tư vấn bởi nhân viên y tế."},
    {a: "tieu_duong_giai_doan_dau", b: "xet_nghiem_duong_huyet", fact_id: "0ef6601e4f81", evidence: "Người có các dấu hiệu như tiểu nhiều, khát nước liên tục, nhanh đói, mệt mỏi, sụt cân không chủ ý hoặc nhìn mờ nên đi khám và xét nghiệm đường huyết, đặc biệt khi nhiều triệu chứng bệnh tiểu đường giai đoạn đầu xuất hiện cùng lúc hoặc kéo dài không rõ nguyên nhân."}
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
    {a: "dai_thao_duong", b: "duong_huyet_cao", fact_id: "4e2e933c2ad4", evidence: "Tình trạng này có thể liên quan đến ảnh hưởng của đường huyết cao đối với khả năng bảo vệ và phục hồi của cơ thể."},
    {a: "dai_thao_duong", b: "nhom_nguy_co", fact_id: "5a0bbaa7776e", evidence: "Người có triệu chứng kéo dài hoặc thuộc nhóm nguy cơ nên đặt lịch khám để được kiểm tra đường huyết."},
    {a: "dai_thao_duong_tuyp_2", b: "it_van_dong", fact_id: "82761e12a1a8", evidence: "Người ít vận động hoặc có các vấn đề sức khỏe liên quan: Lối sống ít vận động có thể làm tăng nguy cơ tiền tiểu đường và tiểu đường type 2. Một số tình trạng như tăng huyết áp, rối loạn mỡ máu, gan nhiễm mỡ hoặc hội chứng buồng trứng đa nang cũng có thể liên quan đến nguy cơ rối loạn đường huyết . Những người thuộc nhóm này nên trao đổi với bác sĩ về việc tầm soát, nhất là khi có thêm các yếu tố nguy cơ khác."},
    {a: "dai_thao_duong_tuyp_2", b: "roi_loan_mo_mau", fact_id: "4bb28cd8c958", evidence: "Người ít vận động hoặc có các vấn đề sức khỏe liên quan: Lối sống ít vận động có thể làm tăng nguy cơ tiền tiểu đường và tiểu đường type 2. Một số tình trạng như tăng huyết áp, rối loạn mỡ máu, gan nhiễm mỡ hoặc hội chứng buồng trứng đa nang cũng có thể liên quan đến nguy cơ rối loạn đường huyết . Những người thuộc nhóm này nên trao đổi với bác sĩ về việc tầm soát, nhất là khi có thêm các yếu tố nguy cơ khác."},
    {a: "dai_thao_duong_tuyp_2", b: "gan_nhiem_mo", fact_id: "952fb0c4e665", evidence: "Người ít vận động hoặc có các vấn đề sức khỏe liên quan: Lối sống ít vận động có thể làm tăng nguy cơ tiền tiểu đường và tiểu đường type 2. Một số tình trạng như tăng huyết áp, rối loạn mỡ máu, gan nhiễm mỡ hoặc hội chứng buồng trứng đa nang cũng có thể liên quan đến nguy cơ rối loạn đường huyết . Những người thuộc nhóm này nên trao đổi với bác sĩ về việc tầm soát, nhất là khi có thêm các yếu tố nguy cơ khác."},
    {a: "tieu_duong_giai_doan_dau", b: "beo_phi", fact_id: "de4f3347b7ab", evidence: "Đặc biệt, người thuộc nhóm nguy cơ cao như thừa cân, béo phì, ít vận động hoặc có người thân mắc bệnh tiểu đường cũng nên chủ động tầm soát ngay cả khi chưa có triệu chứng."},
    {a: "tieu_duong_giai_doan_dau", b: "thua_can", fact_id: "6eda76488bde", evidence: "Đặc biệt, người thuộc nhóm nguy cơ cao như thừa cân, béo phì, ít vận động hoặc có người thân mắc bệnh tiểu đường cũng nên chủ động tầm soát ngay cả khi chưa có triệu chứng."},
    {a: "tieu_duong_giai_doan_dau", b: "it_van_dong", fact_id: "9fb6b65c9ca2", evidence: "Đặc biệt, người thuộc nhóm nguy cơ cao như thừa cân, béo phì, ít vận động hoặc có người thân mắc bệnh tiểu đường cũng nên chủ động tầm soát ngay cả khi chưa có triệu chứng."},
    {a: "tieu_duong_giai_doan_dau", b: "co_nguoi_than_mac_benh_tieu_duong", fact_id: "dd29c80171fd", evidence: "Đặc biệt, người thuộc nhóm nguy cơ cao như thừa cân, béo phì, ít vận động hoặc có người thân mắc bệnh tiểu đường cũng nên chủ động tầm soát ngay cả khi chưa có triệu chứng."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:HAS_RISK_FACTOR {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_3
}
RETURN source.id AS source_id, concept_count,
       rel_count_1 + rel_count_2 + rel_count_3 AS fact_count;
