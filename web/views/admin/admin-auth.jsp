<%
    Integer roleId = (session == null) ? null : (Integer) session.getAttribute("role_id");
    if (roleId == null || roleId != 4) {
        response.sendRedirect(request.getContextPath() + "/views/home/login.jsp?error=access_denied");
        return;
    }
%> 