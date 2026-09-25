# NHẬT KÝ TRA CỨU KỸ THUẬT (AI PROMPT LOG)

### Prompt 1: Tính toán dung lượng Byte của từng phần tử Index
- **Câu hỏi**: "Tính toán chi tiết dung lượng lưu trữ trên 1 row của `idx_fat_covering` so với `idx_lean_search` trong MySQL InnoDB?"
- **Thu hoạch**: 
  - `idx_fat_covering`: `sensor_id` (4B) + `recorded_at` (5B) + `temperature` (3B) + `humidity` (3B) + `status` (VARCHAR 20 chars UTF8MB4 ~ 80B max + 1B prefix) + `log_id` (Primary key pointer 8B) $\approx$ **104 Bytes/row**.
  - `idx_lean_search`: `sensor_id` (4B) + `recorded_at` (5B) + `log_id` (8B) = **17 Bytes/row**. 
  - Lean Index nhỏ gọn gấp hơn 6 lần, giúp nạp được nhiều bản ghi hơn trên mỗi Data Page 16KB.

### Prompt 2: Cơ chế Bookmark Lookup và Clustered Index
- **Câu hỏi**: "Khi mất 'Using index' trên cột Extra của EXPLAIN, InnoDB thực hiện việc lấy dữ liệu chi tiết như thế nào?"
- **Thu hoạch**: InnoDB dùng `idx_lean_search` để định vị danh sách các `log_id` (Primary Key) thỏa mãn điều kiện. Sau đó, nó dùng các `log_id` này để tra cứu (Lookup) vào cây Clustered Index chính nhằm đọc ra `temperature`, `humidity`, `status`.

### Prompt 3: Ảnh hưởng của Write Penalty trong hệ thống Write-Heavy
- **Câu hỏi**: "Tại sao một Secondary Index lớn lại gây tắc nghẽn hàng đợi Write trong MySQL?"
- **Thu hoạch**: Ghi ngẫu nhiên (Random Disk I/O) khi chèn vào các nhánh khác nhau của cây B-Tree. Khi index quá lớn không nằm trọn trong RAM (Buffer Pool), MySQL phải liên tục đọc/ghi trang từ đĩa SSD xuống, gây thắt nút cổ chai luồng nạp dữ liệu từ cảm biến.

- Câu hỏi vấn đáp:
- Câu 1: "Nếu đây là bảng 'Danh mục quốc gia' (Countries) cả năm không ai sửa, thì Covering Index có còn là 'tội ác' không? Tại sao?"Trả lời: Không hề. Bảng danh mục thuộc hệ thống Read-Heavy (gần như 100% là đọc, không có ghi). Khi đó, Covering Index là một kỹ thuật tuyệt vời vì nó giúp loại bỏ hoàn toàn chi phí Bookmark Lookup, đưa toàn bộ dữ liệu lên RAM giúp truy vấn đạt tốc độ tối đa mà không sợ bị trừng phạt tốc độ ghi (Write Penalty).Câu 2: "Khái niệm 'Write Penalty' (Hình phạt khi Ghi) là gì? Tại sao nhét thêm 1 cột vào Index lại làm INSERT chậm lại?"Trả lời: Write Penalty là chi phí hiệu năng mà hệ thống phải trả khi thực hiện thao tác ghi dữ liệu do phải cập nhật các cấu trúc dữ liệu phụ trợ. Khi thêm cột vào Index, kích thước mỗi dòng Index lớn hơn $\rightarrow$ số lượng dòng trên một Data Page (16KB) ít đi $\rightarrow$ tần suất trang bị đầy và phải phân tách trang (Page Split) diễn ra thường xuyên hơn $\rightarrow$ gây ra nhiều thao tác ghi ngẫu nhiên (Random I/O) xuống đĩa, làm kéo dài thời gian hoàn thành câu lệnh INSERT.Câu 3: "Để tối ưu ổ cứng, có đề xuất thay VARCHAR(20) của status thành TINYINT. Việc này tác động thế nào đến Data Length và Index Length nếu lỡ đưa vào Index?"Trả lời: VARCHAR(20) hỗ trợ UTF8MB4 có thể tiêu tốn tối đa tới $20 \times 4 + 1 = 81\text{ bytes}$ cho mỗi bản ghi. Thay bằng TINYINT chỉ tốn đúng 1 byte. Việc này giúp thu nhỏ cả Data Length lẫn Index Length đáng kể, giảm tải kích thước cây B-Tree. Tuy nhiên, trong hệ thống IoT hàng chục nghìn log/giây, giải pháp đúng đắn nhất về mặt kiến trúc vẫn là loại bỏ hoàn toàn cột status ra khỏi Index thay vì chỉ tối ưu kiểu dữ liệu của nó.
