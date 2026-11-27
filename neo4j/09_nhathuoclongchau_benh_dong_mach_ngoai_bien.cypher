MERGE (source:DiabetesSource {id: "nhathuoclongchau_benh_dong_mach_ngoai_bien"})
SET source += {id: "nhathuoclongchau_benh_dong_mach_ngoai_bien", title: "Benh dong mach ngoai bien", publisher: "Nhà thuốc Long Châu", url: "https://nhathuoclongchau.com.vn/benh/benh-dong-mach-ngoai-bien-213.html", language: "vi", title_requires_review: true}
WITH source
CALL {
  WITH source
  UNWIND [
    {id: "benh_dong_mach_ngoai_bien", name: "Bệnh động mạch ngoại biên", category: "disease"},
    {id: "yeu_chi", name: "Yếu chi", category: "symptom"},
    {id: "mat_long", name: "Mất lông", category: "symptom"},
    {id: "mong_chan_gion", name: "Móng chân giòn", category: "symptom"},
    {id: "loet_da", name: "Loét da", category: "symptom"},
    {id: "thay_doi_mau_sac_da", name: "Thay đổi màu sắc da", category: "symptom"},
    {id: "da_bong_loang", name: "Da bóng loáng", category: "symptom"},
    {id: "roi_loan_cuong_duong", name: "Rối loạn cương dương", category: "symptom"},
    {id: "teo_co", name: "Teo cơ", category: "symptom"},
    {id: "dot_quy", name: "Đột quỵ", category: "disease"},
    {id: "benh_mach_vanh", name: "Bệnh mạch vành", category: "disease"},
    {id: "nhoi_mau_co_tim", name: "Nhồi máu cơ tim", category: "disease"},
    {id: "tac_mach_mau_chi_cap", name: "Tắc mạch máu chi cấp", category: "disease"},
    {id: "dau_that_nguc", name: "Đau thắt ngực", category: "disease"},
    {id: "thieu_mau_cuc_bo_o_chi_cap", name: "Thiếu máu cục bộ ở chi cấp", category: "disease"},
    {id: "chup_mach_mau_xoa_nen", name: "Chụp mạch máu xóa nền", category: "test"},
    {id: "sieu_am_mach_mau", name: "Siêu âm mạch máu", category: "test"},
    {id: "do_chi_so_abi", name: "Đo chỉ số ABI", category: "test"},
    {id: "xet_nghiem_mau", name: "Xét nghiệm máu", category: "test"},
    {id: "dai_thao_duong", name: "Đái tháo đường", category: "disease"},
    {id: "tang_huyet_ap", name: "Tăng huyết áp", category: "disease"},
    {id: "beo_phi", name: "Béo phì", category: "risk_factor"},
    {id: "hut_thuoc_la", name: "Hút thuốc lá", category: "risk_factor"},
    {id: "tang_cholesterol_mau", name: "Tăng cholesterol máu", category: "risk_factor"},
    {id: "cilostazol", name: "Cilostazol", category: "drug"},
    {id: "pentoxifylline", name: "Pentoxifylline", category: "drug"},
    {id: "aspirin", name: "Aspirin", category: "drug"},
    {id: "thuoc_chong_dong_mau", name: "Thuốc chống đông máu", category: "drug_class"},
    {id: "thay_doi_loi_song", name: "Thay đổi lối sống", category: "lifestyle"},
    {id: "tap_the_duc_thuong_xuyen", name: "Tập thể dục thường xuyên", category: "lifestyle"},
    {id: "khong_hut_thuoc", name: "Không hút thuốc", category: "lifestyle"}
  ] AS row
  MERGE (n:DiabetesConcept {id: row.id})
  SET n += row
  MERGE (source)-[:MENTIONS]->(n)
  RETURN count(*) AS concept_count
}
CALL {
  WITH source
  UNWIND [
    {a: "benh_dong_mach_ngoai_bien", b: "yeu_chi", fact_id: "a4238bf88913", evidence: "Cảm giác yếu chi;"},
    {a: "benh_dong_mach_ngoai_bien", b: "mat_long", fact_id: "04627ae90f13", evidence: "Mất lông ở vùng cẳng chân/chân;"},
    {a: "benh_dong_mach_ngoai_bien", b: "mong_chan_gion", fact_id: "25023861279f", evidence: "Móng chân giòn, mọc chậm;"},
    {a: "benh_dong_mach_ngoai_bien", b: "loet_da", fact_id: "124ca2601057", evidence: "Loét da vùng cẳng chân/chân khó lành;"},
    {a: "benh_dong_mach_ngoai_bien", b: "thay_doi_mau_sac_da", fact_id: "f3201ab595a4", evidence: "Thay đổi màu sắc da vùng chân;"},
    {a: "benh_dong_mach_ngoai_bien", b: "da_bong_loang", fact_id: "fd3884d005a0", evidence: "Da vùng chân bóng loáng;"},
    {a: "benh_dong_mach_ngoai_bien", b: "roi_loan_cuong_duong", fact_id: "55b629dbfcf1", evidence: "Ở nam giới có thể có rối loạn cương dương ;"},
    {a: "benh_dong_mach_ngoai_bien", b: "teo_co", fact_id: "6f66c7d704cf", evidence: "Teo cơ vùng chân ."}
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
    {a: "benh_dong_mach_ngoai_bien", b: "dot_quy", fact_id: "196ca2448997", evidence: "Bệnh động mạch ngoại biên không đe dọa tính mạng ngay lập tức nhưng quá trình xơ vữa động mạch có thể dẫn đến các vấn đề nghiêm trọng và có khả năng gây tử vong như bệnh mạch vành, nhồi máu cơ tim, đột quỵ hoặc tắc mạch máu chi cấp."},
    {a: "benh_dong_mach_ngoai_bien", b: "benh_mach_vanh", fact_id: "537bff794c7a", evidence: "Bệnh động mạch ngoại biên không đe dọa tính mạng ngay lập tức nhưng quá trình xơ vữa động mạch có thể dẫn đến các vấn đề nghiêm trọng và có khả năng gây tử vong như bệnh mạch vành, nhồi máu cơ tim, đột quỵ hoặc tắc mạch máu chi cấp."},
    {a: "benh_dong_mach_ngoai_bien", b: "nhoi_mau_co_tim", fact_id: "9e1b9a97cbd3", evidence: "Bệnh động mạch ngoại biên không đe dọa tính mạng ngay lập tức nhưng quá trình xơ vữa động mạch có thể dẫn đến các vấn đề nghiêm trọng và có khả năng gây tử vong như bệnh mạch vành, nhồi máu cơ tim, đột quỵ hoặc tắc mạch máu chi cấp."},
    {a: "benh_dong_mach_ngoai_bien", b: "tac_mach_mau_chi_cap", fact_id: "c3ce379f6d83", evidence: "Bệnh động mạch ngoại biên không đe dọa tính mạng ngay lập tức nhưng quá trình xơ vữa động mạch có thể dẫn đến các vấn đề nghiêm trọng và có khả năng gây tử vong như bệnh mạch vành, nhồi máu cơ tim, đột quỵ hoặc tắc mạch máu chi cấp."},
    {a: "benh_dong_mach_ngoai_bien", b: "dau_that_nguc", fact_id: "b7f720891b17", evidence: "Đau thắt ngực ;"},
    {a: "benh_dong_mach_ngoai_bien", b: "thieu_mau_cuc_bo_o_chi_cap", fact_id: "b4367965a76c", evidence: "Thiếu máu cục bộ ở chi cấp:"}
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
    {a: "benh_dong_mach_ngoai_bien", b: "chup_mach_mau_xoa_nen", fact_id: "b2da4a23b642", evidence: "Chụp mạch máu xóa nền (DSA)."},
    {a: "benh_dong_mach_ngoai_bien", b: "sieu_am_mach_mau", fact_id: "6b8021d0c630", evidence: "Siêu âm mạch máu ."},
    {a: "benh_dong_mach_ngoai_bien", b: "do_chi_so_abi", fact_id: "7e64c85811c8", evidence: "Đo chỉ số ABI : Chỉ số mắt cá chân-cánh tay bằng cách so sánh huyết áp ở cẳng chân và cánh tay của bạn."},
    {a: "benh_dong_mach_ngoai_bien", b: "xet_nghiem_mau", fact_id: "42f145bb6d68", evidence: "Xét nghiệm máu để kiểm tra các yếu tố nguy cơ như bệnh đái tháo đường hoặc tăng cholesterol máu."}
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
    {a: "benh_dong_mach_ngoai_bien", b: "dai_thao_duong", fact_id: "8528732fb632", evidence: "Đái tháo đường;"},
    {a: "benh_dong_mach_ngoai_bien", b: "tang_huyet_ap", fact_id: "fdb04b8ee9c0", evidence: "Tăng huyết áp;"},
    {a: "benh_dong_mach_ngoai_bien", b: "beo_phi", fact_id: "63a0c3cdc879", evidence: "Béo phì ;"},
    {a: "benh_dong_mach_ngoai_bien", b: "hut_thuoc_la", fact_id: "9b4377532f78", evidence: "Một số yếu tố làm tăng nguy cơ mắc bệnh động mạch ngoại biên, bao gồm: Hút thuốc lá;"},
    {a: "benh_dong_mach_ngoai_bien", b: "tang_cholesterol_mau", fact_id: "e4e380ff0c3f", evidence: "Tăng cholesterol máu;"}
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
    {a: "benh_dong_mach_ngoai_bien", b: "cilostazol", fact_id: "b3233496297e", evidence: "Thuốc cilostazol có thể giúp giảm bớt các triệu chứng ở nhiều người."},
    {a: "benh_dong_mach_ngoai_bien", b: "pentoxifylline", fact_id: "b93571c35e91", evidence: "Pentoxifylline là một loại thuốc khác có thể giúp cải thiện tình trạng lưu thông máu đến các chi."},
    {a: "benh_dong_mach_ngoai_bien", b: "aspirin", fact_id: "114d62a43d71", evidence: "Bác sĩ cũng có thể kê đơn aspirin hoặc các loại thuốc chống đông máu khác."},
    {a: "benh_dong_mach_ngoai_bien", b: "thuoc_chong_dong_mau", fact_id: "b1a274fade80", evidence: "Bác sĩ cũng có thể kê đơn aspirin hoặc các loại thuốc chống đông máu khác."},
    {a: "benh_dong_mach_ngoai_bien", b: "thay_doi_loi_song", fact_id: "7396bf8171c2", evidence: "Bệnh động mạch ngoại biên phần lớn được điều trị bằng cách thay đổi lối sống (xem phần chế độ sinh hoạt và phòng ngừa) và dùng thuốc."},
    {a: "benh_dong_mach_ngoai_bien", b: "tap_the_duc_thuong_xuyen", fact_id: "a27c7befbd99", evidence: "Tập thể dục thường xuyên và không hút thuốc là những thay đổi lối sống chính có thể làm giảm các triệu chứng của bệnh động mạch ngoại biên và giảm nguy cơ tiến triển của bệnh."},
    {a: "benh_dong_mach_ngoai_bien", b: "khong_hut_thuoc", fact_id: "c979f1687238", evidence: "Tập thể dục thường xuyên và không hút thuốc là những thay đổi lối sống chính có thể làm giảm các triệu chứng của bệnh động mạch ngoại biên và giảm nguy cơ tiến triển của bệnh."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:TREATED_BY {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_5
}
RETURN source.id AS source_id, concept_count,
       rel_count_1 + rel_count_2 + rel_count_3 + rel_count_4 + rel_count_5 AS fact_count;
