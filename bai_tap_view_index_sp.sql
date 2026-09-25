-- =============================================================
-- BƯỚC 1: TẠO CƠ SỞ DỮ LIỆU DEMO
-- =============================================================
DROP DATABASE IF EXISTS demo;
CREATE DATABASE demo;
USE demo;

-- =============================================================
-- BƯỚC 2: TẠO BẢNG PRODUCTS VÀ CHÈN DỮ LIỆU MẪU
-- =============================================================
DROP TABLE IF EXISTS Products;
CREATE TABLE Products (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    productCode VARCHAR(20) NOT NULL UNIQUE,
    productName VARCHAR(100) NOT NULL,
    productPrice DECIMAL(10, 2) NOT NULL,
    productAmount INT NOT NULL,
    productDescription TEXT,
    productStatus VARCHAR(20) DEFAULT 'Available'
);

INSERT INTO Products (productCode, productName, productPrice, productAmount, productDescription, productStatus)
VALUES 
    ('P001', 'Bàn phím cơ AKKO', 1250000, 15, 'Bàn phím cơ không dây switch v3', 'Available'),
    ('P002', 'Chuột Logitech G102', 399000, 30, 'Chuột chơi game cảm biến 8000 DPI', 'Available'),
    ('P003', 'Tai nghe Sony WH-1000XM4', 5900000, 8, 'Tai nghe chống ồn chủ động cao cấp', 'Available'),
    ('P004', 'Màn hình Dell Ultrasharp', 7200000, 5, 'Màn hình đồ họa IPS 2K 27 inch', 'Out of stock'),
    ('P005', 'Chuột Logitech G502', 1150000, 12, 'Chuột công thái học gaming', 'Available');

-- =============================================================
-- BƯỚC 3: TẠO INDEX, COMPOSITE INDEX VÀ DÙNG EXPLAIN ĐỐI CHIẾU
-- =============================================================

-- 1. Khảo sát kế hoạch thực thi TRƯỚC KHI tạo Composite Index
EXPLAIN SELECT * FROM Products WHERE productName = 'Chuột Logitech G102' AND productPrice = 399000;

-- 2. Tạo Unique Index cho cột productCode
-- (Lưu ý: productCode đã có ràng buộc UNIQUE, nếu tạo thêm index riêng):
CREATE UNIQUE INDEX idx_productCode ON Products(productCode);

-- 3. Tạo Composite Index cho 2 cột productName và productPrice
CREATE INDEX idx_name_price ON Products(productName, productPrice);

-- 4. Khảo sát lại SAU KHI tạo Composite Index
-- Quan sát: type chuyển từ ALL sang ref, key sử dụng idx_name_price, rows giảm sâu
EXPLAIN SELECT * FROM Products WHERE productName = 'Chuột Logitech G102' AND productPrice = 399000;

-- =============================================================
-- BƯỚC 4: THAO TÁC VỚI VIEW
-- =============================================================

-- 1. Tạo view lấy về: productCode, productName, productPrice, productStatus
CREATE VIEW view_products AS
SELECT productCode, productName, productPrice, productStatus
FROM Products;

-- Truy vấn từ view vừa tạo
SELECT * FROM view_products;

-- 2. Sửa đổi View (CREATE OR REPLACE VIEW) - bổ sung thêm cột productAmount
CREATE OR REPLACE VIEW view_products AS
SELECT productCode, productName, productPrice, productAmount, productStatus
FROM Products;

SELECT * FROM view_products;

-- 3. Xóa view
DROP VIEW IF EXISTS view_products;

-- =============================================================
-- BƯỚC 5: TẠO CÁC STORED PROCEDURE
-- =============================================================
DELIMITER //

-- 1. Thủ tục lấy tất cả thông tin của tất cả sản phẩm
DROP PROCEDURE IF EXISTS sp_getAllProducts //
CREATE PROCEDURE sp_getAllProducts()
BEGIN
    SELECT * FROM Products;
END //

-- 2. Thủ tục thêm một sản phẩm mới
DROP PROCEDURE IF EXISTS sp_addProduct //
CREATE PROCEDURE sp_addProduct(
    IN p_code VARCHAR(20),
    IN p_name VARCHAR(100),
    IN p_price DECIMAL(10, 2),
    IN p_amount INT,
    IN p_description TEXT,
    IN p_status VARCHAR(20)
)
BEGIN
    INSERT INTO Products (productCode, productName, productPrice, productAmount, productDescription, productStatus)
    VALUES (p_code, p_name, p_price, p_amount, p_description, p_status);
END //

-- 3. Thủ tục sửa thông tin sản phẩm theo Id
DROP PROCEDURE IF EXISTS sp_updateProductById //
CREATE PROCEDURE sp_updateProductById(
    IN p_id INT,
    IN p_name VARCHAR(100),
    IN p_price DECIMAL(10, 2),
    IN p_amount INT,
    IN p_description TEXT,
    IN p_status VARCHAR(20)
)
BEGIN
    UPDATE Products
    SET 
        productName = p_name,
        productPrice = p_price,
        productAmount = p_amount,
        productDescription = p_description,
        productStatus = p_status
    WHERE Id = p_id;
END //

-- 4. Thủ tục xóa sản phẩm theo Id
DROP PROCEDURE IF EXISTS sp_deleteProductById //
CREATE PROCEDURE sp_deleteProductById(
    IN p_id INT
)
BEGIN
    DELETE FROM Products WHERE Id = p_id;
END //

DELIMITER ;

-- =============================================================
-- DEMO THỰC THI CÁC STORED PROCEDURE
-- =============================================================

-- Gọi lấy tất cả sản phẩm
CALL sp_getAllProducts();

-- Thêm sản phẩm mới
CALL sp_addProduct('P006', 'Loa Bluetooth JBL', 2300000, 20, 'Loa kháng nước IPX7', 'Available');

-- Sửa sản phẩm vừa thêm (Id = 6)
CALL sp_updateProductById(6, 'Loa Bluetooth JBL Flip 6', 2490000, 18, 'Loa kháng nước chống bụi IP67', 'Available');

-- Xóa sản phẩm theo Id
CALL sp_deleteProductById(6);

-- Kiểm tra lại danh sách cuối cùng
CALL sp_getAllProducts();