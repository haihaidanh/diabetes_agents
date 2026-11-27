MERGE (source:DiabetesSource {id: "nhathuoclongchau_nguoi_benh_tieu_duong_tuyp_2_nen_an_gi_va_kieng_gi"})
SET source += {id: "nhathuoclongchau_nguoi_benh_tieu_duong_tuyp_2_nen_an_gi_va_kieng_gi", title: "Nguoi benh tieu duong tuyp 2 nen an gi va kieng gi", publisher: "Nhà thuốc Long Châu", url: "https://nhathuoclongchau.com.vn/bai-viet/nguoi-benh-tieu-duong-tuyp-2-nen-an-gi-va-kieng-gi.html", language: "vi", title_requires_review: true}
WITH source
CALL {
  WITH source
  UNWIND [
    {id: "dai_thao_duong_tuyp_2", name: "Đái tháo đường tuýp 2", category: "disease"},
    {id: "trai_cay", name: "Trái cây", category: "symptom"},
    {id: "sua", name: "Sữa", category: "lifestyle"},
    {id: "rau_xanh", name: "Rau xanh", category: "lifestyle"},
    {id: "ngu_coc_nguyen_hat", name: "Ngũ cốc nguyên hạt", category: "lifestyle"},
    {id: "cac_loai_dau", name: "Các loại đậu", category: "lifestyle"},
    {id: "ca_beo", name: "Cá béo", category: "lifestyle"},
    {id: "thit_nac", name: "Thịt nạc", category: "lifestyle"},
    {id: "trung", name: "Trứng", category: "lifestyle"},
    {id: "sua_khong_duong", name: "Sữa không đường", category: "lifestyle"},
    {id: "trai_cay_it_ngot", name: "Trái cây ít ngọt", category: "lifestyle"},
    {id: "do_ngot", name: "Đồ ngọt", category: "lifestyle"},
    {id: "tinh_bot_tinh_che", name: "Tinh bột tinh chế", category: "lifestyle"},
    {id: "mon_chien_ran", name: "Món chiên rán", category: "lifestyle"},
    {id: "hoa_qua_say_kho", name: "Hoa quả sấy khô", category: "risk_factor"},
    {id: "alpha_lipoic_acid", name: "Alpha-lipoic acid", category: "risk_factor"},
    {id: "thit_xong_khoi", name: "Thịt xông khói", category: "risk_factor"},
    {id: "bong_ngo", name: "Bỏng ngô", category: "risk_factor"},
    {id: "xuc_xich", name: "Xúc xích", category: "risk_factor"},
    {id: "snack", name: "Snack", category: "risk_factor"},
    {id: "khoai_tay_chien", name: "Khoai tây chiên", category: "risk_factor"},
    {id: "thuc_an_nhieu_dau_mo", name: "Thức ăn nhiều dầu mỡ", category: "risk_factor"},
    {id: "phu_tang_dong_vat", name: "Phủ tạng động vật", category: "risk_factor"},
    {id: "chocolate", name: "Chocolate", category: "risk_factor"},
    {id: "nguoi_benh_tieu_duong_tuyp_2", name: "Người bệnh tiểu đường tuýp 2", category: "disease"},
    {id: "carbohydrate", name: "Carbohydrate", category: "risk_factor"},
    {id: "an_it_nhat_3_bua_ngay", name: "Ăn ít nhất 3 bữa/ngày", category: "lifestyle"},
    {id: "thuc_pham_nhieu_chat_xo", name: "Thực phẩm nhiều chất xơ", category: "lifestyle"}
  ] AS row
  MERGE (n:DiabetesConcept {id: row.id})
  SET n += row
  MERGE (source)-[:MENTIONS]->(n)
  RETURN count(*) AS concept_count
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong_tuyp_2", b: "trai_cay", fact_id: "d12c8abfeeae", evidence: "Trái cây cung cấp nhiều khoáng chất và vitamin tốt cho cơ thể."}
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
    {a: "dai_thao_duong_tuyp_2", b: "sua", fact_id: "d52ab288cf4b", evidence: "Trong sữa chứa nhiều dưỡng chất quan trọng, bao gồm cả protein và canxi. Sữa còn kích thích khả năng tiết insulin ở người bị tiểu đường."}
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
    {a: "dai_thao_duong_tuyp_2", b: "rau_xanh", fact_id: "bcc831c3309c", evidence: "Người bệnh tiểu đường nên ăn rau xanh, ngũ cốc nguyên hạt (gạo lứt, yến mạch), các loại đậu, cá béo, thịt nạc, trứng, sữa không đường và trái cây ít ngọt như ổi, bưởi, táo; đồng thời hạn chế đồ ngọt, tinh bột tinh chế và món chiên rán để ổn định đường huyết."},
    {a: "dai_thao_duong_tuyp_2", b: "ngu_coc_nguyen_hat", fact_id: "2d81c0e4b4be", evidence: "Người bệnh tiểu đường nên ăn rau xanh, ngũ cốc nguyên hạt (gạo lứt, yến mạch), các loại đậu, cá béo, thịt nạc, trứng, sữa không đường và trái cây ít ngọt như ổi, bưởi, táo; đồng thời hạn chế đồ ngọt, tinh bột tinh chế và món chiên rán để ổn định đường huyết."},
    {a: "dai_thao_duong_tuyp_2", b: "cac_loai_dau", fact_id: "a52d08967197", evidence: "Người bệnh tiểu đường nên ăn rau xanh, ngũ cốc nguyên hạt (gạo lứt, yến mạch), các loại đậu, cá béo, thịt nạc, trứng, sữa không đường và trái cây ít ngọt như ổi, bưởi, táo; đồng thời hạn chế đồ ngọt, tinh bột tinh chế và món chiên rán để ổn định đường huyết."},
    {a: "dai_thao_duong_tuyp_2", b: "ca_beo", fact_id: "262d9a7d5bdc", evidence: "Người bệnh tiểu đường nên ăn rau xanh, ngũ cốc nguyên hạt (gạo lứt, yến mạch), các loại đậu, cá béo, thịt nạc, trứng, sữa không đường và trái cây ít ngọt như ổi, bưởi, táo; đồng thời hạn chế đồ ngọt, tinh bột tinh chế và món chiên rán để ổn định đường huyết."},
    {a: "dai_thao_duong_tuyp_2", b: "thit_nac", fact_id: "2613118a1e8a", evidence: "Người bệnh tiểu đường nên ăn rau xanh, ngũ cốc nguyên hạt (gạo lứt, yến mạch), các loại đậu, cá béo, thịt nạc, trứng, sữa không đường và trái cây ít ngọt như ổi, bưởi, táo; đồng thời hạn chế đồ ngọt, tinh bột tinh chế và món chiên rán để ổn định đường huyết."},
    {a: "dai_thao_duong_tuyp_2", b: "trung", fact_id: "dfaccee73077", evidence: "Người bệnh tiểu đường nên ăn rau xanh, ngũ cốc nguyên hạt (gạo lứt, yến mạch), các loại đậu, cá béo, thịt nạc, trứng, sữa không đường và trái cây ít ngọt như ổi, bưởi, táo; đồng thời hạn chế đồ ngọt, tinh bột tinh chế và món chiên rán để ổn định đường huyết."},
    {a: "dai_thao_duong_tuyp_2", b: "sua_khong_duong", fact_id: "560c798f2639", evidence: "Người bệnh tiểu đường nên ăn rau xanh, ngũ cốc nguyên hạt (gạo lứt, yến mạch), các loại đậu, cá béo, thịt nạc, trứng, sữa không đường và trái cây ít ngọt như ổi, bưởi, táo; đồng thời hạn chế đồ ngọt, tinh bột tinh chế và món chiên rán để ổn định đường huyết."},
    {a: "dai_thao_duong_tuyp_2", b: "trai_cay_it_ngot", fact_id: "fe68deeeafca", evidence: "Người bệnh tiểu đường nên ăn rau xanh, ngũ cốc nguyên hạt (gạo lứt, yến mạch), các loại đậu, cá béo, thịt nạc, trứng, sữa không đường và trái cây ít ngọt như ổi, bưởi, táo; đồng thời hạn chế đồ ngọt, tinh bột tinh chế và món chiên rán để ổn định đường huyết."},
    {a: "dai_thao_duong_tuyp_2", b: "sua", fact_id: "47eb226c867b", evidence: "Người bệnh tiểu đường chỉ nên uống 1 ly sữa khoảng 236ml/ngày vào bữa phụ trước khi đi ngủ là tốt nhất."},
    {a: "nguoi_benh_tieu_duong_tuyp_2", b: "an_it_nhat_3_bua_ngay", fact_id: "161edf5b8b6b", evidence: "Người bệnh tiểu đường cần ăn ít nhất 3 bữa/ngày, tránh ăn lúc quá đói dẫn đến tình trạng đường huyết tăng nhanh cấp tính."}
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
    {a: "dai_thao_duong_tuyp_2", b: "do_ngot", fact_id: "4f8625a36aa3", evidence: "Người bệnh tiểu đường nên ăn rau xanh, ngũ cốc nguyên hạt (gạo lứt, yến mạch), các loại đậu, cá béo, thịt nạc, trứng, sữa không đường và trái cây ít ngọt như ổi, bưởi, táo; đồng thời hạn chế đồ ngọt, tinh bột tinh chế và món chiên rán để ổn định đường huyết."},
    {a: "dai_thao_duong_tuyp_2", b: "tinh_bot_tinh_che", fact_id: "4078f91747df", evidence: "Người bệnh tiểu đường nên ăn rau xanh, ngũ cốc nguyên hạt (gạo lứt, yến mạch), các loại đậu, cá béo, thịt nạc, trứng, sữa không đường và trái cây ít ngọt như ổi, bưởi, táo; đồng thời hạn chế đồ ngọt, tinh bột tinh chế và món chiên rán để ổn định đường huyết."},
    {a: "dai_thao_duong_tuyp_2", b: "mon_chien_ran", fact_id: "c552c193fe0e", evidence: "Người bệnh tiểu đường nên ăn rau xanh, ngũ cốc nguyên hạt (gạo lứt, yến mạch), các loại đậu, cá béo, thịt nạc, trứng, sữa không đường và trái cây ít ngọt như ổi, bưởi, táo; đồng thời hạn chế đồ ngọt, tinh bột tinh chế và món chiên rán để ổn định đường huyết."},
    {a: "dai_thao_duong_tuyp_2", b: "sua", fact_id: "c0968fcf8862", evidence: "Chỉ nên dùng các loại sữa, sữa chua, phô mai nguyên chất ít đường hoặc không đường, chế phẩm từ sữa ít béo hoặc tách béo để hạn chế việc tăng đường huyết."},
    {a: "nguoi_benh_tieu_duong_tuyp_2", b: "thuc_pham_nhieu_chat_xo", fact_id: "14480763c7bd", evidence: "Nên ăn đa dạng các loại thực phẩm chứa nhiều vitamin và khoáng chất , đặc biệt là thực phẩm nhiều chất xơ, ăn nhạt và ít muối."}
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
    {a: "dai_thao_duong_tuyp_2", b: "hoa_qua_say_kho", fact_id: "5ad651f87b93", evidence: "Người tiểu đường không nên ăn các loại hoa quả sấy khô. Bởi các loại hoa này đã bị loại bỏ hết nước, lượng đường trong quả sẽ cao gấp 3 lần so với hoa quả tươi. Vì vậy, người bệnh dễ bị tăng đường huyết đột biến khi ăn hoa quả sấy khô."},
    {a: "dai_thao_duong_tuyp_2", b: "alpha_lipoic_acid", fact_id: "25f9705bd0f0", evidence: "Người bị đái tháo đường vẫn cần bổ sung các thực phẩm chứa chất béo tốt như omega-3, alpha-lipoic acid,... Đây là chất béo tham gia vào quá trình cấu trúc và hình thành tế bào và hormon của cơ thể. Đặc biệt, alpha-lipoic acid còn hỗ trợ ngăn ngừa nguy cơ dẫn đến biến chứng do bệnh tiểu đường."},
    {a: "dai_thao_duong_tuyp_2", b: "thit_xong_khoi", fact_id: "e6944a62941b", evidence: "Vì vậy, tiểu đường tuýp 2 kiêng ăn gì đối với các loại chất béo chuyển hóa như: Thịt xông khói, bỏng ngô, xúc xích, snack, khoai tây chiên, thức ăn nhiều dầu mỡ."},
    {a: "dai_thao_duong_tuyp_2", b: "bong_ngo", fact_id: "96419aad75f9", evidence: "Vì vậy, tiểu đường tuýp 2 kiêng ăn gì đối với các loại chất béo chuyển hóa như: Thịt xông khói, bỏng ngô, xúc xích, snack, khoai tây chiên, thức ăn nhiều dầu mỡ."},
    {a: "dai_thao_duong_tuyp_2", b: "xuc_xich", fact_id: "6270626833bb", evidence: "Vì vậy, tiểu đường tuýp 2 kiêng ăn gì đối với các loại chất béo chuyển hóa như: Thịt xông khói, bỏng ngô, xúc xích, snack, khoai tây chiên, thức ăn nhiều dầu mỡ."},
    {a: "dai_thao_duong_tuyp_2", b: "snack", fact_id: "f07f39d386ed", evidence: "Vì vậy, tiểu đường tuýp 2 kiêng ăn gì đối với các loại chất béo chuyển hóa như: Thịt xông khói, bỏng ngô, xúc xích, snack, khoai tây chiên, thức ăn nhiều dầu mỡ."},
    {a: "dai_thao_duong_tuyp_2", b: "khoai_tay_chien", fact_id: "f216f1c320a6", evidence: "Vì vậy, tiểu đường tuýp 2 kiêng ăn gì đối với các loại chất béo chuyển hóa như: Thịt xông khói, bỏng ngô, xúc xích, snack, khoai tây chiên, thức ăn nhiều dầu mỡ."},
    {a: "dai_thao_duong_tuyp_2", b: "thuc_an_nhieu_dau_mo", fact_id: "51a6250d4ad0", evidence: "Vì vậy, tiểu đường tuýp 2 kiêng ăn gì đối với các loại chất béo chuyển hóa như: Thịt xông khói, bỏng ngô, xúc xích, snack, khoai tây chiên, thức ăn nhiều dầu mỡ."},
    {a: "dai_thao_duong_tuyp_2", b: "phu_tang_dong_vat", fact_id: "19fdeee1310e", evidence: "Hạn chế các thực phẩm giàu cholesterol như phủ tạng động vật, chocolate,..."},
    {a: "dai_thao_duong_tuyp_2", b: "chocolate", fact_id: "67e205611db6", evidence: "Hạn chế các thực phẩm giàu cholesterol như phủ tạng động vật, chocolate,..."},
    {a: "nguoi_benh_tieu_duong_tuyp_2", b: "carbohydrate", fact_id: "9e02ef5af0b1", evidence: "Thực đơn của bệnh nhân tiểu đường vẫn cần có đủ các chất như carbohydrate (tinh bột, đường) 45 - 60%, lipit (chất béo) 20 - 30%, protein (chất đạm) 12 - 20%. Tuy nhiên, lượng carbohydrate cần hạn chế hoặc giảm xuống."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:HAS_RISK_FACTOR {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_5
}
RETURN source.id AS source_id, concept_count,
       rel_count_1 + rel_count_2 + rel_count_3 + rel_count_4 + rel_count_5 AS fact_count;
