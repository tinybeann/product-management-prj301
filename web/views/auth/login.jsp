<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - Product Store</title>
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
            <div class="col-md-5 col-lg-4">
                <div class="text-center mb-3">
                    <a href="${pageContext.request.contextPath}/home" class="d-inline-flex align-items-center gap-2 fw-bold fs-5 text-dark">
                        <span class="brand-icon"><i class="bi bi-bag-check-fill"></i></span>
                        <span>Product Store</span>
                    </a>
                </div>

                <div class="card">
                    <div class="card-body p-4 p-md-5">
                        <div class="mb-4">
                            <h4 class="fw-bold text-dark mb-1">Đăng nhập tài khoản</h4>
                            <p class="text-muted small mb-0">Nhập thông tin đăng nhập để tiếp tục</p>
                        </div>

                        <c:if test="${param.error == 'unauthorized'}">
                            <div class="alert alert-warning py-2 small" role="alert">
                                Vui lòng đăng nhập để tiếp tục!
                            </div>
                        </c:if>

                        <c:if test="${param.error == 'checkout'}">
                            <div class="alert alert-warning py-2 small" role="alert">
                                Vui lòng đăng nhập để tiến hành đặt hàng và thanh toán!
                            </div>
                        </c:if>

                        <c:if test="${param.registered == 'true'}">
                            <div class="alert alert-success py-2 small" role="alert">
                                Đăng ký tài khoản thành công! Vui lòng đăng nhập.
                            </div>
                        </c:if>

                        <c:if test="${not empty error}">
                            <div class="alert alert-danger py-2 small" role="alert">
                                ${error}
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/login" method="post">
                            <div class="mb-3">
                                <label for="username" class="form-label">Tên đăng nhập</label>
                                <input type="text" class="form-control" id="username" name="username"
                                       value="${username}" placeholder="Nhập username" required autofocus>
                            </div>

                            <div class="mb-4">
                                <label for="password" class="form-label">Mật khẩu</label>
                                <input type="password" class="form-control" id="password" name="password"
                                       placeholder="Nhập mật khẩu" required>
                            </div>

                            <div class="d-grid mb-3">
                                <button type="submit" class="btn btn-dark py-2">
                                    Đăng nhập
                                </button>
                            </div>

                            <div class="text-center small">
                                <span class="text-muted">Chưa có tài khoản?</span>
                                <a href="${pageContext.request.contextPath}/register" class="fw-semibold ms-1">
                                    Đăng ký ngay
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
