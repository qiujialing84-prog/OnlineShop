package com.onlineshop.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.logging.Logger;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(LogoutServlet.class.getName());

    @Override
    public void init() throws ServletException{
        super.init();
        logger.info("LoginServlet初始化完成");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String username = "未知用户";

        if (session != null) {
            Object customerObj = session.getAttribute("customer");
            if (customerObj != null && customerObj instanceof com.onlineshop.model.Customer) {
                username = ((com.onlineshop.model.Customer) customerObj).getUsername();
            }
            session.invalidate(); // 销毁session
            logger.info("退出登录: " + username);
        }
        response.sendRedirect(request.getContextPath() + "/login?message=已成功退出");
    }
}