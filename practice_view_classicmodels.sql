USE classicmodels;

-- -------------------------------------------------------------
-- PHẦN 1: TẠO VIEW CƠ BẢN
-- -------------------------------------------------------------
-- Tạo view customer_views lấy 3 cột: customerNumber, customerName, phone
CREATE VIEW customer_views AS
SELECT customerNumber, customerName, phone
FROM customers;

-- Truy vấn dữ liệu từ View vừa tạo (View hoạt động như một bảng ảo)
SELECT * FROM customer_views;


-- -------------------------------------------------------------
-- PHẦN 2: CẬP NHẬT ĐỊNH NGHĨA VIEW (CREATE OR REPLACE VIEW)
-- -------------------------------------------------------------
-- Thêm các cột contactFirstName, contactLastName và thêm điều kiện lọc city = 'Nantes'
CREATE OR REPLACE VIEW customer_views AS
SELECT customerNumber, customerName, contactFirstName, contactLastName, phone
FROM customers
WHERE city = 'Nantes';

-- Truy vấn lại để kiểm tra định nghĩa mới của view
SELECT * FROM customer_views;


-- -------------------------------------------------------------
-- PHẦN 3: XÓA VIEW (DROP VIEW)
-- -------------------------------------------------------------
-- Xóa view customer_views khi không còn sử dụng
DROP VIEW IF EXISTS customer_views;