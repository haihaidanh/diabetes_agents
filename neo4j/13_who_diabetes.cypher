MERGE (source:DiabetesSource {id: "who_diabetes"})
SET source += {id: "who_diabetes", title: "Diabetes", publisher: "WHO", url: "https://www.who.int/News-Room/Fact-Sheets/Detail/Diabetes", language: "en", title_requires_review: true}
WITH source
CALL {
  WITH source
  UNWIND [
    {id: "diabetes", name: "Diabetes", category: "disease"},
    {id: "physical_activity", name: "Physical activity", category: "lifestyle"},
    {id: "healthy_lifestyle", name: "Healthy lifestyle", category: "lifestyle"},
    {id: "medication", name: "Medication", category: "drug"},
    {id: "insulin_injections", name: "Insulin injections", category: "drug"},
    {id: "sglt_2_inhibitors", name: "SGLT-2 inhibitors", category: "drug"},
    {id: "statins", name: "Statins", category: "drug"},
    {id: "diet", name: "Diet", category: "lifestyle"},
    {id: "a_healthy_diet", name: "A healthy diet", category: "lifestyle"},
    {id: "regular_physical_activity", name: "Regular physical activity", category: "lifestyle"},
    {id: "maintaining_a_normal_body_weight", name: "Maintaining a normal body weight", category: "lifestyle"},
    {id: "avoiding_tobacco_use", name: "Avoiding tobacco use", category: "lifestyle"},
    {id: "stroke", name: "Stroke", category: "disease"},
    {id: "heart_attack", name: "Heart attack", category: "risk_factor"},
    {id: "kidney_failure", name: "Kidney failure", category: "risk_factor"},
    {id: "kidney_disease", name: "Kidney disease", category: "disease"},
    {id: "type_1_diabetes", name: "Type 1 diabetes", category: "disease"},
    {id: "deficient_insulin_production", name: "Deficient insulin production", category: "symptom"},
    {id: "type_2_diabetes", name: "Type 2 diabetes", category: "disease"},
    {id: "high_levels_of_blood_sugar", name: "High levels of blood sugar", category: "symptom"},
    {id: "regular_check_ups_and_blood_tests", name: "Regular check-ups and blood tests", category: "test"},
    {id: "being_overweight", name: "Being overweight", category: "risk_factor"},
    {id: "not_getting_enough_exercise", name: "Not getting enough exercise", category: "risk_factor"},
    {id: "genetics", name: "Genetics", category: "risk_factor"},
    {id: "non_insulin_dependent", name: "Non-insulin dependent", category: "risk_factor"},
    {id: "gestational_diabetes", name: "Gestational diabetes", category: "disease"},
    {id: "hyperglycaemia", name: "Hyperglycaemia", category: "symptom"},
    {id: "prenatal_screening", name: "Prenatal screening", category: "test"},
    {id: "pregnancy", name: "Pregnancy", category: "disease"}
  ] AS row
  MERGE (n:DiabetesConcept {id: row.id})
  SET n += row
  MERGE (source)-[:MENTIONS]->(n)
  RETURN count(*) AS concept_count
}
CALL {
  WITH source
  UNWIND [
    {a: "diabetes", b: "physical_activity", fact_id: "3ecd34144d64", evidence: "Diabetes can be treated with diet, physical activity and medication, and its consequences avoided through regular screening for complications and timely treatment."},
    {a: "diabetes", b: "healthy_lifestyle", fact_id: "940d05e3b56a", evidence: "One of the most important ways to treat diabetes is to keep a healthy lifestyle."},
    {a: "diabetes", b: "medication", fact_id: "5f9388bbe845", evidence: "Diabetes can be treated with diet, physical activity and medication, and its consequences avoided through regular screening for complications and timely treatment."},
    {a: "diabetes", b: "insulin_injections", fact_id: "2e8b87165d92", evidence: "People with type 1 diabetes need insulin injections for survival."},
    {a: "diabetes", b: "sglt_2_inhibitors", fact_id: "d0ec3d48ddfb", evidence: "Some people with type 2 diabetes will need to take medicines to help manage their blood sugar levels. These can include insulin injections or other medicines. Some examples include: sodium-glucose co-transporters type 2 (SGLT-2) inhibitors."},
    {a: "diabetes", b: "statins", fact_id: "afec4ea3f826", evidence: "Along with medicines to lower blood sugar, people with diabetes often need medications to lower their blood pressure and statins to reduce the risk of complications."},
    {a: "diabetes", b: "diet", fact_id: "d3760b1c868f", evidence: "Diabetes can be treated with diet, physical activity and medication, and its consequences avoided through regular screening for complications and timely treatment."}
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
    {a: "diabetes", b: "a_healthy_diet", fact_id: "5c79a5f493df", evidence: "A healthy diet, regular physical activity, maintaining a normal body weight and avoiding tobacco use are ways to prevent or delay the onset of type 2 diabetes."},
    {a: "diabetes", b: "regular_physical_activity", fact_id: "f6412a95e6fe", evidence: "A healthy diet, regular physical activity, maintaining a normal body weight and avoiding tobacco use are ways to prevent or delay the onset of type 2 diabetes."},
    {a: "diabetes", b: "maintaining_a_normal_body_weight", fact_id: "add98776f1b0", evidence: "A healthy diet, regular physical activity, maintaining a normal body weight and avoiding tobacco use are ways to prevent or delay the onset of type 2 diabetes."},
    {a: "diabetes", b: "avoiding_tobacco_use", fact_id: "3d020b8d0c9a", evidence: "A healthy diet, regular physical activity, maintaining a normal body weight and avoiding tobacco use are ways to prevent or delay the onset of type 2 diabetes."}
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
    {a: "diabetes", b: "stroke", fact_id: "b87337f9bee0", evidence: "People with diabetes have a higher risk of health problems including heart attack, stroke and kidney failure."},
    {a: "diabetes", b: "heart_attack", fact_id: "7e8fcf594eb9", evidence: "People with diabetes have a higher risk of health problems including heart attack, stroke and kidney failure."},
    {a: "diabetes", b: "kidney_failure", fact_id: "68be9be0bd30", evidence: "People with diabetes have a higher risk of health problems including heart attack, stroke and kidney failure."},
    {a: "type_2_diabetes", b: "being_overweight", fact_id: "58f8423c369e", evidence: "Type 2 diabetes is often preventable. Factors that contribute to developing type 2 diabetes include being overweight, not getting enough exercise, and genetics."},
    {a: "type_2_diabetes", b: "not_getting_enough_exercise", fact_id: "ffc294ed036f", evidence: "Type 2 diabetes is often preventable. Factors that contribute to developing type 2 diabetes include being overweight, not getting enough exercise, and genetics."},
    {a: "type_2_diabetes", b: "genetics", fact_id: "2e7595ce3d63", evidence: "Type 2 diabetes is often preventable. Factors that contribute to developing type 2 diabetes include being overweight, not getting enough exercise, and genetics."},
    {a: "type_2_diabetes", b: "non_insulin_dependent", fact_id: "e7fe00c25a5d", evidence: "More than 95% of people with diabetes have type 2 diabetes. Type 2 diabetes was formerly called non-insulin dependent, or adult onset. Until recently, this type of diabetes was seen only in adults but it is now also occurring increasingly frequently in children."},
    {a: "gestational_diabetes", b: "pregnancy", fact_id: "6f6e314ea6e7", evidence: "Gestational diabetes occurs during pregnancy."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:HAS_RISK_FACTOR {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_3
}
CALL {
  WITH source
  UNWIND [
    {a: "kidney_disease", b: "diabetes", fact_id: "828619597104", evidence: "Another 390 000 kidney disease deaths were caused by diabetes, and high blood glucose causes around 10% of cardiovascular deaths (1) ."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:HAS_COMPLICATION {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_4
}
CALL {
  WITH source
  UNWIND [
    {a: "type_1_diabetes", b: "deficient_insulin_production", fact_id: "ceb7fc1851af", evidence: "Type 1 diabetes (previously known as insulin-dependent, juvenile or childhood-onset) is characterized by deficient insulin production and requires daily administration of insulin."},
    {a: "type_2_diabetes", b: "high_levels_of_blood_sugar", fact_id: "a2281dfddaff", evidence: "Type 2 diabetes affects how your body uses sugar (glucose) for energy. It stops the body from using insulin properly, which can lead to high levels of blood sugar if not treated."},
    {a: "gestational_diabetes", b: "hyperglycaemia", fact_id: "0a1fbd4f699a", evidence: "Gestational diabetes is hyperglycaemia with blood glucose values above normal but below those diagnostic of diabetes."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:HAS_SYMPTOM {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_5
}
CALL {
  WITH source
  UNWIND [
    {a: "type_2_diabetes", b: "regular_check_ups_and_blood_tests", fact_id: "646bca956ab3", evidence: "Early diagnosis is important to prevent the worst effects of type 2 diabetes. The best way to detect diabetes early is to get regular check-ups and blood tests with a health-care provider."},
    {a: "gestational_diabetes", b: "prenatal_screening", fact_id: "31c2ce46d8bb", evidence: "Gestational diabetes is diagnosed through prenatal screening, rather than through reported symptoms."}
  ] AS row
  MATCH (a:DiabetesConcept {id: row.a})
  MATCH (b:DiabetesConcept {id: row.b})
  MERGE (a)-[r:DIAGNOSED_BY {source_id: source.id, fact_id: row.fact_id}]->(b)
  SET r += row, r.a = null, r.b = null, r.fact_id = row.fact_id
  RETURN count(*) AS rel_count_6
}
RETURN source.id AS source_id, concept_count,
       rel_count_1 + rel_count_2 + rel_count_3 + rel_count_4 + rel_count_5 + rel_count_6 AS fact_count;
