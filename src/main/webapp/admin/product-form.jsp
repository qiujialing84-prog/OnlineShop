<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    boolean isEdit = request.getAttribute("product") != null;
    request.setAttribute("pageTitle", isEdit ? "编辑商品" : "添加商品");
    request.setAttribute("contentPage", "product-form-content.jsp");
%>
<jsp:include page="layout.jsp">
    <jsp:param name="active" value="products"/>
</jsp:include>