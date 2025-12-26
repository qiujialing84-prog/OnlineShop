package com.onlineshop.model;

import java.sql.Timestamp;

public class CartItem {
    private int id;
    private int customerId;
    private int productId;
    private int quantity;
    private Timestamp addedDate;

    // 关联的商品信息（用于显示）
    private Product product;

    // 构造方法
    public CartItem() {}

    public CartItem(int customerId, int productId, int quantity) {
        this.customerId = customerId;
        this.productId = productId;
        this.quantity = quantity;
    }

    // Getter和Setter
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public Timestamp getAddedDate() { return addedDate; }
    public void setAddedDate(Timestamp addedDate) { this.addedDate = addedDate; }

    public Product getProduct() { return product; }
    public void setProduct(Product product) { this.product = product; }

    // 计算小计
    public double getSubtotal() {
        if (product != null) {
            return product.getPrice() * quantity;
        }
        return 0;
    }

}