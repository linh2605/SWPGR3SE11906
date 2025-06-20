<%-- 
    Document   : login
    Created on : May 26, 2025, 5:08:48 AM
    Author     : tamthui
--%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    if (session.getAttribute("user") != null) {
        response.sendRedirect(request.getContextPath() + "/views/home/index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Đăng Nhập - G3 Hospital</title>
        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4Q6Gf2aSP4eDXB8Miphtr37CMZZQ5oXLH2yaXMJ2w8e2ZtHTl7GptT4jmndRuHDT" crossorigin="anonymous">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
    </head>
    <body>
        <div class="wrapper">
            <%@ include file="../layouts/header.jsp" %>

            <!-- Login Box -->
            <div class="login-container">
                <div class="login-box">
                    <h2>ĐĂNG NHẬP</h2>
                    <p>Mời bạn đăng nhập để thực hiện các thao tác quản lý</p>
                    <c:if test="${errorMsg != null}">
                        <p style="color: red">${errorMsg}</p>
                    </c:if>
                    <form action="${pageContext.request.contextPath}/login" method="post">
                        <input type="text" name="username" placeholder="Email hoặc tên đăng nhập" required>
                        <input type="password" name="password" placeholder="Mật khẩu" required>
                        <div class="checkbox-group">
                            <label><input type="checkbox" name="remember"> Nhớ mật khẩu</label>
                            <label><a href="${pageContext.request.contextPath}/views/home/forgot_password.jsp">Quên mật khẩu?</a></label>
                        </div>
                        <button type="submit">ĐĂNG NHẬP</button>
                    </form>
                    <p class="mt-3">Chưa có tài khoản? <a href="${pageContext.request.contextPath}/views/home/register.jsp">Đăng ký</a></p>
                </div>
            </div>

            <%@ include file="../layouts/footer.jsp" %>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js" integrity="sha384-j1CDi7MgGQ12Z7Qab0qlWQ/Qqz24Gc6BM0thvEMVjHnfYGF0rmFCozFSxQBxwHKO" crossorigin="anonymous"></script>
        <script src="${pageContext.request.contextPath}/assets/js/scripts.js"></script>
    </body>
</html>