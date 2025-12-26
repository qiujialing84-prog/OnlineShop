<div class="row justify-content-center">
    <div class="col-lg-8">
        <div class="card">
            <div class="card-header">
                <h5 class="card-title mb-0">${isEdit ? '编辑商品' : '添加新商品'}</h5>
            </div>
            <div class="card-body">
                <form action="<%=request.getContextPath()%>/admin/products"
                      method="post" enctype="multipart/form-data" id="productForm">

                    <input type="hidden" name="action" value="${isEdit ? 'edit' : 'add'}">
                    <c:if test="${isEdit}">
                        <input type="hidden" name="id" value="${product.id}">
                    </c:if>

                    <%-- 错误信息 --%>
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <div class="row">
                        <!-- 商品图片 -->
                        <div class="col-md-4 mb-3">
                            <div class="form-group">
                                <label for="image" class="form-label">商品图片</label>
                                <div class="image-upload-container">
                                    <div class="image-preview mb-2">
                                        <img id="imagePreview"
                                             src="${isEdit ? product.imageUrl : 'https://via.placeholder.com/300x200?text=选择图片'}"
                                             alt="商品图片预览"
                                             class="img-fluid rounded border"
                                             style="max-height: 200px;">
                                    </div>
                                    <input type="file" class="form-control" id="image" name="image"
                                           accept="image/*" onchange="previewImage(this)">
                                    <div class="form-text">支持 JPG, PNG 格式，建议尺寸 300x200</div>
                                </div>
                            </div>
                        </div>

                        <!-- 商品信息 -->
                        <div class="col-md-8">
                            <div class="row">
                                <div class="col-12 mb-3">
                                    <label for="name" class="form-label">商品名称 *</label>
                                    <input type="text" class="form-control" id="name" name="name"
                                           value="${isEdit ? product.name : ''}" required>
                                </div>

                                <div class="col-md-6 mb-3">
                                    <label for="price" class="form-label">价格 *</label>
                                    <div class="input-group">
                                        <span class="input-group-text">¥</span>
                                        <input type="number" class="form-control" id="price" name="price"
                                               step="0.01" min="0"
                                               value="${isEdit ? product.price : ''}" required>
                                    </div>
                                </div>

                                <div class="col-md-6 mb-3">
                                    <label for="stockQuantity" class="form-label">库存数量 *</label>
                                    <input type="number" class="form-control" id="stockQuantity" name="stockQuantity"
                                           min="0" value="${isEdit ? product.stockQuantity : '0'}" required>
                                </div>

                                <div class="col-12 mb-3">
                                    <label for="category" class="form-label">分类</label>
                                    <select class="form-select" id="category" name="category">
                                        <option value="">选择分类</option>
                                        <option value="手机" ${isEdit && product.category == '手机' ? 'selected' : ''}>手机</option>
                                        <option value="电脑" ${isEdit && product.category == '电脑' ? 'selected' : ''}>电脑</option>
                                        <option value="配件" ${isEdit && product.category == '配件' ? 'selected' : ''}>配件</option>
                                        <option value="平板" ${isEdit && product.category == '平板' ? 'selected' : ''}>平板</option>
                                        <option value="家居" ${isEdit && product.category == '家居' ? 'selected' : ''}>家居</option>
                                        <option value="服饰" ${isEdit && product.category == '服饰' ? 'selected' : ''}>服饰</option>
                                        <option value="食品" ${isEdit && product.category == '食品' ? 'selected' : ''}>食品</option>
                                        <option value="其他" ${isEdit && product.category == '其他' ? 'selected' : ''}>其他</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="description" class="form-label">商品描述</label>
                        <textarea class="form-control" id="description" name="description"
                                  rows="4">${isEdit ? product.description : ''}</textarea>
                        <div class="form-text">描述商品的特性和优势</div>
                    </div>

                    <div class="d-flex justify-content-between mt-4">
                        <a href="<%=request.getContextPath()%>/admin/products" class="btn btn-outline-secondary">
                            返回列表
                        </a>
                        <div>
                            <button type="reset" class="btn btn-secondary me-2">重置</button>
                            <button type="submit" class="btn btn-primary">
                                ${isEdit ? '更新商品' : '添加商品'}
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    // 图片预览
    function previewImage(input) {
        const preview = document.getElementById('imagePreview');
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function(e) {
                preview.src = e.target.result;
            };
            reader.readAsDataURL(input.files[0]);
        }
    }

    // 表单验证
    document.getElementById('productForm').addEventListener('submit', function(e) {
        const name = document.getElementById('name').value.trim();
        const price = document.getElementById('price').value;
        const stock = document.getElementById('stockQuantity').value;

        if (!name) {
            e.preventDefault();
            alert('商品名称不能为空！');
            return false;
        }

        if (!price || parseFloat(price) <= 0) {
            e.preventDefault();
            alert('价格必须大于0！');
            return false;
        }

        if (!stock || parseInt(stock) < 0) {
            e.preventDefault();
            alert('库存数量不能为负数！');
            return false;
        }

        return true;
    });
</script>