<div class="d-flex justify-content-between align-items-center mb-4">
    <h4 class="mb-0">商品列表</h4>
    <a href="<%=request.getContextPath()%>/admin/products?action=add" class="btn btn-primary">
        <i class="bi bi-plus-circle me-1"></i> 添加商品
    </a>
</div>

<div class="card">
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>图片</th>
                        <th>商品名称</th>
                        <th>价格</th>
                        <th>库存</th>
                        <th>分类</th>
                        <th>创建时间</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty products}">
                            <c:forEach var="product" items="${products}">
                                <tr>
                                    <td>${product.id}</td>
                                    <td>
                                        <img src="${product.imageUrl}"
                                             alt="${product.name}"
                                             style="width: 50px; height: 50px; object-fit: cover; border-radius: 4px;"
                                             onerror="this.src='https://via.placeholder.com/50x50?text=商品'">
                                    </td>
                                    <td>
                                        <div class="fw-medium">${product.name}</div>
                                        <small class="text-muted">${product.description}</small>
                                    </td>
                                    <td class="fw-bold text-danger">¥ ${product.price}</td>
                                    <td>
                                        <span class="badge ${product.stockQuantity > 10 ? 'bg-success' :
                                                           product.stockQuantity > 0 ? 'bg-warning' : 'bg-danger'}">
                                            ${product.stockQuantity}
                                        </span>
                                    </td>
                                    <td>
                                        <span class="badge bg-info">${product.category}</span>
                                    </td>
                                    <td>
                                        <small class="text-muted">${product.createdDate}</small>
                                    </td>
                                    <td>
                                        <div class="btn-group btn-group-sm">
                                            <a href="<%=request.getContextPath()%>/products?id=${product.id}"
                                               class="btn btn-outline-info" title="查看" target="_blank">
                                                <i class="bi bi-eye"></i>
                                            </a>
                                            <a href="<%=request.getContextPath()%>/admin/products?action=edit&id=${product.id}"
                                               class="btn btn-outline-primary" title="编辑">
                                                <i class="bi bi-pencil"></i>
                                            </a>
                                            <button type="button" class="btn btn-outline-danger"
                                                    title="删除" onclick="confirmDelete(${product.id})">
                                                <i class="bi bi-trash"></i>
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
                                        <i class="bi bi-box-seam fs-1 mb-3 d-block"></i>
                                        <p>暂无商品</p>
                                        <a href="<%=request.getContextPath()%>/admin/products?action=add"
                                           class="btn btn-primary mt-2">添加第一个商品</a>
                                    </div>
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

        <div class="d-flex justify-content-between align-items-center mt-3">
            <div class="text-muted">
                共 <span class="fw-bold">${productCount}</span> 件商品
            </div>
        </div>
    </div>
</div>

<script>
    function confirmDelete(productId) {
        if (confirm('确定要删除这个商品吗？此操作不可恢复！')) {
            fetch('<%=request.getContextPath()%>/admin/products', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'action=delete&id=' + productId
            })
            .then(response => {
                if (response.ok) {
                    location.reload();
                } else {
                    alert('删除失败，请稍后重试');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('网络错误，请检查连接');
            });
        }
    }

    // 格式化日期
    document.addEventListener('DOMContentLoaded', function() {
        document.querySelectorAll('small.text-muted').forEach(element => {
            const dateStr = element.textContent;
            if (dateStr && dateStr.includes(':')) {
                const date = new Date(dateStr);
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
    });
</script>