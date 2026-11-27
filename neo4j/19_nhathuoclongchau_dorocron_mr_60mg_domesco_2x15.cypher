MERGE (source:DiabetesSource {id: "nhathuoclongchau_dorocron_mr_60mg_domesco_2x15"})
SET source += {id: "nhathuoclongchau_dorocron_mr_60mg_domesco_2x15", title: "Dorocron mr 60mg domesco 2x15", publisher: "Nhà thuốc Long Châu", url: "https://nhathuoclongchau.com.vn/thuoc/dorocron-mr-60mg-domesco-2x15-28558.html", language: "vi", title_requires_review: true}
WITH source
CALL {
  WITH source
  UNWIND [
    {id: "dai_thao_duong_tuyp_2", name: "Đái tháo đường tuýp 2", category: "disease"},
    {id: "dorocron", name: "Dorocron", category: "drug"},
    {id: "ngua", name: "Ngứa", category: "side_effect"},
    {id: "phat_ban", name: "Phát ban", category: "side_effect"},
    {id: "noi_may_day", name: "Nổi mày đay", category: "side_effect"},
    {id: "viem_da_co_bong_nuoc", name: "Viêm da có bóng nước", category: "side_effect"},
    {id: "giam_bach_cau", name: "Giảm bạch cầu", category: "side_effect"},
    {id: "giam_tieu_cau", name: "Giảm tiểu cầu", category: "side_effect"},
    {id: "tang_asat", name: "Tăng ASAT", category: "side_effect"},
    {id: "tang_alat", name: "Tăng ALAT", category: "side_effect"},
    {id: "tang_phosphatase_kiem", name: "Tăng phosphatase kiềm", category: "side_effect"},
    {id: "viem_gan", name: "Viêm gan", category: "side_effect"},
    {id: "thieu_mau", name: "Thiếu máu", category: "risk_factor"},
    {id: "dai_thao_duong_tuyp_1", name: "Đái tháo đường tuýp 1", category: "disease"},
    {id: "dai_thao_duong_o_tre_em", name: "Đái tháo đường ở trẻ em", category: "disease"},
    {id: "nhiem_toan", name: "Nhiễm toan", category: "disease"},
    {id: "nhiem_ceton_nang", name: "Nhiễm ceton nặng", category: "disease"},
    {id: "hon_me_do_dai_thao_duong", name: "Hôn mê do đái tháo đường", category: "disease"},
    {id: "tien_hon_me_do_dai_thao_duong", name: "Tiền hôn mê do đái tháo đường", category: "disease"},
    {id: "suy_than_nang", name: "Suy thận nặng", category: "disease"},
    {id: "suy_gan_nang", name: "Suy gan nặng", category: "disease"}
  ] AS row
  MERGE (n:DiabetesConcept {id: row.id})
  SET n += row
  MERGE (source)-[:MENTIONS]->(n)
  RETURN count(*) AS concept_count
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong_tuyp_2", b: "dorocron", fact_id: "c188c82788e4", evidence: "Điều trị đái tháo đường typ 2 (không phụ thuộc insulin), phối hợp với chế độ ăn kiêng phù hợp, khi sự kiểm soát đường huyết không đạt được bằng chế độ ăn kiêng đơn thuần."}
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
    {a: "dorocron", b: "ngua", fact_id: "06fc4a3d966c", evidence: "Nổi ban ngoài da, niêm mạc: Ngứa, phát ban, nổi mày đay, hiếm khi có viêm da có bóng nước."},
    {a: "dorocron", b: "phat_ban", fact_id: "d9724beab1b7", evidence: "Nổi ban ngoài da, niêm mạc: Ngứa, phát ban, nổi mày đay, hiếm khi có viêm da có bóng nước."},
    {a: "dorocron", b: "noi_may_day", fact_id: "f06460787b31", evidence: "Nổi ban ngoài da, niêm mạc: Ngứa, phát ban, nổi mày đay, hiếm khi có viêm da có bóng nước."},
    {a: "dorocron", b: "viem_da_co_bong_nuoc", fact_id: "9db80fecb864", evidence: "Nổi ban ngoài da, niêm, mạc: Ngứa, phát ban, nổi mày đay, hiếm khi có viêm da có bóng nước."},
    {a: "dorocron", b: "giam_bach_cau", fact_id: "d47ebc7cd0fc", evidence: "Máu (rất hiếm): Thiếu máu, giảm bạch cầu, giảm tiểu cầu."},
    {a: "dorocron", b: "giam_tieu_cau", fact_id: "0edc66f98c79", evidence: "Máu (rất hiếm): Thiếu máu, giảm bạch cầu, giảm tiểu cầu."},
    {a: "dorocron", b: "tang_asat", fact_id: "5bd2f8d10dbf", evidence: "Tăng ASAT, ALAT, phosphatase kiềm, viêm gan (hiếm)."},
    {a: "dorocron", b: "tang_alat", fact_id: "4270c0b1b4b8", evidence: "Tăng ASAT, ALAT, phosphatase kiềm, viêm gan (hiếm)."},
    {a: "dorocron", b: "tang_phosphatase_kiem", fact_id: "6f976b981de9", evidence: "Tăng ASAT, ALAT, phosphatase kiềm, viêm gan (hiếm)."},
    {a: "dorocron", b: "viem_gan", fact_id: "aad6dbd0a27a", evidence: "Tăng ASAT, ALAT, phosphatase kiềm, viêm gan (hiếm)."},
    {a: "dorocron", b: "thieu_mau", fact_id: "86ae75d9a39c", evidence: "Máu (rất hiếm): Thiếu máu, giảm bạch cầu, giảm tiểu cầu."}
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
    {a: "dorocron", b: "dai_thao_duong_tuyp_1", fact_id: "5c2f592fd1d6", evidence: "Đái tháo đường typ 1, đặc biệt là đái tháo đường ở trẻ em, nhiễm toan, nhiễm ceton nặng, hôn mê hay tiền hôn mê do đái tháo đường ."},
    {a: "dorocron", b: "dai_thao_duong_o_tre_em", fact_id: "edd83360de5a", evidence: "Đái tháo đường typ 1, đặc biệt là đái tháo đường ở trẻ em, nhiễm toan, nhiễm ceton nặng, hôn mê hay tiền hôn mê do đái tháo đường ."},
    {a: "dorocron", b: "nhiem_toan", fact_id: "a99760d7fbbd", evidence: "Đái tháo đường typ 1, đặc biệt là đái tháo đường ở trẻ em, nhiễm toan, nhiễm ceton nặng, hôn mê hay tiền hôn mê do đái tháo đường ."},
    {a: "dorocron", b: "nhiem_ceton_nang", fact_id: "c6ebb2929f21", evidence: "Đái tháo đường typ 1, đặc biệt là đái tháo đường ở trẻ em, nhiễm toan, nhiễm ceton nặng, hôn mê hay tiền hôn mê do đái tháo đường ."},
    {a: "dorocron", b: "hon_me_do_dai_thao_duong", fact_id: "179263edfd39", evidence: "Đái tháo đường typ 1, đặc biệt là đái tháo đường ở trẻ em, nhiễm toan, nhiễm ceton nặng, hôn mê hay tiền hôn mê do đái tháo đường ."},
    {a: "dorocron", b: "tien_hon_me_do_dai_thao_duong", fact_id: "d568fd21e95d", evidence: "Đái tháo đường typ 1, đặc biệt là đái tháo đường ở trẻ em, nhiễm toan, nhiễm ceton nặng, hôn mê hay tiền hôn mê do đái tháo đường ."},
    {a: "dorocron", b: "suy_than_nang", fact_id: "bac8c1a8b6be", evidence: "Suy thận nặng, suy gan nặng."},
    {a: "dorocron", b: "suy_gan_nang", fact_id: "5b95a80397f2", evidence: "Suy thận nặng, suy gan nặng."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:CONTRAINDICATED_IN {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_3
}
RETURN source.id AS source_id, concept_count,
       rel_count_1 + rel_count_2 + rel_count_3 AS fact_count;
