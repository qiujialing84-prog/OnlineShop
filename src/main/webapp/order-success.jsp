<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>订单提交成功 - OnlineShop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .navbar-brand { font-weight: bold; font-size: 1.5rem; }
        .success-container { max-width: 600px; margin: 80px auto; text-align: center; }
        .success-icon { font-size: 5rem; color: #28a745; margin-bottom: 20px; }
        .success-title { font-size: 2rem; font-weight: 600; margin-bottom: 15px; }
        .order-info { background-color: #f8f9fa; border-radius: 10px; padding: 25px; margin: 30px 0; }
        .info-item { display: flex; justify-content: space-between; margin-bottom: 10px; }
        .info-label { font-weight: 500; }
        .info-value { font-weight: 600; }
        .btn-group { margin-top: 30px; }
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

    <!-- 成功内容 -->
    <div class="success-container">
        <h1 class="success-title">订单提交成功！</h1>
        <p class="lead">感谢您的购买，我们会在24小时内处理您的订单。</p>

        <div class="order-info">
            <div class="info-item">
                <span class="info-label">订单编号：</span>
                <span class="info-value">#${orderId}</span>
            </div>
            <div class="info-item">
                <span class="info-label">支付金额：</span>
                <span class="info-value" style="color: #e4393c;">¥ ${totalAmount}</span>
            </div>
            <div class="info-item">
                <span class="info-label">订单状态：</span>
                <span class="info-value" style="color: #007bff;">待付款</span>
            </div>
            <div class="info-item">
                <span class="info-label">下单时间：</span>
                <span class="info-value">${pageContext.request.session.getAttribute("orderTime")}</span>
            </div>
        </div>

        <p class="text-muted">您可以在"我的订单"中查看订单详情和物流信息。</p>
        <p class="text-muted">如需帮助，请联系客服：400-123-4567</p>

        <div class="btn-group">
            <a href="<%=contextPath%>/orders" class="btn btn-primary btn-lg me-3">查看我的订单</a>
            <a href="<%=contextPath%>/products" class="btn btn-outline-primary btn-lg">继续购物</a>
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
        // 设置订单时间
        document.addEventListener('DOMContentLoaded', function() {
            const now = new Date();
            const orderTime = now.getFullYear() + '-' +
                             (now.getMonth() + 1).toString().padStart(2, '0') + '-' +
                             now.getDate().toString().padStart(2, '0') + ' ' +
                             now.getHours().toString().padStart(2, '0') + ':' +
                             now.getMinutes().toString().padStart(2, '0');

            // 更新页面显示
            const orderTimeElement = document.querySelector('.info-value:last-child');
            if (orderTimeElement && orderTimeElement.textContent.includes('orderTime')) {
                orderTimeElement.textContent = orderTime;
            }

            // 格式化金额
            const totalElement = document.querySelector('.info-value[style*="color: #e4393c"]');
            if (totalElement) {
                const total = parseFloat(totalElement.textContent.replace('¥ ', ''));
                totalElement.textContent = '¥ ' + total.toFixed(2);
            }
        });
    </script>
</body>
</html>