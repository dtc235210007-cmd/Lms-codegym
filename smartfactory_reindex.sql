-- ========================================================
-- DỰ ÁN SMARTFACTORY: TỐI ƯU HÓA INDEX HỆ THỐNG IOT REAL-TIME
-- ========================================================

CREATE DATABASE IF NOT EXISTS smartfactory_db;
USE smartfactory_db;

-- 1. Cấu trúc bảng SensorLogs
DROP TABLE IF EXISTS SensorLogs;
CREATE TABLE SensorLogs (
    log_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    sensor_id INT NOT NULL,
    recorded_at DATETIME NOT NULL,
    temperature DECIMAL(5,2),
    humidity DECIMAL(5,2),
    status VARCHAR(20) -- 'NORMAL', 'WARNING', 'CRITICAL'
);

-- ========================================================
-- HIỆN TRẠNG BAN ĐẦU: "FAT COVERING INDEX"
-- ========================================================
CREATE INDEX idx_fat_covering ON SensorLogs(sensor_id, recorded_at, temperature, humidity, status);

-- Khảo sát dung lượng ban đầu
SELECT 
    table_name AS `Table`,
    ROUND(((data_length) / 1024 / 1024), 2) AS `Data_MB`,
    ROUND(((index_length) / 1024 / 1024), 2) AS `Index_MB`
FROM information_schema.TABLES
WHERE table_schema = 'smartfactory_db' AND table_name = 'SensorLogs';

-- EXPLAIN truy vấn Dashboard khi còn Fat Index:
-- Quan sát: Extra = 'Using index' (Dữ liệu lấy 100% từ Index, không chạm Clustered Index)
EXPLAIN SELECT temperature, humidity, status 
FROM SensorLogs 
WHERE sensor_id = 105 AND recorded_at >= '2026-06-20';


-- ========================================================
-- TIẾN HÀNH "PHẪU THUẬT": CHUYỂN ĐỔI SANG LEAN INDEX
-- ========================================================

-- 1. Cắt bỏ Fat Index để chấm dứt tình trạng nghẽn ghi (Write Bottleneck)
ALTER TABLE SensorLogs DROP INDEX idx_fat_covering;

-- 2. Tạo Lean Index: Chỉ giữ 2 cột phục vụ lọc và định vị bản ghi
CREATE INDEX idx_lean_search ON SensorLogs(sensor_id, recorded_at);


-- ========================================================
-- XÁC MINH VÀ ĐỐI CHIẾU KẾT QUẢ
-- ========================================================

-- Kiểm tra lại dung lượng (Index_length giảm mạnh)
SELECT 
    table_name AS `Table`,
    ROUND(((data_length) / 1024 / 1024), 2) AS `Data_MB`,
    ROUND(((index_length) / 1024 / 1024), 2) AS `Index_MB`
FROM information_schema.TABLES
WHERE table_schema = 'smartfactory_db' AND table_name = 'SensorLogs';

-- EXPLAIN truy vấn Dashboard sau khi đổi sang Lean Index:
-- Quan sát:
-- - key: idx_lean_search
-- - type: range (vẫn cực nhanh trong việc thu hẹp tập dữ liệu)
-- - Extra: Không còn 'Using index' (MySQL thực hiện Bookmark Lookup về Clustered Index để lấy temperature, humidity, status)
EXPLAIN SELECT temperature, humidity, status 
FROM SensorLogs 
WHERE sensor_id = 105 AND recorded_at >= '2026-06-20';
