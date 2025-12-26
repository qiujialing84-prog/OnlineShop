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
import java.util.logging.Logger;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(LoginServlet.class.getName());
    private CustomerDAO customerDAO;

    @Override
    public void init() throws ServletException{
        super.init();
        customerDAO = new CustomerDAO();
        logger.info("loginServlet初始化完成");
    }

    @Override
    public void doGet(HttpServletRequest request,HttpServletResponse response) throws ServletException,IOException {
        //显示登录界面
        request.getRequestDispatcher("login.jsp").forward(request,response);
    }

    @Override
    protected void doPost(HttpServletRequest request,HttpServletResponse response) throws ServletException,IOException {
        //获取表单参数
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        logger.info("受到登录请求");

        //验证输入
        if((username == null || username.trim().isEmpty())||(password == null || password.trim().isEmpty())) {
            request.setAttribute("error","用户名或密码不能为空");
            request.getRequestDispatcher("/login.jsp").forward(request,response);
            return;
        }

        //验证用户登录
        Customer customer = customerDAO.login(username.trim(),password.trim());
        if(customer != null){
            //登陆成功，创建session
            HttpSession session = request.getSession();
            session.setAttribute("customer",customer);
            session.setMaxInactiveInterval(-1);//永不超时

            logger.info("用户登录成功：" + username);
            response.sendRedirect(request.getContextPath() + "/products");  //进入商品列表界面
        }else{
            //登录失败
            logger.warning("登录失败");
            request.setAttribute("error","用户名或密码错误");
            request.setAttribute("username",username);   //保留用户名
            request.getRequestDispatcher("/login.jsp").forward(request,response);
        }
    }
}
