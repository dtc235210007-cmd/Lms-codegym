# AI Prompt Log - HealthSync Project

### Prompt 1: Khắc phục Anti-Pattern quản lý vòng đời trạng thái
- **Prompt:** "Trong MySQL, tại sao việc dùng cột `is_active BOOLEAN` để theo dõi vòng đời Đơn hàng/Lịch hẹn lại là một Anti-pattern? Ưu và nhược điểm của việc dùng `ENUM` so với việc tách bảng `Appointment_Statuses` là gì?"
- **Phân tích áp dụng:** Quyết định chọn `ENUM('PENDING', 'CONFIRMED', 'CHECKED_IN', 'COMPLETED', 'CANCELLED')` cho bảng `Appointments` vì số lượng trạng thái nghiệp vụ cố định, giúp kiểm soát chặt chẽ giá trị đầu vào ngay tại tầng database mà không tốn chi phí JOIN thêm bảng.

### Prompt 2: Lựa chọn kiểu dữ liệu cho tiền cọc và phí phạt
- **Prompt:** "Khi lưu trữ `deposit_amount` và `penalty_fee` trong MySQL, tại sao nên dùng `DECIMAL(12,2)` thay vì `FLOAT` hoặc `DOUBLE`?"
- **Phân tích áp dụng:** Tránh lỗi sai số dấu phẩy động (Floating-point precision error). Kiểu `DECIMAL` lưu trữ số học chính xác tuyệt đối, đảm bảo tính toán cọc trừ phạt (`deposit_amount - penalty_fee`) khớp hoàn toàn trong các báo cáo tài chính của kế toán.

### Prompt 3: Đảm bảo tính toàn vẹn quan hệ giữa Khám bệnh và Đơn thuốc
- **Prompt:** "Làm sao để đảm bảo quan hệ 1-1 giữa `Appointments` và `Prescriptions`, đồng thời ngăn chặn xóa lịch hẹn khi đã có đơn thuốc kê?"
- **Phân tích áp dụng:** Áp dụng ràng buộc `UNIQUE` lên khóa ngoại `appointment_id` trong bảng `Prescriptions` và thiết lập `ON DELETE RESTRICT` để bảo vệ hồ sơ bệnh án không bị xóa nhầm.
