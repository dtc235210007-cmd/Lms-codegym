# Phân tích Tính Toàn vẹn Dữ liệu - Dự án AutoRide

Cột `damage_fee` là bắt buộc phải có trong bảng `Rentals` vì những lý do cốt lõi sau:

1. **Khép kín quy trình tính toán tài chính:**
Theo Activity Diagram, công thức quyết toán hợp đồng là: `Tiền hoàn lại = Tiền cọc - Phí trễ hạn - Phí sửa chữa`. Nếu thiếu `damage_fee`, hệ thống không có trường dữ liệu để tự động trừ tiền bồi thường, dẫn đến việc nhân viên phải tính nhẩm bên ngoài hoặc hoàn trả nguyên vẹn tiền cọc, gây thất thoát lợi nhuận trực tiếp cho doanh nghiệp.

2. **Đảm bảo tính kiểm toán và minh bạch (Audit Trail):**
Bảng `Inspections` chỉ lưu trữ mô tả hư hỏng dạng chữ (`TEXT`). Cột `damage_fee` chuẩn hóa giá trị thiệt hại thành số học (`DECIMAL`), cho phép kế toán trích xuất báo cáo doanh thu bồi hoàn, đối soát với chi phí sửa chữa thực tế tại xưởng và làm cơ sở pháp lý xuất hóa đơn phạt cho khách hàng.

## Chuẩn bị câu hỏi Vấn đáp (Q&A)

1. **Tại sao tách bảng Inspections tốt hơn gộp vào Rentals?**
   - Giúp chuẩn hóa CSDL (3NF), tránh lưu dữ liệu TEXT cồng kềnh trong bảng Rentals. Đồng thời hỗ trợ mở rộng quy trình kiểm tra nhiều lần (lúc nhận xe và lúc trả xe) mà không gây dư thừa dữ liệu NULL.

2. **Chặn INSERT vào Inspections khi hợp đồng đang BOOKED bằng cách nào?**
   - Sử dụng `BEFORE INSERT TRIGGER` trên bảng `Inspections` để kiểm tra trạng thái của `Rentals`. Nếu `status = 'BOOKED'`, kích hoạt `SIGNAL SQLSTATE '45000'` để chặn giao dịch.

3. **Hậu quả của sự lệch pha giữa Activity Diagram và ERD đối với người dùng?**
   - Ứng dụng phát sinh lỗi hệ thống (API 500) khi người dùng thao tác tính năng phạt/bồi thường do CSDL thiếu trường lưu trữ. Quy trình bị tắc nghẽn, buộc nhân viên phải giải quyết thủ công bên ngoài, gây trải nghiệm tệ và chậm trễ hoàn tiền cho khách.
