<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>商品列表 - OnlineShop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .navbar-brand {
            font-weight: bold;
            font-size: 1.5rem;
        }
        .product-card {
            transition: transform 0.3s;
            margin-bottom: 20px;
            height: 100%;
        }
        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        .product-img {
            height: 200px;
            object-fit: cover;
            width: 100%;
        }
        .card-body {
            display: flex;
            flex-direction: column;
        }
        .card-title {
            font-size: 1.1rem;
            font-weight: 600;
            height: 3rem;
            overflow: hidden;
        }
        .card-text {
            color: #666;
            font-size: 0.9rem;
            flex-grow: 1;
            overflow: hidden;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
        }
        .price {
            color: #e4393c;
            font-size: 1.2rem;
            font-weight: bold;
            margin: 10px 0;
        }
        .stock {
            color: #666;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>
    <!-- 导航栏 -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="<%=contextPath%>/">🛒 OnlineShop</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="<%=contextPath%>/">首页</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="<%=contextPath%>/products">商品列表</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%=contextPath%>/cart?action=view">购物车</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%=contextPath%>/orders">我的订单</a>
                    </li>
                </ul>
                <%-- 检查是否是管理员 --%>
                            <c:set var="isAdmin"
                                   value="${sessionScope.customer.username == 'admin'}" />
                            <c:if test="${isAdmin}">
                                <li class="nav-item">
                                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">后台管理</a>
                                </li>
                            </c:if>
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
                            <li class="nav-item">
                                <a class="nav-link" href="<%=contextPath%>/register">注册</a>
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
                <li class="breadcrumb-item active">商品列表</li>
            </ol>
        </nav>
    </div>

    <!-- 商品列表 -->
    <div class="container mt-4">
        <div class="row mb-4">
            <div class="col-md-6">
                <h2>商品列表</h2>
                <p class="text-muted">共 ${products.size()} 个商品</p>
            </div>
        </div>

        <!-- 商品展示 -->
        <div class="row">
            <c:choose>
                <c:when test="${not empty products}">
                    <c:forEach var="product" items="${products}">
                        <div class="col-md-4 col-sm-6 mb-4">
                            <div class="card product-card h-100">
                                <img src="<%=contextPath%>/${product.imageUrl}"
                                     class="card-img-top product-img"
                                     alt="${product.name}"
                                     onerror="this.src='https://via.placeholder.com/300x200?text=商品图片'">
                                <div class="card-body">
                                    <h5 class="card-title">${product.name}</h5>
                                    <p class="card-text">${product.description}</p>

                                    <div class="mt-auto">
                                        <div class="price">¥ ${product.price}</div>
                                        <div class="stock mb-3">
                                            库存: ${product.stockQuantity}件 |
                                            分类: ${product.category}
                                        </div>

                                        <div class="d-grid gap-2">
                                            <c:choose>
                                                <c:when test="${not empty sessionScope.customer}">
                                                    <button class="btn btn-primary add-to-cart"
                                                            data-product-id="${product.id}">
                                                        加入购物车
                                                    </button>
                                                    <button class="btn btn-outline-primary">查看详情</button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button class="btn btn-primary"
                                                            onclick="window.location.href='<%=contextPath%>/login'">
                                                        登录后购买
                                                    </button>
                                                    <button class="btn btn-outline-primary">查看详情</button>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="col-12">
                        <div class="alert alert-warning text-center py-5">
                            <h4 class="mb-3">😢 暂无商品</h4>
                            <p class="mb-0">管理员正在上架商品，请稍后再来...</p>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- 页脚 -->
    <footer class="bg-dark text-white py-4 mt-5">
        <div class="container">
            <div class="row">
                <div class="col-md-6">
                    <h5>OnlineShop 在线购物网站</h5>
                    <p class="text-white-50">专业的在线购物平台，为您提供优质的商品和服务。</p>
                </div>
                <div class="col-md-3">
                    <h5>快速链接</h5>
                    <ul class="list-unstyled">
                        <li><a href="<%=contextPath%>/" class="text-white-50 text-decoration-none">首页</a></li>
                        <li><a href="<%=contextPath%>/products" class="text-white-50 text-decoration-none">商品列表</a></li>
                    </ul>
                </div>
                <div class="col-md-3">
                    <h5>联系我们</h5>
                    <ul class="list-unstyled">
                        <li class="text-white-50">电话: 123456789</li>
                        <li class="text-white-50">邮箱: 123456@qq.com</li>
                    </ul>
                </div>
            </div>
            <hr class="bg-light">
            <div class="text-center">
                <p class="text-white-50 mb-0">&copy; 2025 OnlineShop 在线购物网站</p>
            </div>
        </div>
    </footer>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // 加入购物车功能
        document.querySelectorAll('.add-to-cart').forEach(button => {
            button.addEventListener('click', function() {
                const productId = this.getAttribute('data-product-id');

                fetch('<%=contextPath%>/cart?action=add&productId=' + productId + '&quantity=1', {
                    method: 'POST'
                })
                .then(response => {
                    if (response.ok) {
                        alert('商品已加入购物车！');
                    } else {
                        alert('加入购物车失败，请稍后重试');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('网络错误，请检查连接');
                });
            });
        });
    </script>
</body>
</html>