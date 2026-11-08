<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết Đơn hàng #${order.orderId} - Admin Portal</title>
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
                <h1 class="page-title">Chi tiết Đơn hàng #${order.orderId}</h1>
                <p class="page-subtitle">
                    Ngày đặt: <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm:ss" />
                </p>
            </div>
            <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left"></i> Quay lại danh sách
            </a>
        </div>

        <!-- Thông báo cập nhật trạng thái -->
        <c:if test="${param.msg == 'status_updated'}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle-fill me-1"></i>
                Đã cập nhật trạng thái đơn hàng <strong>#${order.orderId}</strong> sang <strong>${order.status}</strong> thành công!
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        <c:if test="${param.msg == 'status_failed'}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-1"></i>
                Cập nhật trạng thái đơn hàng thất bại! Vui lòng thử lại.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <div class="row g-4 mb-4">
            <!-- Thông tin khách hàng và giao hàng -->
            <div class="col-lg-7">
                <div class="card h-100">
                    <div class="card-header">
                        <i class="bi bi-person-lines-fill me-2 text-primary"></i>Thông tin Người nhận &amp; Giao hàng
                    </div>
                    <div class="card-body p-4">
                        <div class="row mb-3">
                            <div class="col-sm-4 text-muted small">Tên khách hàng</div>
                            <div class="col-sm-8 fw-bold text-dark">
                                ${not empty order.customerName ? order.customerName : 'Khách hàng #'.concat(order.userId)}
                                <c:if test="${not empty order.customerUsername}">
                                    <span class="text-muted fw-normal">(@${order.customerUsername})</span>
                                </c:if>
                            </div>
                        </div>
                        <c:if test="${not empty order.customerEmail}">
                            <div class="row mb-3">
                                <div class="col-sm-4 text-muted small">Email</div>
                                <div class="col-sm-8">${order.customerEmail}</div>
                            </div>
                        </c:if>
                        <div class="row mb-3">
                            <div class="col-sm-4 text-muted small">Số điện thoại nhận</div>
                            <div class="col-sm-8 fw-semibold">${order.phone}</div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-sm-4 text-muted small">Địa chỉ giao hàng</div>
                            <div class="col-sm-8 fw-semibold">${order.shippingAddress}</div>
                        </div>
                        <div class="row mb-0">
                            <div class="col-sm-4 text-muted small">Ghi chú của khách</div>
                            <div class="col-sm-8 text-secondary">
                                ${not empty order.notes ? order.notes : 'Không có ghi chú'}
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Form cập nhật trạng thái đơn hàng -->
            <div class="col-lg-5">
                <div class="card h-100">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <span><i class="bi bi-sliders me-2 text-primary"></i>Trạng thái Đơn hàng</span>
                        <c:choose>
                            <c:when test="${order.status == 'Pending'}">
                                <span class="badge-pending">Pending</span>
                            </c:when>
                            <c:when test="${order.status == 'Processing'}">
                                <span class="badge-processing">Processing</span>
                            </c:when>
                            <c:when test="${order.status == 'Shipping'}">
                                <span class="badge-shipping">Shipping</span>
                            </c:when>
                            <c:when test="${order.status == 'Completed'}">
                                <span class="badge-completed">Completed</span>
                            </c:when>
                            <c:when test="${order.status == 'Cancelled'}">
                                <span class="badge-cancelled">Cancelled</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge-category">${order.status}</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="card-body p-4 d-flex flex-column justify-content-between">
                        <form action="${pageContext.request.contextPath}/admin/orders/status" method="post">
                            <input type="hidden" name="orderId" value="${order.orderId}">
                            <div class="mb-3">
                                <label for="status" class="form-label">Chọn trạng thái mới</label>
                                <select name="status" id="status" class="form-select" required>
                                    <option value="Pending" ${order.status == 'Pending' ? 'selected' : ''}>
                                        Pending (Chờ xác nhận)
                                    </option>
                                    <option value="Processing" ${order.status == 'Processing' ? 'selected' : ''}>
                                        Processing (Đang đóng gói / xử lý)
                                    </option>
                                    <option value="Shipping" ${order.status == 'Shipping' ? 'selected' : ''}>
                                        Shipping (Đang giao hàng)
                                    </option>
                                    <option value="Completed" ${order.status == 'Completed' ? 'selected' : ''}>
                                        Completed (Đã giao thành công)
                                    </option>
                                    <option value="Cancelled" ${order.status == 'Cancelled' ? 'selected' : ''}>
                                        Cancelled (Hủy đơn hàng)
                                    </option>
                                </select>
                            </div>
                            <button type="submit" class="btn btn-primary w-100">
                                <i class="bi bi-check2-circle"></i> Cập nhật trạng thái
                            </button>
                        </form>

                        <div class="mt-3 pt-3 border-top d-flex justify-content-between align-items-center">
                            <span class="text-muted fw-semibold">Tổng thanh toán:</span>
                            <span class="fs-4 fw-bold text-danger">
                                <fmt:formatNumber value="${order.totalAmount}" type="number" groupingUsed="true" maxFractionDigits="0" /> ₫
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bảng danh sách sản phẩm trong đơn -->
        <div class="card">
            <div class="card-header">
                <i class="bi bi-box-seam me-2 text-primary"></i>Danh sách sản phẩm trong đơn (${orderDetails.size()} mặt hàng)
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead>
                            <tr>
                                <th class="ps-4">Mã SP</th>
                                <th>Ảnh</th>
                                <th>Tên sản phẩm</th>
                                <th class="text-end">Đơn giá</th>
                                <th class="text-center">Số lượng</th>
                                <th class="text-end pe-4">Thành tiền</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="d" items="${orderDetails}">
                                <tr>
                                    <td class="ps-4 fw-semibold">#${d.productId}</td>
                                    <td>
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
                                    </td>
                                    <td class="fw-semibold text-dark">
                                        ${not empty d.productName ? d.productName : 'Sản phẩm #'.concat(d.productId)}
                                    </td>
                                    <td class="text-end">
                                        <fmt:formatNumber value="${d.unitPrice}" type="number" groupingUsed="true" maxFractionDigits="0" /> ₫
                                    </td>
                                    <td class="text-center fw-bold">${d.quantity}</td>
                                    <td class="text-end pe-4 fw-bold text-dark">
                                        <fmt:formatNumber value="${d.totalPrice}" type="number" groupingUsed="true" maxFractionDigits="0" /> ₫
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                        <tfoot>
                            <tr>
                                <td colspan="5" class="text-end fw-bold py-3">Tổng thanh toán:</td>
                                <td class="text-end pe-4 fw-bold fs-5 text-danger py-3">
                                    <fmt:formatNumber value="${order.totalAmount}" type="number" groupingUsed="true" maxFractionDigits="0" /> ₫
                                </td>
                            </tr>
                        </tfoot>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
