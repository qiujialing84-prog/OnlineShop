<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String contextPath = request.getContextPath();
    // 检查是否为管理员
    boolean isAdmin = false;
    Object customerObj = session.getAttribute("customer");
    if (customerObj != null) {
        com.onlineshop.model.Customer customer = (com.onlineshop.model.Customer) customerObj;
        isAdmin = "admin".equals(customer.getUsername()) || customer.getEmail().endsWith("@admin.com");
    }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>在线购物网站</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .hero-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 100px 0;
            text-align: center;
        }
        .feature-icon {
            font-size: 3rem;
            color: #667eea;
            margin-bottom: 1rem;
        }
        .navbar-brand {
            font-weight: bold;
            font-size: 1.5rem;
        }
        .product-card {
            transition: transform 0.3s;
            margin-bottom: 20px;
        }
        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        .product-img {
            height: 200px;
            object-fit: cover;
        }
        .quick-links {
            background-color: #f8f9fa;
            border-radius: 10px;
            padding: 30px;
            margin-top: 30px;
        }
        .link-card {
            text-align: center;
            padding: 20px;
            border: 1px solid #dee2e6;
            border-radius: 10px;
            margin-bottom: 15px;
            transition: all 0.3s;
            text-decoration: none !important;
            color: #495057;
            display: block;
        }
        .link-card:hover {
            background-color: #007bff;
            color: white;
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0,123,255,0.3);
        }
        .link-icon {
            font-size: 2.5rem;
            margin-bottom: 10px;
            display: block;
        }
        .admin-badge {
            background-color: #dc3545;
            color: white;
            padding: 2px 8px;
            border-radius: 10px;
            font-size: 0.7rem;
            margin-left: 5px;
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
                        <a class="nav-link active" href="<%=contextPath%>/">首页</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%=contextPath%>/products">商品列表</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%=contextPath%>/cart?action=view">购物车</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%=contextPath%>/orders">我的订单</a>
                    </li>
                    <%-- 检查是否是管理员 --%>
                                <c:set var="isAdmin"
                                       value="${sessionScope.customer.username == 'admin'}" />
                                <c:if test="${isAdmin}">
                                    <li class="nav-item">
                                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">后台管理</a>
                                    </li>
                                </c:if>
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
                            <li class="nav-item">
                                <a class="nav-link" href="<%=contextPath%>/register">注册</a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </nav>

    <!-- 英雄区域 -->
    <section class="hero-section">
        <div class="container">
            <h1 class="display-4 fw-bold mb-4">欢迎来到在线购物网站</h1>
            <p class="lead mb-4">发现优质商品，享受便捷购物体验</p>
            <a href="<%=contextPath%>/products" class="btn btn-light btn-lg px-4 py-2 me-3">开始购物 →</a>
            <a href="<%=contextPath%>/products" class="btn btn-outline-light btn-lg px-4 py-2">查看商品</a>
        </div>
    </section>

    <!-- 热门商品 -->
    <section class="py-5 bg-light">
        <div class="container">
            <h2 class="text-center mb-5">热门推荐</h2>
            <div class="row">
                <div class="col-md-4">
                    <div class="card product-card">
                        <img src="<%=contextPath%>/images/iphone17.png"
                             class="card-img-top product-img" alt="iPhone 17">
                        <div class="card-body">
                            <h5 class="card-title">iPhone 17</h5>
                            <p class="card-text">苹果最新款智能手机</p>
                            <p class="text-primary fw-bold h4">¥6999.00</p>
                            <a href="<%=contextPath%>/products" class="btn btn-primary">查看详情</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card product-card">
                        <img src="<%=contextPath%>/images/macbook.jpg"
                             class="card-img-top product-img" alt="MacBook Pro">
                        <div class="card-body">
                            <h5 class="card-title">MacBook Pro</h5>
                            <p class="card-text">苹果专业笔记本电脑，M2 Pro芯片</p>
                            <p class="text-primary fw-bold h4">¥12999.00</p>
                            <a href="<%=contextPath%>/products" class="btn btn-primary">查看详情</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card product-card">
                        <img src="<%=contextPath%>/images/airpods.jpg"
                             class="card-img-top product-img" alt="AirPods Pro">
                        <div class="card-body">
                            <h5 class="card-title">AirPods Pro</h5>
                            <p class="card-text">无线降噪耳机，空间音频技术</p>
                            <p class="text-primary fw-bold h4">¥1999.00</p>
                            <a href="<%=contextPath%>/products" class="btn btn-primary">查看详情</a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="text-center mt-4">
                <a href="<%=contextPath%>/products" class="btn btn-outline-primary btn-lg">浏览更多商品 →</a>
            </div>
        </div>
    </section>

    <!-- 快速链接 -->
    <section class="py-5">
        <div class="container">
            <h2 class="text-center mb-5">网站功能导航</h2>
            <div class="quick-links">
                <div class="row">
                    <div class="col-md-3 col-sm-6">
                        <a href="<%=contextPath%>/products" class="link-card">
                            <h5>商品购物</h5>
                            <p class="small mb-0">浏览和购买商品</p>
                        </a>
                    </div>
                    <div class="col-md-3 col-sm-6">
                        <a href="<%=contextPath%>/cart?action=view" class="link-card">
                            <h5>我的购物车</h5>
                            <p class="small mb-0">查看和管理购物车</p>
                        </a>
                    </div>
                    <div class="col-md-3 col-sm-6">
                        <a href="<%=contextPath%>/orders" class="link-card">
                            <h5>订单管理</h5>
                            <p class="small mb-0">查看历史订单</p>
                        </a>
                    </div>
                    <div class="col-md-3 col-sm-6">
                        <% if (isAdmin) { %>
                            <a href="<%=contextPath%>/admin/dashboard" class="link-card">
                                <h5>后台管理</h5>
                                <span class="admin-badge">Admin</span>
                                <p class="small mb-0">商品和订单管理</p>
                            </a>
                        <% } else { %>
                            <a href="<%=contextPath%>/login" class="link-card">
                                <h5>用户登录</h5>
                                <p class="small mb-0">登录您的账户</p>
                            </a>
                        <% } %>
                    </div>
                </div>

                <!-- 功能说明 -->
                <div class="row mt-5">
                    <div class="col-md-6">
                        <div class="alert alert-info">
                            <h6><i class="bi bi-info-circle me-2"></i>购物流程</h6>
                            <p class="small mb-0">
                                1. 浏览商品 → 2. 加入购物车 → 3. 结算付款 → 4. 查看订单 → 5. 确认收货
                            </p>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <% if (!isAdmin && customerObj != null) { %>
                            <div class="alert alert-warning">
                                <h6><i class="bi bi-shield-check me-2"></i>您的账户</h6>
                                <p class="small mb-0">
                                    当前登录用户：${sessionScope.customer.username}<br>
                                    您可以：<a href="<%=contextPath%>/cart?action=view">查看购物车</a> |
                                    <a href="<%=contextPath%>/orders">查看订单</a>
                                </p>
                            </div>
                        <% } else if (isAdmin) { %>
                            <div class="alert alert-danger">
                                <h6><i class="bi bi-star me-2"></i>管理员特权</h6>
                                <p class="small mb-0">
                                    您拥有管理员权限，可以管理商品、处理订单、查看统计报表等。
                                </p>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- 页脚 -->
    <footer class="bg-dark text-white py-4">
        <div class="container">
            <div class="row">
                <div class="col-md-6">
                    <h5>OnlineShop 在线购物网站</h5>
                    <p class="text-white-50">专业的在线购物平台，为您提供优质的商品和服务。</p>
                </div>
                <div class="col-md-3">
                    <h5>网站导航</h5>
                    <ul class="list-unstyled">
                        <li><a href="<%=contextPath%>/" class="text-white-50 text-decoration-none">首页</a></li>
                        <li><a href="<%=contextPath%>/products" class="text-white-50 text-decoration-none">商品列表</a></li>
                        <li><a href="<%=contextPath%>/cart?action=view" class="text-white-50 text-decoration-none">购物车</a></li>
                        <li><a href="<%=contextPath%>/orders" class="text-white-50 text-decoration-none">我的订单</a></li>
                        <% if (isAdmin) { %>
                            <li><a href="<%=contextPath%>/admin/dashboard" class="text-white-50 text-decoration-none">后台管理</a></li>
                        <% } %>
                    </ul>
                </div>
                <div class="col-md-3">
                    <h5>联系我们</h5>
                    <ul class="list-unstyled">
                        <li class="text-white-50">电话: 123456</li>
                        <li class="text-white-50">地址: 广州市番禺区</li>
                    </ul>
                </div>
            </div>
            <hr class="bg-light">
            <div class="text-center">
                <p class="text-white-50 mb-0">
                    &copy; 2025 OnlineShop 在线购物网站.
                    <span class="text-info">Java Web实验项目</span>
                </p>
            </div>
        </div>
    </footer>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // 页面加载完成后的初始化
        document.addEventListener('DOMContentLoaded', function() {
            console.log('OnlineShop 网站加载完成');
            console.log('当前路径: <%=contextPath%>');

            // 检查登录状态
            const isLoggedIn = <%=customerObj != null%>;
            if (isLoggedIn) {
                console.log('用户已登录: ${sessionScope.customer.username}');
                console.log('是否为管理员: <%=isAdmin%>');
            } else {
                console.log('用户未登录');
            }
        });
    </script>
</body>
</html>