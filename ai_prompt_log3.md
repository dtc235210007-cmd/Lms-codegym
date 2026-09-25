# NHẬT KÝ TRA CỨU VÀ TƯƠNG TÁC KỸ THUẬT (AI PROMPT LOG)

### Prompt 1: Truy vấn kích thước bộ nhớ Data và Index
- **Câu hỏi**: "Làm thế nào để đo lường chính xác dung lượng thực tế của Data và Index theo đơn vị MB trong MySQL?"
- **Thu hoạch**: Khai thác view `information_schema.TABLES`, sử dụng hai trường `DATA_LENGTH` và `INDEX_LENGTH`, chia cho `1024 * 1024` để chuyển đổi Byte sang Megabyte.

### Prompt 2: Bản chất của Cardinality và chi phí Random I/O
- **Câu hỏi**: "Tại sao đánh Index trên cột có Cardinality thấp (như 0 và 1) lại bị Query Optimizer bỏ qua và gây hại cho hệ thống?"
- **Thu hoạch**: Khi một giá trị chiếm tỉ lệ lớn dữ liệu (ví dụ 90% bản ghi có `is_visible = 1`), việc duyệt Index rồi thực hiện Bookmark Lookup (Random Read) về Clustered Index tốn tài nguyên gấp nhiều lần so với việc đọc tuần tự toàn bộ bảng (Sequential Read).

### Prompt 3: Giải pháp tìm kiếm văn bản thay thế B-Tree
- **Câu hỏi**: "Giải pháp nào thay thế việc tạo B-Tree Index trên cột content TEXT mà không làm phình to đĩa cứng?"
- **Thu hoạch**: B-Tree không hiệu quả với tìm kiếm từ khóa con. Cần chuyển đổi sang `FULLTEXT Index` (sử dụng cấu trúc Inverted Index) hoặc tích hợp các Search Engine chuyên dụng như Elasticsearch/Meilisearch cho mạng xã hội.

- Câu hỏi vấn đáp:
- Câu 1: "Điều gì xảy ra ở tầng vật lý khi chạy lệnh INSERT vào bảng có 5 Index? Tại sao người dùng bị Timeout?"

Trả lời: Mỗi bản ghi được thêm vào không chỉ ghi vào vùng dữ liệu chính, mà động cơ lưu trữ (InnoDB) phải tìm đúng vị trí trên 5 cây B-Tree khác nhau để chèn nút mới. Nếu trang dữ liệu (Page 16KB) bị đầy, hệ thống phải thực hiện Page Split, ghi ngẫu nhiên (Random Disk I/O) liên tục xuống ổ cứng, làm nghẽn hàng đợi ghi và dẫn tới Timeout.

Câu 2: "Cardinality là gì? Tại sao cột Giới tính hoặc Status lại là ứng cử viên tồi tệ nhất?"

Trả lời: Cardinality là số lượng giá trị duy nhất (unique) của một cột. Cột trạng thái chỉ có 2 giá trị nên Cardinality cực thấp. Khi tìm kiếm, một giá trị có thể trỏ tới 50%–90% số dòng trong bảng. Trình tối ưu hóa MySQL nhận thấy chi phí lật qua Index rồi quay lại lấy dòng dữ liệu gốc đắt hơn nhiều so với việc đọc thẳng một mạch từ đầu đến cuối bảng (Full Table Scan).

Câu 3: "Nếu bảng là bảng Archive (chỉ đọc, hiếm khi chèn/sửa/xóa) thì việc có nhiều Index có còn là thảm họa không?"

Trả lời: Không còn là thảm họa về tốc độ ghi, vì hệ thống lúc này chịu tải Read-Heavy (đọc là chính). Tuy nhiên, vẫn cần cân nhắc dung lượng đĩa và kích thước RAM (InnoDB Buffer Pool); nếu các Index vô dụng chiếm hết RAM thì các trang dữ liệu thực tế sẽ bị đẩy ra ngoài đĩa, làm chậm toàn bộ hệ thống đọc.
