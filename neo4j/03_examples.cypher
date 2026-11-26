// Example queries for demonstrating the local diabetes knowledge graph.

// Count imported entities by category.
MATCH (n:Entity)
RETURN n.type AS category, count(*) AS entity_count
ORDER BY entity_count DESC;

// Count all imported relationships.
MATCH ()-[r]->()
RETURN count(r) AS relationship_count;

// Find symptoms of diabetes.
MATCH (d:Entity {name: "Đái tháo đường"})-[r:HAS_SYMPTOM]->(s:Entity)
RETURN d.name AS disease, s.name AS symptom, r.evidence AS evidence, r.url AS source;

// Inspect information about a drug.
MATCH (d:Entity {name: "Metformin"})-[r]->(x:Entity)
RETURN d.name AS drug, type(r) AS relation, x.name AS object,
       r.evidence AS evidence, r.url AS source;

// Show how the model's HbA1c feature maps to tests in the knowledge graph.
MATCH (feature:Entity {name: "HbA1c_level"})-[:MAPS_TO]->(test:Entity)
RETURN feature.name AS feature, test.name AS mapped_test;

// Inspect source-backed relationships.
MATCH (a:Entity)-[r]->(b:Entity)
WHERE r.url IS NOT NULL AND r.evidence IS NOT NULL
RETURN a.name AS subject, type(r) AS relation, b.name AS object,
       r.evidence AS evidence, r.url AS source
LIMIT 20;

