USE classicmodels;

-- -------------------------------------------------------------
-- PHẦN 1: TẠO STORED PROCEDURE ĐẦU TIÊN
-- -------------------------------------------------------------
-- Thay đổi dấu phân cách lệnh từ mặc định (;) thành (//)
DELIMITER //

CREATE PROCEDURE findAllCustomers()
BEGIN
    SELECT * FROM customers;
END //

-- Trả lại dấu phân cách lệnh mặc định (;)
DELIMITER ;


-- -------------------------------------------------------------
-- PHẦN 2: GỌI THỦ TỤC ĐỂ THỰC THI (CALL PROCEDURE)
-- -------------------------------------------------------------
CALL findAllCustomers();


-- -------------------------------------------------------------
-- PHẦN 3: SỬA THỦ TỤC (XÓA CŨ VÀ TẠO LẠI BẢN MỚI)
-- -------------------------------------------------------------
DELIMITER //

-- Xóa thủ tục nếu đã tồn tại trước đó
DROP PROCEDURE IF EXISTS `findAllCustomers` //

-- Tạo lại thủ tục với logic mới (chỉ lọc khách hàng có customerNumber = 175)
CREATE PROCEDURE findAllCustomers()
BEGIN
    SELECT * FROM customers WHERE customerNumber = 175;
END //

DELIMITER ;


-- -------------------------------------------------------------
-- PHẦN 4: GỌI LẠI ĐỂ KIỂM TRA LOGIC ĐÃ ĐƯỢC CẬP NHẬT
-- -------------------------------------------------------------
CALL findAllCustomers();