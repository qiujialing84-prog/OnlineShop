package com.onlineshop.dao;

import com.onlineshop.model.Customer;
import com.onlineshop.model.Product;
import java.util.List;

public class DAOTest {
    public static void main(String[] args) {
        System.out.println("=== 开始测试DAO层 ===");

        // 测试ProductDAO
        ProductDAO productDAO = new ProductDAO();

        // 测试获取所有商品
        System.out.println("\n1. 测试获取所有商品：");
        List<Product> products = productDAO.getAllProducts();
        if (products.isEmpty()) {
            System.out.println("   ⚠️ 没有获取到商品，请检查数据库");
        } else {
            System.out.println("   ✅ 成功获取到 " + products.size() + " 个商品");
            for (Product p : products) {
                System.out.println("      - " + p.getName() + " ￥" + p.getPrice());
            }
        }

        // 测试根据ID获取商品
        System.out.println("\n2. 测试根据ID获取商品：");
        if (!products.isEmpty()) {
            Product p = productDAO.getProductById(1);
            if (p != null) {
                System.out.println("   ✅ 成功获取商品: " + p.getName());
            } else {
                System.out.println("   ❌ 根据ID获取商品失败");
            }
        }

        // 测试CustomerDAO
        CustomerDAO customerDAO = new CustomerDAO();

        // 测试检查用户名
        System.out.println("\n3. 测试检查用户名是否存在：");
        boolean exists = customerDAO.isUsernameExists("testuser");
        System.out.println("   " + (exists ? "⚠️ 用户名已存在" : "✅ 用户名可用"));

        // 测试注册用户
        System.out.println("\n4. 测试用户注册：");
        Customer testCustomer = new Customer("testuser", "test123", "test@example.com");
        testCustomer.setPhone("13800138000");
        testCustomer.setAddress("测试地址");

        // 先检查是否已存在
        if (!customerDAO.isUsernameExists("testuser")) {
            boolean registered = customerDAO.register(testCustomer);
            System.out.println("   " + (registered ? "✅ 用户注册成功" : "❌ 用户注册失败"));
        } else {
            System.out.println("   ⚠️ 测试用户已存在，跳过注册");
        }

        // 测试登录
        System.out.println("\n5. 测试用户登录：");
        Customer loggedInCustomer = customerDAO.login("testuser", "test123");
        if (loggedInCustomer != null) {
            System.out.println("   ✅ 登录成功: " + loggedInCustomer.getUsername());
            System.out.println("      邮箱: " + loggedInCustomer.getEmail());
        } else {
            System.out.println("   ❌ 登录失败，用户名或密码错误");
        }

        System.out.println("\n=== DAO测试完成 ===");
    }
}
