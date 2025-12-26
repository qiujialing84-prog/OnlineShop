package com.onlineshop.controller;

import com.onlineshop.dao.OrderDAO;
import com.onlineshop.dao.ProductDAO;
import com.onlineshop.model.Customer;
import com.onlineshop.model.Order;
import com.onlineshop.model.Product;
import com.onlineshop.util.EmailUtil;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.eclipse.tags.shaded.org.apache.xpath.operations.Or;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.logging.Logger;

import static com.onlineshop.util.EmailUtil.sendShippingNotification;

@WebServlet("/admin/*")
@MultipartConfig(
        fileSizeThreshold = 1024*1024,//1MB
        maxFileSize = 1024*1024*5,//5MB
        maxRequestSize = 1024*1024*10//10MB
)
public class AdminServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(AdminServlet.class.getName());
    private ProductDAO productDAO;
    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException{
        super.init();
        productDAO = new ProductDAO();
        orderDAO = new OrderDAO();
        logger.info("初始化成功");
    }

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        //检查管理员权限
        if (!checkAdmin(request,response)){
            return;
        }

        String pathInfo = request.getPathInfo();
        String action = request.getParameter("action");

         if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/products")){
            //商品管理
            if ("add".equals(action)){
                showAddProductForm(request,response);
            }else if ("edit".equals(action)){
                showEditProductForm(request,response);
            }else {
                listProducts(request,response);
            }
        }else if(pathInfo.equals("/orders")){
            //订单管理
            manageOrders(request,response);
        }else if (pathInfo.equals("/dashboard")){
            //统计报表
            showDashboard(request,response);
        }
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        // 检查管理员权限
        if (!checkAdmin(request, response)) {
            return;
        }

        String pathInfo = request.getPathInfo();
        String action = request.getParameter("action");

        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/products")){
            //商品管理
            if ("add".equals(action)){
                addProduct(request,response);
            }else if ("edit".equals(action)){
                updateProduct(request,response);
            }else if ("delete".equals(action)){
                deleteProduct(request,response);
            }
        }else if (pathInfo.equals("/orders")){
            //订单管理
            if("update".equals(action)){
                updateOrderStatus(request,response);
            }
        }
    }

    //检查管理员权限
    private boolean checkAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        System.out.println("=== 检查管理员权限 ===");

        HttpSession session = request.getSession(false);
        if (session == null) {
            System.out.println("没有session，重定向到登录");
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }

        Customer customer = (Customer) session.getAttribute("customer");
        if (customer == null) {
            System.out.println("session中没有customer，重定向到登录");
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }

        boolean isAdmin = "admin".equals(customer.getUsername());
        System.out.println("用户名: " + customer.getUsername() + ", 是管理员: " + isAdmin);

        if (!isAdmin) {
            System.out.println("不是管理员，重定向到首页");
            response.sendRedirect(request.getContextPath() + "/");
            return false;
        }

        System.out.println("权限检查通过");
        return true;
    }

    //显示商品列表
    private void listProducts(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        List<Product> products = productDAO.getAllProducts();
        request.setAttribute("products",products);
        request.setAttribute("productsCount",products.size());

        request.getRequestDispatcher("/admin/products.jsp").forward(request,response);
        logger.info("查看商品列表：" + products.size() + "个商品");
    }

    //显示添加商品表单
    private void showAddProductForm(HttpServletRequest request,HttpServletResponse response) throws ServletException,IOException{
        request.getRequestDispatcher("/admin/product-form.jsp").forward(request,response);
    }

    //显示编辑商品表单
    private void showEditProductForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        try{
            int id = Integer.parseInt(request.getParameter("id"));
            Product product = productDAO.getProductById(id);

            if (product == null){
                response.sendRedirect(request.getContextPath() + "/admin/products?error=商品不存在");
                return;
            }

            request.setAttribute("product",product);
            request.getRequestDispatcher("/admin/product-form.jsp").forward(request,response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/products?error=参数错误");
        }
    }

    //添加商品
    private void addProduct(HttpServletRequest request, HttpServletResponse response) throws ServletException,IOException{
        try {
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            double price = Double.parseDouble(request.getParameter("price"));
            int stockQuantity = Integer.parseInt(request.getParameter("stockQuantity"));
            String category = request.getParameter("category");

            //处理图片上传
            String imageUrl = handleImageUpload(request);
            if(imageUrl == null){
                imageUrl = "https://via.placeholder.com/300x200?text=商品图片";
            }

            Product product = new Product();
            product.setName(name);
            product.setDescription(description);
            product.setPrice(price);
            product.setStockQuantity(stockQuantity);
            product.setCategory(category);
            product.setImageUrl(imageUrl);

            boolean success = productDAO.addProduct(product);

            if(success){
                logger.info("商品添加成功：" + name);
                response.sendRedirect(request.getContextPath() + "/admin/products?success=添加成功");
            }else {
                request.setAttribute("error", "添加失败");
                request.setAttribute("product", product);
                request.getRequestDispatcher("/admin/product-form.jsp").forward(request, response);
            }
        } catch (Exception e) {
            logger.severe("添加失败：" + e.getMessage());
            request.setAttribute("error","添加失败：" + e.getMessage());
            request.getRequestDispatcher("/admin/product-form.jsp").forward(request,response);
        }
    }

    //更新商品
    private void updateProduct(HttpServletRequest request,HttpServletResponse response) throws  ServletException, IOException{
        try{
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            double price = Double.parseDouble(request.getParameter("price"));
            int stockQuantity = Integer.parseInt(request.getParameter("stockQuantity"));
            String category = request.getParameter("category");

            Product product = new Product();
            product.setId(id);
            product.setName(name);
            product.setDescription(description);
            product.setPrice(price);
            product.setStockQuantity(stockQuantity);
            product.setCategory(category);

            //新图片
            Part filepart = request.getPart("image");
            if (filepart != null && filepart.getSize() > 0){
                String imageUrl = handleImageUpload(request);
                if (imageUrl != null){
                    product.setImageUrl(imageUrl);
                }
            }

            boolean success = productDAO.addProduct(product);

            if (success){
                logger.info("更新成功：id" + id);
                response.sendRedirect(request.getContextPath() + "/admin/products?success=更新成功");
            }else {
                request.setAttribute("error","更新失败");
                request.setAttribute("product",product);
                request.getRequestDispatcher("/admin/product-form.jsp").forward(request,response);
            }
        }catch (Exception e){
            logger.severe("失败：" + e.getMessage());
            request.setAttribute("error","失败：" + e.getMessage());
            request.getRequestDispatcher("/admin/product-form.jsp").forward(request,response);
        }
    }

    //删除商品
    private void deleteProduct(HttpServletRequest request,HttpServletResponse response) throws IOException{
        try{
            int id = Integer.parseInt(request.getParameter("id"));
            boolean success = productDAO.deleteProduct(id);

            if (success){
                logger.info("删除成功");
                response.sendRedirect(request.getContextPath() + "/admin/products?success=删除成功");
            }else {
                response.sendRedirect(request.getContextPath() + "/admin/products?error=删除失败");
            }
        }catch (NumberFormatException e){
            response.sendRedirect(request.getContextPath() + "/admin/products?error=参数错误");
        }
    }

    //管理订单
    private void manageOrders(HttpServletRequest request,HttpServletResponse response) throws ServletException,IOException{
        List<Order> orders = orderDAO.getAllOrders();
        double totalSales = orderDAO.getTotalSales();
        int orderCount = orderDAO.getOrderCount();

        request.setAttribute("orders",orders);
        request.setAttribute("totalSales",totalSales);
        request.setAttribute("orderCount",orderCount);
        request.setAttribute("isAdminView",true);

        request.getRequestDispatcher("/admin/orders.jsp").forward(request,response);
        logger.info("管理" + orderCount + "个订单");
    }

    //更新订单状态
    private void updateOrderStatus(HttpServletRequest request,HttpServletResponse response) throws IOException{
        try{
            int orderId = Integer.parseInt(request.getParameter("id"));
            String status = request.getParameter("status");

            boolean success = orderDAO.updateOrderStatus(orderId,status);

            if (success){
                logger.info("更新成功：orderId" + orderId + "，status" + status);

                //发货
                if ("shipped".equals(status)){
                    sendShipping(orderId);
                }

                response.sendRedirect(request.getContextPath() + "/admin/orders?success=更新成功");
            }else {
                response.sendRedirect(request.getContextPath() + "/admin/orders?error=更新失败");
            }
        }catch (Exception e){
            logger.severe("失败：" + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/orders?error=" + e.getMessage());
        }
    }

    //邮件发送
    private void sendShipping(int orderId){
        try {
            Order order = orderDAO.getOrderById(orderId);
            if (order != null && order.getCustomer() != null){
                boolean emailSent = EmailUtil.sendShippingNotification(order.getCustomer().getEmail());

                if (emailSent) {
                    logger.info("发货通知邮件已发送: orderId=" + orderId + ", email=" + order.getCustomer().getEmail());
                } else {
                    logger.warning("发货通知邮件发送失败: orderId=" + orderId);
                }
            }
        } catch (Exception e) {
            logger.severe("发送发货通知邮件时出错: " + e.getMessage());
        }
    }

    //显示统计报表
    private void showDashboard(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("=== 进入 showDashboard 方法 ===");

        try {
            // 检查响应状态
            System.out.println("响应是否已提交: " + response.isCommitted());

            if (response.isCommitted()) {
                System.out.println("响应已提交，无法转发");
                return;
            }

            // 获取数据
            double totalSales = orderDAO.getTotalSales();
            int orderCount = orderDAO.getOrderCount();
            int productCount = productDAO.getAllProducts().size();
            List<Order> orders = orderDAO.getAllOrders();

            // 计算统计数据
            int pendingOrders = 0;
            int shippedOrders = 0;
            for (Order order : orders) {
                String status = order.getStatus();
                if ("pending".equals(status)) {
                    pendingOrders++;
                } else if ("shipped".equals(status)) {
                    shippedOrders++;
                }
            }

            // 设置属性
            request.setAttribute("totalSales", totalSales);
            request.setAttribute("orderCount", orderCount);
            request.setAttribute("productCount", productCount);
            request.setAttribute("pendingOrders", pendingOrders);
            request.setAttribute("shippedOrders", shippedOrders);
            request.setAttribute("orders", orders);

            // 设置dashboard.jsp需要的属性（用于layout.jsp）
            request.setAttribute("pageTitle", "仪表盘");
            request.setAttribute("contentPage", "dashboard-content.jsp"); // 注意：这里使用相对路径，因为layout.jsp在admin目录下

            // 调试信息
            System.out.println("数据设置完成:");
            System.out.println("  totalSales: " + totalSales);
            System.out.println("  orderCount: " + orderCount);
            System.out.println("  productCount: " + productCount);

            // 检查JSP文件是否存在
            String jspPath = "/admin/dashboard.jsp";
            String realPath = getServletContext().getRealPath(jspPath);
            System.out.println("JSP路径: " + jspPath);
            System.out.println("实际路径: " + realPath);

            File jspFile = new File(realPath);
            if (!jspFile.exists()) {
                System.out.println("错误：JSP文件不存在！");
                response.getWriter().println("JSP文件不存在: " + realPath);
                return;
            }
            System.out.println("JSP文件存在，可以转发");

            // 获取RequestDispatcher
            RequestDispatcher dispatcher = request.getRequestDispatcher(jspPath);
            if (dispatcher == null) {
                System.out.println("错误：RequestDispatcher为null！");
                response.getWriter().println("RequestDispatcher为null，路径可能错误: " + jspPath);
                return;
            }

            System.out.println("准备转发到: " + jspPath);

            // 转发
            dispatcher.forward(request, response);

            System.out.println("转发完成");

        } catch (Exception e) {
            System.err.println("showDashboard 异常: " + e.getMessage());
            e.printStackTrace();

            if (!response.isCommitted()) {
                response.setContentType("text/html;charset=UTF-8");
                java.io.PrintWriter out = response.getWriter();
                out.println("<html><body>");
                out.println("<h1>showDashboard异常</h1>");
                out.println("<pre>");
                e.printStackTrace(out);
                out.println("</pre>");
                out.println("</body></html>");
            }
        }
    }

    //处理图片上传
    private String handleImageUpload(HttpServletRequest request) throws ServletException,IOException{
        Part filePart = request.getPart("image");
        if (filePart == null || filePart.getSize() == 0){
            return null;
        }

        //获取上传的文件名
        String fileName = filePart.getSubmittedFileName();
        if (fileName == null || fileName.isEmpty()){
            return null;
        }

        //生成新文件名
        String fileExtension = "";
        int dotIndex = fileName.lastIndexOf(".");
        if (dotIndex > 0){
            fileExtension = fileName.substring(dotIndex);
        }
        String newFileName = UUID.randomUUID().toString() + fileExtension;

        //保存文件到服务器
        String uploadPath = getServletContext().getRealPath("") + "upload";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()){
            uploadDir.mkdirs();
        }

        File file = new File(uploadDir,newFileName);
        try(InputStream input = filePart.getInputStream()) {
            Files.copy(input,file.toPath(),StandardCopyOption.REPLACE_EXISTING);
        }

        //返回URL
        return request.getContextPath() + "/uploads/" + newFileName;
    }


}
