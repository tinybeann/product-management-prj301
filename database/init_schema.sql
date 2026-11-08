-- =============================================
-- Mini Product & Order Management - SQL Server
-- =============================================
IF DB_ID(N'product_mgmt') IS NULL
    CREATE DATABASE product_mgmt;
GO

USE product_mgmt;
GO

-- Xoa bang cu (theo thu tu khoa ngoai)
IF OBJECT_ID(N'dbo.OrderDetails', N'U') IS NOT NULL DROP TABLE dbo.OrderDetails;
IF OBJECT_ID(N'dbo.Orders',       N'U') IS NOT NULL DROP TABLE dbo.Orders;
IF OBJECT_ID(N'dbo.Products',     N'U') IS NOT NULL DROP TABLE dbo.Products;
IF OBJECT_ID(N'dbo.Categories',   N'U') IS NOT NULL DROP TABLE dbo.Categories;
IF OBJECT_ID(N'dbo.Users',        N'U') IS NOT NULL DROP TABLE dbo.Users;
IF OBJECT_ID(N'dbo.Roles',        N'U') IS NOT NULL DROP TABLE dbo.Roles;
GO

-- =============================================
-- DDL
-- =============================================
CREATE TABLE Roles (
    role_id   INT IDENTITY(1,1) NOT NULL,
    role_name NVARCHAR(20) NOT NULL,
    CONSTRAINT PK_Roles PRIMARY KEY (role_id),
    CONSTRAINT UQ_Roles_name UNIQUE (role_name)
);
GO

CREATE TABLE Users (
    user_id    INT IDENTITY(1,1) NOT NULL,
    username   NVARCHAR(50)  NOT NULL,
    password   NVARCHAR(255) NOT NULL,
    full_name  NVARCHAR(100) NOT NULL,
    email      NVARCHAR(100) NOT NULL,
    phone      NVARCHAR(15)  NULL,
    address    NVARCHAR(255) NULL,
    role_id    INT NOT NULL,
    is_active  BIT NOT NULL CONSTRAINT DF_Users_active DEFAULT 1,
    created_at DATETIME NOT NULL CONSTRAINT DF_Users_created DEFAULT GETDATE(),
    CONSTRAINT PK_Users PRIMARY KEY (user_id),
    CONSTRAINT UQ_Users_username UNIQUE (username),
    CONSTRAINT UQ_Users_email UNIQUE (email),
    CONSTRAINT FK_Users_Roles FOREIGN KEY (role_id) REFERENCES Roles(role_id)
);
GO

CREATE TABLE Categories (
    category_id   INT IDENTITY(1,1) NOT NULL,
    category_name NVARCHAR(100) NOT NULL,
    description   NVARCHAR(255) NULL,
    CONSTRAINT PK_Categories PRIMARY KEY (category_id),
    CONSTRAINT UQ_Categories_name UNIQUE (category_name)
);
GO

CREATE TABLE Products (
    product_id   INT IDENTITY(1,1) NOT NULL,
    product_name NVARCHAR(150) NOT NULL,
    description  NVARCHAR(MAX) NULL,
    price        DECIMAL(18,2) NOT NULL,
    stock        INT NOT NULL CONSTRAINT DF_Products_stock DEFAULT 0,
    image_url    NVARCHAR(255) NULL,
    category_id  INT NOT NULL,
    is_active    BIT NOT NULL CONSTRAINT DF_Products_active DEFAULT 1,
    created_at   DATETIME NOT NULL CONSTRAINT DF_Products_created DEFAULT GETDATE(),
    CONSTRAINT PK_Products PRIMARY KEY (product_id),
    CONSTRAINT CK_Products_price CHECK (price >= 0),
    CONSTRAINT CK_Products_stock CHECK (stock >= 0),
    CONSTRAINT FK_Products_Categories FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);
GO

CREATE TABLE Orders (
    order_id         INT IDENTITY(1,1) NOT NULL,
    user_id          INT NOT NULL,
    order_date       DATETIME NOT NULL CONSTRAINT DF_Orders_date DEFAULT GETDATE(),
    total_amount     DECIMAL(18,2) NOT NULL CONSTRAINT DF_Orders_total DEFAULT 0,
    status           NVARCHAR(20) NOT NULL CONSTRAINT DF_Orders_status DEFAULT N'PENDING',
    shipping_address NVARCHAR(255) NOT NULL,
    phone            NVARCHAR(15) NOT NULL,
    note             NVARCHAR(255) NULL,
    CONSTRAINT PK_Orders PRIMARY KEY (order_id),
    CONSTRAINT CK_Orders_total CHECK (total_amount >= 0),
    CONSTRAINT CK_Orders_status CHECK (status IN (N'PENDING', N'CONFIRMED', N'SHIPPING', N'COMPLETED', N'CANCELLED')),
    CONSTRAINT FK_Orders_Users FOREIGN KEY (user_id) REFERENCES Users(user_id)
);
GO

