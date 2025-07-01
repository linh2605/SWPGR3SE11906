<%-- 
    Document   : login.jsp
    Location   : views/home/login.jsp
    Author     : tamthui
--%>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
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
        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
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

                    <!-- Hiển thị lỗi -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger" role="alert">
                            ${error}
                        </div>
                    </c:if>

                    <!-- Hiển thị thông báo thành công -->
                    <c:if test="${param.reset != null}">
                        <div class="alert alert-success" role="alert">
                            Đặt lại mật khẩu thành công.
                        </div>
                    </c:if>
                    <c:if test="${param.verified != null}">
                        <div class="alert alert-success" role="alert">
                            Xác minh OTP thành công, bạn có thể đăng nhập.
                        </div>
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

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/scripts.js"></script>
    </body>
</html>
