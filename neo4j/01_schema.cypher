// Schema for the local diabetes knowledge graph.
// All concepts use :Entity; their category is stored in the `type` property.

// The constraint also creates an index for Entity.name lookups.
CREATE CONSTRAINT entity_name IF NOT EXISTS
FOR (n:Entity) REQUIRE n.name IS UNIQUE;

// Entity categories (Disease, Drug, Symptom, ...) are values of n.type,
// not separate Neo4j labels.
CREATE INDEX entity_type_idx IF NOT EXISTS
FOR (n:Entity) ON (n.type);

