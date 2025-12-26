package com.onlineshop.dao;

import com.onlineshop.model.*;
import com.onlineshop.util.DBUtil;
import org.eclipse.tags.shaded.org.apache.xpath.operations.Or;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class OrderDAO {
    private static final Logger logger = Logger.getLogger(OrderDAO.class.getName());

    //创建订单
    public int createOrder(Order order, List<CartItem> cartItems){
        Connection conn = null;
        PreparedStatement orderStmt = null;
        PreparedStatement itemStmt = null;
        ResultSet rs = null;

        try{
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);  //开始事务

            //插入订单
            String orderSql = "INSERT INTO orders (customer_id, total_amount, shipping_address, payment_method, status) VALUES (?, ?, ?, ?, ?)";
            orderStmt = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS);
            orderStmt.setInt(1, order.getCustomerId());
            orderStmt.setDouble(2, order.getTotalAmount());
            orderStmt.setString(3, order.getShippingAddress());
            orderStmt.setString(4, order.getPaymentMethod());
            orderStmt.setString(5, order.getStatus());

            orderStmt.executeUpdate();

            //获取生成的订单id
            rs = orderStmt.getGeneratedKeys();
            int orderId = 0;
            if(rs.next()){
                orderId = rs.getInt(1);
            }

            //插入订单项
            String itemSql = "INSERT INTO order_items (order_id, product_id, quantity,unit_price) VALUES (?, ?, ?, ?)";
            itemStmt = conn.prepareStatement(itemSql);

            for (CartItem cartItem : cartItems) {
                itemStmt.setInt(1, orderId);
                itemStmt.setInt(2, cartItem.getProductId());
                itemStmt.setInt(3, cartItem.getQuantity());
                itemStmt.setDouble(4, cartItem.getProduct().getPrice());
                itemStmt.addBatch();  //添加到批处理
            }

            itemStmt.executeBatch();  //批量插入

            //更新商品库存
            String updateStockSql = "UPDATE products SET stock_quantity = stock_quantity - ? WHERE id = ?";
            PreparedStatement stockStmt = conn.prepareStatement(updateStockSql);

            for(CartItem cartItem : cartItems){
                stockStmt.setInt(1, cartItem.getQuantity());
                stockStmt.setInt(2, cartItem.getProductId());
                stockStmt.addBatch();
            }

            stockStmt.addBatch();
            stockStmt.close();

            //清空购物车
            String clearSql = "DELETE FROM cart WHERE customer_id = ?";
            PreparedStatement cartStmt = conn.prepareStatement(clearSql);
            cartStmt.setInt(1,order.getCustomerId());
            cartStmt.executeUpdate();
            cartStmt.close();

            conn.commit();//提交事务
            logger.info("创建订单成功：orderId=" + orderId + ",customerId=" + order.getCustomerId());

            return orderId;

        } catch (SQLException e) {
            try {
                if(conn != null){
                    conn.rollback();//回滚事务
                }
            } catch (SQLException ex) {
                logger.severe("回滚事务失败" + ex.getMessage());
            }
            logger.severe("创建订单失败" + e.getMessage());
            return 0;
        }finally {
            try {
                if(rs != null) rs.close();;
                if(orderStmt != null) orderStmt.close();
                if (itemStmt != null) itemStmt.close();
                if(conn != null){
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
                logger.severe("关闭资源失败" + e.getMessage());
            }
        }
    }

    //获取用户所有订单
    public List<Order> getOrdersByCustomer(int customerId){
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, c.username, c.email FROM orders o JOIN customers c ON o.customer_id = c.id WHERE o.customer_id = ? ORDER BY o.order_date DESC";

        try(Connection conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1,customerId);
            ResultSet rs = stmt.executeQuery();

            while(rs.next()){
                Order order = extractOrder(rs);

                //获取顾客信息
                Customer customer = new Customer();
                customer.setUsername(rs.getString("username"));
                customer.setEmail(rs.getString("email"));
                order.setCustomer(customer);

                //获取订单项
                order.setItems(getOrderItems(order.getId()));

                orders.add(order);
            }
            logger.info("获取用户订单：customerId=" + customerId + ",数量=" + orders.size());

        } catch (SQLException e) {
            logger.severe("获取失败" + e.getMessage());
        }
        return orders;
    }

    //根据id获取订单
    public Order getOrderById(int orderId) {
        String sql = "SELECT o.*, c.username, c.email FROM orders o JOIN customers c ON o.customer_id = c.id WHERE o.id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1,orderId);
            ResultSet  rs = stmt.executeQuery();

            if (rs.next()){
                Order order = extractOrder(rs);

                // 设置顾客信息
                Customer customer = new Customer();
                customer.setUsername(rs.getString("username"));
                customer.setEmail(rs.getString("email"));
                order.setCustomer(customer);

                // 获取订单项
                order.setItems(getOrderItems(orderId));

                return order;
            }
        } catch (SQLException e) {
            logger.severe("获取失败" + e.getMessage());
        }
        return null;
    }

    //获取所有订单（管理员用）
    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, c.username, c.email FROM orders o JOIN customers c ON o.customer_id = c.id ORDER BY o.order_date DESC";

        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()){
                Order order = extractOrder(rs);

                // 设置顾客信息
                Customer customer = new Customer();
                customer.setUsername(rs.getString("username"));
                customer.setEmail(rs.getString("email"));
                order.setCustomer(customer);

                orders.add(order);
            }
            logger.info("获取所有订单");

        } catch (SQLException e) {
            logger.severe("获取失败" + e.getMessage());
        }
        return orders;
    }

    //更新订单状态
    public boolean updateOrderStatus(int orderId,String status) {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1,status);
            stmt.setInt(2,orderId);

            int rows = stmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            logger.severe("更新失败" + e.getMessage());
            return false;
        }
    }

    //获取订单项
    private List<OrderItem> getOrderItems(int orderId) {
        List<OrderItem> items = new ArrayList<>();
        String sql = "SELECT oi.*, p.name, p.description, p.image_url FROM order_items oi JOIN products p ON oi.product_id = p.id WHERE oi.order_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1,orderId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()){
                OrderItem item = new OrderItem();

                item.setId(rs.getInt("id"));
                item.setOrderId(rs.getInt("order_id"));
                item.setProductId(rs.getInt("product_id"));
                item.setQuantity(rs.getInt("quantity"));
                item.setUnitPrice(rs.getDouble("unit_price"));

                //设置商品信息
                Product product = new Product();

                product.setName(rs.getString("name"));
                product.setDescription(rs.getString("description"));
                product.setImageUrl(rs.getString("image_url"));
                item.setProduct(product);

                items.add(item);
            }
        } catch (SQLException e) {
            logger.severe("获取失败" + e.getMessage());
        }
        return items;
    }

    //从结果集提取Order对象
    private Order extractOrder(ResultSet rs) throws SQLException{
        Order order = new Order();

        order.setId(rs.getInt("id"));
        order.setCustomerId(rs.getInt("customer_id"));
        order.setOrderDate(rs.getTimestamp("order_date"));
        order.setTotalAmount(rs.getDouble("total_amount"));
        order.setStatus(rs.getString("status"));
        order.setShippingAddress(rs.getString("shipping_address"));
        order.setPaymentMethod(rs.getString("payment_method"));
        return order;
    }

    //获取销售统计
    public double getTotalSales() {
        String sql = "SELECT SUM(total_amount) as total FROM orders WHERE status IN ('paid', 'shipped', 'delivered')";

        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            if(rs.next()){
                return rs.getDouble("total");
            }
        } catch (SQLException e) {
            logger.severe("获取失败" + e.getMessage());
        }
        return 0;
    }

    //获取订单数量统计
    public int getOrderCount(){
        String sql = "SELECT COUNT(*) as count FROM orders";

        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            if(rs.next()){
                return rs.getInt("count");
            }
        } catch (SQLException e) {
            logger.severe("获取失败" + e.getMessage());
        }
        return 0;
    }
}
