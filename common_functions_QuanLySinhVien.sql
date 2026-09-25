-- 1. Sử dụng CSDL QuanLySinhVien
USE QuanLySinhVien;

-- 2. Hiển thị số lượng sinh viên ở từng nơi
SELECT 
    Address, 
    COUNT(StudentId) AS 'Số lượng học viên'
FROM Student
GROUP BY Address;

-- 3. Tính điểm trung bình các môn học của mỗi học viên
SELECT 
    S.StudentId, 
    S.StudentName, 
    AVG(M.Mark) AS 'DiemTrungBinh'
FROM Student S 
JOIN Mark M ON S.StudentId = M.StudentId
GROUP BY S.StudentId, S.StudentName;

-- 4. Hiển thị những bạn học viên có điểm trung bình các môn học lớn hơn 15
SELECT 
    S.StudentId, 
    S.StudentName, 
    AVG(M.Mark) AS 'DiemTrungBinh'
FROM Student S 
JOIN Mark M ON S.StudentId = M.StudentId
GROUP BY S.StudentId, S.StudentName
HAVING AVG(M.Mark) > 15;

-- 5. Hiển thị thông tin các học viên có điểm trung bình lớn nhất (sử dụng HAVING >= ALL)
SELECT 
    S.StudentId, 
    S.StudentName, 
    AVG(M.Mark) AS 'DiemTrungBinh'
FROM Student S 
JOIN Mark M ON S.StudentId = M.StudentId
GROUP BY S.StudentId, S.StudentName
HAVING AVG(M.Mark) >= ALL (
    SELECT AVG(Mark) 
    FROM Mark 
    GROUP BY StudentId
);