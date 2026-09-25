USE classicmodels;
-- 1. Tìm thông tin khách hàng
SELECT * FROM customers WHERE customerName = 'Land of Toys Inc.';

-- 2. Xem kế hoạch thực thi
EXPLAIN SELECT * FROM customers WHERE customerName = 'Land of Toys Inc.';
-- 3. Tạo index
ALTER TABLE customers ADD INDEX idx_customerName(customerName);

-- 4. Chạy lại EXPLAIN để so sánh
EXPLAIN SELECT * FROM customers WHERE customerName = 'Land of Toys Inc.';
-- 5. Tạo composite index cho cả 2 cột họ và tên
ALTER TABLE customers ADD INDEX idx_full_name(contactFirstName, contactLastName);

-- 6. Kiểm tra kế hoạch thực thi với composite index
EXPLAIN SELECT * FROM customers WHERE contactFirstName = 'Jean' OR contactFirstName = 'King';

-- 7. Xóa composite index vừa tạo
ALTER TABLE customers DROP INDEX idx_full_name;