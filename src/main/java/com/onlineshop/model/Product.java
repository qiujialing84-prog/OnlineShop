package com.onlineshop.model;

import java.sql.Timestamp;

public class Product {
    private int id;  //商品id
    private String name;
    private String description;  //商品描述
    private double price;
    private int stockQuantity;  //库存
    private String category;  //分类
    private String imageURL;  //商品图片链接
    private Timestamp createdDate;  //创建时间（当前时间）

    //构造方法
    public Product() {};

    public Product(String name,String description,double price,int stockQuantity){
        this.name = name;
        this.description = description;
        this.price = price;
        this.stockQuantity = stockQuantity;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public int getStockQuantity() { return stockQuantity; }
    public void setStockQuantity(int stockQuantity) { this.stockQuantity = stockQuantity; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getImageUrl() { return imageURL; }
    public void setImageUrl(String imageUrl) { this.imageURL = imageUrl; }

    public Timestamp getCreatedDate() { return createdDate; }
    public void setCreatedDate(Timestamp createdDate) { this.createdDate = createdDate; }
}