CREATE TABLE OrderDetails (
    order_detail_id INT IDENTITY(1,1) NOT NULL,
    order_id        INT NOT NULL,
    product_id      INT NOT NULL,
    quantity        INT NOT NULL,
    unit_price      DECIMAL(18,2) NOT NULL,
    CONSTRAINT PK_OrderDetails PRIMARY KEY (order_detail_id),
    CONSTRAINT CK_OD_quantity CHECK (quantity > 0),
    CONSTRAINT CK_OD_price CHECK (unit_price >= 0),
    CONSTRAINT UQ_OD_order_product UNIQUE (order_id, product_id),
    CONSTRAINT FK_OD_Orders FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    CONSTRAINT FK_OD_Products FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
GO

CREATE INDEX IX_Products_category ON Products(category_id);
CREATE INDEX IX_Products_name ON Products(product_name);
CREATE INDEX IX_Orders_user ON Orders(user_id);
GO

-- =============================================
-- DML (du lieu mau)
-- =============================================
INSERT INTO Roles (role_name) VALUES (N'ADMIN'), (N'CUSTOMER');
GO

-- Mat khau duoc bam SHA-256 (hex chu thuong) truoc khi luu vao CSDL.
-- Khong luu mat khau trong kho ma trongg. Doi mat khau mac dinh sau khi trien khai thuc te.
INSERT INTO Users (username, password, full_name, email, phone, address, role_id) VALUES
(N'admin',
 LOWER(CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'admin123'), 2)),
 N'Quản Trị Viên', N'admin@shop.com', N'0901000001', N'TP. Hồ Chí Minh',
 (SELECT role_id FROM Roles WHERE role_name = N'ADMIN')),
(N'customer',
 LOWER(CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'customer123'), 2)),
 N'Nguyễn Văn A', N'customer@shop.com', N'0901000002', N'12 Lê Lợi, Quận 1, TP.HCM',
 (SELECT role_id FROM Roles WHERE role_name = N'CUSTOMER'));
GO

INSERT INTO Categories (category_name, description) VALUES
(N'Điện thoại', N'Điện thoại thông minh các hãng'),
(N'Laptop',     N'Máy tính xách tay học tập, văn phòng, gaming'),
(N'Phụ kiện',   N'Tai nghe, chuột, bàn phím, sạc dự phòng');
GO

INSERT INTO Products (product_name, description, price, stock, image_url, category_id) VALUES
(N'iPhone 15 128GB',            N'Màn hình 6.1 inch, chip A16 Bionic', 19990000, 25, N'images/iphone15.jpg',  (SELECT category_id FROM Categories WHERE category_name = N'Điện thoại')),
(N'Samsung Galaxy S24',         N'Màn hình Dynamic AMOLED 2X, 256GB',  18490000, 30, N'images/galaxys24.jpg', (SELECT category_id FROM Categories WHERE category_name = N'Điện thoại')),
(N'Dell Inspiron 15',           N'Core i5, RAM 16GB, SSD 512GB',       16990000, 15, N'images/dell15.jpg',    (SELECT category_id FROM Categories WHERE category_name = N'Laptop')),
(N'MacBook Air M2',             N'Chip M2, RAM 8GB, SSD 256GB',        24990000, 10, N'images/macbookm2.jpg', (SELECT category_id FROM Categories WHERE category_name = N'Laptop')),
(N'Tai nghe Sony WH-1000XM5',   N'Chống ồn chủ động, pin 30 giờ',       6990000, 40, N'images/sonyxm5.jpg',   (SELECT category_id FROM Categories WHERE category_name = N'Phụ kiện')),
(N'Chuột Logitech MX Master 3S',N'Chuột không dây, cuộn êm',            2290000, 50, N'images/mxmaster.jpg',  (SELECT category_id FROM Categories WHERE category_name = N'Phụ kiện'));
GO

-- Kiem tra nhanh
SELECT * FROM Roles;
SELECT user_id, username, full_name, role_id FROM Users;
SELECT * FROM Categories;
SELECT product_id, product_name, price, stock, category_id FROM Products;
GO
