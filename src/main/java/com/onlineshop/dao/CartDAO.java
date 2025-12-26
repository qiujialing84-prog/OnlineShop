package com.onlineshop.dao;

import com.onlineshop.model.CartItem;
import com.onlineshop.model.Product;
import com.onlineshop.util.DBUtil;

import java.sql.*;
import java.util.logging.Logger;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {
    private static final Logger logger = Logger.getLogger(CartItem.class.getName());

    //添加商品到购物车
    public boolean addToCart(int customersId, int productId, int quantity) {
        String sql = "INSERT INTO cart(customer_id, product_id, quantity) VALUES(?, ?, ?)" + "ON DUPLICATE KEY UPDATE quantity = quantity + ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, customersId);
            stmt.setInt(2, productId);
            stmt.setInt(3, quantity);
            stmt.setInt(4, quantity);

            int rows = stmt.executeUpdate();
            logger.info("成功添加到购物车");
            return rows > 0;

        } catch (SQLException e) {
            logger.severe("添加失败" + e.getMessage());
            return false;
        }
    }

    //获取用户的购物车商品
    public List<CartItem> getCartItems(int customersId) {
        String sql = "SELECT c.*, p.name, p.description, p.price, p.stock_quantity, p.category, p.image_url FROM cart c JOIN products p ON c.product_id = p.id WHERE c.customer_id = ? ORDER BY c.added_date DESC";
        List<CartItem> cartItems = new ArrayList<>();

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, customersId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                CartItem cartItem = new CartItem();
                cartItem.setId(rs.getInt("id"));
                cartItem.setCustomerId(rs.getInt("customer_id"));
                cartItem.setProductId(rs.getInt("product_id"));
                cartItem.setQuantity(rs.getInt("quantity"));
                cartItem.setAddedDate(rs.getTimestamp("added_date"));

                //商品信息
                Product product = new Product();
                product.setId(rs.getInt("product_id"));
                product.setName(rs.getString("name"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getDouble("price"));
                product.setStockQuantity(rs.getInt("stock_quantity"));
                product.setCategory(rs.getString("category"));
                product.setImageUrl(rs.getString("image_url"));

                cartItem.setProduct(product);
                cartItems.add(cartItem);
            }
        } catch (SQLException e) {
            logger.severe("获取失败" + e.getMessage());
        }
        return cartItems;
    }

    //从购物车删除商品
    public boolean deleteCartItem(int cartId) {
        String sql = "DELETE FROM cart WHERE id = ?";


        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, cartId);

            int rows = stmt.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            logger.severe("删除失败" + e.getMessage());
            return false;
        }
    }

    //更新购物车商品数量
    public boolean updateCartQuantity(int cartId, int quantity) {
        if (quantity <= 0) {
            return deleteCartItem(cartId);
        }

        String sql = "UPDATE cart SET quantity = ? WHERE id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, quantity);
            stmt.setInt(2, cartId);

            int rows = stmt.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            logger.severe("更新失败" + e.getMessage());
            return false;
        }
    }

    //清空用户购物车
    public boolean clearCart(int customerId) {
        String sql = "DELETE FROM cart WHERE customer_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, customerId);
            int rows = stmt.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            logger.severe("清空失败" + e.getMessage());
            return false;
        }
    }

    //获取用户购物车商品总数
    public int getCartItemCount(int customerId){
        String sql = "SELECT SUM(quantity) as total FROM cart WHERE customer_id = ?";


        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1,customerId);
            ResultSet rs = stmt.executeQuery();

            if(rs.next()){
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            logger.severe("获取失败" + e.getMessage());
        }
        return 0;
    }
}