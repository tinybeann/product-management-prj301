# 🛒 Product managerment system

Hệ thống quản lý sản phẩm, giỏ hàng và đơn hàng trực tuyến được phát triển bằng ngôn ngữ **Java**, kiến trúc **MVC (Model - View - Controller)** kết hợp **Java Servlet & JSP (Jakarta EE 10)** và cơ sở dữ liệu **Microsoft SQL Server**.

---

## 📋 Mục lục
- [Giới thiệu](#-giới-thiệu)
- [Công nghệ sử dụng](#-công-nghệ-sử-dụng)
- [Cấu trúc dự án](#-cấu-trúc-dự-án)
- [Yêu cầu hệ thống](#-yêu-cầu-hệ-thống)
- [Hướng dẫn cài đặt và chạy dự án](#-hướng-dẫn-cài-đặt-và-chạy-dự-án)
  - [Bước 1: Clone mã nguồn](#bước-1-clone-mã-nguồn)
  - [Bước 2: Cài đặt Cơ sở dữ liệu (SQL Server)](#bước-2-cài-đặt-cơ-sở-dữ-liệu-sql-server)
  - [Bước 3: Cấu hình biến môi trường (.env)](#bước-3-cấu-hình-biến-môi-trường-env)
  - [Bước 4: Kiểm tra thư viện JAR (web/WEB-INF/lib)](#bước-4-kiểm-tra-thư-viện-jar-webweb-inflib)
  - [Bước 5: Chạy dự án](#bước-5-chạy-dự-án)
- [Tài khoản mặc định](#-tài-khoản-mặc-định)
- [Danh sách tính năng chính](#-danh-sách-tính-năng-chính)
- [Danh sách URL Endpoints](#-danh-sách-url-endpoints)
- [Xử lý sự cố thường gặp (Troubleshooting)](#-xử-lý-sự-cố-thường-gặp-troubleshooting)

---

## 🌟 Giới thiệu

Dự án cung cấp giải pháp bán hàng và quản lý sản phẩm mini với hai phân hệ chính:
1. **Khách hàng (Client):** Duyệt danh mục sản phẩm, tìm kiếm, giỏ hàng, đặt hàng và theo dõi tiến độ đơn hàng.
2. **Quản trị viên (Admin):** Bảng điều khiển (Dashboard) thống kê doanh thu, quản lý danh mục & sản phẩm (CRUD), kiểm duyệt và chuyển trạng thái đơn hàng.

---

## 💻 Công nghệ sử dụng

- **Ngôn ngữ:** Java (JDK 17 LTS khuyến nghị)
- **Nền tảng:** Jakarta EE 10 / Servlet 6.0 / JSP 3.1
- **Web Server:** Apache Tomcat 10.1.x *(bắt buộc Tomcat 10+, không tương thích với Tomcat 9 trở xuống)*
- **Cơ sở dữ liệu:** Microsoft SQL Server (2016 trở lên)
- **Thư viện chính:**
  - `mssql-jdbc-12.8.1.jre11.jar`: Driver kết nối SQL Server qua JDBC.
  - `jakarta.servlet.jsp.jstl-3.0.1.jar` & `jakarta.servlet.jsp.jstl-api-3.0.0.jar`: Thư viện thẻ JSTL chuẩn Jakarta EE 10.
- **Bảo mật:**
  - `AuthFilter` kiểm soát phân quyền truy cập trang Admin.
  - Băm mật khẩu một chiều an toàn bằng thuật toán **SHA-256**.
- **Giao diện:** HTML5, CSS3 hiện đại, Font Awesome.

---

## 📁 Cấu trúc dự án

```text
product-management/
├── database/
│   └── init_schema.sql            # Script tạo CSDL, bảng và nạp dữ liệu mẫu
├── docs/
│   └── database_design.md         # Tài liệu thiết kế CSDL (ERD, Data Dictionary)
├── src/
│   ├── conf/
│   │   └── MANIFEST.MF
│   └── java/
│       ├── context/
│       │   └── DBContext.java     # Quản lý kết nối JDBC, đọc cấu hình từ .env
│       ├── controller/
│       │   ├── admin/             # Các Servlet quản trị (Dashboard, Sản phẩm, Đơn hàng)
│       │   ├── auth/              # Các Servlet xác thực (Login, Logout, Register)
│       │   └── client/            # Các Servlet khách hàng (Home, Cart, Checkout, Orders)
│       ├── dao/                   # Lớp truy xuất dữ liệu (ProductDAO, OrderDAO, UserDAO,...)
│       ├── filter/
│       │   └── AuthFilter.java    # Bộ lọc phân quyền bảo vệ tuyến /admin/*
│       ├── model/                 # Các thực thể dữ liệu (Product, Order, User, Cart,...)
│       └── util/
│           └── PasswordUtil.java  # Mã hóa mật khẩu SHA-256
├── web/
│   ├── assets/
│   │   └── css/
│   │       └── style.css          # Định kiểu giao diện toàn trang
│   ├── META-INF/
│   │   └── context.xml
│   ├── views/
│   │   ├── admin/                 # Giao diện quản trị (dashboard, product-list, order-list,...)
│   │   ├── auth/                  # Giao diện đăng nhập, đăng ký
│   │   ├── client/                # Giao diện người mua (home, cart, checkout, orders,...)
│   │   └── common/                # Navbar và các thành phần dùng chung
│   ├── WEB-INF/
│   │   ├── lib/                   # Thư mục chứa các file thư viện .jar (JDBC, JSTL)
│   │   └── web.xml                # Cấu hình Web Application (Jakarta EE 6.0)
│   └── index.jsp                  # Trang chuyển hướng mặc định về /home
├── .env.example                   # Mẫu cấu hình biến môi trường kết nối CSDL
├── .gitignore                     # Cấu hình bỏ qua các file sinh tự động, thư viện, secret
└── build.xml                      # Ant build script
```

---

## ⚙️ Yêu cầu hệ thống

Trước khi cài đặt, hãy đảm bảo máy tính của bạn đã cài đặt các công cụ sau:
1. **JDK 17** hoặc mới hơn (ví dụ: Oracle OpenJDK 17, Eclipse Temurin 17).
2. **Apache Tomcat 10.1.x** (tải tại [tomcat.apache.org](https://tomcat.apache.org/download-100.cgi)).
   > ⚠️ **LƯU Ý QUAN TRỌNG:** Phải sử dụng **Tomcat 10.1.x** trở lên vì dự án chạy trên chuẩn **Jakarta EE 10** (`jakarta.servlet.*`). **Không** sử dụng Tomcat 9.x vì sẽ gặp lỗi `ClassNotFoundException: javax.servlet.*`.
3. **Microsoft SQL Server** (2016/2019/2022 hoặc SQL Server Express/Developer Edition).
4. Công cụ quản trị CSDL: **SQL Server Management Studio (SSMS)** hoặc **Azure Data Studio**.
5. IDE khuyến nghị: **Apache NetBeans 17+**, **IntelliJ IDEA Ultimate**, hoặc **Eclipse for Enterprise Java**.

---

## 🚀 Hướng dẫn cài đặt và chạy dự án

### Bước 1: Clone mã nguồn

Mở terminal hoặc Git Bash và chạy lệnh:
```bash
git clone https://github.com/<your-username>/<your-repo-name>.git
cd product-management
```

---

### Bước 2: Cài đặt Cơ sở dữ liệu (SQL Server)

1. Mở **SQL Server Management Studio (SSMS)** và đăng nhập vào SQL Server instance của bạn (ví dụ: `localhost` hoặc `localhost\SQLEXPRESS`).
2. Mở file script `database/init_schema.sql` có trong thư mục dự án.
3. Nhấn **Execute (F5)** để thực thi script.
4. Script sẽ tự động:
   - Tạo cơ sở dữ liệu `product_mgmt` (nếu chưa có).
   - Tạo các bảng: `Roles`, `Users`, `Categories`, `Products`, `Orders`, `OrderDetails`.
   - Chèn dữ liệu mẫu cho các danh mục, sản phẩm và 2 tài khoản mẫu (Admin & Khách hàng).
5. Đảm bảo SQL Server đã bật chế độ **SQL Server and Windows Authentication mode** và tài khoản `sa` đã được kích hoạt.

---

### Bước 3: Cấu hình biến môi trường (`.env`)

Để ứng dụng kết nối tới CSDL an toàn mà không phải sửa code trong `DBContext.java`:

1. Tại thư mục gốc của dự án, sao chép file `.env.example` thành file `.env`:
   - Trên Windows Command Prompt / PowerShell:
     ```powershell
     copy .env.example .env
     ```
   - Hoặc trên Linux/macOS:
     ```bash
     cp .env.example .env
     ```
2. Mở file `.env` vừa tạo và chỉnh sửa thông tin kết nối CSDL của bạn:
   ```env
   DB_HOST=localhost
   DB_PORT=1433
   DB_NAME=product_mgmt
   DB_USER=sa
   DB_PASSWORD=mat_khau_sql_server_cua_ban
   ```
   *(File `.env` đã được cấu hình trong `.gitignore` nên thông tin mật khẩu của bạn sẽ an toàn và không bị đẩy lên GitHub).*

---

### Bước 4: Kiểm tra thư viện JAR (`web/WEB-INF/lib`)

Do các file `.jar` thường bị Git ignore khi đẩy lên repository, hãy kiểm tra thư mục `web/WEB-INF/lib/`. Thư mục này cần có đủ 3 file thư viện sau:
1. `mssql-jdbc-12.8.1.jre11.jar` (hoặc bản mới hơn tương thích Java 17)
2. `jakarta.servlet.jsp.jstl-3.0.1.jar`
3. `jakarta.servlet.jsp.jstl-api-3.0.0.jar`

*Nếu thư mục `web/WEB-INF/lib/` bị trống, bạn có thể tải các file JAR này từ [Maven Central](https://mvnrepository.com/) và sao chép vào thư mục `web/WEB-INF/lib/`.*

---

### Bước 5: Chạy dự án

#### Lựa chọn 1: Chạy bằng Apache NetBeans (Khuyên dùng)
1. Mở Apache NetBeans (phiên bản 17+).
2. Vào **File** -> **Open Project...** -> Điều hướng chọn thư mục `product-management`.
3. Đăng ký Tomcat 10.1 vào NetBeans (nếu chưa có):
   - Vào thẻ **Services** -> Chuột phải **Servers** -> **Add Server...**
   - Chọn **Apache Tomcat or TomEE** -> Trỏ tới thư mục cài đặt Tomcat 10.1.
4. Cấu hình Project:
   - Chuột phải vào tên dự án `product-managerment` -> **Properties**.
   - Mục **Run**: Đảm bảo **Server** chọn `Apache Tomcat 10.1` và **Java Platform** là `JDK 17`.
5. Chuột phải vào dự án -> chọn **Clean and Build**.
6. Nhấn **Run** (phím `F6`) để khởi động ứng dụng trên trình duyệt.

#### Lựa chọn 2: Chạy bằng IntelliJ IDEA Ultimate
1. Mở IntelliJ IDEA -> Chọn **Open** -> Chọn thư mục dự án `product-management`.
2. Vào **File** -> **Project Structure** (`Ctrl + Alt + Shift + S`):
   - **Project**: Chọn SDK là Java 17.
   - **Modules**: Thêm Web Facet:
     - Web Resource Directory: trỏ tới thư mục `web`.
     - Deployment Descriptor: trỏ tới `web/WEB-INF/web.xml`.
   - **Libraries**: Thêm toàn bộ các file `.jar` trong `web/WEB-INF/lib/`.
3. Vào **Run** -> **Edit Configurations...** -> Nhấn dấu `+` -> Chọn **Tomcat Server** -> **Local**:
   - Chọn Application server: Apache Tomcat 10.1.x.
   - Thẻ **Deployment**: Nhấn `+` -> Chọn **Artifact...** -> chọn `product-management:war exploded`.
   - Application context: `/product-management` hoặc `/`.
4. Nhấn **Run** (`Shift + F10`) để khởi chạy.

---

## 🔑 Tài khoản mặc định

Dữ liệu khởi tạo trong `init_schema.sql` đã tạo sẵn 2 tài khoản để bạn kiểm thử ngay:

| Vai trò | Tên đăng nhập | Mật khẩu | Quyền hạn |
|---|---|---|---|
| **Quản trị viên (Admin)** | `admin` | `admin123` | Quản lý sản phẩm, đơn hàng, bảng thống kê |
| **Khách hàng (Customer)** | `customer` | `customer123` | Mua hàng, xem giỏ, đặt hàng, lịch sử đơn |

> *Ghi chú:* Bạn cũng có thể đăng ký tài khoản khách hàng mới tại trang `/register`.

---

## ✨ Danh sách tính năng chính

### 1. Phân hệ Khách hàng (Client)
- **Trang chủ & Tìm kiếm:** Duyệt danh sách các sản phẩm đang bán, lọc sản phẩm theo Danh mục, tìm kiếm theo tên/từ khóa.
- **Giỏ hàng (Shopping Cart):**
  - Thêm sản phẩm vào giỏ hàng.
  - Cập nhật số lượng từng món hàng hoặc xóa sản phẩm.
  - Tính tự động tổng tiền giỏ hàng.
- **Thanh toán & Đặt hàng (Checkout):**
  - Nhập thông tin người nhận: Địa chỉ giao hàng, số điện thoại, ghi chú.
  - Tự động trừ số lượng tồn kho sản phẩm khi đặt thành công.
- **Quản lý đơn hàng cá nhân:** Xem danh sách đơn đã đặt, xem chi tiết từng món trong đơn và trạng thái xử lý.

### 2. Phân hệ Quản trị (Admin)
- **Dashboard Thống kê:**
  - Tổng doanh thu bán hàng.
  - Tổng số đơn hàng, tổng sản phẩm và tổng khách hàng.
  - Danh sách đơn hàng mới nhất cần xử lý.
- **Quản lý sản phẩm (Product Management - CRUD):**
  - Xem danh sách sản phẩm với đầy đủ thông tin: hình ảnh, danh mục, giá, tồn kho, trạng thái.
  - Thêm mới sản phẩm, cập nhật thông tin sản phẩm.
  - Bật/tắt trạng thái hoạt động hoặc xóa sản phẩm.
- **Quản lý đơn hàng (Order Management):**
  - Xem tất cả đơn hàng, lọc theo trạng thái (`PENDING`, `CONFIRMED`, `SHIPPING`, `COMPLETED`, `CANCELLED`).
  - Xem chi tiết thông tin người mua, địa chỉ nhận hàng và danh sách món hàng.
  - Cập nhật tiến trình trạng thái đơn hàng.

---

## 🗺️ Danh sách URL Endpoints

### Tuyến công khai & Khách hàng:
- `/home` hoặc `/`: Trang chủ hiển thị danh sách sản phẩm
- `/login`: Đăng nhập hệ thống
- `/register`: Đăng ký tài khoản khách hàng
- `/logout`: Đăng xuất phiên làm việc
- `/cart`: Xem và cập nhật giỏ hàng
- `/checkout`: Đặt hàng và điền thông tin thanh toán
- `/orders`: Xem lịch sử đơn hàng của cá nhân
- `/order-detail?id={orderId}`: Xem chi tiết đơn hàng cá nhân

### Tuyến Quản trị viên (Yêu cầu đăng nhập tài khoản ADMIN):
- `/admin/dashboard`: Bảng điều khiển thống kê tổng quan
- `/admin/products`: Danh sách quản lý sản phẩm
- `/admin/product-add`: Form thêm sản phẩm mới
- `/admin/product-edit?id={productId}`: Form chỉnh sửa sản phẩm
- `/admin/product-delete?id={productId}`: Xóa hoặc ngưng bán sản phẩm
- `/admin/orders`: Danh sách tất cả đơn hàng
- `/admin/order-detail?id={orderId}`: Xem chi tiết đơn hàng
- `/admin/order-status`: Cập nhật trạng thái đơn hàng

---

## 🛠️ Xử lý sự cố thường gặp (Troubleshooting)

### 1. Lỗi `ClassNotFoundException: jakarta.servlet.*` hoặc `500 Internal Server Error`
- **Nguyên nhân:** Đang chạy trên Apache Tomcat 9 hoặc phiên bản cũ hơn chỉ hỗ trợ `javax.servlet.*`.
- **Khắc phục:** Cài đặt và cấu hình Server là **Apache Tomcat 10.1.x** (hỗ trợ **Jakarta EE 10**).

### 2. Lỗi `The driver could not establish a secure connection using SSL`
- **Khắc phục:** Kết nối JDBC trong `DBContext.java` đã được thiết lập sẵn tham số `encrypt=true;trustServerCertificate=true;`. Hãy đảm bảo không xóa các tham số này.

### 3. Lỗi `Cannot connect to SQL Server` hoặc `Login failed for user 'sa'`
- Kiểm tra file `.env` đã điền đúng tài khoản/mật khẩu và tên CSDL `product_mgmt` chưa.
- Kiểm tra SQL Server Configuration Manager:
  - Đảm bảo dịch vụ `SQL Server (MSSQLSERVER)` hoặc instance tương ứng đang ở trạng thái **Running**.
  - Vào **SQL Server Network Configuration** -> **Protocols for MSSQLSERVER** -> Bật (**Enabled**) mục **TCP/IP** (Port 1433).

### 4. Lỗi thẻ JSTL hiển thị thô trên trình duyệt (ví dụ `${product.name}`)
- Kiểm tra thư mục `web/WEB-INF/lib/` đã có đủ 2 file `jakarta.servlet.jsp.jstl-3.0.1.jar` và `jakarta.servlet.jsp.jstl-api-3.0.0.jar`.

---

## 📄 Bản quyền
Dự án được xây dựng phục vụ mục đích học tập và nghiên cứu kiến trúc Java Web MVC.
