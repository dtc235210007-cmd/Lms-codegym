USE classicmodels;

-- -------------------------------------------------------------
-- PHẦN 1: THAM SỐ LOẠI IN (Tham số truyền vào để xử lý)
-- -------------------------------------------------------------
DELIMITER //

DROP PROCEDURE IF EXISTS `getCusById` //

CREATE PROCEDURE getCusById(
    IN cusNum INT
)
BEGIN
    SELECT * 
    FROM customers 
    WHERE customerNumber = cusNum;
END //

DELIMITER ;

-- Gọi thủ tục loại IN: Tìm khách hàng có mã số 175
CALL getCusById(175);


-- -------------------------------------------------------------
-- PHẦN 2: THAM SỐ LOẠI OUT (Lấy kết quả từ Procedure ra bên ngoài)
-- -------------------------------------------------------------
DELIMITER //

DROP PROCEDURE IF EXISTS `GetCustomersCountByCity` //

CREATE PROCEDURE GetCustomersCountByCity(
    IN in_city VARCHAR(50),
    OUT total INT
)
BEGIN
    SELECT COUNT(customerNumber)
    INTO total
    FROM customers
    WHERE city = in_city;
END //

DELIMITER ;

-- Gọi thủ tục loại OUT: Truyền biến @total hứng kết quả và in ra
CALL GetCustomersCountByCity('Lyon', @total);
SELECT @total AS TotalCustomersInLyon;


-- -------------------------------------------------------------
-- PHẦN 3: THAM SỐ LOẠI INOUT (Vừa nhận dữ liệu vào, vừa trả về sau khi tính toán)
-- -------------------------------------------------------------
DELIMITER //

DROP PROCEDURE IF EXISTS `SetCounter` //

CREATE PROCEDURE SetCounter(
    INOUT counter INT,
    IN inc INT
)
BEGIN
    SET counter = counter + inc;
END //

DELIMITER ;

-- Gọi thủ tục loại INOUT:
-- 1. Khởi tạo biến @counter ban đầu = 1
SET @counter = 1;

-- 2. Tăng dần biến @counter qua các lần gọi thủ tục
CALL SetCounter(@counter, 1); -- @counter = 2
CALL SetCounter(@counter, 1); -- @counter = 3
CALL SetCounter(@counter, 5); -- @counter = 8

-- 3. Xem kết quả cuối cùng
SELECT @counter AS FinalCounter;