<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<nav class="navbar navbar-expand-lg app-navbar mb-4">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/admin/dashboard">
            <span class="brand-icon brand-admin"><i class="bi bi-layers-fill"></i></span>
            <span>Admin Portal</span>
            <span class="admin-tag">Workspace</span>
        </a>
        <button class="navbar-toggler border-0 shadow-none" type="button" data-bs-toggle="collapse"
                data-bs-target="#adminNavbar" aria-controls="adminNavbar" aria-expanded="false"
                aria-label="Toggle navigation">
            <i class="bi bi-list fs-2"></i>
        </button>

        <div class="collapse navbar-collapse" id="adminNavbar">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-lg-3 gap-1">
                <li class="nav-item">
                    <a class="nav-link ${pageContext.request.requestURI.contains('/dashboard') ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/admin/dashboard">
                        <i class="bi bi-speedometer2"></i>Tổng quan
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${pageContext.request.requestURI.contains('/product') ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/admin/products">
                        <i class="bi bi-box-seam"></i>Sản phẩm
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${pageContext.request.requestURI.contains('/order') ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/admin/orders">
                        <i class="bi bi-clipboard-check"></i>Đơn hàng
                    </a>
                </li>
            </ul>

            <div class="d-flex flex-wrap align-items-center gap-2 mt-2 mt-lg-0">
                <a class="btn btn-outline-secondary btn-sm" href="${pageContext.request.contextPath}/home">
                    <i class="bi bi-shop"></i>Xem Cửa hàng
                </a>
                <span class="d-none d-md-inline-flex align-items-center gap-2 small text-muted px-2">
                    <span class="user-avatar"><i class="bi bi-person-fill"></i></span>
                    <strong class="text-dark">${sessionScope.currentUser.fullName}</strong>
                </span>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm">
                    <i class="bi bi-box-arrow-right"></i>Đăng xuất
                </a>
            </div>
        </div>
    </div>
</nav>
