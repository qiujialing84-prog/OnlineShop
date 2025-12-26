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
    <title>订单详情 - OnlineShop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .order-detail-container { max-width: 800px; margin: 0 auto; }
        .order-header { background-color: #f8f9fa; border-radius: 10px; padding: 25px; margin-bottom: 30px; }
        .order-info-item { margin-bottom: 10px; }
        .info-label { font-weight: 600; color: #495057; min-width: 100px; }
        .info-value { color: #212529; }
        .order-items { margin-bottom: 30px; }
        .order-item { border: 1px solid #dee2e6; border-radius: 8px; padding: 15px; margin-bottom: 15px; }
        .item-img { width: 80px; height: 80px; object-fit: cover; border-radius: 6px; }
        .item-title { font-weight: 600; }
        .item-price { color: #e4393c; font-weight: bold; }
        .order-summary { background-color: #f8f9fa; border-radius: 10px; padding: 25px; }
        .summary-row { display: flex; justify-content: space-between; margin-bottom: 10px; }
        .summary-total { font-size: 1.3rem; font-weight: bold; color: #e4393c; border-top: 2px solid #dee2e6; padding-top: 15px; margin-top: 15px; }
        .status-badge { padding: 6px 12px; border-radius: 20px; font-size: 0.875rem; font-weight: 500; }
        .status-pending { background-color: #fff3cd; color: #856404; }
        .status-paid { background-color: #d1ecf1; color: #0c5460; }
        .status-shipped { background-color: #d4edda; color: #155724; }
        .status-delivered { background-color: #c3e6cb; color: #155724; }
        .status-cancelled { background-color: #f8d7da; color: #721c24; }
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
                        <a class="nav-link" href="<%=contextPath%>/products">商品列表</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%=contextPath%>/cart?action=view">购物车</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="<%=contextPath%>/orders">我的订单</a>
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
                <li class="breadcrumb-item"><a href="<%=contextPath%>/orders">我的订单</a></li>
                <li class="breadcrumb-item active">订单详情</li>
            </ol>
        </nav>
    </div>

    <!-- 订单详情 -->
    <div class="container my-4">
        <div class="order-detail-container">
            <!-- 订单头部信息 -->
            <div class="order-header">
                <div class="d-flex justify-content-between align-items-start mb-4">
                    <div>
                        <h3 class="mb-2">订单号: #${order.id}</h3>
                        <p class="text-muted mb-0">下单时间: ${order.orderDate}</p>
                    </div>
                    <div>
                        <span class="status-badge status-${order.status}">${order.statusText}</span>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <div class="order-info-item">
                            <span class="info-label">客户姓名:</span>
                            <span class="info-value">${order.customer.username}</span>
                        </div>
                        <div class="order-info-item">
                            <span class="info-label">客户邮箱:</span>
                            <span class="info-value">${order.customer.email}</span>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="order-info-item">
                            <span class="info-label">收货地址:</span>
                            <span class="info-value">${order.shippingAddress}</span>
                        </div>
                        <div class="order-info-item">
                            <span class="info-label">支付方式:</span>
                            <span class="info-value">${order.paymentMethod}</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 订单商品 -->
            <div class="order-items">
                <h5 class="mb-3">商品清单</h5>

                <c:forEach var="item" items="${orderItems}">
                    <div class="order-item">
                        <div class="row align-items-center">
                            <div class="col-md-2 col-4">
                                <img src="${item.product.imageUrl}"
                                     class="item-img"
                                     alt="${item.product.name}"
                                     onerror="this.src='https://via.placeholder.com/80x80?text=商品'">
                            </div>
                            <div class="col-md-6 col-8">
                                <div class="item-title">${item.product.name}</div>
                                <p class="text-muted small mb-2">${item.product.description}</p>
                                <div class="text-muted small">
                                    单价: ¥ ${item.unitPrice} × 数量: ${item.quantity}
                                </div>
                            </div>
                            <div class="col-md-4 col-12 text-end mt-3 mt-md-0">
                                <div class="item-price">小计: ¥ ${item.subtotal}</div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- 订单汇总 -->
            <div class="order-summary">
                <h5 class="mb-4">订单汇总</h5>

                <div class="summary-row">
                    <span>商品总价:</span>
                    <span>¥ ${order.totalAmount}</span>
                </div>
                <div class="summary-row">
                    <span>运费:</span>
                    <span>¥ 0.00</span>
                </div>
                <div class="summary-row">
                    <span>优惠:</span>
                    <span>- ¥ 0.00</span>
                </div>

                <div class="summary-total">
                    <span>实付金额:</span>
                    <span>¥ ${order.totalAmount}</span>
                </div>
            </div>

            <!-- 操作按钮 -->
            <div class="d-flex justify-content-between mt-4">
                <a href="<%=contextPath%>/orders" class="btn btn-outline-secondary">
                    返回订单列表
                </a>
            </div>
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
        // 格式化日期和金额
        document.addEventListener('DOMContentLoaded', function() {
            // 格式化金额
            document.querySelectorAll('.item-price, .summary-row span:last-child, .summary-total span:last-child').forEach(element => {
                if (element.textContent.includes('¥')) {
                    const amount = parseFloat(element.textContent.replace(/[^0-9.-]+/g, ''));
                    if (!isNaN(amount)) {
                        element.textContent = element.textContent.replace(/¥\s*\d+(\.\d+)?/, '¥ ' + amount.toFixed(2));
                    }
                }
            });

            // 格式化日期
            const dateElement = document.querySelector('.text-muted.mb-0');
            if (dateElement && dateElement.textContent.includes(':')) {
                const dateStr = dateElement.textContent.replace('下单时间: ', '');
                const date = new Date(dateStr);
                if (!isNaN(date.getTime())) {
                    const formattedDate = date.getFullYear() + '年' +
                                         (date.getMonth() + 1) + '月' +
                                         date.getDate() + '日 ' +
                                         date.getHours().toString().padStart(2, '0') + ':' +
                                         date.getMinutes().toString().padStart(2, '0');
                    dateElement.textContent = '下单时间: ' + formattedDate;
                }
            }
        });
    </script>
</body>
</html>