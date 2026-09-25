-- 1. Chọn cơ sở dữ liệu để làm việc
USE QuanLySinhVien;

-- 2. Thêm dữ liệu vào bảng Class
INSERT INTO Class (ClassID, ClassName, StartDate, Status)
VALUES 
    (1, 'A1', '2008-12-20', 1),
    (2, 'A2', '2008-12-22', 1),
    (3, 'B3', CURRENT_DATE, 0);

-- 3. Thêm dữ liệu vào bảng Student
-- Chú ý: StudentID tự tăng (AUTO_INCREMENT) nên chỉ định rõ danh sách cột
INSERT INTO Student (StudentName, Address, Phone, Status, ClassId)
VALUES ('Hung', 'Ha Noi', '0912113113', 1, 1);

INSERT INTO Student (StudentName, Address, Status, ClassId)
VALUES ('Hoa', 'Hai phong', 1, 1);

INSERT INTO Student (StudentName, Address, Phone, Status, ClassId)
VALUES ('Manh', 'HCM', '0123123123', 0, 2);

-- 4. Thêm dữ liệu vào bảng Subject
INSERT INTO Subject (SubId, SubName, Credit, Status)
VALUES 
    (1, 'CF', 5, 1),
    (2, 'C', 6, 1),
    (3, 'HDJ', 5, 1),
    (4, 'RDBMS', 10, 1);

-- 5. Thêm dữ liệu vào bảng Mark
-- MarkID tự tăng, ràng buộc UNIQUE(SubId, StudentId)
INSERT INTO Mark (SubId, StudentId, Mark, ExamTimes)
VALUES 
    (1, 1, 8, 1),
    (1, 2, 10, 2),
    (2, 1, 12, 1);

-- 6. Truy vấn kiểm tra dữ liệu sau khi thêm
SELECT * FROM Class;
SELECT * FROM Student;
SELECT * FROM Subject;
SELECT * FROM Mark;