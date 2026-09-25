# BÁO CÁO TỐI ƯU HÓA HIỆU NĂNG VÀ TÀI NGUYÊN HỆ THỐNG QUICKFEED

## 1. Nguyên nhân gây sự cố Write Timeout và Phình to ổ cứng
Trước tối ưu, mỗi thao tác `INSERT` vào bảng `Posts` buộc MySQL phải chèn dữ liệu vào bảng chính (Clustered Index `post_id`) và đồng thời cập nhật **5 cây B-Tree phụ (Secondary Indexes)**. Việc phân tách trang (Page Split) ngẫu nhiên trên đĩa diễn ra liên tục, đẩy I/O lên mức tối đa gây nghẽn hàng đợi ghi và Timeout.

## 2. Phân tích Cardinality & Quyết định loại bỏ Index
- **idx_is_visible & idx_post_type**: Độ chọn lọc (Selectivity) cực thấp khi chỉ có 2–3 giá trị lặp lại. Query Optimizer luôn ưu tiên quét toàn bảng (`Full Table Scan`) thay vì tốn chi phí đọc Index rồi Lookup ngược về Clustered Index (Random I/O). Việc duy trì 2 Index này hoàn toàn vô giá trị.
- **idx_content**: Prefix index trên chuỗi 255 bytes gây phình to Index Pages trong bộ nhớ đệm Buffer Pool và ổ cứng, không phục vụ được tìm kiếm ngữ nghĩa tự nhiên.
- **Giữ lại**: `idx_user_id` (Cardinality cao, lọc tường nhà) và `idx_created_at` (hỗ trợ phân trang, tránh `Using filesort`).

## 3. Kết quả đánh đổi (Trade-off)
Cắt bỏ 3 Index giúp giảm 60% chi phí duy trì B-Tree khi ghi. Thao tác `INSERT` phục hồi tốc độ tức thì, dung lượng `Index_length` giảm sâu, trả lại không gian đĩa cứng và bộ nhớ RAM quý giá cho MySQL Buffer Pool.
