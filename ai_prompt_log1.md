# AI Prompt Log - AutoRide Project

### Prompt 1: Chọn kiểu dữ liệu cho tiền cọc và phí phạt
- **Prompt:** "Trong MySQL, tại sao các trường `security_deposit`, `late_fee`, `damage_fee` nên dùng `DECIMAL(12,2)` thay vì `FLOAT` hay `DOUBLE`?"
- **Phân tích áp dụng:** Tránh lỗi sai số dấu phẩy động (Floating-point precision error) vốn xảy ra với `FLOAT/DOUBLE`. Phép toán hoàn tiền `security_deposit - late_fee - damage_fee` đòi hỏi độ chính xác tuyệt đối từng đơn vị tiền tệ để không làm lệch số liệu kế toán.

### Prompt 2: Tách bảng Inspections so với gộp cột vào Rentals
- **Prompt:** "Tại sao nên tách `Inspections` thành bảng riêng liên kết khóa ngoại với `Rentals` thay vì thêm cột `damage_description` vào `Rentals`?"
- **Phân tích áp dụng:** Tuân thủ chuẩn hóa cơ sở dữ liệu (3NF). Một xe khi giao/nhận có thể cần nhiều lần kiểm tra (lúc nhận xe và lúc trả xe, hoặc do nhiều giám định viên khác nhau ký nhận). Tách bảng giúp schema mở rộng linh hoạt mà không để lại các ô dữ liệu `NULL` thừa thãi trong bảng hợp đồng.

### Prompt 3: Kiểm soát trạng thái hợp đồng bằng ENUM
- **Prompt:** "Cú pháp tạo cột `status` kiểu `ENUM` giới hạn các giá trị ('BOOKED', 'ACTIVE', 'COMPLETED', 'CANCELLED') và lợi ích của nó so với `VARCHAR(50)`?"
- **Phân tích áp dụng:** Dùng `ENUM` khóa chặt miền giá trị ngay tại tầng dữ liệu, ngăn ngừa lỗi gõ sai chính tả từ code backend hoặc người nhập liệu, đồng thời tiết kiệm dung lượng lưu trữ hơn so với chuỗi `VARCHAR`.
