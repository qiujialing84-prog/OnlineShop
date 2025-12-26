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
    <title>订单结算 - OnlineShop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .navbar-brand { font-weight: bold; font-size: 1.5rem; }
        .checkout-header { background-color: #f8f9fa; border-radius: 10px; padding: 20px; margin-bottom: 30px; }
        .checkout-section { border: 1px solid #dee2e6; border-radius: 10px; padding: 25px; margin-bottom: 25px; }
        .section-title { font-size: 1.2rem; font-weight: 600; margin-bottom: 20px; color: #495057; }
        .order-item { border-bottom: 1px solid #e9ecef; padding: 15px 0; }
        .order-item:last-child { border-bottom: none; }
        .item-img { width: 80px; height: 80px; object-fit: cover; border-radius: 6px; }
        .item-title { font-size: 1rem; font-weight: 500; margin-bottom: 5px; }
        .item-price { color: #e4393c; font-weight: 600; }
        .summary-box { background-color: #f8f9fa; border-radius: 10px; padding: 25px; }
        .summary-title { font-size: 1.2rem; font-weight: 600; margin-bottom: 20px; }
        .summary-row { display: flex; justify-content: space-between; margin-bottom: 10px; }
        .summary-total { font-size: 1.3rem; font-weight: bold; color: #e4393c; border-top: 2px solid #dee2e6; padding-top: 15px; margin-top: 15px; }
        .payment-method { margin-bottom: 15px; }
        .payment-label { cursor: pointer; }
    </style>
</head>
<body>
    <!-- 导航栏 -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="<%=contextPath%>/">🛒 OnlineShop</a>
        </div>
    </nav>

    <!-- 面包屑导航 -->
    <div class="container mt-3">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="<%=contextPath%>/">首页</a></li>
                <li class="breadcrumb-item"><a href="<%=contextPath%>/cart?action=view">购物车</a></li>
                <li class="breadcrumb-item active">订单结算</li>
            </ol>
        </nav>
    </div>

    <!-- 主内容 -->
    <div class="container my-4">
        <div class="checkout-header">
            <h2 class="mb-2">订单结算</h2>
            <p class="text-muted mb-0">请确认订单信息并完成支付</p>
        </div>

        <%-- 错误信息 --%>
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <form action="<%=contextPath%>/cart" method="post">
            <input type="hidden" name="action" value="place">

            <div class="row">
                <!-- 左侧：收货信息和支付方式 -->
                <div class="col-lg-7">
                    <!-- 收货地址 -->
                    <div class="checkout-section">
                        <h5 class="section-title">收货地址</h5>

                        <div class="mb-3">
                            <label for="shippingAddress" class="form-label">详细地址 *</label>
                            <textarea class="form-control" id="shippingAddress" name="shippingAddress"
                                      rows="3" required>${customer.address}</textarea>
                            <div class="form-text">请填写详细收货地址，包括省市区、街道、门牌号等</div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="recipientName" class="form-label">收货人姓名</label>
                                <input type="text" class="form-control" id="recipientName"
                                       value="${customer.username}" disabled>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="recipientPhone" class="form-label">联系电话</label>
                                <input type="text" class="form-control" id="recipientPhone"
                                       value="${customer.phone}" disabled>
                            </div>
                        </div>
                    </div>

                    <!-- 支付方式 -->
                    <div class="checkout-section">
                        <h5 class="section-title">支付方式</h5>

                        <div class="payment-method">
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="paymentMethod"
                                       id="alipay" value="支付宝" checked>
                                <label class="form-check-label payment-label" for="alipay">
                                    <span class="d-flex align-items-center">
                                        <span style="font-size: 1.5rem;">💰</span>
                                        <span class="ms-2">支付宝支付</span>
                                    </span>
                                    <small class="text-muted d-block">推荐支付宝扫码支付</small>
                                </label>
                            </div>
                        </div>

                        <div class="payment-method">
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="paymentMethod"
                                       id="wechat" value="微信支付">
                                <label class="form-check-label payment-label" for="wechat">
                                    <span class="d-flex align-items-center">
                                        <span style="font-size: 1.5rem;">💳</span>
                                        <span class="ms-2">微信支付</span>
                                    </span>
                                    <small class="text-muted d-block">微信扫码支付</small>
                                </label>
                            </div>
                        </div>

                        <div class="payment-method">
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="paymentMethod"
                                       id="cod" value="货到付款">
                                <label class="form-check-label payment-label" for="cod">
                                    <span class="d-flex align-items-center">
                                        <span style="font-size: 1.5rem;">📦</span>
                                        <span class="ms-2">货到付款</span>
                                    </span>
                                    <small class="text-muted d-block">收到商品时支付现金</small>
                                </label>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 右侧：订单汇总 -->
                <div class="col-lg-5">
                    <div class="summary-box">
                        <h5 class="summary-title">订单详情</h5>

                        <!-- 订单商品列表 -->
                        <div class="mb-4">
                            <c:forEach var="item" items="${cartItems}">
                                <div class="order-item">
                                    <div class="row align-items-center">
                                        <div class="col-3">
                                            <img src="${item.product.imageUrl}"
                                                 class="item-img"
                                                 alt="${item.product.name}"
                                                 onerror="this.src='https://via.placeholder.com/80x80?text=商品'">
                                        </div>
                                        <div class="col-6">
                                            <div class="item-title">${item.product.name}</div>
                                            <div class="text-muted small">数量: ${item.quantity}</div>
                                        </div>
                                        <div class="col-3 text-end">
                                            <div class="item-price">¥ ${item.subtotal}</div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <!-- 价格汇总 -->
                        <div class="mb-3">
                            <div class="summary-row">
                                <span>商品总价</span>
                                <span>¥ ${totalAmount}</span>
                            </div>
                            <div class="summary-row">
                                <span>运费</span>
                                <span>¥ 0.00</span>
                            </div>
                            <div class="summary-row">
                                <span>优惠</span>
                                <span>- ¥ 0.00</span>
                            </div>
                        </div>

                        <div class="summary-total">
                            <span>应付总额</span>
                            <span>¥ ${totalAmount}</span>
                        </div>

                        <!-- 提交订单按钮 -->
                        <div class="d-grid mt-4">
                            <button type="submit" class="btn btn-primary btn-lg">
                                提交订单
                            </button>
                        </div>

                        <!-- 返回购物车 -->
                        <div class="text-center mt-3">
                            <a href="<%=contextPath%>/cart?action=view" class="text-decoration-none">返回修改</a>
                        </div>

                        <!-- 用户协议 -->
                        <div class="mt-4">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="agreeTerms" required checked>
                                <label class="form-check-label small" for="agreeTerms">
                                    我已阅读并同意 <a href="#" class="text-decoration-none">《用户购买协议》</a>
                                </label>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </form>
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
        // 表单验证
        document.querySelector('form').addEventListener('submit', function(e) {
            const address = document.getElementById('shippingAddress').value.trim();
            if (!address) {
                e.preventDefault();
                alert('请填写收货地址！');
                return false;
            }

            if (!document.getElementById('agreeTerms').checked) {
                e.preventDefault();
                alert('请同意用户购买协议！');
                return false;
            }

            // 确认提交
            if (!confirm('确认提交订单吗？')) {
                e.preventDefault();
                return false;
            }

            return true;
        });

        // 实时计算总金额
        document.addEventListener('DOMContentLoaded', function() {
            // 格式化金额显示
            const totalElement = document.querySelector('.summary-total span:last-child');
            if (totalElement) {
                const total = parseFloat(totalElement.textContent.replace('¥ ', ''));
                totalElement.textContent = '¥ ' + total.toFixed(2);
            }
        });
    </script>
</body>
</html>