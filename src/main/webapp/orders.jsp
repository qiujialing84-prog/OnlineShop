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
    <title>我的订单 - OnlineShop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .navbar-brand { font-weight: bold; font-size: 1.5rem; }
        .orders-header { background-color: #f8f9fa; border-radius: 10px; padding: 20px; margin-bottom: 30px; }
        .order-card { border: 1px solid #dee2e6; border-radius: 10px; padding: 20px; margin-bottom: 20px; }
        .order-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; }
        .order-id { font-size: 1.1rem; font-weight: 600; color: #007bff; }
        .order-date { color: #6c757d; }
        .order-status { padding: 4px 12px; border-radius: 20px; font-size: 0.875rem; font-weight: 500; }
        .status-pending { background-color: #fff3cd; color: #856404; }
        .status-paid { background-color: #d1ecf1; color: #0c5460; }
        .status-shipped { background-color: #d4edda; color: #155724; }
        .status-delivered { background-color: #c3e6cb; color: #155724; }
        .status-cancelled { background-color: #f8d7da; color: #721c24; }
        .order-summary { background-color: #f8f9fa; border-radius: 8px; padding: 15px; }
        .summary-item { display: flex; justify-content: space-between; margin-bottom: 8px; }
        .order-total { font-size: 1.2rem; font-weight: bold; color: #e4393c; }
        .empty-orders { text-align: center; padding: 60px 20px; }
        .empty-icon { font-size: 4rem; color: #6c757d; margin-bottom: 20px; }
        .stats-card { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; border-radius: 10px; padding: 20px; margin-bottom: 20px; }
        .stats-number { font-size: 2rem; font-weight: bold; }
        .stats-label { font-size: 0.9rem; opacity: 0.9; }
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
                <li class="breadcrumb-item active">我的订单</li>
            </ol>
        </nav>
    </div>

    <!-- 主内容 -->
    <div class="container my-4">
        <div class="orders-header">
            <h2 class="mb-0">${isAdminView ? '订单管理' : '我的订单'}</h2>
            <c:if test="${not empty orderCount}">
                <p class="text-muted mb-0">共 ${orderCount} 个订单</p>
            </c:if>
        </div>

        <%-- 错误信息 --%>
        <% if (error != null) { %>
            <div class="alert alert-warning alert-dismissible fade show" role="alert">
                <%= error %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <%-- 管理员统计信息 --%>
        <c:if test="${isAdminView}">
            <div class="row mb-4">
                <div class="col-md-4">
                    <div class="stats-card">
                        <div class="stats-number">${orderCount}</div>
                        <div class="stats-label">总订单数</div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stats-card" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
                        <div class="stats-number">¥ ${totalSales}</div>
                        <div class="stats-label">总销售额</div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stats-card" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);">
                        <div class="stats-number">${orders.stream().filter(o -> o.status == 'pending').count()}</div>
                        <div class="stats-label">待处理订单</div>
                    </div>
                </div>
            </div>
        </c:if>

        <%-- 用户统计信息 --%>
        <c:if test="${not isAdminView and not empty totalSpent}">
            <div class="alert alert-info">
                <div class="row">
                    <div class="col-md-6">
                        <strong>累计消费：</strong> ¥ ${totalSpent}
                    </div>
                    <div class="col-md-6 text-end">
                        <strong>订单总数：</strong> ${orderCount} 个
                    </div>
                </div>
            </div>
        </c:if>

        <c:choose>
            <c:when test="${not empty orders and orderCount > 0}">
                <c:forEach var="order" items="${orders}">
                    <div class="order-card">
                        <div class="order-header">
                            <div>
                                <span class="order-id">订单号: #${order.id}</span>
                                <span class="order-date ms-3">${order.orderDate}</span>
                            </div>
                            <span class="order-status status-${order.status}">
                                ${order.statusText}
                            </span>
                        </div>

                        <div class="row">
                            <c:if test="${isAdminView}">
                                <div class="col-md-3 mb-3">
                                    <strong>客户：</strong> ${order.customer.username}<br>
                                    <small class="text-muted">${order.customer.email}</small>
                                </div>
                            </c:if>
                            <div class="col-md-${isAdminView ? '3' : '4'} mb-3">
                                <strong>收货地址：</strong><br>
                                <small>${order.shippingAddress}</small>
                            </div>
                            <div class="col-md-${isAdminView ? '3' : '4'} mb-3">
                                <strong>支付方式：</strong><br>
                                <small>${order.paymentMethod}</small>
                            </div>
                            <div class="col-md-${isAdminView ? '3' : '4'}">
                                <div class="order-summary">
                                    <div class="summary-item">
                                        <span>商品金额：</span>
                                        <span>¥ ${order.totalAmount}</span>
                                    </div>
                                    <div class="summary-item">
                                        <span>运费：</span>
                                        <span>¥ 0.00</span>
                                    </div>
                                    <div class="order-total">
                                        <span>实付金额：</span>
                                        <span>¥ ${order.totalAmount}</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="text-end mt-3">
                            <a href="<%=contextPath%>/orders?id=${order.id}"
                               class="btn btn-outline-primary btn-sm">查看详情</a>
                            <c:if test="${isAdminView}">
                                <c:if test="${order.status == 'pending'}">
                                    <button class="btn btn-success btn-sm ms-2"
                                            onclick="updateOrderStatus(${order.id}, 'paid')">
                                        标记为已付款
                                    </button>
                                </c:if>
                                <c:if test="${order.status == 'paid'}">
                                    <button class="btn btn-info btn-sm ms-2"
                                            onclick="updateOrderStatus(${order.id}, 'shipped')">
                                        标记为已发货
                                    </button>
                                </c:if>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="empty-orders">
                    <div class="empty-icon">📋</div>
                    <h3 class="mb-3">${isAdminView ? '暂无订单' : '您还没有订单'}</h3>
                    <p class="text-muted mb-4">${isAdminView ? '还没有用户下单' : '快去选购心仪的商品吧！'}</p>
                    <a href="<%=contextPath%>/products" class="btn btn-primary btn-lg">去购物</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- 页脚 -->
    <footer class="bg-dark text-white py-4 mt-5">
        <div class="container">
            <div class="text-center">
                <p class="text-white-50 mb-0">&copy; 2025 OnlineShop 在线购物网站</p>
            </div>
        </div>
    </footer>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // 更新订单状态（管理员功能）
        function updateOrderStatus(orderId, status) {
            if (confirm('确定要更新订单状态吗？')) {
                fetch('<%=contextPath%>/admin/order?action=update&id=' + orderId + '&status=' + status, {
                    method: 'POST'
                })
                .then(response => {
                    if (response.ok) {
                        location.reload();
                    } else {
                        alert('更新失败，请稍后重试');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('网络错误，请检查连接');
                });
            }
        }

        // 格式化金额显示
        document.addEventListener('DOMContentLoaded', function() {
            document.querySelectorAll('.order-total span:last-child').forEach(element => {
                const total = parseFloat(element.textContent.replace('¥ ', ''));
                element.textContent = '¥ ' + total.toFixed(2);
            });

            // 格式化日期显示
            document.querySelectorAll('.order-date').forEach(element => {
                const dateStr = element.textContent;
                if (dateStr) {
                    const date = new Date(dateStr);
                    const formattedDate = date.getFullYear() + '-' +
                                         (date.getMonth() + 1).toString().padStart(2, '0') + '-' +
                                         date.getDate().toString().padStart(2, '0') + ' ' +
                                         date.getHours().toString().padStart(2, '0') + ':' +
                                         date.getMinutes().toString().padStart(2, '0');
                    element.textContent = formattedDate;
                }
            });
        });
    </script>
</body>
</html>