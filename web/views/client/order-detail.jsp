<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết Đơn hàng #${order.orderId} - Product Store</title>
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
                <h1 class="page-title">Chi tiết Đơn hàng #${order.orderId}</h1>
                <p class="page-subtitle">
                    Ngày đặt: <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm:ss" />
                </p>
            </div>
            <a href="${pageContext.request.contextPath}/orders" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left"></i> Quay lại lịch sử đơn hàng
            </a>
        </div>

        <!-- Thông tin chung & Trạng thái đơn hàng -->
        <div class="card mb-4">
            <div class="card-header d-flex flex-wrap justify-content-between align-items-center gap-2">
                <span><i class="bi bi-geo-alt me-2 text-primary"></i>Thông tin nhận hàng</span>
                <div class="d-flex align-items-center gap-2">
                    <span class="text-muted small">Trạng thái:</span>
                    <c:choose>
                        <c:when test="${order.status == 'Pending'}">
                            <span class="badge-pending">Pending (Chờ xử lý)</span>
                        </c:when>
                        <c:when test="${order.status == 'Processing'}">
                            <span class="badge-processing">Processing (Đang chuẩn bị)</span>
                        </c:when>
                        <c:when test="${order.status == 'Shipping'}">
                            <span class="badge-shipping">Shipping (Đang giao hàng)</span>
                        </c:when>
                        <c:when test="${order.status == 'Completed'}">
                            <span class="badge-completed">Completed (Đã hoàn thành)</span>
                        </c:when>
                        <c:when test="${order.status == 'Cancelled'}">
                            <span class="badge-cancelled">Cancelled (Đã hủy)</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge-category">${order.status}</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="card-body p-4">
                <div class="row g-3">
                    <div class="col-md-4">
                        <div class="text-muted small mb-1">Người đặt hàng</div>
                        <div class="fw-bold text-dark">
                            ${not empty order.customerName ? order.customerName : sessionScope.currentUser.fullName}
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="text-muted small mb-1">Số điện thoại nhận hàng</div>
                        <div class="fw-bold text-dark">${order.phone}</div>
                    </div>
                    <div class="col-md-4">
                        <div class="text-muted small mb-1">Ghi chú đơn hàng</div>
                        <div class="fw-semibold text-secondary">${not empty order.notes ? order.notes : 'Không có ghi chú'}</div>
                    </div>
                    <div class="col-12">
                        <div class="text-muted small mb-1">Địa chỉ giao hàng</div>
                        <div class="fw-semibold text-dark">${order.shippingAddress}</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Danh sách sản phẩm trong đơn -->
        <div class="card">
            <div class="card-header">
                <i class="bi bi-box-seam me-2 text-primary"></i>Danh sách sản phẩm đã mua (${orderDetails.size()} món)
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead>
                            <tr>
                                <th class="ps-4">Sản phẩm</th>
                                <th class="text-end">Đơn giá</th>
                                <th class="text-center">Số lượng</th>
                                <th class="text-end pe-4">Thành tiền</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="d" items="${orderDetails}">
                                <tr>
                                    <td class="ps-4 py-3">
                                        <div class="d-flex align-items-center gap-3">
                                            <c:choose>
                                                <c:when test="${not empty d.imageUrl}">
                                                    <img src="${d.imageUrl.startsWith('http') ? d.imageUrl : pageContext.request.contextPath.concat('/').concat(d.imageUrl)}"
                                                         alt="${d.productName}"
                                                         class="product-thumb"
                                                         onerror="this.onerror=null;this.src='https://placehold.co/48x48?text=No+Img';">
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="https://placehold.co/48x48?text=No+Img"
                                                         alt="No Image"
                                                         class="product-thumb">
                                                </c:otherwise>
                                            </c:choose>
                                            <div>
                                                <div class="fw-bold text-dark">
                                                    ${not empty d.productName ? d.productName : 'Sản phẩm #'.concat(d.productId)}
                                                </div>
                                                <div class="small text-muted">Mã SP: #${d.productId}</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="text-end fw-semibold text-nowrap">
                                        <fmt:formatNumber value="${d.unitPrice}" type="number" groupingUsed="true" maxFractionDigits="0" /> ₫
                                    </td>
                                    <td class="text-center fw-bold">${d.quantity}</td>
                                    <td class="text-end pe-4 fw-bold text-dark text-nowrap">
                                        <fmt:formatNumber value="${d.totalPrice}" type="number" groupingUsed="true" maxFractionDigits="0" /> ₫
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                        <tfoot>
                            <tr>
                                <td colspan="3" class="text-end fw-bold py-3">Tổng tiền thanh toán:</td>
                                <td class="text-end pe-4 fw-bold fs-4 text-danger py-3">
                                    <fmt:formatNumber value="${order.totalAmount}" type="number" groupingUsed="true" maxFractionDigits="0" /> ₫
                                </td>
                            </tr>
                        </tfoot>
                    </table>
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
