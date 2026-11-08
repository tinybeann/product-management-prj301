<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán &amp; Đặt hàng - Product Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="d-flex flex-column min-vh-100">
    <jsp:include page="/views/common/client-navbar.jsp" />

    <div class="container pb-5 flex-grow-1">
        <div class="page-header">
            <div>
                <h1 class="page-title">Xác nhận thông tin Đặt hàng</h1>
                <p class="page-subtitle">Kiểm tra địa chỉ nhận hàng và danh sách sản phẩm trước khi hoàn tất</p>
            </div>
            <a href="${pageContext.request.contextPath}/cart" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left"></i> Quay lại Giỏ hàng
            </a>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-circle me-1"></i>${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <div class="row g-4 align-items-start">
            <!-- Form thông tin giao hàng -->
            <div class="col-lg-7">
                <div class="card">
                    <div class="card-header">
                        <i class="bi bi-geo-alt me-2 text-primary"></i>Thông tin người nhận &amp; Giao hàng
                    </div>
                    <div class="card-body p-4">
                        <form action="${pageContext.request.contextPath}/checkout" method="post" id="checkoutForm">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="fullName" class="form-label">Họ và tên người nhận <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="fullName" name="fullName"
                                           value="${not empty fullName ? fullName : sessionScope.currentUser.fullName}"
                                           placeholder="Nhập họ và tên người nhận" required>
                                </div>

                                <div class="col-md-6 mb-3">
                                    <label for="phone" class="form-label">Số điện thoại liên hệ <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="phone" name="phone"
                                           value="${not empty phone ? phone : sessionScope.currentUser.phone}"
                                           placeholder="Nhập số điện thoại nhận hàng" required>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="shippingAddress" class="form-label">Địa chỉ giao hàng chi tiết <span class="text-danger">*</span></label>
                                <textarea class="form-control" id="shippingAddress" name="shippingAddress" rows="3"
                                          placeholder="Số nhà, tên đường, phường/xã, quận/huyện, tỉnh/thành phố..." required>${not empty shippingAddress ? shippingAddress : sessionScope.currentUser.address}</textarea>
                            </div>

                            <div class="mb-4">
                                <label for="notes" class="form-label">Ghi chú đơn hàng (Tùy chọn)</label>
                                <textarea class="form-control" id="notes" name="notes" rows="2"
                                          placeholder="Ghi chú thêm về thời gian giao hàng hoặc hướng dẫn chỉ đường...">${notes}</textarea>
                            </div>

                            <div class="d-grid">
                                <button type="submit" class="btn btn-primary btn-lg">
                                    <i class="bi bi-check2-circle"></i> Xác nhận Đặt hàng
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Tóm tắt danh sách món hàng sẽ mua -->
            <div class="col-lg-5">
                <div class="card summary-sticky">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <span><i class="bi bi-bag-check me-2 text-primary"></i>Đơn hàng của bạn</span>
                        <span class="badge-category">${sessionScope.cart.totalQuantity} sản phẩm</span>
                    </div>
                    <div class="card-body p-4">
                        <ul class="list-group list-group-flush mb-3">
                            <c:forEach var="item" items="${sessionScope.cart.itemsList}">
                                <li class="list-group-item px-0 py-3 d-flex justify-content-between align-items-start gap-2 bg-transparent">
                                    <div>
                                        <div class="fw-semibold text-dark">${item.product.productName}</div>
                                        <div class="small text-muted">
                                            SL: <strong>${item.quantity}</strong> &times;
                                            <fmt:formatNumber value="${item.product.price}" type="number" groupingUsed="true" maxFractionDigits="0" /> ₫
                                        </div>
                                    </div>
                                    <span class="fw-bold text-dark text-nowrap">
                                        <fmt:formatNumber value="${item.totalPrice}" type="number" groupingUsed="true" maxFractionDigits="0" /> ₫
                                    </span>
                                </li>
                            </c:forEach>
                        </ul>

                        <div class="d-flex justify-content-between mb-2 text-muted small">
                            <span>Tạm tính</span>
                            <span>
                                <fmt:formatNumber value="${sessionScope.cart.totalMoney}" type="number" groupingUsed="true" maxFractionDigits="0" /> ₫
                            </span>
                        </div>
                        <div class="d-flex justify-content-between mb-3 text-muted small">
                            <span>Phí vận chuyển</span>
                            <span class="text-success fw-semibold">Miễn phí</span>
                        </div>
                        <hr>
                        <div class="d-flex justify-content-between align-items-center">
                            <span class="fw-bold">Tổng thanh toán</span>
                            <span class="fw-bold fs-4 text-danger">
                                <fmt:formatNumber value="${sessionScope.cart.totalMoney}" type="number" groupingUsed="true" maxFractionDigits="0" /> ₫
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <footer class="bg-white border-top py-3 mt-auto">
        <div class="container text-center text-muted small">
            &copy; 2026 Product Store - Hệ thống Quản lý Sản phẩm &amp; Đơn hàng
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
