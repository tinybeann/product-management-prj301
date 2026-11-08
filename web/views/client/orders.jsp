<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch sử đơn hàng - Product Store</title>
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
                <h1 class="page-title">Lịch sử đơn hàng của tôi</h1>
                <p class="page-subtitle">Theo dõi trạng thái xử lý và chi tiết các đơn hàng bạn đã đặt</p>
            </div>
            <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary">
                <i class="bi bi-bag-plus"></i> Mua sắm thêm
            </a>
        </div>

        <c:if test="${not empty param.msg}">
            <div class="alert alert-warning alert-dismissible fade show" role="alert">
                <c:choose>
                    <c:when test="${param.msg == 'forbidden'}">Bạn không có quyền xem đơn hàng này!</c:when>
                    <c:when test="${param.msg == 'notfound'}">Không tìm thấy đơn hàng yêu cầu!</c:when>
                    <c:otherwise>Thông báo hệ thống.</c:otherwise>
                </c:choose>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <c:choose>
            <c:when test="${empty orders}">
                <div class="card text-center py-5">
                    <div class="card-body py-4">
                        <div class="mb-3 text-muted" style="font-size: 3rem;"><i class="bi bi-inbox"></i></div>
                        <h4 class="fw-bold text-dark mb-2">Bạn chưa có đơn hàng nào</h4>
                        <p class="text-muted mb-4">Hãy chọn sản phẩm yêu thích và đặt hàng ngay hôm nay.</p>
                        <a href="${pageContext.request.contextPath}/home" class="btn btn-primary px-4">
                            Mua sắm ngay
                        </a>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="d-flex flex-column gap-3">
                    <c:forEach var="order" items="${orders}">
                        <div class="card">
                            <div class="card-header d-flex flex-wrap justify-content-between align-items-center gap-2">
                                <div class="d-flex align-items-center flex-wrap gap-2">
                                    <span class="fw-bold text-dark">Đơn hàng #${order.orderId}</span>
                                    <span class="text-muted small">
                                        &bull; <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm" />
                                    </span>
                                </div>
                                <div class="d-flex align-items-center gap-2">
                                    <c:choose>
                                        <c:when test="${order.status == 'Pending'}">
                                            <span class="badge-pending">Pending (Chờ xử lý)</span>
                                        </c:when>
                                        <c:when test="${order.status == 'Processing'}">
                                            <span class="badge-processing">Processing (Đang chuẩn bị)</span>
                                        </c:when>
                                        <c:when test="${order.status == 'Shipping'}">
                                            <span class="badge-shipping">Shipping (Đang giao)</span>
                                        </c:when>
                                        <c:when test="${order.status == 'Completed'}">
                                            <span class="badge-completed">Completed (Hoàn thành)</span>
                                        </c:when>
                                        <c:when test="${order.status == 'Cancelled'}">
                                            <span class="badge-cancelled">Cancelled (Đã hủy)</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge-category">${order.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                    <a href="${pageContext.request.contextPath}/order-detail?id=${order.orderId}"
                                       class="btn btn-sm btn-outline-secondary">
                                        Xem chi tiết <i class="bi bi-arrow-right"></i>
                                    </a>
                                </div>
                            </div>

                            <div class="card-body p-4">
                                <div class="row g-3 mb-3 small">
                                    <div class="col-md-5">
                                        <div class="text-muted mb-1">Địa chỉ nhận hàng</div>
                                        <div class="fw-semibold text-dark">${order.shippingAddress}</div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="text-muted mb-1">Số điện thoại</div>
                                        <div class="fw-semibold text-dark">${order.phone}</div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="text-muted mb-1">Ghi chú</div>
                                        <div class="fw-semibold text-dark">${not empty order.notes ? order.notes : 'Không có'}</div>
                                    </div>
                                </div>

                                <div class="d-flex flex-wrap justify-content-between align-items-center pt-3 border-top">
                                    <a href="${pageContext.request.contextPath}/order-detail?id=${order.orderId}"
                                       class="fw-semibold small">
                                        <i class="bi bi-list-ul me-1"></i>Xem danh sách sản phẩm trong đơn
                                    </a>
                                    <div>
                                        <span class="text-muted small me-2">Tổng thanh toán:</span>
                                        <span class="fs-5 fw-bold text-danger">
                                            <fmt:formatNumber value="${order.totalAmount}" type="number" groupingUsed="true" maxFractionDigits="0" /> ₫
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <footer class="bg-white border-top py-3 mt-auto">
        <div class="container text-center text-muted small">
            &copy; 2026 Product Store - Hệ thống Quản lý Sản phẩm &amp; Đơn hàng
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
