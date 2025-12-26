<%-- 在文件顶部添加临时数据 --%>
<c:if test="${empty totalSales}">
    <%-- 如果后端没有传数据，使用默认值 --%>
    <c:set var="totalSales" value="12500.00" />
    <c:set var="orderCount" value="150" />
    <c:set var="productCount" value="80" />
    <c:set var="pendingOrders" value="12" />
    <c:set var="shippedOrders" value="45" />
</c:if>

<div class="row">
    <!-- 统计卡片 -->
    <div class="col-md-3 col-sm-6 mb-4">
        <div class="card border-primary">
            <div class="card-body">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="text-muted mb-2">总销售额</h6>
                        <h3 class="mb-0">¥ ${totalSales}</h3>
                    </div>
                    <div class="avatar-sm">
                        <span class="avatar-title bg-primary rounded-circle">
                            <i class="bi bi-currency-dollar fs-4"></i>
                        </span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="col-md-3 col-sm-6 mb-4">
        <div class="card border-success">
            <div class="card-body">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="text-muted mb-2">总订单数</h6>
                        <h3 class="mb-0">${orderCount}</h3>
                    </div>
                    <div class="avatar-sm">
                        <span class="avatar-title bg-success rounded-circle">
                            <i class="bi bi-cart-check fs-4"></i>
                        </span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="col-md-3 col-sm-6 mb-4">
        <div class="card border-info">
            <div class="card-body">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="text-muted mb-2">商品总数</h6>
                        <h3 class="mb-0">${productCount}</h3>
                    </div>
                    <div class="avatar-sm">
                        <span class="avatar-title bg-info rounded-circle">
                            <i class="bi bi-box-seam fs-4"></i>
                        </span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="col-md-3 col-sm-6 mb-4">
        <div class="card border-warning">
            <div class="card-body">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="text-muted mb-2">待处理订单</h6>
                        <h3 class="mb-0">${pendingOrders}</h3>
                    </div>
                    <div class="avatar-sm">
                        <span class="avatar-title bg-warning rounded-circle">
                            <i class="bi bi-clock-history fs-4"></i>
                        </span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 最近订单 -->
<div class="row">
    <div class="col-12">
        <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5 class="card-title mb-0">最近订单</h5>
                <a href="<%=request.getContextPath()%>/admin/orders" class="btn btn-sm btn-outline-primary">查看全部</a>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>订单号</th>
                                <th>客户</th>
                                <th>金额</th>
                                <th>状态</th>
                                <th>下单时间</th>
                                <th>操作</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="order" items="${orders}" begin="0" end="5">
                                <tr>
                                    <td>#${order.id}</td>
                                    <td>${order.customer.username}</td>
                                    <td>¥ ${order.totalAmount}</td>
                                    <td>
                                        <span class="badge bg-${order.status == 'pending' ? 'warning' :
                                                               order.status == 'paid' ? 'info' :
                                                               order.status == 'shipped' ? 'success' :
                                                               order.status == 'delivered' ? 'success' : 'danger'}">
                                            ${order.statusText}
                                        </span>
                                    </td>
                                    <td>${order.orderDate}</td>
                                    <td>
                                        <a href="<%=request.getContextPath()%>/admin/orders?id=${order.id}"
                                           class="btn btn-sm btn-outline-primary">详情</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 销售统计（简化版） -->
<div class="row mt-4">
    <div class="col-md-6">
        <div class="card">
            <div class="card-header">
                <h5 class="card-title mb-0">订单状态分布</h5>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-6">
                        <div class="d-flex align-items-center mb-3">
                            <div class="flex-shrink-0">
                                <span class="badge bg-warning rounded-circle p-2"></span>
                            </div>
                            <div class="flex-grow-1 ms-3">
                                <h6 class="mb-0">待付款</h6>
                                <span class="text-muted">${pendingOrders} 个订单</span>
                            </div>
                        </div>
                        <div class="d-flex align-items-center mb-3">
                            <div class="flex-shrink-0">
                                <span class="badge bg-info rounded-circle p-2"></span>
                            </div>
                            <div class="flex-grow-1 ms-3">
                                <h6 class="mb-0">已发货</h6>
                                <span class="text-muted">${shippedOrders} 个订单</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="d-flex align-items-center mb-3">
                            <div class="flex-shrink-0">
                                <span class="badge bg-success rounded-circle p-2"></span>
                            </div>
                            <div class="flex-grow-1 ms-3">
                                <h6 class="mb-0">已完成</h6>
                                <span class="text-muted">${orderCount - pendingOrders - shippedOrders} 个订单</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="col-md-6">
        <div class="card">
            <div class="card-header">
                <h5 class="card-title mb-0">快速操作</h5>
            </div>
            <div class="card-body">
                <div class="row g-3">
                    <div class="col-6">
                        <a href="<%=request.getContextPath()%>/admin/products?action=add"
                           class="btn btn-primary w-100 h-100 d-flex flex-column justify-content-center align-items-center p-3">
                            <i class="bi bi-plus-circle fs-2 mb-2"></i>
                            <span>添加商品</span>
                        </a>
                    </div>
                    <div class="col-6">
                        <a href="<%=request.getContextPath()%>/admin/orders"
                           class="btn btn-success w-100 h-100 d-flex flex-column justify-content-center align-items-center p-3">
                            <i class="bi bi-receipt fs-2 mb-2"></i>
                            <span>处理订单</span>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // 格式化金额显示
    document.addEventListener('DOMContentLoaded', function() {
        const totalSalesElement = document.querySelector('.card.border-primary h3');
        if (totalSalesElement) {
            const totalSales = parseFloat(totalSalesElement.textContent.replace('¥ ', ''));
            totalSalesElement.textContent = '¥ ' + totalSales.toFixed(2);
        }
    });
</script>