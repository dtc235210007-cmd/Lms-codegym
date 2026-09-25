-- 1. Sử dụng CSDL QuanLySinhVien
USE QuanLySinhVien;

-- 2. Hiển thị tất cả các sinh viên có tên bắt đầu bằng ký tự 'h' (không phân biệt hoa/thường)
SELECT * 
FROM Student 
WHERE StudentName LIKE 'h%';

-- 3. Hiển thị các thông tin lớp học có thời gian bắt đầu vào tháng 12
SELECT * 
FROM Class 
WHERE MONTH(StartDate) = 12;

-- 4. Hiển thị tất cả các thông tin môn học có credit trong khoảng từ 3 đến 5
SELECT * 
FROM Subject 
WHERE Credit BETWEEN 3 AND 5;

-- 5. Thay đổi mã lớp (ClassID) của sinh viên có tên 'Hung' thành 2
-- Chú ý: Tắt Safe Updates tạm thời nếu MySQL Workbench yêu cầu cập nhật qua khóa chính
SET SQL_SAFE_UPDATES = 0;

UPDATE Student 
SET ClassId = 2 
WHERE StudentName = 'Hung';

SET SQL_SAFE_UPDATES = 1;

-- 6. Hiển thị các thông tin: StudentName, SubName, Mark.
-- Dữ liệu sắp xếp theo điểm thi (Mark) giảm dần, nếu trùng sắp theo tên sinh viên tăng dần
SELECT 
    s.StudentName, 
    sub.SubName, 
    m.Mark
FROM Mark m
JOIN Student s ON m.StudentID = s.StudentID
JOIN Subject sub ON m.SubID = sub.SubID
ORDER BY m.Mark DESC, s.StudentName ASC;