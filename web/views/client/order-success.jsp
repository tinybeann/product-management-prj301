<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt hàng thành công - Product Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="d-flex flex-column min-vh-100">
    <jsp:include page="/views/common/client-navbar.jsp" />

    <div class="container py-5 flex-grow-1 d-flex align-items-center justify-content-center">
        <div class="card text-center p-4 p-md-5" style="max-width: 540px; width: 100%;">
            <div class="card-body">
                <div class="mx-auto mb-3 d-inline-flex align-items-center justify-content-center rounded-circle"
                     style="width: 64px; height: 64px; background: #ecfdf5; color: #059669; font-size: 2rem;">
                    <i class="bi bi-check-lg"></i>
                </div>
                <h2 class="fw-bold text-dark mb-2">Đặt hàng thành công!</h2>
                <p class="text-muted mb-4">
                    Cảm ơn bạn đã mua sắm tại <strong>Product Store</strong>. Đơn hàng của bạn đã được ghi nhận vào hệ thống và đang chờ xử lý.
                </p>

                <c:if test="${not empty sessionScope.lastOrderId}">
                    <div class="rounded-3 p-3 mb-4 border text-start" style="background: var(--bg-subtle);">
                        <div class="d-flex justify-content-between mb-2 small">
                            <span class="text-muted">Mã đơn hàng:</span>
                            <span class="fw-bold text-dark">#${sessionScope.lastOrderId}</span>
                        </div>
                        <c:if test="${not empty sessionScope.lastOrderFullName}">
                            <div class="d-flex justify-content-between mb-2 small">
                                <span class="text-muted">Người nhận:</span>
                                <span class="fw-semibold text-dark">${sessionScope.lastOrderFullName}</span>
                            </div>
                        </c:if>
                        <c:if test="${not empty sessionScope.lastOrderTotal}">
                            <div class="d-flex justify-content-between small pt-2 border-top">
                                <span class="text-muted">Tổng thanh toán:</span>
                                <span class="fw-bold text-danger">
                                    <fmt:formatNumber value="${sessionScope.lastOrderTotal}" type="number" groupingUsed="true" maxFractionDigits="0" /> ₫
                                </span>
                            </div>
                        </c:if>
                    </div>
                </c:if>

                <div class="d-flex flex-wrap justify-content-center gap-2">
                    <a href="${pageContext.request.contextPath}/orders" class="btn btn-primary px-4">
                        <i class="bi bi-receipt"></i> Xem lịch sử đơn hàng
                    </a>
                    <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary px-4">
                        <i class="bi bi-house-door"></i> Về trang chủ
                    </a>
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
