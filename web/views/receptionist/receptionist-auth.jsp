<%
    Integer roleId = (session == null) ? null : (Integer) session.getAttribute("roleId");
    if (roleId == null || roleId != 3) {
        response.sendRedirect(request.getContextPath() + "/views/home/login.jsp?error=access_denied");
        return;
    }
%> 