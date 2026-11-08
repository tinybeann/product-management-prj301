<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${isEdit ? 'Chỉnh sửa sản phẩm' : 'Thêm sản phẩm mới'} - Admin Portal</title>
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
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="page-header">
                    <div>
                        <h1 class="page-title">${isEdit ? 'Chỉnh sửa sản phẩm' : 'Thêm sản phẩm mới'}</h1>
                        <p class="page-subtitle">Điền đầy đủ thông tin sản phẩm bên dưới để lưu vào hệ thống</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-outline-secondary">
                        <i class="bi bi-arrow-left"></i> Quay lại
                    </a>
                </div>

                <div class="card">
                    <div class="card-body p-4">
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger py-2" role="alert">
                                <i class="bi bi-exclamation-circle me-1"></i>${error}
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/admin/products/${isEdit ? 'edit' : 'add'}" method="post">
                            <c:if test="${isEdit}">
                                <input type="hidden" name="productId" value="${product.productId}">
                            </c:if>

                            <div class="row">
                                <div class="col-md-8 mb-3">
                                    <label for="productName" class="form-label">
                                        Tên sản phẩm <span class="text-danger">*</span>
                                    </label>
                                    <input type="text" class="form-control" id="productName" name="productName"
                                           value="${product.productName}" placeholder="Nhập tên sản phẩm" required>
                                </div>

                                <div class="col-md-4 mb-3">
                                    <label for="categoryId" class="form-label">
                                        Danh mục <span class="text-danger">*</span>
                                    </label>
                                    <select class="form-select" id="categoryId" name="categoryId" required>
                                        <option value="">-- Chọn danh mục --</option>
                                        <c:forEach var="cat" items="${categories}">
                                            <option value="${cat.categoryId}" ${product.categoryId == cat.categoryId ? 'selected' : ''}>
                                                ${cat.categoryName}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-4 mb-3">
                                    <label for="price" class="form-label">
                                        Đơn giá (VNĐ) <span class="text-danger">*</span>
                                    </label>
                                    <input type="number" step="0.01" min="0.01" class="form-control" id="price" name="price"
                                           value="${product.price}" placeholder="Ví dụ: 19990000" required>
                                </div>

                                <div class="col-md-4 mb-3">
                                    <label for="stockQuantity" class="form-label">
                                        Số lượng tồn kho <span class="text-danger">*</span>
                                    </label>
                                    <input type="number" min="0" class="form-control" id="stockQuantity" name="stockQuantity"
                                           value="${not empty product ? product.stockQuantity : 0}" required>
                                </div>

                                <div class="col-md-4 mb-3">
                                    <label for="status" class="form-label">Trạng thái</label>
                                    <select class="form-select" id="status" name="status">
                                        <option value="1" ${empty product or product.status ? 'selected' : ''}>Còn bán</option>
                                        <option value="0" ${not empty product and not product.status ? 'selected' : ''}>Ngừng bán</option>
                                    </select>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="imageUrl" class="form-label">Link ảnh (imageUrl)</label>
                                <input type="text" class="form-control" id="imageUrl" name="imageUrl"
                                       value="${product.imageUrl}" placeholder="Ví dụ: images/iphone15.jpg hoặc https://...">
                            </div>

                            <div class="mb-4">
                                <label for="description" class="form-label">Mô tả chi tiết</label>
                                <textarea class="form-control" id="description" name="description" rows="4"
                                          placeholder="Nhập mô tả chi tiết sản phẩm...">${product.description}</textarea>
                            </div>

                            <div class="d-flex justify-content-end gap-2 pt-2 border-top">
                                <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-outline-secondary">
                                    Hủy bỏ
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-check-lg"></i> Lưu sản phẩm
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
