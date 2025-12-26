//用户的数据访问层，实现用户注册登录功能
package com.onlineshop.dao;

import com.onlineshop.model.Customer;
import com.onlineshop.util.DBUtil;
import java.sql.*;
import java.util.logging.Logger;


public class CustomerDAO {
    private static final Logger logger = Logger.getLogger(CustomerDAO.class.getName());

    //用户注册
    public boolean register(Customer customer){
        String sql = "INSERT INTO customers (username,password,email,phone,address) VALUES (?,?,?,?,?)";

        try(Connection conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1,customer.getUsername());
            stmt.setString(2,customer.getPassword());
            stmt.setString(3, customer.getEmail());
            stmt.setString(4, customer.getPhone());
            stmt.setString(5, customer.getAddress());

            int rows = stmt.executeUpdate();
            return rows > 0;
        }catch (SQLException e){
            logger.severe("注册失败：" + e.getMessage());
            return false;
        }
    }

    //用户登录
    public Customer login(String username,String password){
        String sql = "SELECT * FROM customers WHERE username = ? AND password = ?";
        try(Connection conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1,username);
            stmt.setString(2,password);

            ResultSet rs = stmt.executeQuery();
            if(rs.next()){
                return extractCustomer(rs);
            }

        }catch (SQLException e){
            logger.severe("用户登录失败：" + e.getMessage());
        }
        return null;
    }

    // 删除用户（根据用户名）
    public boolean deleteCustomerByUsername(String username) {
        String sql = "DELETE FROM customers WHERE username = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, username);
            int rows = stmt.executeUpdate();

            if (rows > 0) {
                logger.info("成功删除用户: " + username);
                return true;
            } else {
                logger.warning("未找到要删除的用户: " + username);
                return false;
            }

        } catch (SQLException e) {
            logger.severe("删除用户失败 (" + username + "): " + e.getMessage());
            return false;
        }
    }

    //检查用户名是否存在
    public boolean isUsernameExists(String username){
        String sql = "SELECT id FROM customers WHERE username = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1,username);
            ResultSet rs = stmt.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            logger.severe("检查用户名失败：" + e.getMessage());
        }
        return false;
    }

    //检查邮箱是否存在
    public boolean isEmailExists(String email){
        String sql = "SELECT id FROM customers WHERE email = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1,email);
            ResultSet rs = stmt.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            logger.severe("检查邮箱失败：" + e.getMessage());
        }
        return false;
    }

    //从结果集提取Customer对象
    private Customer extractCustomer(ResultSet rs) throws SQLException{
        Customer customer = new Customer();
        customer.setId(rs.getInt("id"));
        customer.setUsername(rs.getString("username"));
        customer.setPassword(rs.getString("password"));
        customer.setEmail(rs.getString("email"));
        customer.setPhone(rs.getString("phone"));
        customer.setAddress(rs.getString("address"));
        customer.setRegistrationDate(rs.getTimestamp("registration_date"));
        return customer;
    }
}
