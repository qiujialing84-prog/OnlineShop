<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setAttribute("pageTitle", "订单管理");
    request.setAttribute("contentPage", "orders-content.jsp");
%>
<jsp:include page="layout.jsp">
    <jsp:param name="active" value="orders"/>
</jsp:include>