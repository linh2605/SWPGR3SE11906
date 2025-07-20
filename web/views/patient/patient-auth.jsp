<%@ page import="utils.AuthHelper" %>
<%
    Integer roleId = AuthHelper.getCurrentUserRoleId(request);
    if (roleId == null || roleId != 1) {
        response.sendRedirect(request.getContextPath() + "/views/home/login.jsp?error=access_denied");
        return;
    }
%> 