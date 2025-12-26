package com.onlineshop.controller;

import com.onlineshop.dao.ProductDAO;
import com.onlineshop.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;

@WebServlet("/products")
public class ProductServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(ProductServlet.class.getName());
    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException{
        super.init();
        productDAO = new ProductDAO();
        logger.info("ProductServlet初始化完成");
    }

    @Override
    public void doGet(HttpServletRequest request,HttpServletResponse response) throws ServletException, IOException{
        logger.info("收到商品列表请求");

        try{
            //从数据库获得所有商品
            List<Product> products = productDAO.getAllProducts();

            //将商品放入request属性
            request.setAttribute("products",products);
            logger.info("设置products属性，共" + products.size() + "个商品");

            //转发到商品列表界面
            request.getRequestDispatcher("/product-list.jsp").forward(request,response);
            logger.info("转发到商品列表界面");
        } catch (Exception e) {
            logger.severe("获取商品列表失败: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "获取商品列表失败");
        }
    }
}
