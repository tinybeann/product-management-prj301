<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<nav class="navbar navbar-expand-lg app-navbar mb-4">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/home">
            <span class="brand-icon"><i class="bi bi-bag-check-fill"></i></span>
            <span>Product Store</span>
        </a>

        <button class="navbar-toggler border-0 shadow-none" type="button" data-bs-toggle="collapse"
                data-bs-target="#clientNavbar" aria-controls="clientNavbar" aria-expanded="false"
                aria-label="Toggle navigation">
            <i class="bi bi-list fs-2"></i>
        </button>

        <div class="collapse navbar-collapse" id="clientNavbar">
            <ul class="navbar-nav me-3 mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link ${pageContext.request.requestURI.contains('/home') ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/home">
                        <i class="bi bi-grid"></i>Trang chủ
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${pageContext.request.requestURI.contains('/order') ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/orders">
                        <i class="bi bi-receipt"></i>Đơn hàng của tôi
                    </a>
                </li>
            </ul>

            <!-- Ô tìm kiếm sản phẩm -->
            <form class="search-pill mx-lg-auto" action="${pageContext.request.contextPath}/home" method="get">
                <c:if test="${not empty selectedCategoryId and selectedCategoryId > 0}">
                    <input type="hidden" name="categoryId" value="${selectedCategoryId}">
                </c:if>
                <i class="bi bi-search search-icon"></i>
                <input class="form-control" type="search" name="keyword" value="${keyword}"
                       placeholder="Tìm kiếm tên sản phẩm..." aria-label="Search">
            </form>

            <!-- Giỏ hàng & Tài khoản -->
            <div class="d-flex align-items-center gap-2 ms-lg-3 mt-2 mt-lg-0">
                <a href="${pageContext.request.contextPath}/cart" class="cart-btn" title="Giỏ hàng">
                    <i class="bi bi-cart3"></i>
                    <span class="d-none d-sm-inline">Giỏ hàng</span>
                    <span class="cart-badge">${not empty sessionScope.cart ? sessionScope.cart.totalQuantity : 0}</span>
                </a>

                <c:choose>
                    <c:when test="${not empty sessionScope.currentUser}">
                        <div class="dropdown">
                            <button class="btn btn-outline-secondary dropdown-toggle d-flex align-items-center gap-2" type="button"
                                    data-bs-toggle="dropdown" aria-expanded="false">
                                <span class="user-avatar"><i class="bi bi-person-fill"></i></span>
                                <span class="text-truncate" style="max-width: 140px;">${sessionScope.currentUser.fullName}</span>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <c:if test="${sessionScope.currentUser.roleId == 1 or sessionScope.currentUser.roleName == 'ADMIN'}">
                                    <li>
                                        <a class="dropdown-item fw-semibold text-primary"
                                           href="${pageContext.request.contextPath}/admin/dashboard">
                                            <i class="bi bi-speedometer2 me-2"></i>Quản trị Admin
                                        </a>
                                    </li>
                                    <li><hr class="dropdown-divider"></li>
                                </c:if>
                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/orders">
                                        <i class="bi bi-receipt me-2"></i>Đơn hàng của tôi
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/cart">
                                        <i class="bi bi-cart3 me-2"></i>Giỏ hàng (${not empty sessionScope.cart ? sessionScope.cart.totalQuantity : 0})
                                    </a>
                                </li>
                                <li><hr class="dropdown-divider"></li>
                                <li>
                                    <a class="dropdown-item text-danger fw-semibold"
                                       href="${pageContext.request.contextPath}/logout">
                                        <i class="bi bi-box-arrow-right me-2"></i>Đăng xuất
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-secondary">
                            Đăng nhập
                        </a>
                        <a href="${pageContext.request.contextPath}/register" class="btn btn-dark">
                            Đăng ký
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</nav>
