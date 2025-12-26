package com.onlineshop.model;

import java.sql.Timestamp;
import java.util.List;

public class Order {
    private int id;
    private int customerId;
    private Timestamp orderDate;
    private double totalAmount;
    private String status;
    private String shippingAddress;
    private String paymentMethod;

    // 关联的订单项
    private List<OrderItem> items;
    // 关联的顾客信息
    private Customer customer;

    // 构造方法
    public Order() {}

    public Order(int customerId, double totalAmount, String shippingAddress) {
        this.customerId = customerId;
        this.totalAmount = totalAmount;
        this.shippingAddress = shippingAddress;
        this.status = "pending";
    }

    // Getter和Setter
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }

    public Timestamp getOrderDate() { return orderDate; }
    public void setOrderDate(Timestamp orderDate) { this.orderDate = orderDate; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getShippingAddress() { return shippingAddress; }
    public void setShippingAddress(String shippingAddress) { this.shippingAddress = shippingAddress; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public List<OrderItem> getItems() { return items; }
    public void setItems(List<OrderItem> items) { this.items = items; }

    public Customer getCustomer() { return customer; }
    public void setCustomer(Customer customer) { this.customer = customer; }

    // 获取状态中文名称
    public String getStatusText() {
        switch (status) {
            case "pending": return "待付款";
            case "paid": return "已付款";
            case "processing": return "处理中";
            case "shipped": return "已发货";
            case "delivered": return "已送达";
            case "cancelled": return "已取消";
            default: return status;
        }
    }

}
