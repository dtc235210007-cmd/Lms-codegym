# Báo cáo Chẩn đoán Sự Bất nhất Dữ liệu (Consistency Gap Report) - HealthSync

Hệ thống kế thừa (Legacy Database) xuất hiện 3 điểm "vênh" nghiêm trọng so với quy trình Activity Diagram:

1. **Sai lệch kiểu dữ liệu trạng thái (State Modeling Anti-Pattern):** 
Cột `is_active BOOLEAN` chỉ biểu diễn 2 giá trị đóng/mở nhị phân, hoàn toàn bất khả thi khi ánh xạ quy trình 5 bước (`PENDING` -> `CONFIRMED` -> `CHECKED_IN` -> `COMPLETED` / `CANCELLED`). Việc thiếu trạng thái trung gian làm mất dấu vết chuyển giao giữa Lễ tân và Bác sĩ.

2. **Thiếu hụt thực thể Đơn thuốc (Missing Entity):**
Quy trình nghiệp vụ yêu cầu sau khi khám xong (`COMPLETED`), Bác sĩ phải kê đơn. Database cũ không có bảng `Prescriptions`, dẫn đến việc hoàn tất khám mà không có nơi lưu thông tin chỉ định thuốc, vi phạm luồng khám bệnh cốt lõi.

3. **Thất thoát nghiệp vụ Dòng tiền & Chế tài (Financial Audit Gap):**
Quy trình bắt buộc thu tiền cọc (`deposit_amount`), phạt tiền cọc (`penalty_fee`) và ghi nhận `cancel_reason` khi hủy hẹn. Thiết kế cũ hoàn toàn bỏ qua các trường này, khiến hệ thống không thể đối soát dòng tiền, không có cơ chế hoàn cọc tự động và gây rủi ro thất thoát doanh thu cho phòng khám.
