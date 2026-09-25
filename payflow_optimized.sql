-- ========================================================
-- HỆ THỐNG VÍ ĐIỆN TỬ PAYFLOW - GIẢI PHÁP TỐI ƯU TRUY VẤN
-- ========================================================

CREATE DATABASE IF NOT EXISTS payflow_db;
USE payflow_db;

-- 1. Bảng Transactions
CREATE TABLE IF NOT EXISTS Transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    amount DECIMAL(15,2),
    transaction_type VARCHAR(20), -- 'DEPOSIT', 'WITHDRAW', 'TRANSFER'
    created_at DATETIME
);

-- ========================================================
-- TRƯỚC TỐI ƯU (LEGACY QUERY) - Non-SARGable Query
-- Quét toàn bộ bảng: type = ALL, rows = toàn bộ dòng
-- ========================================================
EXPLAIN 
SELECT SUM(amount) AS total_deposit
FROM Transactions
WHERE transaction_type = 'DEPOSIT' 
  AND YEAR(created_at) = 2026 
  AND MONTH(created_at) = 6;

-- ========================================================
-- GIẢI PHÁP TỐI ƯU HÓA
-- ========================================================

-- Bước 1: Tạo Composite Index B-Tree theo thứ tự: (cột lọc đẳng thức, cột lọc khoảng)
CREATE INDEX idx_type_date ON Transactions(transaction_type, created_at);

-- Bước 2: Viết lại truy vấn chuẩn SARGable (Dùng toán tử so sánh khoảng >= và <)
EXPLAIN 
SELECT SUM(amount) AS total_deposit
FROM Transactions
WHERE transaction_type = 'DEPOSIT' 
  AND created_at >= '2026-06-01 00:00:00' 
  AND created_at < '2026-07-01 00:00:00';

-- Truy vấn thực tế lấy dữ liệu:
SELECT SUM(amount) AS total_deposit
FROM Transactions
WHERE transaction_type = 'DEPOSIT' 
  AND created_at >= '2026-06-01 00:00:00' 
  AND created_at < '2026-07-01 00:00:00';
