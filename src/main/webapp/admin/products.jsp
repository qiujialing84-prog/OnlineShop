<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setAttribute("pageTitle", "商品管理");
    request.setAttribute("contentPage", "products-content.jsp");
%>
<jsp:include page="layout.jsp">
    <jsp:param name="active" value="products"/>
</jsp:include>