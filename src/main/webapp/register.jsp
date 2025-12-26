<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户注册 - OnlineShop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .register-container {
            max-width: 500px;
            margin: 50px auto;
            padding: 30px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }
        .register-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .form-label {
            font-weight: 500;
        }
    </style>
</head>
<body>
    <!-- 导航栏（复用首页的） -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="<%=contextPath%>/">🛒 OnlineShop</a>
        </div>
    </nav>

    <div class="container">
        <div class="register-container">
            <div class="register-header">
                <h2>用户注册</h2>
                <p class="text-muted">创建您的OnlineShop账户</p>
            </div>

            <%-- 显示错误信息 --%>
            <%
                String error = (String) request.getAttribute("error");
                if (error != null) {
            %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <%= error %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>

            <form action="<%=contextPath%>/register" method="post" id="registerForm">
                <div class="mb-3">
                    <label for="username" class="form-label">用户名 *</label>
                    <input type="text" class="form-control" id="username" name="username"
                           required maxlength="20" value="${param.username}">
                    <div class="form-text">用户名由3-20个字符组成</div>
                </div>

                <div class="mb-3">
                    <label for="password" class="form-label">密码 *</label>
                    <input type="password" class="form-control" id="password" name="password"
                           required minlength="6">
                    <div class="form-text">密码至少6位字符</div>
                </div>

                <div class="mb-3">
                    <label for="confirmPassword" class="form-label">确认密码 *</label>
                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                </div>

                <div class="mb-3">
                    <label for="email" class="form-label">邮箱 *</label>
                    <input type="email" class="form-control" id="email" name="email"
                           required value="${param.email}">
                </div>

                <div class="mb-3">
                    <label for="phone" class="form-label">手机号</label>
                    <input type="tel" class="form-control" id="phone" name="phone"
                           pattern="[0-9]{11}" value="${param.phone}">
                    <div class="form-text">请输入11位手机号码</div>
                </div>

                <div class="mb-3">
                    <label for="address" class="form-label">收货地址</label>
                    <textarea class="form-control" id="address" name="address" rows="3">${param.address}</textarea>
                </div>

                <div class="d-grid gap-2">
                    <button type="submit" class="btn btn-primary btn-lg">注册</button>
                    <a href="<%=contextPath%>/login" class="btn btn-outline-secondary">已有账户？去登录</a>
                </div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 表单验证
        document.getElementById('registerForm').addEventListener('submit', function(e) {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;

            if (password !== confirmPassword) {
                e.preventDefault();
                alert('两次输入的密码不一致！');
                return false;
            }

            const phone = document.getElementById('phone').value;
            if (phone && !/^[0-9]{11}$/.test(phone)) {
                e.preventDefault();
                alert('请输入有效的11位手机号码！');
                return false;
            }

            return true;
        });
    </script>
</body>
</html>