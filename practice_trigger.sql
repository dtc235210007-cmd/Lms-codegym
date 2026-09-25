-- -------------------------------------------------------------
-- BƯỚC 1: TẠO CƠ SỞ DỮ LIỆU VÀ BẢNG EMPLOYEES
-- -------------------------------------------------------------
DROP DATABASE IF EXISTS company;
CREATE DATABASE company;
USE company;

CREATE TABLE employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    department VARCHAR(50) NOT NULL,
    salary DECIMAL(10, 2) NOT NULL
);


-- -------------------------------------------------------------
-- BƯỚC 2: TẠO TRIGGER TỰ ĐỘNG CẬP NHẬT PHÒNG BAN TRƯỚC KHI THÊM
-- -------------------------------------------------------------
DELIMITER //

DROP TRIGGER IF EXISTS update_department //

CREATE TRIGGER update_department
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary >= 5000 THEN
        SET NEW.department = 'Management';
    ELSEIF NEW.salary >= 3000 THEN
        SET NEW.department = 'Sales';
    ELSE
        SET NEW.department = 'Support';
    END IF;
END //

DELIMITER ;


-- -------------------------------------------------------------
-- BƯỚC 3: KIỂM TRA TRIGGER VẬN HÀNH (DEMO INSERT)
-- -------------------------------------------------------------
-- Dù truyền giá trị department ban đầu là 'A', Trigger BEFORE INSERT sẽ tự động ghi đè
INSERT INTO employees (name, department, salary)
VALUES 
    ('John Doe', 'A', 3500),
    ('Jane Smith', 'A', 2000),
    ('David Johnson', 'A', 6000);

-- Kiểm tra kết quả trong bảng:
-- John Doe (3500)      -> department sẽ thành 'Sales'
-- Jane Smith (2000)    -> department sẽ thành 'Support'
-- David Johnson (6000) -> department sẽ thành 'Management'
SELECT * FROM employees;