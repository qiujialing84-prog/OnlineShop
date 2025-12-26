//商品数据访问层，实现商品查询等功能
package com.onlineshop.dao;

import com.onlineshop.model.Product;
import com.onlineshop.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class ProductDAO {
    private static final Logger logger = Logger.getLogger(ProductDAO.class.getName());

    //获取所有商品
    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products ORDER BY created_date DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()){
                products.add(extractProduct(rs));
            }

            //logger.info("获取到" + products.size() + "个商品");
        } catch (SQLException e) {
            logger.severe("获取商品列表失败：" + e.getMessage());
        }
        return products;
    }

    //根据id获取商品
    public Product getProductById(int id) {
        String sql = "SELECT * FROM products WHERE id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1,id);   //绑定id到sql语句的第一个占位符（即第一个？）上
            ResultSet rs = stmt.executeQuery();
            if(rs.next()){
                return extractProduct(rs);
            }
        } catch (SQLException e) {
            logger.severe("根据id获取商品失败：" + e.getMessage());
        }
        return null;
    }

    //添加商品
    public boolean addProduct(Product product) {
        String sql = "INSERT INTO products (name, description, price, stock_quantity, category, image_url) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1,product.getName());
            stmt.setString(2,product.getDescription());
            stmt.setDouble(3,product.getPrice());
            stmt.setInt(4,product.getStockQuantity());
            stmt.setString(5,product.getCategory());
            stmt.setString(6,product.getImageUrl());

            int rows = stmt.executeUpdate();   //检测是否插入成功
            return rows > 0;
        } catch (SQLException e) {
            logger.severe("添加失败：" + e.getMessage());
            return false;
        }
    }

    //更新商品
    public boolean updateProduct(Product product){
        String sql = "UPDATE products SET name=?, description=?, price=?, stock_quantity=?, category=?, image_url=? WHERE id=?";

        try(Connection conn = DBUtil.getConnection();
        PreparedStatement stmt = conn.prepareStatement(sql)){

            stmt.setString(1,product.getName());
            stmt.setString(2,product.getDescription());
            stmt.setDouble(3,product.getPrice());
            stmt.setInt(4,product.getStockQuantity());
            stmt.setString(5,product.getCategory());
            stmt.setString(6,product.getImageUrl());
            stmt.setInt(7,product.getId());

            int rows = stmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            logger.severe("更新商品失败：" + e.getMessage());
            return false;
        }
    }

    //删除商品
    public boolean deleteProduct(int id) {
        String sql = "DELETE FROM products WHERE id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1,id);
            int rows = stmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            logger.severe("删除失败：" + e.getMessage());
            return false;
        }
    }

    //从结果集提取Product对象
    private Product extractProduct(ResultSet rs) throws SQLException{
        Product product = new Product();
        product.setId(rs.getInt("id"));
        product.setName(rs.getString("name"));
        product.setDescription(rs.getString("description"));
        product.setPrice(rs.getDouble("price"));
        product.setStockQuantity(rs.getInt("stock_quantity"));
        product.setCategory(rs.getString("category"));
        product.setImageUrl(rs.getString("image_url"));
        product.setCreatedDate(rs.getTimestamp("created_date"));
        return product;
    }
}
