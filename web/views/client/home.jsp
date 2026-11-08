<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang chủ - Product Store</title>
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
        <!-- Thong bao neu bi tu choi quyen hoac vua them gio hang -->
        <c:if test="${param.error == 'forbidden'}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                Bạn không có quyền truy cập vào khu vực Quản trị viên!
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <c:if test="${param.added == 'true'}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                Đã thêm sản phẩm vào giỏ hàng thành công!
                <a href="${pageContext.request.contextPath}/cart" class="alert-link ms-2">Xem giỏ hàng</a>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <!-- Hero Banner -->
        <div class="hero-banner mb-4">
            <div class="hero-content">
                <span class="hero-eyebrow"><i class="bi bi-shield-check"></i> Chính hãng &bull; Giao nhanh</span>
                <h1 class="fw-bold mb-2">Mua sắm tiện lợi - Giao hàng nhanh chóng</h1>
                <p class="mb-0">
                    Đặt hàng trực tuyến dễ dàng, quản lý giỏ hàng thông minh và theo dõi trạng thái đơn hàng theo thời gian thực.
                </p>
            </div>
            <i class="bi bi-bag-check hero-deco d-none d-md-block"></i>
        </div>

        <!-- Danh muc san pham (Pills) -->
        <div class="category-bar mb-4">
            <a href="${pageContext.request.contextPath}/home"
               class="category-pill ${empty selectedCategoryId or selectedCategoryId == 0 ? 'active' : ''}">
                Tất cả sản phẩm
            </a>
            <c:forEach var="cat" items="${categories}">
                <a href="${pageContext.request.contextPath}/home?categoryId=${cat.categoryId}${not empty keyword ? '&keyword='.concat(keyword) : ''}"
                   class="category-pill ${selectedCategoryId == cat.categoryId ? 'active' : ''}">
                    ${cat.categoryName}
                </a>
            </c:forEach>
        </div>

        <!-- Hien thi ket qua loc / tim kiem -->
        <c:if test="${not empty keyword or (not empty selectedCategoryId and selectedCategoryId > 0)}">
            <div class="d-flex justify-content-between align-items-center bg-white p-3 rounded-3 shadow-sm mb-4">
                <div>
                    <span class="text-muted">Đang lọc kết quả</span>
                    <c:if test="${not empty keyword}">
                        cho từ khóa: <strong class="text-primary">"${keyword}"</strong>
                    </c:if>
                    <span class="badge bg-secondary ms-2">${products.size()} sản phẩm</span>
                </div>
                <a href="${pageContext.request.contextPath}/home" class="btn btn-sm btn-outline-danger">
                    Xóa bộ lọc
                </a>
            </div>
        </c:if>

        <!-- Luoi san pham -->
        <c:choose>
            <c:when test="${empty products}">
                <div class="card border-0 shadow-sm rounded-4 text-center py-5">
                    <div class="card-body py-4">
                        <h4 class="text-muted fw-bold mb-2">Không tìm thấy sản phẩm nào!</h4>
                        <p class="text-secondary mb-4">Vui lòng thử lại với từ khóa hoặc danh mục khác.</p>
                        <a href="${pageContext.request.contextPath}/home" class="btn btn-primary fw-semibold px-4">
                            Xem tất cả sản phẩm
                        </a>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row">
                    <c:forEach var="p" items="${products}">
                        <div class="col-12 col-md-4 col-lg-3 mb-4">
                            <div class="card h-100 product-card">
                                <div class="product-img-wrapper position-relative">
                                    <c:choose>
                                        <c:when test="${not empty p.imageUrl}">
                                            <img src="${p.imageUrl.startsWith('http') ? p.imageUrl : pageContext.request.contextPath.concat('/').concat(p.imageUrl)}"
                                                 alt="${p.productName}"
                                                 class="product-img"
                                                 onerror="this.onerror=null;this.src='https://placehold.co/400x300?text=No+Image';">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="https://placehold.co/400x300?text=No+Image"
                                                 alt="${p.productName}"
                                                 class="product-img">
                                        </c:otherwise>
                                    </c:choose>
                                    <c:if test="${not empty p.categoryName}">
                                        <span class="position-absolute top-0 start-0 m-2 badge bg-dark bg-opacity-75">
                                            ${p.categoryName}
                                        </span>
                                    </c:if>
                                </div>

                                <div class="card-body d-flex flex-column p-3">
                                    <h6 class="product-name fw-bold text-dark mb-2" title="${p.productName}">
                                        ${p.productName}
                                    </h6>

                                    <div class="mt-auto mb-3">
                                        <div class="product-price">
                                            <fmt:formatNumber value="${p.price}" type="number" groupingUsed="true" maxFractionDigits="0" /> ₫
                                        </div>
                                        <div class="small ${p.stockQuantity > 0 ? 'text-muted' : 'text-danger fw-semibold'}">
                                            <c:choose>
                                                <c:when test="${p.stockQuantity > 0}">
                                                    Còn ${p.stockQuantity} sản phẩm
                                                </c:when>
                                                <c:otherwise>
                                                    Hết hàng
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>

                                    <form action="${pageContext.request.contextPath}/cart" method="post">
                                        <input type="hidden" name="action" value="add">
                                        <input type="hidden" name="productId" value="${p.productId}">
                                        <input type="hidden" name="quantity" value="1">
                                        <button type="submit"
                                                class="btn ${p.stockQuantity > 0 ? 'btn-dark' : 'btn-outline-secondary'} w-100"
                                                ${p.stockQuantity <= 0 ? 'disabled' : ''}>
                                            <c:choose>
                                                <c:when test="${p.stockQuantity > 0}">
                                                    <i class="bi bi-cart-plus"></i> Thêm vào giỏ hàng
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="bi bi-x-circle"></i> Tạm hết hàng
                                                </c:otherwise>
                                            </c:choose>
                                        </button>
                                    </form>
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
