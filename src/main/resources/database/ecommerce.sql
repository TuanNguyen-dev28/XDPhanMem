-- Xóa database cũ nếu tồn tại để tạo lại từ đầu (cẩn thận khi dùng trên production)
-- DROP DATABASE IF EXISTS ecommerce;

-- Tạo database (nếu chưa có)
CREATE DATABASE IF NOT EXISTS ecommerce CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ecommerce;

-- =============================================
-- Bảng quản lý người dùng và phân quyền
-- =============================================
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    username VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('user', 'admin') NOT NULL DEFAULT 'user',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- =============================================
-- Bảng quản lý sản phẩm
-- =============================================

-- Bảng Thương hiệu (Trademarks)
CREATE TABLE Brands (
    brand_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) UNIQUE NOT NULL,
    logo_url VARCHAR(255),
    description TEXT
) ENGINE=InnoDB;

-- Bảng Danh mục sản phẩm
CREATE TABLE Categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) UNIQUE NOT NULL,
    parent_id INT, -- Để tạo danh mục đa cấp (e.g., Váy -> Váy công sở)
    FOREIGN KEY (parent_id) REFERENCES Categories(category_id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- Bảng Bộ sưu tập
CREATE TABLE Collections (
    collection_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    image_url VARCHAR(255)
) ENGINE=InnoDB;

-- Bảng Sản phẩm
CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    code VARCHAR(50) UNIQUE NOT NULL,
    description TEXT NOT NULL,
    original_price DECIMAL(10, 2) NOT NULL,
    sale_price DECIMAL(10, 2),
    images TEXT, -- Lưu dưới dạng JSON hoặc chuỗi phân cách (e.g., "url1,url2")
    stock_quantity INT NOT NULL DEFAULT 0,
    category_id INT,
    brand_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id) ON DELETE SET NULL,
    FOREIGN KEY (brand_id) REFERENCES Brands(brand_id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- Bảng trung gian: Sản phẩm thuộc Bộ sưu tập (Many-to-Many)
CREATE TABLE Product_Collections (
    product_id INT NOT NULL,
    collection_id INT NOT NULL,
    PRIMARY KEY (product_id, collection_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE,
    FOREIGN KEY (collection_id) REFERENCES Collections(collection_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- =============================================
-- Bảng quản lý giỏ hàng và đơn hàng
-- =============================================

-- Bảng Giỏ hàng (mỗi user có một giỏ hàng)
CREATE TABLE Carts (
    cart_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT UNIQUE NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Bảng Chi tiết giỏ hàng
CREATE TABLE CartItems (
    cart_item_id INT PRIMARY KEY AUTO_INCREMENT,
    cart_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    FOREIGN KEY (cart_id) REFERENCES Carts(cart_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE,
    UNIQUE KEY unique_cart_product (cart_id, product_id)
) ENGINE=InnoDB;

-- Bảng Đơn hàng
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    buyer_name VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    shipping_address TEXT NOT NULL,
    total_amount DECIMAL(12, 2) NOT NULL,
    payment_method ENUM('cod', 'bank_transfer', 'online_payment') NOT NULL,
    status ENUM('pending', 'processing', 'shipped', 'delivered', 'cancelled', 'returned') NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- Bảng Chi tiết đơn hàng
CREATE TABLE OrderItems (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL, -- Giá tại thời điểm đặt hàng
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- =============================================
-- Các bảng chức năng phụ
-- =============================================

-- Bảng Danh sách yêu thích (Wishlist)
CREATE TABLE Wishlists (
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, product_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Bảng Đánh giá sản phẩm
CREATE TABLE Reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    user_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Bảng Danh mục Blog
CREATE TABLE BlogCategories (
    blog_category_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) UNIQUE NOT NULL
) ENGINE=InnoDB;

-- Bảng Bài viết Blog
CREATE TABLE BlogPosts (
    post_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    image_url VARCHAR(255),
    author_id INT,
    blog_category_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (author_id) REFERENCES Users(user_id) ON DELETE SET NULL,
    FOREIGN KEY (blog_category_id) REFERENCES BlogCategories(blog_category_id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- =============================================
-- Ví dụ insert dữ liệu mẫu
-- =============================================
INSERT INTO Users (name, email, phone, address, username, password_hash, role) 
VALUES ('Nguyễn Anh Tuấn', 'tuan.na@example.com', '0987654321', '123 Đường ABC, Quận 1, TP. HCM', 'anhtuan', '$2a$10$your_hashed_password_here', 'admin');

INSERT INTO Categories (name) VALUES ('Áo'), ('Quần'), ('Váy');
INSERT INTO Brands (name) VALUES ('Kaira'), ('Uniqlo'), ('Zara');

INSERT INTO Products (name, code, description, original_price, sale_price, images, category_id, brand_id, stock_quantity) 
VALUES ('Áo Sơ Mi Lụa', 'SM001', 'Áo sơ mi lụa cao cấp, mềm mại, thoáng mát.', 550000.00, 499000.00, '["img1.jpg", "img2.jpg"]', 1, 1, 100);

INSERT INTO BlogCategories (name) VALUES ('Hướng dẫn phối đồ'), ('Xu hướng thời trang');
INSERT INTO BlogPosts (title, content, author_id, blog_category_id)
VALUES ('5 Cách Phối Đồ Với Áo Sơ Mi Trắng', 'Nội dung chi tiết về 5 cách phối đồ...', 1, 1);
