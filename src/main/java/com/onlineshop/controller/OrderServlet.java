package com.onlineshop.controller;

import com.onlineshop.dao.OrderDAO;
import com.onlineshop.model.Customer;
import com.onlineshop.model.Order;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.eclipse.tags.shaded.org.apache.xpath.operations.Or;

import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;

@WebServlet("/orders")
public class OrderServlet extends HttpServlet{
    private static final Logger logger = Logger.getLogger(OrderServlet.class.getName());
    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException{
        super.init();
        orderDAO = new OrderDAO();
        logger.info("初始化成功");
    }

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("customer") == null){
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Customer customer = (Customer) session.getAttribute("customer");
        String action = request.getParameter("action");
        String orderIdParam = request.getParameter("id");

        if (orderIdParam != null && !orderIdParam.isEmpty()){
            //查看单个订单详情
            viewOrderDetail(request, response, customer, orderIdParam);
        }else if("all".equals(action) && isAdmin(customer)){
            //管理员查看所有订单
            viewAllOrders(request, response);
        }else {
            //查看当前用户订单
            viewUserOrders(request,response,customer);
        }
    }

    //查看用户订单
    private void viewUserOrders(HttpServletRequest request, HttpServletResponse response, Customer customer) throws ServletException, IOException{
        List<Order> orders = orderDAO.getOrdersByCustomer(customer.getId());

        request.setAttribute("orders",orders);
        request.setAttribute("orderCount",orders.size());

        double totalSpent = 0;
        for (Order order : orders){
            if ("delivered".equals(order.getStatus())){
                totalSpent += order.getTotalAmount();
            }
        }
        request.setAttribute("totalSpent", totalSpent);

        request.getRequestDispatcher("/orders.jsp").forward(request,response);
        logger.info("查看用户订单，customerId" + customer.getId() + "，订单数" + orders.size());
    }

    //查看订单详情
    private void viewOrderDetail(HttpServletRequest request, HttpServletResponse response, Customer customer, String orderIdParam) throws ServletException, IOException{
        try {
            int orderId = Integer.parseInt(orderIdParam);
            Order order = orderDAO.getOrderById(orderId);

            if (order == null){
                response.sendRedirect(request.getContextPath() + "/orders?error=订单不存在");
                return;
            }

            //检查权限
            if (!isAdmin(customer) && order.getCustomerId() != customer.getId()){
                response.sendRedirect(request.getContextPath() + "/orders?error=无权限");
                return;
            }

            request.setAttribute("order",order);
            request.setAttribute("orderItems",order.getItems());

            request.getRequestDispatcher("/order-detail.jsp").forward(request, response);

            logger.info("查看订单详情，orderId" + orderId);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/orders?error=参数错误");
        }
    }

    //管理员查看订单
    private void viewAllOrders(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        List<Order> orders = orderDAO.getAllOrders();
        double totalSales = orderDAO.getTotalSales();
        int orderCount = orderDAO.getOrderCount();

        request.setAttribute("orders",orders);
        request.setAttribute("totalSales",totalSales);
        request.setAttribute("orderCount",orderCount);
        request.setAttribute("isAdminView",true);

        request.getRequestDispatcher("/orders.jsp").forward(request,response);
        logger.info("管理员查看，订单数" + orderCount + "销售额" + totalSales);
    }

    //检查是否为管理员
    private boolean isAdmin(Customer customer){
        return "admin".equals(customer.getUsername());
    }
}
