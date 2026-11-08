<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Sản phẩm - Admin</title>
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
                    Quản lý Sản phẩm
                    <span class="badge-category ms-1">${products.size()} mặt hàng</span>
                </h1>
                <p class="page-subtitle">Tìm kiếm, lọc theo danh mục và cập nhật thông tin sản phẩm trong kho</p>
            </div>
            <a href="${pageContext.request.contextPath}/admin/products/add" class="btn btn-primary">
                <i class="bi bi-plus-lg"></i> Thêm mới sản phẩm
            </a>
        </div>

        <!-- Alert thong bao -->
        <c:if test="${not empty param.msg}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <c:choose>
                    <c:when test="${param.msg == 'added'}">Thêm sản phẩm mới thành công!</c:when>
                    <c:when test="${param.msg == 'updated'}">Cập nhật thông tin sản phẩm thành công!</c:when>
                    <c:when test="${param.msg == 'deleted'}">Đã xóa / ngừng kinh doanh sản phẩm thành công!</c:when>
                    <c:when test="${param.msg == 'notfound'}">Không tìm thấy sản phẩm yêu cầu!</c:when>
                    <c:otherwise>Thao tác thành công!</c:otherwise>
                </c:choose>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <!-- Thanh tim kiem va loc -->
        <div class="card mb-4">
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/admin/products" method="get" class="row g-3 align-items-end">
                    <div class="col-md-5">
                        <label for="keyword" class="form-label fw-semibold small text-muted">Từ khóa tên sản phẩm</label>
                        <input type="text" class="form-control" id="keyword" name="keyword"
                               value="${keyword}" placeholder="Nhập tên sản phẩm cần tìm...">
                    </div>
                    <div class="col-md-4">
                        <label for="categoryId" class="form-label fw-semibold small text-muted">Danh mục</label>
                        <select class="form-select" id="categoryId" name="categoryId">
                            <option value="0">-- Tất cả danh mục --</option>
                            <c:forEach var="cat" items="${categories}">
                                <option value="${cat.categoryId}" ${selectedCatId == cat.categoryId ? 'selected' : ''}>
                                    ${cat.categoryName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-3 d-flex gap-2">
                        <button type="submit" class="btn btn-primary flex-grow-1">
                            <i class="bi bi-search me-1"></i>Tìm kiếm
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-outline-secondary" title="Đặt lại">
                            <i class="bi bi-arrow-counterclockwise"></i>
                        </a>
                    </div>
                </form>
            </div>
        </div>

        <!-- Bang danh sach san pham -->
        <div class="card">
            <div class="card-body p-0">
                <div class="table-responsive border-0 shadow-none">
                    <table class="table table-hover align-middle mb-0">
                        <thead>
                            <tr>
                                <th class="ps-3">ID</th>
                                <th>Ảnh</th>
                                <th>Tên sản phẩm</th>
                                <th>Danh mục</th>
                                <th class="text-end">Đơn giá</th>
                                <th class="text-center">Tồn kho</th>
                                <th class="text-center">Trạng thái</th>
                                <th class="text-center pe-3">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty products}">
                                    <tr>
                                        <td colspan="8" class="text-center py-4 text-muted">
                                            Không tìm thấy sản phẩm nào phù hợp.
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="p" items="${products}">
                                        <tr>
                                            <td class="ps-3 fw-semibold">#${p.productId}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty p.imageUrl}">
                                                        <img src="${p.imageUrl.startsWith('http') ? p.imageUrl : pageContext.request.contextPath.concat('/').concat(p.imageUrl)}"
                                                             alt="${p.productName}"
                                                             class="product-thumb"
                                                             onerror="this.onerror=null;this.src='https://placehold.co/45x45?text=No+Img';">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="https://placehold.co/45x45?text=No+Img"
                                                             alt="No Image"
                                                             class="product-thumb">
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="fw-semibold text-dark">${p.productName}</div>
                                                <c:if test="${not empty p.description}">
                                                    <div class="small text-muted text-truncate" style="max-width: 260px;">
                                                        ${p.description}
                                                    </div>
                                                </c:if>
                                            </td>
                                            <td>
                                                <span class="badge-category">${p.categoryName}</span>
                                            </td>
                                            <td class="text-end fw-bold text-dark">
                                                <fmt:formatNumber value="${p.price}" type="number" groupingUsed="true" maxFractionDigits="0" /> ₫
                                            </td>
                                            <td class="text-center">
                                                <span class="fw-semibold ${p.stockQuantity == 0 ? 'text-danger' : 'text-dark'}">
                                                    ${p.stockQuantity}
                                                </span>
                                            </td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${p.status}">
                                                        <span class="badge-completed">Còn bán</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge-cancelled">Ngừng bán</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center pe-3">
                                                <a href="${pageContext.request.contextPath}/admin/products/edit?id=${p.productId}"
                                                   class="btn-icon btn-icon-edit me-1" title="Sửa">
                                                    <i class="bi bi-pencil-square"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/admin/products/delete?id=${p.productId}"
                                                   class="btn-icon btn-icon-delete" title="Xóa"
                                                   onclick="return confirm('Bạn có chắc muốn xóa?');">
                                                    <i class="bi bi-trash3"></i>
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
