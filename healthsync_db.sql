-- ========================================================
-- PHÒNG KHÁM ĐA KHOA HEALTHSYNC - RESTRUCTURED DATABASE
-- ========================================================

CREATE DATABASE IF NOT EXISTS healthsync_db;
USE healthsync_db;

-- 1. Bảng Patients (Bệnh nhân)
CREATE TABLE IF NOT EXISTS Patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL
);

-- 2. Bảng Doctors (Bác sĩ)
CREATE TABLE IF NOT EXISTS Doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    specialty VARCHAR(50)
);

-- 3. Bảng Appointments (Tái cấu trúc: Loại bỏ is_active, thêm trạng thái và tài chính)
CREATE TABLE IF NOT EXISTS Appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATETIME NOT NULL,
    status ENUM('PENDING', 'CONFIRMED', 'CHECKED_IN', 'COMPLETED', 'CANCELLED') NOT NULL DEFAULT 'PENDING',
    deposit_amount DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    penalty_fee DECIMAL(12, 2) DEFAULT 0.00,
    cancel_reason VARCHAR(255) DEFAULT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

-- 4. Bảng Prescriptions (Đơn thuốc khi hoàn thành khám)
CREATE TABLE IF NOT EXISTS Prescriptions (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL UNIQUE, -- Quan hệ 1-1 với lịch hẹn đã khám xong
    medication_details TEXT NOT NULL,
    issued_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id) ON DELETE RESTRICT
);

-- ========================================================
-- DML: DỮ LIỆU BAN ĐẦU & KỊCH BẢN VẬN HÀNH NGHIỆP VỤ
-- ========================================================

-- Dữ liệu mẫu ban đầu
INSERT INTO Patients (full_name, phone) VALUES 
('Nguyen Van A', '0912345678'),
('Tran Thi B', '0987654321');

INSERT INTO Doctors (full_name, specialty) VALUES 
('BS. Le Van C', 'Noi tong quat'),
('BS. Pham Thi D', 'Da lieu');

-- Kịch bản 1: Luồng khám thành công (Happy Path)
-- 1.1 Tạo lịch hẹn PENDING, cọc 500.000 VNĐ
INSERT INTO Appointments (patient_id, doctor_id, appointment_date, status, deposit_amount)
VALUES (1, 1, '2026-04-10 09:00:00', 'PENDING', 500000.00);

SET @app_id_success = LAST_INSERT_ID();

-- 1.2 Bệnh nhân đến nơi check-in
UPDATE Appointments 
SET status = 'CHECKED_IN' 
WHERE appointment_id = @app_id_success;

-- 1.3 Khám xong, chuyển trạng thái sang COMPLETED
UPDATE Appointments 
SET status = 'COMPLETED' 
WHERE appointment_id = @app_id_success;

-- 1.4 Kê đơn thuốc kèm lịch hẹn vừa hoàn tất
INSERT INTO Prescriptions (appointment_id, medication_details)
VALUES (@app_id_success, 'Paracetamol 500mg (10 vien), Vitamin C 1000mg (10 vien)');

-- Kịch bản 2: Luồng hủy lịch và phạt cọc (Penalty Path)
-- 2.1 Tạo lịch hẹn CONFIRMED, cọc 300.000 VNĐ
INSERT INTO Appointments (patient_id, doctor_id, appointment_date, status, deposit_amount)
VALUES (2, 2, '2026-04-11 14:00:00', 'CONFIRMED', 300000.00);

SET @app_id_cancelled = LAST_INSERT_ID();

-- 2.2 Bệnh nhân hủy lịch -> Cập nhật CANCELLED, lý do và áp phí phạt 150.000 VNĐ
UPDATE Appointments 
SET status = 'CANCELLED',
    cancel_reason = 'Ban viec dot xuat',
    penalty_fee = 150000.00
WHERE appointment_id = @app_id_cancelled;

-- ========================================================
-- TRUY VẤN KIỂM CHỨNG KẾT QUẢ
-- ========================================================

-- Kiểm tra danh sách bệnh nhân đã hoàn tất khám và chi tiết đơn thuốc
SELECT 
    a.appointment_id,
    p.full_name AS patient_name,
    d.full_name AS doctor_name,
    a.appointment_date,
    a.status,
    a.deposit_amount,
    pr.medication_details,
    pr.issued_date
FROM Appointments a
JOIN Patients p ON a.patient_id = p.patient_id
JOIN Doctors d ON a.doctor_id = d.doctor_id
JOIN Prescriptions pr ON a.appointment_id = pr.appointment_id
WHERE a.status = 'COMPLETED';

-- Kiểm tra danh sách lịch bị hủy và phí phạt ghi nhận
SELECT 
    appointment_id,
    status,
    deposit_amount,
    penalty_fee,
    (deposit_amount - penalty_fee) AS refund_to_patient,
    cancel_reason
FROM Appointments
WHERE status = 'CANCELLED';
