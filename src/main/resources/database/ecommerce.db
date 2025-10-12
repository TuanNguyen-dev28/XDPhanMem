-- Tạo database (nếu chưa có)
CREATE DATABASE IF NOT EXISTS ecommerce;
USE ecommerce;

-- Bảng Users
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20) NOT NULL,
    address TEXT NOT NULL,
    username VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,  -- Mật khẩu đã mã hóa (sử dụng bcrypt hoặc tương tự)
    role ENUM('user', 'admin') NOT NULL DEFAULT 'user'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Bảng Products
CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    code VARCHAR(50) UNIQUE NOT NULL,
    description TEXT NOT NULL,  -- Chi tiết: kiểu dáng, chất liệu, màu sắc, size, v.v.
    original_price DECIMAL(10,2) NOT NULL,
    sale_price DECIMAL(10,2) DEFAULT NULL,  -- Giá khuyến mãi (NULL nếu không có)
    images TEXT,  -- Lưu dưới dạng JSON hoặc chuỗi phân cách (e.g., "url1,url2")
    category VARCHAR(100) NOT NULL,  -- e.g., 'ao', 'quan', 'vay', 'phu_kien'
    stock_quantity INT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Bảng Carts (mỗi user có một giỏ hàng)
CREATE TABLE Carts (
    cart_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users (user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Bảng CartItems (sản phẩm trong giỏ hàng)
CREATE TABLE CartItems (
    cart_item_id INT PRIMARY KEY AUTO_INCREMENT,
    cart_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    FOREIGN KEY (cart_id) REFERENCES Carts (cart_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products (product_id) ON DELETE CASCADE,
    UNIQUE KEY unique_cart_product (cart_id, product_id)  -- Tránh trùng sản phẩm trong giỏ
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Bảng Orders
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    buyer_name VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    shipping_address TEXT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,  -- Bao gồm phí vận chuyển
    payment_method ENUM('the_tin_dung', 'chuyen_khoan', 'thanhtoan_nhanhang') NOT NULL,
    status ENUM('pending', 'processing', 'shipped', 'delivered', 'cancelled') NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users (user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Bảng OrderItems (sản phẩm trong đơn hàng)
CREATE TABLE OrderItems (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,  -- Giá đơn vị tại thời điểm đặt hàng
    FOREIGN KEY (order_id) REFERENCES Orders (order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products (product_id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Ví dụ insert dữ liệu mẫu (tùy chọn)
INSERT INTO Users (name, email, phone, address, username, password_hash, role) 
VALUES ('Nguyễn Văn A', 'a@example.com', '0123456789', 'Hà Nội', 'userA', 'hashed_password_here', 'user');

INSERT INTO Products (name, code, description, original_price, sale_price, images, category, stock_quantity) 
VALUES ('Áo thun', 'AT001', 'Áo thun cotton, màu xanh, size M', 200000.00, 150000.00, 'img1.jpg,img2.jpg', 'ao', 50);