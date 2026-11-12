// Schema for the local copy of the diabetes knowledge graph.
// This file intentionally uses the generic Entity label so it works
// without APOC or other Neo4j plugins.

CREATE CONSTRAINT entity_name IF NOT EXISTS
FOR (n:Entity) REQUIRE n.name IS UNIQUE;

