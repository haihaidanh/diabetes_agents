# Neo4j local demo

Thư mục này tạo một bản sao local để trình bày với giảng viên. Runtime trên
Kaggle vẫn dùng Neo4j Aura; không đổi các biến `NEO4J_URI`, `NEO4J_USER` hoặc
`NEO4J_PASSWORD` của Aura trong notebook.

## Tạo file Cypher từ Knowledge Graph

Sau khi cập nhật PDF/HTML và chạy lại pipeline:

```powershell
python main.py parse
python main.py parse-pdf
python main.py extract
python main.py kg
python neo4j/export_cypher.py
```

Lệnh cuối tạo [02_load_graph.cypher](./02_load_graph.cypher) từ
`artifacts/kb/kg.pkl`. File này là snapshot local của graph tại thời điểm
export; chạy export lại sau mỗi lần chạy `python main.py kg`.

## Nạp vào Neo4j local

Khởi động Neo4j Desktop/Neo4j local với Bolt ở `localhost:7687`, sau đó trong
Neo4j Browser chạy lần lượt:

```text
01_schema.cypher
02_load_graph.cypher
```

Hoặc dùng `cypher-shell`:

```powershell
cypher-shell -a bolt://localhost:7687 -u neo4j -p "<local-password>" `
  -f neo4j/01_schema.cypher
cypher-shell -a bolt://localhost:7687 -u neo4j -p "<local-password>" `
  -f neo4j/02_load_graph.cypher
```

Sau đó chạy các truy vấn minh họa trong `03_examples.cypher`.

## Kiểm tra kết nối local từ Python

Chỉ áp dụng các biến môi trường cho **một process local**:

```powershell
$env:NEO4J_URI = "bolt://localhost:7687"
$env:NEO4J_USER = "neo4j"
$env:NEO4J_PASSWORD = "<local-password>"
python main.py neo4j-push
```

Lệnh trên dùng `artifacts/kb/kg.pkl` để nạp vào local. Nó không xóa hoặc sửa
Aura, vì URI local chỉ tồn tại trong process PowerShell đó. Khi chạy Kaggle,
tiếp tục đặt lại các biến Aura và giữ `KG_BACKEND=neo4j` như trước.

Nếu chỉ cần trình bày bằng Cypher, không cần chạy `main.py neo4j-push`; chỉ
cần nạp `01_schema.cypher` và `02_load_graph.cypher`. Lưu ý file load bắt đầu
bằng `MATCH (n) DETACH DELETE n`, nên chỉ chạy trong database local dành riêng
cho demo.

