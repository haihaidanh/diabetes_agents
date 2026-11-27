MERGE (source:DiabetesSource {id: "tamanhhospital_nhieu_nguoi_khong_biet_bi_tieu_duong_den_khi_cap_cuu"})
SET source += {id: "tamanhhospital_nhieu_nguoi_khong_biet_bi_tieu_duong_den_khi_cap_cuu", title: "Nhieu nguoi khong biet bi tieu duong den khi cap cuu", publisher: "Bệnh viện Tâm Anh", url: "https://tamanhhospital.vn/tin-tuc/nhieu-nguoi-khong-biet-bi-tieu-duong-den-khi-cap-cuu/", language: "vi", title_requires_review: true}
WITH source
CALL {
  WITH source
  UNWIND [
    {id: "dai_thao_duong", name: "Đái tháo đường", category: "disease"},
    {id: "kien_bu_nuoc_tieu", name: "Kiến bu nước tiểu", category: "symptom"},
    {id: "giam_can_khong_ly_do", name: "Giảm cân không lý do", category: "symptom"},
    {id: "vet_thuong_lau_lanh", name: "Vết thương lâu lành", category: "symptom"},
    {id: "viem_tuy_cap", name: "Viêm tụy cấp", category: "disease"},
    {id: "khong_hut_thuoc", name: "Không hút thuốc", category: "lifestyle"},
    {id: "an_nhieu_rau_xanh_co_nhieu_chat_xo", name: "Ăn nhiều rau xanh có nhiều chất xơ", category: "lifestyle"},
    {id: "tap_the_duc_it_nhat_30_phut_moi_ngay", name: "Tập thể dục ít nhất 30 phút mỗi ngày", category: "lifestyle"},
    {id: "han_che_an_tinh_bot_chat_beo_nuoc_ngot_ruou_bia", name: "Hạn chế ăn tinh bột, chất béo, nước ngọt, rượu bia", category: "lifestyle"},
    {id: "tien_dai_thao_duong", name: "Tiền đái tháo đường", category: "disease"},
    {id: "hba1c", name: "HbA1c", category: "disease"},
    {id: "tieu_duong_tip_2", name: "Tiểu đường típ 2", category: "disease"},
    {id: "khat_nuoc", name: "Khát nước", category: "symptom"},
    {id: "insulin_ha_duong_huyet", name: "Insulin hạ đường huyết", category: "drug"},
    {id: "thuoc_ha_huyet_ap", name: "Thuốc hạ huyết áp", category: "drug"},
    {id: "thuoc_khang_ket_tap_tieu_cau_kep", name: "Thuốc kháng kết tập tiểu cầu kép", category: "drug"}
  ] AS row
  MERGE (n:DiabetesConcept {id: row.id})
  SET n += row
  MERGE (source)-[:MENTIONS]->(n)
  RETURN count(*) AS concept_count
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong", b: "kien_bu_nuoc_tieu", fact_id: "3c8a3f05ce48", evidence: "Do đó, ngoài việc đi khám sức khỏe định kỳ, tầm soát bệnh tiểu đường, người bệnh hãy đi khám ngay với bác sĩ chuyên về Nội tiết – Đái tháo đường khi có dấu hiệu: khát nước, tiểu nhiều, kiến bu nước tiểu, giảm cân không lý do, buồn nôn, nhìn mờ, vết thương lâu lành…"},
    {a: "dai_thao_duong", b: "giam_can_khong_ly_do", fact_id: "82343a2bbdc7", evidence: "Do đó, ngoài việc đi khám sức khỏe định kỳ, tầm soát bệnh tiểu đường, người bệnh hãy đi khám ngay với bác sĩ chuyên về Nội tiết – Đái tháo đường khi có dấu hiệu: khát nước, tiểu nhiều, kiến bu nước tiểu, giảm cân không lý do, buồn nôn, nhìn mờ, vết thương lâu lành…"},
    {a: "dai_thao_duong", b: "vet_thuong_lau_lanh", fact_id: "4b5fb5eb6421", evidence: "Do đó, ngoài việc đi khám sức khỏe định kỳ, tầm soát bệnh tiểu đường, người bệnh hãy đi khám ngay với bác sĩ chuyên về Nội tiết – Đái tháo đường khi có dấu hiệu: khát nước, tiểu nhiều, kiến bu nước tiểu, giảm cân không lý do, buồn nôn, nhìn mờ, vết thương lâu lành…"},
    {a: "tieu_duong_tip_2", b: "khat_nuoc", fact_id: "8165b8f198b6", evidence: "Mỗi ngày uống gần 2 lít nước nhưng bà P.T.L. (63 tuổi, quận 4, TP.HCM) vẫn thấy khô họng, khát nước."}
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
    {a: "dai_thao_duong", b: "viem_tuy_cap", fact_id: "66a4b6d7d2ab", evidence: "Tương tự, anh P.V.H. (45 tuổi, tỉnh Bà Rịa – Vũng Tàu) được đưa vào khoa Cấp cứu, BVĐK Tâm Anh TP.HCM trong tình trạng bụng đau quằn quại. Nhận thấy người bệnh có những triệu chứng của viêm tụy cấp, ngay lập tức bác sĩ Khương chỉ định cho người bệnh nhập lên khoa ICU. Kết quả xét nghiệm đúng như bác sĩ Khương chẩn đoán, anh H. bị viêm tụy cấp và tiểu đường với chỉ số HbA1C ở mức 7.2% (bình thường khoảng 4 – 6 %), chỉ số viêm tụy cao đến 169 mg/L."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:HAS_COMPLICATION {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_2
}
CALL {
  WITH source
  UNWIND [
    {a: "dai_thao_duong", b: "khong_hut_thuoc", fact_id: "07f883ef40bf", evidence: "Với người dù bị tiểu đường hay không cũng cần ăn nhiều rau xanh có nhiều chất xơ làm chậm hấp thu đường huyết vào cơ thể, tập thể dục ít nhất 30 phút mỗi ngày, hạn chế ăn tinh bột, chất béo, nước ngọt, rượu bia, không hút thuốc… để giảm nguy cơ bị tiểu đường tuýp 2."},
    {a: "dai_thao_duong", b: "an_nhieu_rau_xanh_co_nhieu_chat_xo", fact_id: "6c4052f16ea4", evidence: "Với người dù bị tiểu đường hay không cũng cần ăn nhiều rau xanh có nhiều chất xơ làm chậm hấp thu đường huyết vào cơ thể, tập thể dục ít nhất 30 phút mỗi ngày, hạn chế ăn tinh bột, chất béo, nước ngọt, rượu bia, không hút thuốc… để giảm nguy cơ bị tiểu đường tuýp 2."},
    {a: "dai_thao_duong", b: "tap_the_duc_it_nhat_30_phut_moi_ngay", fact_id: "a03df80d6dfe", evidence: "Với người dù bị tiểu đường hay không cũng cần ăn nhiều rau xanh có nhiều chất xơ làm chậm hấp thu đường huyết vào cơ thể, tập thể dục ít nhất 30 phút mỗi ngày, hạn chế ăn tinh bột, chất béo, nước ngọt, rượu bia, không hút thuốc… để giảm nguy cơ bị tiểu đường tuýp 2."},
    {a: "dai_thao_duong", b: "han_che_an_tinh_bot_chat_beo_nuoc_ngot_ruou_bia", fact_id: "ee1733d8981a", evidence: "Với người dù bị tiểu đường hay không cũng cần ăn nhiều rau xanh có nhiều chất xơ làm chậm hấp thu đường huyết vào cơ thể, tập thể dục ít nhất 30 phút mỗi ngày, hạn chế ăn tinh bột, chất béo, nước ngọt, rượu bia, không hút thuốc… để giảm nguy cơ bị tiểu đường tuýp 2."}
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
    {a: "tien_dai_thao_duong", b: "hba1c", fact_id: "5eca3049d6f1", op: "range", value: 4, value_max: 6, unit: "%", evidence: "bị viêm tụy cấp và tiểu đường với chỉ số HbA1C ở mức 7.2% (bình thường khoảng 4 – 6 %), chỉ số viêm tụy cao đến 169 mg/L."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:DIAGNOSED_BY {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_4
}
CALL {
  WITH source
  UNWIND [
    {a: "tieu_duong_tip_2", b: "insulin_ha_duong_huyet", fact_id: "78ac2c3dad30", evidence: "Bà L. được truyền insulin hạ đường huyết, uống thuốc hạ huyết áp, hạ mỡ máu, thuốc kháng kết tập tiểu cầu kép chặn nguy cơ đột quỵ."},
    {a: "tieu_duong_tip_2", b: "thuoc_ha_huyet_ap", fact_id: "3631c28a6585", evidence: "Bà L. được truyền insulin hạ đường huyết, uống thuốc hạ huyết áp, hạ mỡ máu, thuốc kháng kết tập tiểu cầu kép chặn nguy cơ đột quỵ."},
    {a: "tieu_duong_tip_2", b: "thuoc_khang_ket_tap_tieu_cau_kep", fact_id: "973155b50177", evidence: "Bà L. được truyền insulin hạ đường huyết, uống thuốc hạ huyết áp, hạ mỡ máu, thuốc kháng kết tập tiểu cầu kép chặn nguy cơ đột quỵ."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:TREATED_BY {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_5
}
RETURN source.id AS source_id, concept_count,
       rel_count_1 + rel_count_2 + rel_count_3 + rel_count_4 + rel_count_5 AS fact_count;
