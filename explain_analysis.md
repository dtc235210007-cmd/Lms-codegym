# Báo Cáo Phân Tích Kế Hoạch Thực Thi (EXPLAIN Analysis) - PayFlow

Sự khác biệt rõ rệt giữa hai kế hoạch thực thi trước và sau khi tối ưu:

| Chỉ số EXPLAIN | Trước tối ưu (Legacy) | Sau tối ưu (Optimized) | Ý nghĩa kỹ thuật |
| :--- | :--- | :--- | :--- |
| **type** | `ALL` (Full Table Scan) | `range` (hoặc `ref`) | Đã chuyển từ duyệt tuần tự từng dòng trên đĩa sang duyệt nhị phân trên nhánh cây Index. |
| **key** | `NULL` | `idx_type_date` | MySQL đã nhận diện và tận dụng thành công Composite Index mới tạo. |
| **rows** | ~5.000.000 dòng | Vài trăm đến vài nghìn dòng | Lượng dữ liệu I/O cần đọc giảm hơn 99%, giải phóng nghẽn CPU và tránh hiện tượng khóa bảng kéo dài. |
| **Extra** | `Using where` | `Using index condition` | Sử dụng cơ chế Index Condition Pushdown (ICP) để lọc trực tiếp ở tầng lưu trữ trước khi trả về. |

**Kết luận:** Việc chuyển từ hàm `YEAR()`/`MONTH()` sang truy vấn dạng khoảng (`>=` và `<`) đã khôi phục tính **SARGable**, cho phép cây B-Tree thu hẹp phạm vi quét dữ liệu ngay lập tức.
