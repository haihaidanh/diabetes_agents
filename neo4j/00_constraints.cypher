CREATE CONSTRAINT diabetes_source_id IF NOT EXISTS FOR (s:DiabetesSource) REQUIRE s.id IS UNIQUE;
CREATE CONSTRAINT diabetes_concept_id IF NOT EXISTS FOR (c:DiabetesConcept) REQUIRE c.id IS UNIQUE;
