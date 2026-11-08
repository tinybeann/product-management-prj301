<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký tài khoản - Product Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="d-flex align-items-center min-vh-100 py-4">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-7 col-lg-6">
                <div class="text-center mb-3">
                    <a href="${pageContext.request.contextPath}/home" class="d-inline-flex align-items-center gap-2 fw-bold fs-5 text-dark">
                        <span class="brand-icon"><i class="bi bi-bag-check-fill"></i></span>
                        <span>Product Store</span>
                    </a>
                </div>

                <div class="card">
                    <div class="card-body p-4 p-md-5">
                        <div class="mb-4">
                            <h4 class="fw-bold text-dark mb-1">Đăng ký tài khoản</h4>
                            <p class="text-muted small mb-0">Tạo tài khoản khách hàng mới để đặt hàng nhanh chóng</p>
                        </div>

                        <c:if test="${not empty error}">
                            <div class="alert alert-danger py-2 small" role="alert">
                                ${error}
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/register" method="post">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="username" class="form-label">Tên đăng nhập <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="username" name="username"
                                           value="${username}" placeholder="Tối thiểu 3 ký tự" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="fullName" class="form-label">Họ và tên <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="fullName" name="fullName"
                                           value="${fullName}" placeholder="Nguyễn Văn A" required>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="password" class="form-label">Mật khẩu <span class="text-danger">*</span></label>
                                    <input type="password" class="form-control" id="password" name="password"
                                           placeholder="Tối thiểu 6 ký tự" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="confirmPassword" class="form-label">Xác nhận mật khẩu <span class="text-danger">*</span></label>
                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword"
                                           placeholder="Nhập lại mật khẩu" required>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="email" class="form-label">Email <span class="text-danger">*</span></label>
                                    <input type="email" class="form-control" id="email" name="email"
                                           value="${email}" placeholder="example@email.com" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="phone" class="form-label">Số điện thoại</label>
                                    <input type="text" class="form-control" id="phone" name="phone"
                                           value="${phone}" placeholder="090xxxxxxx">
                                </div>
                            </div>

                            <div class="mb-4">
                                <label for="address" class="form-label">Địa chỉ</label>
                                <input type="text" class="form-control" id="address" name="address"
                                       value="${address}" placeholder="Số nhà, đường, quận/huyện, tỉnh/thành phố">
                            </div>

                            <div class="d-grid mb-3">
                                <button type="submit" class="btn btn-dark py-2">
                                    Tạo tài khoản
                                </button>
                            </div>

                            <div class="text-center small">
                                <span class="text-muted">Đã có tài khoản?</span>
                                <a href="${pageContext.request.contextPath}/login" class="fw-semibold ms-1">
                                    Đăng nhập
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
