MERGE (source:DiabetesSource {id: "nhathuoclongchau_7_dau_hieu_thuong_thay_o_nguoi_mac_benh_tieu_duong"})
SET source += {id: "nhathuoclongchau_7_dau_hieu_thuong_thay_o_nguoi_mac_benh_tieu_duong", title: "7 dau hieu thuong thay o nguoi mac benh tieu duong", publisher: "Nhà thuốc Long Châu", url: "https://nhathuoclongchau.com.vn/bai-viet/7-dau-hieu-thuong-thay-o-nguoi-mac-benh-tieu-duong-6861.html", language: "vi", title_requires_review: true}
WITH source
CALL {
  WITH source
  UNWIND [
    {id: "dai_thao_duong", name: "Đái tháo đường", category: "disease"},
    {id: "khat_nuoc", name: "Khát nước", category: "symptom"},
    {id: "an_rat_nhieu", name: "Ăn rất nhiều", category: "symptom"},
    {id: "vet_thuong_cham_lanh", name: "Vết thương chậm lành", category: "symptom"},
    {id: "di_tieu_nhieu", name: "Đi tiểu nhiều", category: "side_effect"},
    {id: "nhiem_trung", name: "Nhiễm trùng", category: "risk_factor"}
  ] AS row
  MERGE (n:DiabetesConcept {id: row.id})
  SET n += row
  MERGE (source)-[:MENTIONS]->(n)
  RETURN count(*) AS concept_count
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong", b: "khat_nuoc", fact_id: "7ef236356479", evidence: "Bệnh nhân luôn khát nước\nBởi khi bị mắc bệnh tiểu đường , sẽ có mức đường huyết trong máu cao hơn và nó sẽ lấy nước từ các tế bào pha loãng đường có trong máu, chính vì thế mà làm cho các tế bào trong cơ thể bị thiếu nước, khi đó chúng sẽ kích thích não để có điều chỉnh cảm giác khát của cơ thể. Do vậy mà ở những người bị bệnh tiểu đường thường uống rất nhiều nước."},
    {a: "dai_thao_duong", b: "an_rat_nhieu", fact_id: "0cdd39e86ccf", evidence: "Ăn rất nhiều\nBởi lượng đường có trong máu cao, cơ chế của cơ thể là tiết ra nhiều insulin để có thể chuyển hóa đường vào trong cơ thể. Tuy nhiên, insulin trong cơ thể lại có khả năng kích thích cảm giác đói nên khiến người bệnh tiểu đường ăn rất nhiều."},
    {a: "dai_thao_duong", b: "vet_thuong_cham_lanh", fact_id: "c534e62e89b4", evidence: "Vết thương chậm lành\nLượng đường có trong máu của người bệnh tiểu đường quá cao và gây khó khăn cho các hoạt động của tế bào bạch cầu có trong máu, vì thế nó làm cho các vết thương hở trở nên lâu lành hơn và thường bị nhiễm trùng nhiều hơn."},
    {a: "dai_thao_duong", b: "di_tieu_nhieu", fact_id: "ad0023c826eb", evidence: "Luôn đi tiểu nhiều\nVì uống nhiều nước, kèm theo đó là trong máu có quá nhiều đường nên cơ thể phải đào thải bớt ra bằng đường nước tiểu. Chính vì vậy, một dấu hiệu thường thấy ở người bị bệnh tiểu đường chính là đi tiểu nhiều, và nước tiểu có kiến bu quanh rất nhiều."},
    {a: "dai_thao_duong", b: "nhiem_trung", fact_id: "b7fdaa3c10ec", evidence: "Dễ mắc các bệnh nhiễm trùng"}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:HAS_SYMPTOM {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_1
}
RETURN source.id AS source_id, concept_count,
       rel_count_1 AS fact_count;
