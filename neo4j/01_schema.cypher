// ==============================================================================
// 01_SCHEMA.CYPHER: KHỞI TẠO CẤU TRÚC BẢNG VÀ CHỈ MỤC CHO KNOWLEDGE GRAPH (NEO4J)
// ==============================================================================

// 1. Ràng buộc duy nhất (Unique Constraint) cho thực thể theo tên
CREATE CONSTRAINT entity_name IF NOT EXISTS
FOR (n:Entity) REQUIRE n.name IS UNIQUE;

// 2. Tạo chỉ mục (Indexes) để tăng tốc độ tìm kiếm theo phân loại và thuộc tính
CREATE INDEX entity_type_idx IF NOT EXISTS
FOR (n:Entity) ON (n.type);

CREATE INDEX disease_name_idx IF NOT EXISTS
FOR (n:Disease) ON (n.name);

CREATE INDEX drug_name_idx IF NOT EXISTS
FOR (n:Drug) ON (n.name);

CREATE INDEX symptom_name_idx IF NOT EXISTS
FOR (n:Symptom) ON (n.name);


