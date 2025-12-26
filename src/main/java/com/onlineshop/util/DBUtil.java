package com.onlineshop.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {
    private static final String URL = "jdbc:mysql://localhost:3306/onlineshop?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai&useSSL=false";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "20050608Aaa";

    //静态代码块
    static {
        try {
            //加载MySQL驱动
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("MySQL驱动加载成功");

        } catch (ClassNotFoundException e) {
            System.out.println("MySQL驱动加载失败");
            e.printStackTrace();
        }
    }

    //获取数据库连接
    public static Connection getConnection(){
        Connection conn = null;
        try{
            conn = DriverManager.getConnection(URL,USERNAME,PASSWORD);
            System.out.println("连接成功");
            return conn;
        } catch (SQLException e) {
            System.out.println("连接失败");
            return null;
        }
    }

    public static void closeConnection(Connection conn){
        if(conn!=null){
            try{
                conn.close();;
                System.out.println("连接关闭");
            } catch (SQLException e) {
                System.out.println("关闭连接失败：" + e.getMessage());

            }
        }
    }


    // 测试方法
    public static void main(String[] args) {
        System.out.println("=== 开始测试数据库连接 ===");
        System.out.println("使用的配置：");
        System.out.println("URL: " + URL);
        System.out.println("用户名: " + USERNAME);
        System.out.println("密码: " + PASSWORD);
        System.out.println("------------------------");

        Connection conn = getConnection();
        if (conn != null) {
            System.out.println("数据库连接测试成功");
            closeConnection(conn);
        } else {
            System.out.println("连接失败，请检查以上配置");
        }
        System.out.println("=== 测试结束 ===");
    }
}
