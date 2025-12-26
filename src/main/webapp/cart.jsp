<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String contextPath = request.getContextPath();
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>我的购物车 - OnlineShop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .navbar-brand { font-weight: bold; font-size: 1.5rem; }
        .cart-header { background-color: #f8f9fa; border-radius: 10px; padding: 20px; margin-bottom: 30px; }
        .cart-item { border: 1px solid #dee2e6; border-radius: 10px; padding: 20px; margin-bottom: 20px; }
        .cart-item-img { width: 120px; height: 120px; object-fit: cover; border-radius: 8px; }
        .product-title { font-size: 1.1rem; font-weight: 600; margin-bottom: 5px; }
        .product-price { color: #e4393c; font-size: 1.2rem; font-weight: bold; }
        .quantity-input { width: 70px; text-align: center; }
        .subtotal { font-size: 1.1rem; font-weight: 600; }
        .cart-summary { background-color: #f8f9fa; border-radius: 10px; padding: 25px; }
        .summary-title { font-size: 1.2rem; font-weight: 600; margin-bottom: 20px; }
        .summary-item { display: flex; justify-content: space-between; margin-bottom: 10px; }
        .summary-total { font-size: 1.3rem; font-weight: bold; color: #e4393c; border-top: 2px solid #dee2e6; padding-top: 15px; margin-top: 15px; }
        .empty-cart { text-align: center; padding: 60px 20px; }
        .empty-cart-icon { font-size: 4rem; color: #6c757d; margin-bottom: 20px; }
    </style>
</head>
<body>
    <!-- 导航栏 -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="<%=contextPath%>/">OnlineShop</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="<%=contextPath%>/">首页</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%=contextPath%>/products">商品列表</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="<%=contextPath%>/cart?action=view">购物车</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%=contextPath%>/orders">我的订单</a>
                    </li>
                </ul>
                <ul class="navbar-nav">
                    <c:choose>
                        <c:when test="${not empty sessionScope.customer}">
                            <li class="nav-item">
                                <span class="navbar-text me-3">欢迎，${sessionScope.customer.username}</span>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="<%=contextPath%>/logout">退出</a>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="nav-item">
                                <a class="nav-link" href="<%=contextPath%>/login">登录</a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </nav>

    <!-- 面包屑导航 -->
    <div class="container mt-3">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="<%=contextPath%>/">首页</a></li>
                <li class="breadcrumb-item active">我的购物车</li>
            </ol>
        </nav>
    </div>

    <!-- 主内容 -->
    <div class="container my-4">
        <div class="cart-header">
            <h2 class="mb-0">我的购物车</h2>
            <p class="text-muted mb-0">共 ${itemCount} 件商品</p>
        </div>

        <%-- 错误信息 --%>
        <% if (error != null) { %>
            <div class="alert alert-warning alert-dismissible fade show" role="alert">
                <%= error %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="row">
            <!-- 购物车商品列表 -->
            <div class="col-lg-8">
                <c:choose>
                    <c:when test="${not empty cartItems and itemCount > 0}">
                        <c:forEach var="item" items="${cartItems}">
                            <div class="cart-item">
                                <div class="row align-items-center">
                                    <!-- 商品图片 -->
                                    <div class="col-md-2 col-4">
                                        <img src="<%=contextPath%>/${product.imageUrl}"
                                             class="cart-item-img"
                                             alt="${item.product.name}"
                                             onerror="this.src='https://via.placeholder.com/120x120?text=商品'">
                                    </div>

                                    <!-- 商品信息 -->
                                    <div class="col-md-4 col-8">
                                        <h5 class="product-title">${item.product.name}</h5>
                                        <p class="text-muted small mb-2">${item.product.description}</p>
                                        <p class="product-price mb-0">¥ ${item.product.price}</p>
                                        <p class="text-muted small mb-0">库存: ${item.product.stockQuantity}件</p>
                                    </div>

                                    <!-- 数量控制 -->
                                    <div class="col-md-3 col-6 mt-3 mt-md-0">
                                        <div class="input-group">
                                            <button class="btn btn-outline-secondary"
                                                    onclick="updateQuantity(${item.id}, ${item.quantity - 1})"
                                                    ${item.quantity <= 1 ? 'disabled' : ''}>-</button>
                                            <input type="text" class="form-control quantity-input"
                                                   value="${item.quantity}" readonly>
                                            <button class="btn btn-outline-secondary"
                                                    onclick="updateQuantity(${item.id}, ${item.quantity + 1})"
                                                    ${item.quantity >= item.product.stockQuantity ? 'disabled' : ''}>+</button>
                                        </div>
                                        <div class="mt-2">
                                            <button class="btn btn-link text-danger btn-sm p-0"
                                                    onclick="removeItem(${item.id})">
                                                删除
                                            </button>
                                        </div>
                                    </div>

                                    <!-- 小计 -->
                                    <div class="col-md-3 col-6 mt-3 mt-md-0 text-end">
                                        <p class="subtotal">¥ <span id="subtotal-${item.id}">${item.subtotal}</span></p>
                                        <p class="text-muted small">单价: ¥ ${item.product.price}</p>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-cart">
                            <div class="empty-cart-icon">🛒</div>
                            <h3 class="mb-3">购物车空空如也</h3>
                            <p class="text-muted mb-4">快去添加一些商品吧！</p>
                            <a href="<%=contextPath%>/products" class="btn btn-primary btn-lg">去购物</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- 购物车汇总 -->
            <c:if test="${not empty cartItems and itemCount > 0}">
                <div class="col-lg-4">
                    <div class="cart-summary sticky-top" style="top: 20px;">
                        <h5 class="summary-title">订单汇总</h5>

                        <div class="summary-item">
                            <span>商品件数</span>
                            <span>${itemCount} 件</span>
                        </div>

                        <div class="summary-item">
                            <span>商品总价</span>
                            <span>¥ ${cartTotal}</span>
                        </div>

                        <div class="summary-item">
                            <span>运费</span>
                            <span>¥ 0.00</span>
                        </div>

                        <div class="summary-item">
                            <span>优惠</span>
                            <span>- ¥ 0.00</span>
                        </div>

                        <div class="summary-total">
                            <span>应付总额</span>
                            <span>¥ ${cartTotal}</span>
                        </div>

                        <div class="d-grid mt-4">
                            <a href="<%=contextPath%>/cart?action=checkout"
                               class="btn btn-primary btn-lg">去结算</a>
                        </div>

                        <div class="text-center mt-3">
                            <a href="<%=contextPath%>/products" class="text-decoration-none">继续购物</a>
                        </div>
                    </div>
                </div>
            </c:if>
        </div>
    </div>

    <!-- 页脚 -->
    <footer class="bg-dark text-white py-4 mt-5">
        <div class="container">
            <div class="text-center">
                <p class="text-white-50 mb-0">&copy; 2025 OnlineShop 在线购物网站. 实验项目，仅供学习使用。</p>
            </div>
        </div>
    </footer>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // 更新购物车数量
        function updateQuantity(cartId, newQuantity) {
            if (newQuantity < 1) return;

            fetch('<%=contextPath%>/cart', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'action=update&cartId=' + cartId + '&quantity=' + newQuantity
            })
            .then(response => {
                if (response.ok) {
                    location.reload();
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('更新失败，请稍后重试');
            });
        }

        // 删除购物车商品
        function removeItem(cartId) {
            if (confirm('确定要删除这个商品吗？')) {
                fetch('<%=contextPath%>/cart', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'action=remove&cartId=' + cartId
                })
                .then(response => {
                    if (response.ok) {
                        location.reload();
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('删除失败，请稍后重试');
                });
            }
        }

        // 初始化页面
        document.addEventListener('DOMContentLoaded', function() {
            // 更新所有商品的小计显示（格式化两位小数）
            document.querySelectorAll('[id^="subtotal-"]').forEach(element => {
                const subtotal = parseFloat(element.textContent);
                element.textContent = subtotal.toFixed(2);
            });
        });
    </script>
</body>
</html>