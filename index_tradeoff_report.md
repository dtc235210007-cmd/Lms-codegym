# BÁO CÁO ĐÁNH ĐỔI HIỆU NĂNG: GIẢI PHÁP LEAN INDEX CHO SMARTFACTORY

## 1. Bản chất sự cố
Hệ thống IoT SmartFactory là mô hình **Write-Heavy** đặc thù với hàng chục nghìn lượt `INSERT/giây`. Việc lạm dụng Covering Index (`idx_fat_covering`) ép MySQL phải nhân đôi dữ liệu của toàn bộ các cột vào cây B-Tree phụ. Kích thước mỗi nút (Index Key) tăng từ **12 bytes lên hơn 40 bytes**, gây phình to trang bộ nhớ (Page Splits liên tục), ngốn cạn bộ nhớ đệm Buffer Pool và tạo ra hiện tượng **Write Penalty** nặng nề dẫn đến mất dữ liệu qua đường ống nạp.

## 2. Giải pháp và Đánh đổi (Trade-off)
Chúng tôi quyết định thay thế bằng **Lean Index** `(sensor_id, recorded_at)`:
- **Tốc độ Đọc (Read)**: Mất trạng thái "Using index", phát sinh thêm chi phí *Bookmark Lookup* về Clustered Index để lấy các trường đo lường. Thời gian phản hồi tăng thêm khoảng 0.5–2ms — mức trễ hoàn toàn chấp nhận được đối với Dashboard người dùng.
- **Tốc độ Ghi (Write)**: Giảm kích thước mỗi bản ghi Index xuống ~70%, triệt tiêu độ trễ phân tách trang, phục hồi hoàn toàn tốc độ `INSERT` thời gian thực.
- **Chi phí Lưu trữ (Storage)**: Giải phóng hơn 65% dung lượng `Index_length`, tiết kiệm hàng nghìn USD chi phí thuê dung lượng ổ đĩa SSD AWS hàng tháng.
