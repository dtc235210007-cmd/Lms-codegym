-- ========================================================
-- HỆ THỐNG AUTORIDE - RESTRUCTURED DATABASE
-- ========================================================

CREATE DATABASE IF NOT EXISTS autoride_db;
USE autoride_db;

-- 1. Bảng Cars (Xe)
CREATE TABLE IF NOT EXISTS Cars (
    car_id INT AUTO_INCREMENT PRIMARY KEY,
    model_name VARCHAR(100) NOT NULL,
    license_plate VARCHAR(20) UNIQUE NOT NULL
);

-- 2. Bảng Rentals (Nâng cấp: Dùng ENUM, bổ sung các trường tài chính)
CREATE TABLE IF NOT EXISTS Rentals (
    rental_id INT AUTO_INCREMENT PRIMARY KEY,
    car_id INT NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    rent_date DATETIME NOT NULL,
    return_date DATETIME DEFAULT NULL,
    status ENUM('BOOKED', 'ACTIVE', 'COMPLETED', 'CANCELLED') NOT NULL DEFAULT 'BOOKED',
    security_deposit DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    late_fee DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    damage_fee DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    FOREIGN KEY (car_id) REFERENCES Cars(car_id)
);

-- 3. Bảng Inspections (Biên bản kiểm tra xe khi trả)
CREATE TABLE IF NOT EXISTS Inspections (
    inspection_id INT AUTO_INCREMENT PRIMARY KEY,
    rental_id INT NOT NULL,
    inspection_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    damage_description TEXT,
    inspector_name VARCHAR(100) NOT NULL,
    FOREIGN KEY (rental_id) REFERENCES Rentals(rental_id) ON DELETE RESTRICT
);

-- ========================================================
-- DML: DỮ LIỆU BAN ĐẦU & MÔ PHỎNG NGHIỆP VỤ THỰC TẾ
-- ========================================================

-- Thêm xe mẫu
INSERT INTO Cars (model_name, license_plate) VALUES 
('Toyota Vios', '30E-123.45'),
('Mazda CX-5', '29A-678.90');

-- Kịch bản: Khách hàng "Nguyen Van A" thuê xe, cọc 10.000.000 VNĐ, nhận xe (ACTIVE)
INSERT INTO Rentals (car_id, customer_name, rent_date, status, security_deposit)
VALUES (1, 'Nguyen Van A', '2026-04-01 08:00:00', 'ACTIVE', 10000000.00);

SET @cur_rental_id = LAST_INSERT_ID();

-- Khách trả xe: Nhân viên kiểm tra và lập biên bản ghi nhận vỡ đèn pha
INSERT INTO Inspections (rental_id, inspection_date, damage_description, inspector_name)
VALUES (@cur_rental_id, '2026-04-03 10:00:00', 'Vo den pha trai', 'Tran Kiem Dinh');

-- Cập nhật hợp đồng: Hoàn tất, ghi nhận không trễ hạn, phạt hư hỏng 2.000.000 VNĐ
UPDATE Rentals
SET status = 'COMPLETED',
    return_date = '2026-04-03 10:00:00',
    late_fee = 0.00,
    damage_fee = 2000000.00
WHERE rental_id = @cur_rental_id;

-- ========================================================
-- TRUY VẤN KIỂM CHỨNG & TÍNH TOÁN TIỀN HOÀN LẠI CHO KHÁCH
-- ========================================================

SELECT 
    r.rental_id,
    r.customer_name,
    c.model_name,
    c.license_plate,
    r.status,
    r.security_deposit,
    r.late_fee,
    r.damage_fee,
    (r.security_deposit - r.late_fee - r.damage_fee) AS refund_amount,
    i.damage_description,
    i.inspector_name
FROM Rentals r
JOIN Cars c ON r.car_id = c.car_id
LEFT JOIN Inspections i ON r.rental_id = i.rental_id
WHERE r.rental_id = @cur_rental_id;
