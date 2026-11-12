// Example queries for demonstrating the local knowledge graph.

// Count entities and relationships.
MATCH (n:Entity)
RETURN count(n) AS entity_count;

MATCH ()-[r]->()
RETURN count(r) AS relationship_count;

// Find symptoms of diabetes.
MATCH (d:Entity {name: "Đái tháo đường"})-[r:HAS_SYMPTOM]->(s:Entity)
RETURN d.name AS disease, s.name AS symptom, r.evidence AS evidence, r.url AS source;

// Inspect information about a drug.
MATCH (d:Entity {name: "Metformin"})-[r]->(x:Entity)
RETURN d.name AS drug, type(r) AS relation, x.name AS object,
       r.evidence AS evidence, r.url AS source;

// Show relationships imported from a PDF source.
MATCH (a:Entity)-[r]->(b:Entity)
WHERE r.url STARTS WITH "pdf/"
RETURN a.name AS subject, type(r) AS relation, b.name AS object,
       r.evidence AS evidence, r.url AS source
LIMIT 20;

