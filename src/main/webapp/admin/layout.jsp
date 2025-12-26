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
    <title><%= request.getAttribute("pageTitle") != null ? request.getAttribute("pageTitle") + " - " : "" %>后台管理 - OnlineShop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --sidebar-width: 250px;
            --header-height: 60px;
        }

        body {
            font-size: 0.9rem;
            background-color: #f8f9fa;
        }

        /* 侧边栏 */
        .sidebar {
            width: var(--sidebar-width);
            height: 100vh;
            position: fixed;
            top: 0;
            left: 0;
            background: linear-gradient(180deg, #343a40 0%, #2c3136 100%);
            color: white;
            z-index: 1000;
            overflow-y: auto;
        }

        .sidebar-header {
            padding: 20px;
            border-bottom: 1px solid #4b545c;
        }

        .sidebar-brand {
            font-size: 1.2rem;
            font-weight: bold;
            color: white;
            text-decoration: none;
        }

        .sidebar-menu {
            padding: 20px 0;
        }

        .nav-link {
            color: rgba(255, 255, 255, 0.8);
            padding: 12px 20px;
            border-left: 3px solid transparent;
            transition: all 0.3s;
        }

        .nav-link:hover {
            color: white;
            background-color: rgba(255, 255, 255, 0.1);
        }

        .nav-link.active {
            color: white;
            background-color: rgba(255, 255, 255, 0.1);
            border-left-color: #007bff;
        }

        .nav-icon {
            width: 20px;
            margin-right: 10px;
            text-align: center;
        }

        /* 主内容区 */
        .main-content {
            margin-left: var(--sidebar-width);
            min-height: 100vh;
        }

        .content-header {
            background-color: white;
            border-bottom: 1px solid #dee2e6;
            padding: 15px 20px;
            position: sticky;
            top: 0;
            z-index: 999;
        }

        .content-body {
            padding: 20px;
        }

        .card {
            border: none;
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
            margin-bottom: 20px;
        }

        .card-header {
            background-color: white;
            border-bottom: 1px solid rgba(0, 0, 0, 0.125);
            font-weight: 600;
        }

        /* 响应式 */
        @media (max-width: 768px) {
            .sidebar {
                width: 70px;
            }

            .sidebar .nav-text {
                display: none;
            }

            .sidebar-brand span:last-child {
                display: none;
            }

            .nav-icon {
                margin-right: 0;
                font-size: 1.2rem;
            }

            .main-content {
                margin-left: 70px;
            }
        }
    </style>
</head>
<body>
    <!-- 侧边栏 -->
    <div class="sidebar">
        <div class="sidebar-header">
            <a href="<%=contextPath%>/admin/dashboard" class="sidebar-brand d-flex align-items-center">
                <i class="bi bi-speedometer2 me-2"></i>
                <span>OnlineShop</span>
                <span class="ms-2">后台</span>
            </a>
        </div>

        <div class="sidebar-menu">
            <ul class="nav flex-column">
                <li class="nav-item">
                    <a href="<%=contextPath%>/admin/dashboard"
                       class="nav-link ${param.active == 'dashboard' ? 'active' : ''}">
                        <i class="bi bi-speedometer2 nav-icon"></i>
                        <span class="nav-text">仪表盘</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=contextPath%>/admin/products"
                       class="nav-link ${param.active == 'products' ? 'active' : ''}">
                        <i class="bi bi-box-seam nav-icon"></i>
                        <span class="nav-text">商品管理</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=contextPath%>/admin/orders"
                       class="nav-link ${param.active == 'orders' ? 'active' : ''}">
                        <i class="bi bi-receipt nav-icon"></i>
                        <span class="nav-text">订单管理</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=contextPath%>/admin/customers"
                       class="nav-link ${param.active == 'customers' ? 'active' : ''}">
                        <i class="bi bi-people nav-icon"></i>
                        <span class="nav-text">客户管理</span>
                    </a>
                </li>
                <li class="nav-item mt-4">
                    <a href="<%=contextPath%>/"
                       class="nav-link">
                        <i class="bi bi-house nav-icon"></i>
                        <span class="nav-text">返回前台</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<%=contextPath%>/logout"
                       class="nav-link text-danger">
                        <i class="bi bi-box-arrow-right nav-icon"></i>
                        <span class="nav-text">退出登录</span>
                    </a>
                </li>
            </ul>
        </div>
    </div>

    <!-- 主内容区 -->
    <div class="main-content">
        <div class="content-header">
            <div class="d-flex justify-content-between align-items-center">
                <h4 class="mb-0">${pageTitle}</h4>
                <div>
                    <span class="text-muted me-3">${sessionScope.customer.username}</span>
                    <span class="badge bg-primary">管理员</span>
                </div>
            </div>
        </div>

        <div class="content-body">
            <%-- 消息提示 --%>
            <c:if test="${not empty param.success}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    ${param.success}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <c:if test="${not empty param.error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    ${param.error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <%-- 内容区域 --%>
            <jsp:include page="${contentPage}" />
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // 设置活动菜单项
        document.addEventListener('DOMContentLoaded', function() {
            const currentPath = window.location.pathname;
            const menuItems = document.querySelectorAll('.nav-link');

            menuItems.forEach(item => {
                item.classList.remove('active');
                if (currentPath.includes(item.getAttribute('href').replace('<%=contextPath%>', ''))) {
                    item.classList.add('active');
                }
            });
        });
    </script>
</body>
</html>