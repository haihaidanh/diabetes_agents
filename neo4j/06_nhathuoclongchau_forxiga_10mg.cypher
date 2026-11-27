MERGE (source:DiabetesSource {id: "nhathuoclongchau_forxiga_10mg"})
SET source += {id: "nhathuoclongchau_forxiga_10mg", title: "Forxiga 10mg", publisher: "Nhà thuốc Long Châu", url: "https://nhathuoclongchau.com.vn/thuoc/forxiga-10mg-3713.html", language: "vi", title_requires_review: true}
WITH source
CALL {
  WITH source
  UNWIND [
    {id: "dai_thao_duong_tuyp_2", name: "Đái tháo đường tuýp 2", category: "disease"},
    {id: "forxiga", name: "Forxiga", category: "drug"},
    {id: "suy_tim", name: "Suy tim", category: "disease"},
    {id: "benh_than_man", name: "Bệnh thận mạn", category: "disease"},
    {id: "ha_duong_huyet", name: "Hạ đường huyết", category: "disease"},
    {id: "di_tieu_nhieu", name: "Đi tiểu nhiều", category: "side_effect"},
    {id: "roi_loan_lipid_mau", name: "Rối loạn lipid máu", category: "side_effect"},
    {id: "giam_can", name: "Giảm cân", category: "side_effect"},
    {id: "phat_ban", name: "Phát ban", category: "side_effect"},
    {id: "nhiem_trung_duong_nieu_sinh_duc", name: "Nhiễm trùng đường niệu sinh dục", category: "side_effect"},
    {id: "ha_duong_huyet_nghiem_trong", name: "Hạ đường huyết nghiêm trọng", category: "side_effect"},
    {id: "nhiem_toan_ceton_do_dai_thao_duong", name: "Nhiễm toan ceton do đái tháo đường", category: "side_effect"},
    {id: "nhiem_nam", name: "Nhiễm nấm", category: "side_effect"},
    {id: "giam_the_tich_tuan_hoan", name: "Giảm thể tích tuần hoàn", category: "side_effect"},
    {id: "tao_bon", name: "Táo bón", category: "side_effect"},
    {id: "kho_mieng", name: "Khô miệng", category: "side_effect"},
    {id: "dau_lung", name: "Đau lưng", category: "side_effect"},
    {id: "tieu_kho", name: "Tiểu khó", category: "side_effect"},
    {id: "ngua_am_dao_am_ho", name: "Ngứa âm đạo - âm hộ", category: "side_effect"},
    {id: "ngua_duong_sinh_duc", name: "Ngứa đường sinh dục", category: "side_effect"},
    {id: "tang_hematocrit", name: "Tăng hematocrit", category: "side_effect"},
    {id: "tang_ure_trong_mau", name: "Tăng urê trong máu", category: "side_effect"},
    {id: "viem_am_dao_am_ho", name: "Viêm âm đạo – âm hộ", category: "side_effect"},
    {id: "viem_quy_dau", name: "Viêm quy đầu", category: "side_effect"},
    {id: "nhiem_nam_sinh_duc", name: "Nhiễm nấm sinh dục", category: "side_effect"},
    {id: "nhiem_nam_candida_am_dao_am_ho", name: "Nhiễm nấm Candida âm đạo – âm hộ", category: "side_effect"},
    {id: "nhiem_nam_candida_quy_dau", name: "Nhiễm nấm Candida quy đầu", category: "side_effect"},
    {id: "nhiem_nam_candida_sinh_duc", name: "Nhiễm nấm Candida sinh dục", category: "side_effect"},
    {id: "nhiem_trung_duong_sinh_duc", name: "Nhiễm trùng đường sinh dục", category: "side_effect"},
    {id: "nhiem_trung_sinh_duc_nam_gioi", name: "Nhiễm trùng sinh dục nam giới", category: "side_effect"},
    {id: "nhiem_trung_duong_vat", name: "Nhiễm trùng dương vật", category: "side_effect"},
    {id: "viem_am_ho", name: "Viêm âm hộ", category: "side_effect"},
    {id: "viem_am_dao_do_vi_khuan", name: "Viêm âm đạo do vi khuẩn", category: "side_effect"},
    {id: "ap_xe_am_ho", name: "Áp - xe âm hộ", category: "side_effect"},
    {id: "nhiem_trung_tiet_nieu", name: "Nhiễm trùng tiết niệu", category: "side_effect"},
    {id: "viem_bang_quang", name: "Viêm bàng quang", category: "side_effect"},
    {id: "nhiem_trung_duong_tiet_nieu_do_escherichia", name: "Nhiễm trùng đường tiết niệu do Escherichia", category: "side_effect"},
    {id: "viem_be_than", name: "Viêm bể thận", category: "side_effect"},
    {id: "viem_vung_tam_giac_bang_quang", name: "Viêm vùng tam giác bàng quang", category: "side_effect"},
    {id: "viem_nieu_dao", name: "Viêm niệu đạo", category: "side_effect"},
    {id: "nhiem_trung_than", name: "Nhiễm trùng thận", category: "side_effect"},
    {id: "viem_tuyen_tien_liet", name: "Viêm tuyến tiền liệt", category: "side_effect"},
    {id: "mat_nuoc", name: "Mất nước", category: "side_effect"},
    {id: "giam_the_tich_mau", name: "Giảm thể tích máu", category: "side_effect"},
    {id: "tieu_nhat", name: "Tiểu nhắt", category: "side_effect"},
    {id: "tang_luong_nuoc_tieu", name: "Tăng lượng nước tiểu", category: "side_effect"},
    {id: "cac_nhiem_trung_duong_sinh_duc", name: "Các nhiễm trùng đường sinh dục", category: "side_effect"},
    {id: "ha_duong_huyet_nang", name: "Hạ đường huyết nặng", category: "side_effect"},
    {id: "giam_the_tich", name: "Giảm thể tích", category: "side_effect"},
    {id: "bien_co_ngoai_y_nang", name: "Biến cố ngoại ý nặng", category: "side_effect"},
    {id: "bien_co_ngoai_y", name: "Biến cố ngoại ý", category: "side_effect"},
    {id: "bao_cao_phan_ung_ngoai_y_nghi_ngo", name: "Báo cáo phản ứng ngoại ý nghi ngờ", category: "side_effect"},
    {id: "theo_doi_loi_ich_va_nguy_co", name: "Theo dõi lợi ích và nguy cơ", category: "side_effect"},
    {id: "ha_huyet_ap", name: "Hạ huyết áp", category: "test"},
    {id: "thuoc_uc_che_sglt2", name: "Thuốc ức chế SGLT2", category: "drug_class"}
  ] AS row
  MERGE (n:DiabetesConcept {id: row.id})
  SET n += row
  MERGE (source)-[:MENTIONS]->(n)
  RETURN count(*) AS concept_count
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong_tuyp_2", b: "forxiga", fact_id: "445d0c27c296", evidence: "Forxiga được chỉ định để làm giảm nguy cơ nhập viện do suy tim ở bệnh nhân trưởng thành bị đái tháo đường týp 2 và hoặc có tiền sử bệnh lý tim mạch hoặc nhiều yếu tố nguy cơ tim mạch."},
    {a: "suy_tim", b: "forxiga", fact_id: "4f0acabfcb75", evidence: "Forxiga được chỉ định để làm giảm nguy cơ tử vong tim mạch, nhập viện do suy tim và khám cấp cứu do suy tim ở bệnh nhân trưởng thành bị suy tim."},
    {a: "benh_than_man", b: "forxiga", fact_id: "4f0d8f3f62d0", evidence: "Forxiga được chỉ định để làm giảm nguy cơ suy giảm eGFR kéo dài, bệnh thận giai đoạn cuối, tử vong tim mạch và nhập viện do suy tim ở bệnh nhân trưởng thành bị bệnh thận mạn tính có nguy cơ tiến triển."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:TREATED_BY {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_1
}
CALL {
  WITH source
  UNWIND [
    {a: "forxiga", b: "ha_duong_huyet", fact_id: "c6688bb0512c", evidence: "Hạ đường huyết (khi sử dụng với SU hoặc insulin) b"},
    {a: "forxiga", b: "di_tieu_nhieu", fact_id: "80677a5e7e2e", evidence: "Tiểu khó Tiểu nhiều *,f"},
    {a: "forxiga", b: "roi_loan_lipid_mau", fact_id: "1a8ae2028d32", evidence: "Tăng hematocritg Rối loạn lipid máuh"},
    {a: "forxiga", b: "giam_can", fact_id: "4afd006b010e", evidence: "Tăng urê trong máu ** Giảm cân **"},
    {a: "forxiga", b: "phat_ban", fact_id: "417484078186", evidence: "Phát ban k"},
    {a: "forxiga", b: "nhiem_trung_duong_nieu_sinh_duc", fact_id: "957c1757b16d", evidence: "Phản ứng ngoại ý thường gặp nhất được báo cáo trong các nghiên cứu lâm sàng là nhiễm trùng đường sinh dục."},
    {a: "forxiga", b: "ha_duong_huyet_nghiem_trong", fact_id: "ff65c87f131b", evidence: "Hạ đường huyết nghiêm trọng và nhiễm toan ceton do đái đường chỉ được ghi nhận ở các bệnh nhân đái tháo đường."},
    {a: "forxiga", b: "nhiem_toan_ceton_do_dai_thao_duong", fact_id: "9a60e2071039", evidence: "Hạ đường huyết nghiêm trọng và nhiễm toan ceton do đái đường chỉ được ghi nhận ở các bệnh nhân đái tháo đường."},
    {a: "forxiga", b: "nhiem_nam", fact_id: "78f3698f9b16", evidence: "Nhiễm nấm **"},
    {a: "forxiga", b: "giam_the_tich_tuan_hoan", fact_id: "a6067ce96ddb", evidence: "Giảm thể tích tuần hoàn b,e Khát **"},
    {a: "forxiga", b: "tao_bon", fact_id: "9dcc6f23f5cf", evidence: "Táo bón ** Khô miệng**"},
    {a: "forxiga", b: "kho_mieng", fact_id: "6d8c450bde15", evidence: "Táo bón ** Khô miệng**"},
    {a: "forxiga", b: "dau_lung", fact_id: "95cab10de67f", evidence: "Đau lưng *"},
    {a: "forxiga", b: "tieu_kho", fact_id: "10499a15e309", evidence: "Tiểu khó Tiểu nhiều *,f"},
    {a: "forxiga", b: "ngua_am_dao_am_ho", fact_id: "85ba1ad36e69", evidence: "Ngứa âm đạo - âm hộ ** Ngứa đường sinh dục **"},
    {a: "forxiga", b: "ngua_duong_sinh_duc", fact_id: "e7d7828985a4", evidence: "Rối loạn sinh dục và tuyến vú |  |  | Ngứa âm đạo - âm hộ ** Ngứa đường sinh dục ** |"},
    {a: "forxiga", b: "tang_hematocrit", fact_id: "dad759e46ac9", evidence: "Tăng hematocritg Rối loạn lipid máuh"},
    {a: "forxiga", b: "tang_ure_trong_mau", fact_id: "8bc9a5c4b384", evidence: "Tăng urê trong máu ** Giảm cân **"},
    {a: "forxiga", b: "viem_am_dao_am_ho", fact_id: "e9c6f681427e", evidence: "Viêm âm đạo – âm hộ, viêm quy đầu và các nhiễm trùng đường sinh dục bao gồm các thuật ngữ khác thường được dùng như: viêm nhiễm âm đạo – âm hộ do nấm, nhiễm trùng âm đạo, viêm quy đầu, nhiễm nấm sinh dục, nhiễm nấm Candida âm đạo – âm hộ, viêm âm đạo – âm hộ, nhiễm nấm Candida quy đầu, nhiễm nấm Candida sinh dục, nhiễm trùng sinh dục, nhiễm trùng sinh dục nam giới, nhiễm trùng dương vật, viêm âm hộ, viêm âm đạo do vi khuẩn, áp - xe âm hộ."},
    {a: "forxiga", b: "viem_quy_dau", fact_id: "6d3edd3bf799", evidence: "Viêm âm đạo – âm hộ, viêm quy đầu và các nhiễm trùng đường sinh dục bao gồm các thuật ngữ khác thường được dùng như: viêm nhiễm âm đạo – âm hộ do nấm, nhiễm trùng âm đạo, viêm quy đầu, nhiễm nấm sinh dục, nhiễm nấm Candida âm đạo – âm hộ, viêm âm đạo – âm hộ, nhiễm nấm Candida quy đầu, nhiễm nấm Candida sinh dục, nhiễm trùng sinh dục, nhiễm trùng sinh dục nam giới, nhiễm trùng dương vật, viêm âm hộ, viêm âm đạo do vi khuẩn, áp - xe âm hộ."},
    {a: "forxiga", b: "nhiem_nam_sinh_duc", fact_id: "0c82aa08f771", evidence: "Viêm âm đạo – âm hộ, viêm quy đầu và các nhiễm trùng đường sinh dục bao gồm các thuật ngữ khác thường được dùng như: viêm nhiễm âm đạo – âm hộ do nấm, nhiễm trùng âm đạo, viêm quy đầu, nhiễm nấm sinh dục, nhiễm nấm Candida âm đạo – âm hộ, viêm âm đạo – âm hộ, nhiễm nấm Candida quy đầu, nhiễm nấm Candida sinh dục, nhiễm trùng sinh dục, nhiễm trùng sinh dục nam giới, nhiễm trùng dương vật, viêm âm hộ, viêm âm đạo do vi khuẩn, áp - xe âm hộ."},
    {a: "forxiga", b: "nhiem_nam_candida_am_dao_am_ho", fact_id: "794c7d592ecd", evidence: "Viêm âm đạo – âm hộ, viêm quy đầu và các nhiễm trùng đường sinh dục bao gồm các thuật ngữ khác thường được dùng như: viêm nhiễm âm đạo – âm hộ do nấm, nhiễm trùng âm đạo, viêm quy đầu, nhiễm nấm sinh dục, nhiễm nấm Candida âm đạo – âm hộ, viêm âm đạo – âm hộ, nhiễm nấm Candida quy đầu, nhiễm nấm Candida sinh dục, nhiễm trùng sinh dục, nhiễm trùng sinh dục nam giới, nhiễm trùng dương vật, viêm âm hộ, viêm âm đạo do vi khuẩn, áp - xe âm hộ."},
    {a: "forxiga", b: "nhiem_nam_candida_quy_dau", fact_id: "87cd7e7bc7c8", evidence: "Viêm âm đạo – âm hộ, viêm quy đầu và các nhiễm trùng đường sinh dục bao gồm các thuật ngữ khác thường được dùng như: viêm nhiễm âm đạo – âm hộ do nấm, nhiễm trùng âm đạo, viêm quy đầu, nhiễm nấm sinh dục, nhiễm nấm Candida âm đạo – âm hộ, viêm âm đạo – âm hộ, nhiễm nấm Candida quy đầu, nhiễm nấm Candida sinh dục, nhiễm trùng sinh dục, nhiễm trùng sinh dục nam giới, nhiễm trùng dương vật, viêm âm hộ, viêm âm đạo do vi khuẩn, áp - xe âm hộ."},
    {a: "forxiga", b: "nhiem_nam_candida_sinh_duc", fact_id: "30e75d6045e5", evidence: "Viêm âm đạo – âm hộ, viêm quy đầu và các nhiễm trùng đường sinh dục bao gồm các thuật ngữ khác thường được dùng như: viêm nhiễm âm đạo – âm hộ do nấm, nhiễm trùng âm đạo, viêm quy đầu, nhiễm nấm sinh dục, nhiễm nấm Candida âm đạo – âm hộ, viêm âm đạo – âm hộ, nhiễm nấm Candida quy đầu, nhiễm nấm Candida sinh dục, nhiễm trùng sinh dục, nhiễm trùng sinh dục nam giới, nhiễm trùng dương vật, viêm âm hộ, viêm âm đạo do vi khuẩn, áp - xe âm hộ."},
    {a: "forxiga", b: "nhiem_trung_duong_sinh_duc", fact_id: "2e3c872e1c92", evidence: "Viêm âm đạo – âm hộ, viêm quy đầu và các nhiễm trùng đường sinh dục bao gồm các thuật ngữ khác thường được dùng như: viêm nhiễm âm đạo – âm hộ do nấm, nhiễm trùng âm đạo, viêm quy đầu, nhiễm nấm sinh dục, nhiễm nấm Candida âm đạo – âm hộ, viêm âm đạo – âm hộ, nhiễm nấm Candida quy đầu, nhiễm nấm Candida sinh dục, nhiễm trùng sinh dục, nhiễm trùng sinh dục nam giới, nhiễm trùng dương vật, viêm âm hộ, viêm âm đạo do vi khuẩn, áp - xe âm hộ."},
    {a: "forxiga", b: "nhiem_trung_sinh_duc_nam_gioi", fact_id: "92bf47823671", evidence: "Viêm âm đạo – âm hộ, viêm quy đầu và các nhiễm trùng đường sinh dục bao gồm các thuật ngữ khác thường được dùng như: viêm nhiễm âm đạo – âm hộ do nấm, nhiễm trùng âm đạo, viêm quy đầu, nhiễm nấm sinh dục, nhiễm nấm Candida âm đạo – âm hộ, viêm âm đạo – âm hộ, nhiễm nấm Candida quy đầu, nhiễm nấm Candida sinh dục, nhiễm trùng sinh dục, nhiễm trùng sinh dục nam giới, nhiễm trùng dương vật, viêm âm hộ, viêm âm đạo do vi khuẩn, áp - xe âm hộ."},
    {a: "forxiga", b: "nhiem_trung_duong_vat", fact_id: "65edc43e2517", evidence: "Viêm âm đạo – âm hộ, viêm quy đầu và các nhiễm trùng đường sinh dục bao gồm các thuật ngữ khác thường được dùng như: viêm nhiễm âm đạo – âm hộ do nấm, nhiễm trùng âm đạo, viêm quy đầu, nhiễm nấm sinh dục, nhiễm nấm Candida âm đạo – âm hộ, viêm âm đạo – âm hộ, nhiễm nấm Candida quy đầu, nhiễm nấm Candida sinh dục, nhiễm trùng sinh dục, nhiễm trùng sinh dục nam giới, nhiễm trùng dương vật, viêm âm hộ, viêm âm đạo do vi khuẩn, áp - xe âm hộ."},
    {a: "forxiga", b: "viem_am_ho", fact_id: "71b251cf2136", evidence: "Viêm âm đạo – âm hộ, viêm quy đầu và các nhiễm trùng đường sinh dục bao gồm các thuật ngữ khác thường được dùng như: viêm nhiễm âm đạo – âm hộ do nấm, nhiễm trùng âm đạo, viêm quy đầu, nhiễm nấm sinh dục, nhiễm nấm Candida âm đạo – âm hộ, viêm âm đạo – âm hộ, nhiễm nấm Candida quy đầu, nhiễm nấm Candida sinh dục, nhiễm trùng sinh dục, nhiễm trùng sinh dục nam giới, nhiễm trùng dương vật, viêm âm hộ, viêm âm đạo do vi khuẩn, áp - xe âm hộ."},
    {a: "forxiga", b: "viem_am_dao_do_vi_khuan", fact_id: "489eb070efbc", evidence: "Viêm âm đạo – âm hộ, viêm quy đầu và các nhiễm trùng đường sinh dục bao gồm các thuật ngữ khác thường được dùng như: viêm nhiễm âm đạo – âm hộ do nấm, nhiễm trùng âm đạo, viêm quy đầu, nhiễm nấm sinh dục, nhiễm nấm Candida âm đạo – âm hộ, viêm âm đạo – âm hộ, nhiễm nấm Candida quy đầu, nhiễm nấm Candida sinh dục, nhiễm trùng sinh dục, nhiễm trùng sinh dục nam giới, nhiễm trùng dương vật, viêm âm hộ, viêm âm đạo do vi khuẩn, áp - xe âm hộ."},
    {a: "forxiga", b: "ap_xe_am_ho", fact_id: "e1b72de00226", evidence: "Viêm âm đạo – âm hộ, viêm quy đầu và các nhiễm trùng đường sinh dục bao gồm các thuật ngữ khác thường được dùng như: viêm nhiễm âm đạo – âm hộ do nấm, nhiễm trùng âm đạo, viêm quy đầu, nhiễm nấm sinh dục, nhiễm nấm Candida âm đạo – âm hộ, viêm âm đạo – âm hộ, nhiễm nấm Candida quy đầu, nhiễm nấm Candida sinh dục, nhiễm trùng sinh dục, nhiễm trùng sinh dục nam giới, nhiễm trùng dương vật, viêm âm hộ, viêm âm đạo do vi khuẩn, áp - xe âm hộ."},
    {a: "forxiga", b: "nhiem_trung_tiet_nieu", fact_id: "ebb7e7b9e2c4", evidence: "Nhiễm trùng đường tiết niệu bao gồm các thuật ngữ thường được dùng sau đây, được liệt kê theo thứ tự tần suất báo cáo: nhiễm trùng đường tiết niệu, viêm bàng quang, nhiễm trùng đường tiết niệu do Escherichia, nhiễm trùng đường niệu sinh dục, viêm bể thận, viêm vùng tam giác bàng quang, viêm niệu đạo, nhiễm trùng thận và viêm tuyến tiền liệt."},
    {a: "forxiga", b: "viem_bang_quang", fact_id: "8d21c9804485", evidence: "Nhiễm trùng đường tiết niệu bao gồm các thuật ngữ thường được dùng sau đây, được liệt kê theo thứ tự tần suất báo cáo: nhiễm trùng đường tiết niệu, viêm bàng quang, nhiễm trùng đường tiết niệu do Escherichia, nhiễm trùng đường niệu sinh dục, viêm bể thận, viêm vùng tam giác bàng quang, viêm niệu đạo, nhiễm trùng thận và viêm tuyến tiền liệt."},
    {a: "forxiga", b: "nhiem_trung_duong_tiet_nieu_do_escherichia", fact_id: "9c76154c0f33", evidence: "Nhiễm trùng đường tiết niệu bao gồm các thuật ngữ thường được dùng sau đây, được liệt kê theo thứ tự tần suất báo cáo: nhiễm trùng đường tiết niệu, viêm bàng quang, nhiễm trùng đường tiết niệu do Escherichia, nhiễm trùng đường niệu sinh dục, viêm bể thận, viêm vùng tam giác bàng quang, viêm niệu đạo, nhiễm trùng thận và viêm tuyến tiền liệt."},
    {a: "forxiga", b: "viem_be_than", fact_id: "63dab3516544", evidence: "Nhiễm trùng đường tiết niệu bao gồm các thuật ngữ thường được dùng sau đây, được liệt kê theo thứ tự tần suất báo cáo: nhiễm trùng đường tiết niệu, viêm bàng quang, nhiễm trùng đường tiết niệu do Escherichia, nhiễm trùng đường niệu sinh dục, viêm bể thận, viêm vùng tam giác bàng quang, viêm niệu đạo, nhiễm trùng thận và viêm tuyến tiền liệt."},
    {a: "forxiga", b: "viem_vung_tam_giac_bang_quang", fact_id: "495e73bee7d6", evidence: "Nhiễm trùng đường tiết niệu bao gồm các thuật ngữ thường được dùng sau đây, được liệt kê theo thứ tự tần suất báo cáo: nhiễm trùng đường tiết niệu, viêm bàng quang, nhiễm trùng đường tiết niệu do Escherichia, nhiễm trùng đường niệu sinh dục, viêm bể thận, viêm vùng tam giác bàng quang, viêm niệu đạo, nhiễm trùng thận và viêm tuyến tiền liệt."},
    {a: "forxiga", b: "viem_nieu_dao", fact_id: "3f631994eaa3", evidence: "Nhiễm trùng đường tiết niệu bao gồm các thuật ngữ thường được dùng sau đây, được liệt kê theo thứ tự tần suất báo cáo: nhiễm trùng đường tiết niệu, viêm bàng quang, nhiễm trùng đường tiết niệu do Escherichia, nhiễm trùng đường niệu sinh dục, viêm bể thận, viêm vùng tam giác bàng quang, viêm niệu đạo, nhiễm trùng thận và viêm tuyến tiền liệt."},
    {a: "forxiga", b: "nhiem_trung_than", fact_id: "f6d329183d60", evidence: "nhiễm trùng đường tiết niệu, viêm bàng quang, nhiễm trùng đường tiết niệu do Escherichia, nhiễm trùng đường niệu sinh dục, viêm bể thận, viêm vùng tam giác bàng quang, viêm niệu đạo, nhiễm trùng thận và viêm tuyến tiền liệt."},
    {a: "forxiga", b: "viem_tuyen_tien_liet", fact_id: "1e2d49d74072", evidence: "Nhiễm trùng đường tiết niệu bao gồm các thuật ngữ thường được dùng sau đây, được liệt kê theo thứ tự tần suất báo cáo: nhiễm trùng đường tiết niệu, viêm bàng quang, nhiễm trùng đường tiết niệu do Escherichia, nhiễm trùng đường niệu sinh dục, viêm bể thận, viêm vùng tam giác bàng quang, viêm niệu đạo, nhiễm trùng thận và viêm tuyến tiền liệt."},
    {a: "forxiga", b: "mat_nuoc", fact_id: "49a4b40b80e7", evidence: "Giảm thể tích tuần hoàn bao gồm các thuật ngữ khác thường được dùng như: mất nước, giảm thể tích máu, hạ huyết áp."},
    {a: "forxiga", b: "giam_the_tich_mau", fact_id: "839ca47ac01c", evidence: "Giảm thể tích tuần hoàn bao gồm các thuật ngữ khác thường được dùng như: mất nước, giảm thể tích máu, hạ huyết áp."},
    {a: "forxiga", b: "tieu_nhat", fact_id: "d3c38a4a01f7", evidence: "Tiểu nhiều bao gồm các thuật ngữ khác thường được dùng như: tiểu nhắt, tiểu nhiều, tăng lượng nước tiểu."},
    {a: "forxiga", b: "tang_luong_nuoc_tieu", fact_id: "2d164a546b27", evidence: "Tiểu nhiều bao gồm các thuật ngữ khác thường được dùng như: tiểu nhắt, tiểu nhiều, tăng lượng nước tiểu."},
    {a: "forxiga", b: "cac_nhiem_trung_duong_sinh_duc", fact_id: "42427b3e208d", evidence: "Viêm âm đạo – âm hộ, viêm quy đầu và các nhiễm trùng đường sinh dục"},
    {a: "forxiga", b: "ha_duong_huyet_nang", fact_id: "9793d15de82c", evidence: "Trong một nghiên cứu phối hợp bổ sung với metformin và 1 thuốc sulfonylurê, lên đến 24 tuần, không ghi nhận các cơn hạ đường huyết nặng."},
    {a: "forxiga", b: "giam_the_tich", fact_id: "7e2c45dd68a7", evidence: "Trong nghiên cứu dự hậu tim mạch của dapagliflozin, số lượng bệnh nhân mắc phải biến cố giảm thể tích được ghi nhận phân bổ đều giữa các nhóm điều trị:"},
    {a: "forxiga", b: "bien_co_ngoai_y_nang", fact_id: "54bb8eb429c9", evidence: "Biến cố ngoại ý nặng được ghi nhận ở 81 (0,9%) trong nhóm dapagliflozin và 70 (0,8%) trong nhóm giả dược."},
    {a: "forxiga", b: "bien_co_ngoai_y", fact_id: "ef2b2ae4756b", evidence: "Biến cố ngoại ý thường phân bổ đều giữa các nhóm điều trị trải đều trên các phân nhóm nhỏ về tuổi tác, dùng thuốc lợi tiểu, tăng huyết áp và dùng thuốc ức chế thụ thể angiotensin/ ức chế men chuyển angiotensin."},
    {a: "forxiga", b: "bao_cao_phan_ung_ngoai_y_nghi_ngo", fact_id: "277c3d988c0b", evidence: "Báo cáo các phản ứng ngoại ý nghi ngờ sau khi các sản phẩm dược được cấp phép rất quan trọng."},
    {a: "forxiga", b: "theo_doi_loi_ich_va_nguy_co", fact_id: "d5b51a8f5464", evidence: "Điều này cho phép theo dõi liên tục sự cân bằng giữa lợi ích và nguy cơ của các sản phẩm dược."},
    {a: "forxiga", b: "ha_huyet_ap", fact_id: "66395339bbb6", evidence: "Giảm thể tích tuần hoàn bao gồm các thuật ngữ khác thường được dùng như: mất nước, giảm thể tích máu, hạ huyết áp."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:HAS_SIDE_EFFECT {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_2
}
CALL {
  WITH source
  UNWIND [
    {a: "forxiga", b: "thuoc_uc_che_sglt2", fact_id: "e577d5fbba19", evidence: "Các trường hợp bị viêm mô hoại tử vùng đáy chậu (còn được gọi là hoại tử Fournier) sau khi thuốc lưu hành trên thị trường đã được báo cáo ở bệnh nhân nữ và nam dùng thuốc ức chế SGLT2."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:BELONGS_TO {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_3
}
RETURN source.id AS source_id, concept_count,
       rel_count_1 + rel_count_2 + rel_count_3 AS fact_count;
