<div class="d-flex justify-content-between align-items-center mb-4">
    <h4 class="mb-0">订单管理</h4>
    <div class="text-muted">
        共 <span class="fw-bold">${orderCount}</span> 个订单，
        销售额: <span class="fw-bold text-danger">¥ ${totalSales}</span>
    </div>
</div>

<!-- 订单筛选 -->
<div class="card mb-4">
    <div class="card-body">
        <form action="<%=request.getContextPath()%>/admin/orders" method="get" class="row g-3">
            <div class="col-md-3">
                <label for="status" class="form-label">订单状态</label>
                <select class="form-select" id="status" name="status">
                    <option value="">全部状态</option>
                    <option value="pending">待付款</option>
                    <option value="paid">已付款</option>
                    <option value="processing">处理中</option>
                    <option value="shipped">已发货</option>
                    <option value="delivered">已送达</option>
                    <option value="cancelled">已取消</option>
                </select>
            </div>
            <div class="col-md-3">
                <label for="dateFrom" class="form-label">开始日期</label>
                <input type="date" class="form-control" id="dateFrom" name="dateFrom">
            </div>
            <div class="col-md-3">
                <label for="dateTo" class="form-label">结束日期</label>
                <input type="date" class="form-control" id="dateTo" name="dateTo">
            </div>
            <div class="col-md-3 d-flex align-items-end">
                <button type="submit" class="btn btn-primary w-100">筛选</button>
            </div>
        </form>
    </div>
</div>

<!-- 订单列表 -->
<div class="card">
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>订单号</th>
                        <th>客户</th>
                        <th>联系方式</th>
                        <th>金额</th>
                        <th>状态</th>
                        <th>支付方式</th>
                        <th>下单时间</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty orders}">
                            <c:forEach var="order" items="${orders}">
                                <tr>
                                    <td>
                                        <strong>#${order.id}</strong>
                                        <br>
                                        <small class="text-muted">${order.shippingAddress}</small>
                                    </td>
                                    <td>
                                        <div class="fw-medium">${order.customer.username}</div>
                                        <small class="text-muted">${order.customer.email}</small>
                                    </td>
                                    <td>
                                        <small class="text-muted">${order.customer.phone}</small>
                                    </td>
                                    <td class="fw-bold text-danger">¥ ${order.totalAmount}</td>
                                    <td>
                                        <select class="form-select form-select-sm status-select"
                                                data-order-id="${order.id}"
                                                style="width: auto; display: inline-block;">
                                            <option value="pending" ${order.status == 'pending' ? 'selected' : ''}>待付款</option>
                                            <option value="paid" ${order.status == 'paid' ? 'selected' : ''}>已付款</option>
                                            <option value="processing" ${order.status == 'processing' ? 'selected' : ''}>处理中</option>
                                            <option value="shipped" ${order.status == 'shipped' ? 'selected' : ''}>已发货</option>
                                            <option value="delivered" ${order.status == 'delivered' ? 'selected' : ''}>已送达</option>
                                            <option value="cancelled" ${order.status == 'cancelled' ? 'selected' : ''}>已取消</option>
                                        </select>
                                    </td>
                                    <td>
                                        <span class="badge bg-info">${order.paymentMethod}</span>
                                    </td>
                                    <td>
                                        <small class="text-muted">${order.orderDate}</small>
                                    </td>
                                    <td>
                                        <div class="btn-group btn-group-sm">
                                            <a href="<%=request.getContextPath()%>/orders?id=${order.id}"
                                               class="btn btn-outline-info" title="查看详情">
                                                <i class="bi bi-eye"></i>
                                            </a>
                                            <c:if test="${order.status == 'paid'}">
                                                <button type="button" class="btn btn-outline-success"
                                                        title="发货" onclick="shipOrder(${order.id})">
                                                    <i class="bi bi-truck"></i>
                                                </button>
                                            </c:if>
                                            <button type="button" class="btn btn-outline-primary"
                                                    title="更新状态" onclick="updateOrderStatus(${order.id})">
                                                <i class="bi bi-check2"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="8" class="text-center py-5">
                                    <div class="text-muted">
                                        <i class="bi bi-receipt fs-1 mb-3 d-block"></i>
                                        <p>暂无订单</p>
                                    </div>
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

        <!-- 分页（简化版） -->
        <c:if test="${orderCount > 10}">
            <nav aria-label="订单分页" class="mt-3">
                <ul class="pagination justify-content-center">
                    <li class="page-item disabled">
                        <a class="page-link" href="#" tabindex="-1">上一页</a>
                    </li>
                    <li class="page-item active"><a class="page-link" href="#">1</a></li>
                    <li class="page-item"><a class="page-link" href="#">2</a></li>
                    <li class="page-item"><a class="page-link" href="#">3</a></li>
                    <li class="page-item">
                        <a class="page-link" href="#">下一页</a>
                    </li>
                </ul>
            </nav>
        </c:if>
    </div>
</div>

<script>
    // 更新订单状态
    function updateOrderStatus(orderId) {
        const selectElement = document.querySelector(`.status-select[data-order-id="${orderId}"]`);
        const newStatus = selectElement.value;

        if (confirm(`确定将订单 #${orderId} 的状态更新为 "${selectElement.options[selectElement.selectedIndex].text}" 吗？`)) {
            fetch('<%=request.getContextPath()%>/admin/order', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'action=update&id=' + orderId + '&status=' + newStatus
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
        } else {
            // 恢复原来的选择
            selectElement.value = selectElement.getAttribute('data-original-value');
        }
    }

    // 保存原始状态值
    document.addEventListener('DOMContentLoaded', function() {
        document.querySelectorAll('.status-select').forEach(select => {
            select.setAttribute('data-original-value', select.value);
        });

        // 格式化日期和金额
        document.querySelectorAll('td .text-muted').forEach(element => {
            const text = element.textContent;
            if (text.includes(':')) {
                const date = new Date(text);
                if (!isNaN(date.getTime())) {
                    const formattedDate = date.getFullYear() + '-' +
                                         (date.getMonth() + 1).toString().padStart(2, '0') + '-' +
                                         date.getDate().toString().padStart(2, '0') + ' ' +
                                         date.getHours().toString().padStart(2, '0') + ':' +
                                         date.getMinutes().toString().padStart(2, '0');
                    element.textContent = formattedDate;
                }
            }
        });

        document.querySelectorAll('.text-danger').forEach(element => {
            if (element.textContent.includes('¥')) {
                const amount = parseFloat(element.textContent.replace('¥ ', ''));
                element.textContent = '¥ ' + amount.toFixed(2);
            }
        });
    });

    // 快速发货
    function shipOrder(orderId) {
        if (confirm('确定要发货并发送通知邮件吗？')) {
            fetch('<%=request.getContextPath()%>/admin/order', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'action=update&id=' + orderId + '&status=shipped'
            })
            .then(response => {
                if (response.ok) {
                    alert('订单已标记为已发货，通知邮件已发送！');
                    location.reload();
                } else {
                    alert('发货失败，请稍后重试');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('网络错误，请检查连接');
            });
        }
    }
</script>