-- ========================================================
-- DỰ ÁN QUICKFEED: TỐI ƯU HÓA INDEX & GIẢI CỨU BỘ NHỚ
-- ========================================================

CREATE DATABASE IF NOT EXISTS quickfeed_db;
USE quickfeed_db;

-- 1. Khởi tạo cấu trúc bảng Posts
DROP TABLE IF EXISTS Posts;
CREATE TABLE Posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    content TEXT,
    post_type VARCHAR(10),       -- 'TEXT', 'IMAGE', 'VIDEO'
    is_visible BOOLEAN DEFAULT 1, -- 1 (Hiện) hoặc 0 (Ẩn)
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 2. Mô phỏng tình trạng quá tải (Legacy Over-indexing)
CREATE INDEX idx_user_id ON Posts(user_id);
CREATE INDEX idx_content ON Posts(content(255));
CREATE INDEX idx_post_type ON Posts(post_type);
CREATE INDEX idx_is_visible ON Posts(is_visible);
CREATE INDEX idx_created_at ON Posts(created_at);

-- --------------------------------------------------------
-- BƯỚC 1: ĐO LƯỜNG TÀI NGUYÊN BAN ĐẦU (TRƯỚC KHI TỐI ƯU)
-- --------------------------------------------------------
SELECT 
    table_name AS `Table`,
    ROUND(((data_length) / 1024 / 1024), 2) AS `Data_Size_MB`,
    ROUND(((index_length) / 1024 / 1024), 2) AS `Index_Size_MB`,
    ROUND(((data_length + index_length) / 1024 / 1024), 2) AS `Total_Size_MB`
FROM information_schema.TABLES
WHERE table_schema = 'quickfeed_db' AND table_name = 'Posts';

-- --------------------------------------------------------
-- BƯỚC 2: PHẪU THUẬT CẮT BỎ CÁC INDEX VÔ DỤNG (LOW CARDINALITY / BLOAT)
-- --------------------------------------------------------

-- Xóa idx_content: Index prefix B-Tree trên TEXT gây phình to đĩa, nên dùng FULLTEXT thay thế
ALTER TABLE Posts DROP INDEX idx_content;

-- Xóa idx_post_type: Cardinality cực thấp (chỉ có 3 giá trị), Optimizer sẽ bỏ qua
ALTER TABLE Posts DROP INDEX idx_post_type;

-- Xóa idx_is_visible: Cardinality tồi tệ nhất (chỉ 0 và 1), Full Table Scan hiệu quả hơn
ALTER TABLE Posts DROP INDEX idx_is_visible;

-- Lưu ý: Giữ lại idx_user_id (load profile) và idx_created_at (sort Newsfeed)

-- --------------------------------------------------------
-- BƯỚC 3: ĐO LƯỜNG LẠI TÀI NGUYÊN (SAU KHI TỐI ƯU)
-- --------------------------------------------------------
SELECT 
    table_name AS `Table`,
    ROUND(((data_length) / 1024 / 1024), 2) AS `Data_Size_MB`,
    ROUND(((index_length) / 1024 / 1024), 2) AS `Index_Size_MB`,
    ROUND(((data_length + index_length) / 1024 / 1024), 2) AS `Total_Size_MB`
FROM information_schema.TABLES
WHERE table_schema = 'quickfeed_db' AND table_name = 'Posts';
