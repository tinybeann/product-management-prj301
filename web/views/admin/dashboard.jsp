<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tổng quan Quản trị - Admin Portal</title>
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
        <!-- Header -->
        <div class="page-header">
            <div>
                <h1 class="page-title">Tổng quan Hệ thống</h1>
                <p class="page-subtitle">
                    Xin chào <strong>${sessionScope.currentUser.fullName}</strong>, theo dõi hoạt động kinh doanh và đơn hàng mới nhất tại đây.
                </p>
            </div>
            <div class="d-flex flex-wrap gap-2">
                <a href="${pageContext.request.contextPath}/admin/products/add" class="btn btn-primary">
                    <i class="bi bi-plus-lg"></i> Thêm sản phẩm
                </a>
                <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-outline-secondary">
                    <i class="bi bi-clipboard-check"></i> Duyệt đơn hàng
                </a>
            </div>
        </div>

        <!-- KPI Metrics Grid -->
        <div class="row g-3 mb-4">
            <div class="col-12 col-sm-6 col-xl-3">
                <div class="card h-100">
                    <div class="kpi-card">
                        <div>
                            <div class="kpi-label">Tổng doanh thu</div>
                            <div class="kpi-value">
                                <fmt:formatNumber value="${not empty totalRevenue ? totalRevenue : 0}" type="number" groupingUsed="true" maxFractionDigits="0" /> ₫
                            </div>
                            <div class="kpi-sub">Tính trên các đơn hợp lệ</div>
                        </div>
                        <span class="kpi-icon emerald"><i class="bi bi-currency-dollar"></i></span>
                    </div>
                </div>
            </div>

            <div class="col-12 col-sm-6 col-xl-3">
                <div class="card h-100">
                    <div class="kpi-card">
                        <div>
                            <div class="kpi-label">Tổng đơn hàng</div>
                            <div class="kpi-value">${not empty totalOrders ? totalOrders : 0}</div>
                            <div class="kpi-sub">
                                <span class="text-success fw-semibold">${not empty completedOrders ? completedOrders : 0}</span> hoàn thành,
                                <span class="text-primary fw-semibold">${not empty shippingOrders ? shippingOrders : 0}</span> đang xử lý
                            </div>
                        </div>
                        <span class="kpi-icon blue"><i class="bi bi-bag-check"></i></span>
                    </div>
                </div>
            </div>

            <div class="col-12 col-sm-6 col-xl-3">
                <div class="card h-100">
                    <div class="kpi-card">
                        <div>
                            <div class="kpi-label">Đơn chờ xác nhận</div>
                            <div class="kpi-value">${not empty pendingOrders ? pendingOrders : 0}</div>
                            <div class="kpi-sub">
                                <a href="${pageContext.request.contextPath}/admin/orders?status=Pending" class="fw-semibold">
                                    Xem đơn Pending &rarr;
                                </a>
                            </div>
                        </div>
                        <span class="kpi-icon amber"><i class="bi bi-hourglass-split"></i></span>
                    </div>
                </div>
            </div>

            <div class="col-12 col-sm-6 col-xl-3">
                <div class="card h-100">
                    <div class="kpi-card">
                        <div>
                            <div class="kpi-label">Sản phẩm &amp; Danh mục</div>
                            <div class="kpi-value">${not empty totalProducts ? totalProducts : 0}</div>
                            <div class="kpi-sub">
                                ${not empty activeProducts ? activeProducts : 0} đang bán &bull; ${not empty totalCategories ? totalCategories : 0} danh mục
                            </div>
                        </div>
                        <span class="kpi-icon slate"><i class="bi bi-box-seam"></i></span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Recent Orders & Quick Navigation -->
        <div class="row g-4">
            <div class="col-lg-8">
                <div class="card h-100">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <span><i class="bi bi-clock-history me-2 text-primary"></i>Đơn đặt hàng gần đây</span>
                        <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-sm btn-outline-secondary">
                            Xem tất cả
                        </a>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead>
                                    <tr>
                                        <th class="ps-3">Mã đơn</th>
                                        <th>Khách hàng</th>
                                        <th>Ngày đặt</th>
                                        <th class="text-end">Tổng tiền</th>
                                        <th class="text-center">Trạng thái</th>
                                        <th class="text-end pe-3">Chi tiết</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty recentOrders}">
                                            <tr>
                                                <td colspan="6" class="text-center py-4 text-muted">
                                                    Chưa có đơn hàng nào được ghi nhận.
                                                </td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="o" items="${recentOrders}">
                                                <tr>
                                                    <td class="ps-3 fw-bold text-dark">#${o.orderId}</td>
                                                    <td>
                                                        <div class="fw-semibold text-dark">
                                                            ${not empty o.customerName ? o.customerName : 'Khách hàng #'.concat(o.userId)}
                                                        </div>
                                                        <div class="small text-muted">${o.phone}</div>
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
                                                                <span class="badge-pending">Chờ xử lý</span>
                                                            </c:when>
                                                            <c:when test="${o.status == 'Processing'}">
                                                                <span class="badge-processing">Đang chuẩn bị</span>
                                                            </c:when>
                                                            <c:when test="${o.status == 'Shipping'}">
                                                                <span class="badge-shipping">Đang giao</span>
                                                            </c:when>
                                                            <c:when test="${o.status == 'Completed'}">
                                                                <span class="badge-completed">Hoàn thành</span>
                                                            </c:when>
                                                            <c:when test="${o.status == 'Cancelled'}">
                                                                <span class="badge-cancelled">Đã hủy</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge-category">${o.status}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="text-end pe-3">
                                                        <a href="${pageContext.request.contextPath}/admin/orders/detail?id=${o.orderId}"
                                                           class="btn btn-sm btn-outline-secondary">
                                                            Chi tiết
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

            <div class="col-lg-4">
                <div class="card h-100">
                    <div class="card-header">
                        <i class="bi bi-lightning-charge me-2 text-primary"></i>Lối tắt Quản trị
                    </div>
                    <div class="card-body d-flex flex-column gap-3">
                        <a href="${pageContext.request.contextPath}/admin/products" class="p-3 rounded-3 border d-flex align-items-center justify-content-between text-dark" style="background: var(--bg-subtle);">
                            <div class="d-flex align-items-center gap-3">
                                <span class="kpi-icon blue" style="width: 38px; height: 38px; font-size: 1rem;"><i class="bi bi-box-seam"></i></span>
                                <div>
                                    <div class="fw-bold">Danh sách Sản phẩm</div>
                                    <div class="small text-muted">Cập nhật giá, tồn kho, trạng thái</div>
                                </div>
                            </div>
                            <i class="bi bi-chevron-right text-muted"></i>
                        </a>

                        <a href="${pageContext.request.contextPath}/admin/products/add" class="p-3 rounded-3 border d-flex align-items-center justify-content-between text-dark" style="background: var(--bg-subtle);">
                            <div class="d-flex align-items-center gap-3">
                                <span class="kpi-icon emerald" style="width: 38px; height: 38px; font-size: 1rem;"><i class="bi bi-plus-circle"></i></span>
                                <div>
                                    <div class="fw-bold">Thêm Sản phẩm mới</div>
                                    <div class="small text-muted">Tạo mặt hàng mới vào kho</div>
                                </div>
                            </div>
                            <i class="bi bi-chevron-right text-muted"></i>
                        </a>

                        <a href="${pageContext.request.contextPath}/admin/orders?status=Pending" class="p-3 rounded-3 border d-flex align-items-center justify-content-between text-dark" style="background: var(--bg-subtle);">
                            <div class="d-flex align-items-center gap-3">
                                <span class="kpi-icon amber" style="width: 38px; height: 38px; font-size: 1rem;"><i class="bi bi-bell"></i></span>
                                <div>
                                    <div class="fw-bold">Xử lý Đơn hàng mới</div>
                                    <div class="small text-muted">${not empty pendingOrders ? pendingOrders : 0} đơn đang chờ duyệt</div>
                                </div>
                            </div>
                            <i class="bi bi-chevron-right text-muted"></i>
                        </a>

                        <a href="${pageContext.request.contextPath}/home" class="p-3 rounded-3 border d-flex align-items-center justify-content-between text-dark" style="background: var(--bg-subtle);">
                            <div class="d-flex align-items-center gap-3">
                                <span class="kpi-icon slate" style="width: 38px; height: 38px; font-size: 1rem;"><i class="bi bi-shop"></i></span>
                                <div>
                                    <div class="fw-bold">Giao diện Khách hàng</div>
                                    <div class="small text-muted">Kiểm tra hiển thị cửa hàng</div>
                                </div>
                            </div>
                            <i class="bi bi-chevron-right text-muted"></i>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
