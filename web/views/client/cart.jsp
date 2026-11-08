<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ hàng của bạn - Product Store</title>
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
                <h1 class="page-title">Giỏ hàng của bạn</h1>
                <p class="page-subtitle">Kiểm tra số lượng mặt hàng trước khi tiến hành thanh toán</p>
            </div>
            <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left"></i> Tiếp tục mua hàng
            </a>
        </div>

        <c:choose>
            <c:when test="${empty sessionScope.cart or empty sessionScope.cart.itemsList}">
                <div class="card text-center py-5">
                    <div class="card-body py-4">
                        <div class="mb-3 text-muted" style="font-size: 3rem;"><i class="bi bi-cart-x"></i></div>
                        <h4 class="fw-bold text-dark mb-2">Giỏ hàng của bạn đang trống</h4>
                        <p class="text-muted mb-4">Hãy khám phá thêm các sản phẩm tại cửa hàng và thêm vào giỏ nhé.</p>
                        <a href="${pageContext.request.contextPath}/home" class="btn btn-primary px-4">
                            Khám phá sản phẩm ngay
                        </a>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row g-4 align-items-start">
                    <div class="col-lg-8">
                        <div class="card">
                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle mb-0">
                                        <thead>
                                            <tr>
                                                <th class="ps-4">Sản phẩm</th>
                                                <th class="text-end">Đơn giá</th>
                                                <th class="text-center" style="width: 190px;">Số lượng</th>
                                                <th class="text-end">Thành tiền</th>
                                                <th class="text-center pe-4">Xóa</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="item" items="${sessionScope.cart.itemsList}">
                                                <tr>
                                                    <td class="ps-4 py-3">
                                                        <div class="d-flex align-items-center gap-3">
                                                            <c:choose>
                                                                <c:when test="${not empty item.product.imageUrl}">
                                                                    <img src="${item.product.imageUrl.startsWith('http') ? item.product.imageUrl : pageContext.request.contextPath.concat('/').concat(item.product.imageUrl)}"
                                                                         alt="${item.product.productName}"
                                                                         class="cart-thumb"
                                                                         onerror="this.onerror=null;this.src='https://placehold.co/64x64?text=No+Img';">
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <img src="https://placehold.co/64x64?text=No+Img"
                                                                         alt="${item.product.productName}"
                                                                         class="cart-thumb">
                                                                </c:otherwise>
                                                            </c:choose>
                                                            <div>
                                                                <div class="fw-bold text-dark">${item.product.productName}</div>
                                                                <c:if test="${not empty item.product.categoryName}">
                                                                    <span class="badge-category mt-1">${item.product.categoryName}</span>
                                                                </c:if>
                                                                <div class="small text-muted mt-1">
                                                                    Tồn kho: ${item.product.stockQuantity}
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td class="text-end fw-semibold text-nowrap">
                                                        <fmt:formatNumber value="${item.product.price}" type="number" groupingUsed="true" maxFractionDigits="0" /> ₫
                                                    </td>
                                                    <td class="text-center">
                                                        <form action="${pageContext.request.contextPath}/cart" method="post"
                                                              class="d-flex align-items-center justify-content-center gap-1">
                                                            <input type="hidden" name="action" value="update">
                                                            <input type="hidden" name="productId" value="${item.product.productId}">
                                                            <input type="number" name="quantity" value="${item.quantity}"
                                                                   min="1" max="${item.product.stockQuantity > 0 ? item.product.stockQuantity : 999}"
                                                                   class="form-control form-control-sm text-center" style="width: 68px;" required>
                                                            <button type="submit" class="btn btn-sm btn-outline-secondary">
                                                                Lưu
                                                            </button>
                                                        </form>
                                                    </td>
                                                    <td class="text-end fw-bold text-dark text-nowrap">
                                                        <fmt:formatNumber value="${item.totalPrice}" type="number" groupingUsed="true" maxFractionDigits="0" /> ₫
                                                    </td>
                                                    <td class="text-center pe-4">
                                                        <a href="${pageContext.request.contextPath}/cart?action=delete&productId=${item.product.productId}"
                                                           class="btn-icon btn-icon-delete" title="Xóa khỏi giỏ"
                                                           onclick="return confirm('Xóa sản phẩm này khỏi giỏ hàng?');">
                                                            <i class="bi bi-trash3"></i>
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Tổng kết giỏ hàng -->
                    <div class="col-lg-4">
                        <div class="card summary-sticky">
                            <div class="card-header">
                                Tóm tắt đơn hàng
                            </div>
                            <div class="card-body p-4">
                                <div class="d-flex justify-content-between mb-2 text-muted small">
                                    <span>Tổng số lượng</span>
                                    <span class="fw-semibold text-dark">${sessionScope.cart.totalQuantity} sản phẩm</span>
                                </div>
                                <div class="d-flex justify-content-between mb-3 text-muted small">
                                    <span>Phí vận chuyển</span>
                                    <span class="text-success fw-semibold">Miễn phí</span>
                                </div>
                                <hr>
                                <div class="d-flex justify-content-between align-items-center mb-4">
                                    <span class="fw-bold">Tổng thanh toán</span>
                                    <span class="fw-bold fs-4 text-danger">
                                        <fmt:formatNumber value="${sessionScope.cart.totalMoney}" type="number" groupingUsed="true" maxFractionDigits="0" /> ₫
                                    </span>
                                </div>

                                <div class="d-grid gap-2">
                                    <a href="${pageContext.request.contextPath}/checkout" class="btn btn-primary btn-lg">
                                        Tiến hành Đặt hàng <i class="bi bi-arrow-right"></i>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary">
                                        Tiếp tục mua hàng
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
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
