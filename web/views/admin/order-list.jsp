<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Đơn hàng - Admin Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <jsp:include page="/views/admin/navbar.jsp" />

    <div class="container pb-5">
        <div class="page-header">
            <div>
                <h1 class="page-title">
                    Quản lý Đơn hàng
                    <span class="badge-category ms-1">${orders.size()} đơn</span>
                </h1>
                <p class="page-subtitle">Theo dõi trạng thái thanh toán, vận chuyển và xử lý đơn đặt hàng của khách</p>
            </div>
        </div>

        <!-- Alert thông báo -->
        <c:if test="${not empty param.msg}">
            <div class="alert ${param.msg == 'notfound' or param.msg == 'invalid' ? 'alert-warning' : 'alert-success'} alert-dismissible fade show" role="alert">
                <c:choose>
                    <c:when test="${param.msg == 'notfound'}">Không tìm thấy đơn hàng yêu cầu!</c:when>
                    <c:when test="${param.msg == 'invalid'}">Mã đơn hàng không hợp lệ!</c:when>
                    <c:when test="${param.msg == 'status_updated'}">Đã cập nhật trạng thái đơn hàng thành công!</c:when>
                    <c:otherwise>Thao tác thành công!</c:otherwise>
                </c:choose>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <!-- Bộ lọc trạng thái -->
        <div class="card mb-4">
            <div class="card-body d-flex flex-wrap align-items-center justify-content-between gap-3">
                <div class="filter-pills">
                    <a href="${pageContext.request.contextPath}/admin/orders"
                       class="filter-pill ${empty selectedStatus or selectedStatus == 'ALL' ? 'active' : ''}">
                        Tất cả
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/orders?status=Pending"
                       class="filter-pill ${selectedStatus == 'Pending' ? 'active' : ''}">
                        <i class="bi bi-hourglass-split"></i> Chờ xử lý
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/orders?status=Processing"
                       class="filter-pill ${selectedStatus == 'Processing' ? 'active' : ''}">
                        <i class="bi bi-box-seam"></i> Đang chuẩn bị
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/orders?status=Shipping"
                       class="filter-pill ${selectedStatus == 'Shipping' ? 'active' : ''}">
                        <i class="bi bi-truck"></i> Đang giao
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/orders?status=Completed"
                       class="filter-pill ${selectedStatus == 'Completed' ? 'active' : ''}">
                        <i class="bi bi-check2-circle"></i> Hoàn thành
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/orders?status=Cancelled"
                       class="filter-pill ${selectedStatus == 'Cancelled' ? 'active' : ''}">
                        <i class="bi bi-x-circle"></i> Đã hủy
                    </a>
                </div>

                <form action="${pageContext.request.contextPath}/admin/orders" method="get" class="d-flex gap-2">
                    <select name="status" class="form-select form-select-sm" style="min-width: 190px;" onchange="this.form.submit()">
                        <option value="">-- Lọc nhanh trạng thái --</option>
                        <option value="Pending" ${selectedStatus == 'Pending' ? 'selected' : ''}>Pending (Chờ xử lý)</option>
                        <option value="Processing" ${selectedStatus == 'Processing' ? 'selected' : ''}>Processing (Đang chuẩn bị)</option>
                        <option value="Shipping" ${selectedStatus == 'Shipping' ? 'selected' : ''}>Shipping (Đang giao)</option>
                        <option value="Completed" ${selectedStatus == 'Completed' ? 'selected' : ''}>Completed (Hoàn thành)</option>
                        <option value="Cancelled" ${selectedStatus == 'Cancelled' ? 'selected' : ''}>Cancelled (Đã hủy)</option>
                    </select>
                </form>
            </div>
        </div>

        <!-- Bảng danh sách đơn hàng -->
        <div class="card">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead>
                            <tr>
                                <th class="ps-3">Mã đơn</th>
                                <th>Khách hàng</th>
                                <th>Điện thoại</th>
                                <th>Địa chỉ giao</th>
                                <th>Ngày đặt</th>
                                <th class="text-end">Tổng tiền</th>
                                <th class="text-center">Trạng thái</th>
                                <th class="text-end pe-3">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty orders}">
                                    <tr>
                                        <td colspan="8" class="text-center py-5 text-muted">
                                            Không có đơn hàng nào phù hợp với bộ lọc hiện tại.
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="o" items="${orders}">
                                        <tr>
                                            <td class="ps-3 fw-bold text-dark">#${o.orderId}</td>
                                            <td>
                                                <div class="fw-semibold text-dark">
                                                    ${not empty o.customerName ? o.customerName : 'Khách hàng #'.concat(o.userId)}
                                                </div>
                                                <c:if test="${not empty o.customerEmail}">
                                                    <div class="small text-muted">${o.customerEmail}</div>
                                                </c:if>
                                            </td>
                                            <td class="fw-medium">${o.phone}</td>
                                            <td>
                                                <div class="text-truncate" style="max-width: 220px;" title="${o.shippingAddress}">
                                                    ${o.shippingAddress}
                                                </div>
                                            </td>
                                            <td class="small text-muted">
                                                <fmt:formatDate value="${o.orderDate}" pattern="dd/MM/yyyy HH:mm" />
                                            </td>
                                            <td class="text-end fw-bold text-dark">
                                                <fmt:formatNumber value="${o.totalAmount}" type="number" groupingUsed="true" maxFractionDigits="0" /> ₫
                                            </td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${o.status == 'Pending'}">
                                                        <span class="badge-pending">Pending</span>
                                                    </c:when>
                                                    <c:when test="${o.status == 'Processing'}">
                                                        <span class="badge-processing">Processing</span>
                                                    </c:when>
                                                    <c:when test="${o.status == 'Shipping'}">
                                                        <span class="badge-shipping">Shipping</span>
                                                    </c:when>
                                                    <c:when test="${o.status == 'Completed'}">
                                                        <span class="badge-completed">Completed</span>
                                                    </c:when>
                                                    <c:when test="${o.status == 'Cancelled'}">
                                                        <span class="badge-cancelled">Cancelled</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge-category">${o.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-end pe-3">
                                                <a href="${pageContext.request.contextPath}/admin/orders/detail?id=${o.orderId}"
                                                   class="btn btn-sm btn-outline-secondary">
                                                    <i class="bi bi-eye"></i> Chi tiết
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
