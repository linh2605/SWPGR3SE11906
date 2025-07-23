<%-- 
    Document   : register.jsp
    Location   : views/home/register.jsp
    Author     : tamthui
--%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    if (session.getAttribute("user") != null) {
        response.sendRedirect(request.getContextPath() + "/views/home/index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Đăng ký - G3 Hospital</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
        <style>
            body {
                font-family: 'Montserrat', sans-serif;
                background-color: #f0f6ff;
            }
            .register-container {
                max-width: 400px;
                margin: 50px auto;
                background: #fff;
                padding: 30px;
                border-radius: 15px;
                box-shadow: 0 8px 20px rgba(0,0,0,0.1);
            }
            .register-container h2 {
                font-weight: 700;
                text-align: center;
                margin-bottom: 10px;
            }
            .register-container p.description {
                text-align: center;
                font-size: 14px;
                color: #666;
                margin-bottom: 20px;
            }
            .btn-primary {
                font-weight: 600;
                border-radius: 8px;
            }
        </style>
    </head>
    <body>
        <%@ include file="../layouts/header.jsp" %>

        <div class="container">
            <div class="register-container">
                <h2>ĐĂNG KÝ</h2>
                <p class="description">Vui lòng điền đầy đủ thông tin để tạo tài khoản mới</p>

                <!-- Thông báo lỗi -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger" role="alert">
                        ${error}
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/views/home/register" method="post" class="needs-validation" novalidate>
                    <div class="mb-3">
                        <input type="text" class="form-control" id="username" name="username" 
                               pattern="^\S{5,}$" 
                               placeholder="Ít nhất 5 ký tự, không chứa khoảng trắng" required>
                        <div class="invalid-feedback">
                            Tên đăng nhập phải có ít nhất 5 ký tự và không chứa khoảng trắng.
                        </div>


                        <div class="mb-3 position-relative">
                            <label for="password" class="form-label">Mật khẩu</label>
                            <input type="password" class="form-control pe-5" id="password" name="password"
                                   pattern="(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}"
                                   placeholder="Ít nhất 8 ký tự, gồm chữ và số" required>

                            <!-- Biểu tượng mắt -->
                            <span class="toggle-password" onclick="togglePassword()" 
                                  style="position:absolute; top: 38px; right: 15px; cursor:pointer; font-size: 18px;">
                                👁️
                            </span>

                            <div class="invalid-feedback">Mật khẩu phải có ít nhất 8 ký tự, gồm chữ và số.</div>
                        </div>


                        <div class="mb-3">
                            <label for="fullName" class="form-label">Họ và tên</label>
                            <input type="text" class="form-control" id="fullName" name="fullName" 
                                   pattern="^[\p{L}\s]+$" 
                                   title="Họ và tên chỉ được chứa chữ cái có dấu (tiếng Việt) và dấu cách." 
                                   required>
                            <div class="invalid-feedback">Vui lòng nhập họ và tên hợp lệ.</div>
                        </div>



                        <div class="mb-3">
                            <label for="email" class="form-label">Email</label>
                            <input type="email" class="form-control" id="email" name="email" placeholder="example@gmail.com" required>
                            <div class="invalid-feedback">Vui lòng nhập email hợp lệ.</div>
                        </div>

                        <div class="mb-3">
                            <label for="phone" class="form-label">Số điện thoại</label>
                            <input type="tel" class="form-control" id="phone" name="phone" placeholder="0xxxxxxxxx" pattern="0[0-9]{9}" required>
                            <div class="invalid-feedback">Số điện thoại phải bắt đầu bằng 0 và đủ 10 số.</div>
                        </div>

                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary">ĐĂNG KÝ</button>
                        </div>
                </form>

                <p class="text-center mt-3">Đã có tài khoản? 
                    <a href="${pageContext.request.contextPath}/views/home/login.jsp">Đăng nhập</a>
                </p>
            </div>
        </div>

        <%@ include file="../layouts/footer.jsp" %>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                // Bootstrap validation
                                (() => {
                                    'use strict'
                                    const forms = document.querySelectorAll('.needs-validation')
                                    Array.from(forms).forEach(form => {
                                        form.addEventListener('submit', event => {
                                            if (!form.checkValidity()) {
                                                event.preventDefault()
                                                event.stopPropagation()
                                            }
                                            form.classList.add('was-validated')
                                        }, false)
                                    })
                                })()
        </script>
        <script>
            function togglePassword() {
                const passwordField = document.getElementById("password");
                const toggleIcon = document.querySelector(".toggle-password");

                if (passwordField.type === "password") {
                    passwordField.type = "text";
                    toggleIcon.textContent = "🙈"; // đổi icon khi hiện
                } else {
                    passwordField.type = "password";
                    toggleIcon.textContent = "👁️"; // đổi lại khi ẩn
                }
            }
        </script>

    </body>
</html>
