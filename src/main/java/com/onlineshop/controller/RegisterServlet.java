package com.onlineshop.controller;

import com.onlineshop.dao.CustomerDAO;
import com.onlineshop.model.Customer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Objects;
import java.util.logging.Logger;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet{
    private static final Logger logger = Logger.getLogger(RegisterServlet.class.getName());
    private CustomerDAO customerDAO;

    @Override
    public void init() throws ServletException{
        super.init();
        customerDAO = new CustomerDAO();
        logger.info("RegisterServlet初始化完成");
    }

    @Override
    public void doGet(HttpServletRequest request,HttpServletResponse response) throws ServletException,IOException{
        //显示注册界面
        request.getRequestDispatcher("/register.jsp").forward(request,response);
    }

    @Override
    protected void doPost(HttpServletRequest request,HttpServletResponse response) throws ServletException,IOException{
        //获取注册界面表单数据
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        logger.info("收到注册请求：" + username);

        //验证输入
        if(username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty() || email == null || email.trim().isEmpty()){
            request.setAttribute("error","用户名、密码、邮件不能为空");
            request.getRequestDispatcher("/register.jsp").forward(request,response);
            return;
        }

        //验证密码确认
        if(!Objects.equals(confirmPassword, password)){
            request.setAttribute("error","两次输入不一致");
            request.setAttribute("username",username);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.setAttribute("address", address);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        //检查用户名是否已存在
        if(customerDAO.isUsernameExists(username)){
            request.setAttribute("error","用户名已存在");
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.setAttribute("address", address);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // 检查邮箱是否已存在
        if (customerDAO.isEmailExists(email)) {
            request.setAttribute("error", "邮箱已被注册");
            request.setAttribute("username", username);
            request.setAttribute("phone", phone);
            request.setAttribute("address", address);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        //创建用户对象
        Customer customer = new Customer();
        customer.setUsername(username.trim());
        customer.setPassword(password.trim());
        customer.setEmail(email.trim());
        customer.setPhone(phone != null ?phone.trim() : "");
        customer.setAddress(address != null ?address.trim() : "");

        //保存到数据库
        boolean success = customerDAO.register(customer);

        if(success){
            logger.info("用户注册成功：" + username);
            response.sendRedirect(request.getContextPath() + "/login");
        }else{
            logger.warning("用户注册失败: " + username);
            request.setAttribute("error", "注册失败，请重试");
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.setAttribute("address", address);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
}
