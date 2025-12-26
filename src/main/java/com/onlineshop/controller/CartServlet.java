package com.onlineshop.controller;

import com.onlineshop.dao.CartDAO;
import com.onlineshop.dao.OrderDAO;
import com.onlineshop.dao.ProductDAO;
import com.onlineshop.model.CartItem;
import com.onlineshop.model.Customer;
import com.onlineshop.model.Order;
import com.onlineshop.util.EmailUtil;
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

@WebServlet("/cart")
public class CartServlet extends HttpServlet{
    private static final Logger logger = Logger.getLogger(CartServlet.class.getName());
    private CartDAO cartDAO;
    private ProductDAO productDAO;
    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException{
        super.init();
        cartDAO = new CartDAO();
        productDAO = new ProductDAO();
        orderDAO = new OrderDAO();
        logger.info("CartServlet初始化成功");
    }

    @Override
    protected void doGet(HttpServletRequest request,HttpServletResponse response) throws ServletException, IOException{
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("customer") == null){
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        Customer customer = (Customer) session.getAttribute("customer");
        String action = request.getParameter("action");
        
        if ("view".equals(action) || action == null){
            //查看购物车
            viewCart(request,response,customer);
        } else if ("checkout".equals(action)) {
            //结算界面
            checkout(request,response,customer);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,HttpServletResponse response) throws ServletException, IOException{
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("customer") == null){
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Customer customer = (Customer) session.getAttribute("customer");
        String action = request.getParameter("action");

        if("add".equals(action)){
            //添加商品到购物车
            addToCart(request, response, customer);
        } else if ("update".equals(action)) {
            //更新购物车数量
            updateCart(request, response, customer);
        } else if ("remove".equals(action)) {
            //从购物车移除商品
            removeFromCart(request, response, customer);
        } else if ("place".equals(action)) {
            //提交订单
            placeOrder(request, response, customer);
        }
    }

    //查看购物车
    private void viewCart(HttpServletRequest request, HttpServletResponse response, Customer customer) throws ServletException, IOException{
        List<CartItem> cartItems = cartDAO.getCartItems(customer.getId());
        double total = 0;

        for (CartItem item : cartItems){   //遍历
            total += item.getSubtotal();
        }

        request.setAttribute("cartItems",cartItems);
        request.setAttribute("cartTotal",total);
        request.setAttribute("itemCount",cartItems.size());

        request.getRequestDispatcher("/cart.jsp").forward(request,response);
        logger.info("查看购物车，customerId" + customer.getId());
    }

    //添加商品到购物车
    private void addToCart(HttpServletRequest request,HttpServletResponse response,Customer customer) throws IOException{
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            //检查商品库存
            var product = productDAO.getProductById(productId);
            if (product == null){
                response.sendRedirect(request.getContextPath() + "/products?error=商品不存在");
                return;
            }

            //检查商品库存是否足够
            int currentCartQuantity = getCartQuantity(customer.getId(),productId);
            if (currentCartQuantity + quantity > product.getStockQuantity()){
                response.sendRedirect(request.getContextPath() + "/products?error=库存不足");
                return;
            }

            boolean success = cartDAO.addToCart(customer.getId(), productId, quantity);
            if (success){
                response.sendRedirect(request.getContextPath() + "/cart?action=view");
            }else {
                response.sendRedirect(request.getContextPath() + "/products?error=添加失败");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/products?error=参数错误");
        }
    }

    //更新购物车数量
    private void updateCart(HttpServletRequest request, HttpServletResponse response, Customer customer) throws IOException{
        try{
            int cartId = Integer.parseInt(request.getParameter("cartId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            //检查库存
            CartItem cartItem = getCartItemById(cartId,customer.getId());
            if (cartItem != null){
                var product = productDAO.getProductById(cartItem.getProductId());
                if (quantity > product.getStockQuantity()){
                    response.sendRedirect(request.getContextPath() + "/cart?action=view&error=库存不足");
                    return;
                }
            }

            boolean success = cartDAO.updateCartQuantity(cartId, quantity);
            response.sendRedirect(request.getContextPath() + "/cart?action=view");

        } catch(NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/cart?action=view&error=参数错误");
        }
    }

    //从购物车移除商品
    private void removeFromCart(HttpServletRequest request, HttpServletResponse response, Customer customer) throws IOException{
        try {
            int cartId = Integer.parseInt(request.getParameter("cartId"));
            boolean success = cartDAO.deleteCartItem(cartId);
            response.sendRedirect(request.getContextPath() + "/cart?action=view");
        }catch (NumberFormatException e){
            response.sendRedirect(request.getContextPath() + "/cart?action=view&error=参数错误");
        }
    }

    //结算界面
    private void checkout(HttpServletRequest request, HttpServletResponse response, Customer customer) throws ServletException, IOException{
        List<CartItem> cartItems = cartDAO.getCartItems(customer.getId());
        if (cartItems.isEmpty()){
            response.sendRedirect(request.getContextPath() + "/cart?action=view&error=购物车为空");
            return;
        }

        double total = 0;
        for (CartItem item : cartItems){
            total += item.getSubtotal();
        }

        request.setAttribute("cartItems",cartItems);
        request.setAttribute("totalAmount",total);
        request.setAttribute("customer",customer);

        request.getRequestDispatcher("/checkout.jsp").forward(request, response);
        logger.info("进入结算界面，customerId" + customer.getId());
    }

    //提交订单
    private void placeOrder(HttpServletRequest request,HttpServletResponse response,Customer customer) throws ServletException,IOException{
        String shippingAddress = request.getParameter("shippingAddress");
        String paymentMethod = request.getParameter("paymentMethod");

        if (shippingAddress == null || shippingAddress.trim().isEmpty()){
            shippingAddress = customer.getAddress();
            if (shippingAddress == null || shippingAddress.trim().isEmpty()){
                request.setAttribute("error", "请填写收货地址");
                checkout(request,response,customer);
                return;
            }
        }

        List<CartItem> cartItems = cartDAO.getCartItems(customer.getId());
        if (cartItems.isEmpty()){
            response.sendRedirect(request.getContextPath() + "/cart?action=view&error=购物车为空");
            return;
        }

        //计算总金额
        double total = 0;
        for (CartItem item : cartItems){
            total += item.getSubtotal();
        }

        //创建订单
        Order order = new Order();
        order.setCustomerId(customer.getId());
        order.setTotalAmount(total);
        order.setShippingAddress(shippingAddress);
        order.setPaymentMethod(paymentMethod);
        order.setStatus("paid");

        int orderId = orderDAO.createOrder(order, cartItems);

        if (orderId > 0){
            logger.info("订单创建成功，orderId" + orderId + ",customerId" + customer.getId());

            boolean email = EmailUtil.sendShippingNotification(customer.getEmail());
            if(email){logger.info("邮件发送成功");}
            else {logger.info("邮件发送失败");}

            request.setAttribute("orderId", orderId);
            request.setAttribute("totalAmount",total);
            request.getRequestDispatcher("/order-success.jsp").forward(request,response);


        }else {
            request.setAttribute("error", "订单创建失败");
            checkout(request,response,customer);
        }
    }

    //获取购物车中某商品的数量
    private int getCartQuantity(int customerId, int productId){
        List<CartItem> cartItems = cartDAO.getCartItems(customerId);
        for (CartItem item : cartItems){
            if (item.getProductId() == productId){
                return item.getQuantity();
            }
        }
        return 0;
    }

    //根据id获取购物车项
    private CartItem getCartItemById(int cartId,int customerId){
        List<CartItem> cartItems = cartDAO.getCartItems(customerId);
        for(CartItem item : cartItems){
            if (item.getId() == cartId){
                return item;
            }
        }
        return null;
    }
}
