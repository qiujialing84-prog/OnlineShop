<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setAttribute("pageTitle", "仪表盘");
    request.setAttribute("contentPage", "dashboard-content.jsp");
%>
<jsp:include page="layout.jsp">
    <jsp:param name="active" value="dashboard"/>
</jsp:include>