<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="../layouts/header.jsp" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Xác minh OTP - G3 Hospital</title>
        <!-- Bootstrap -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Custom styles -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
        <style>
            .otp-wrapper {
                max-width: 500px;
                margin: 60px auto;
                background: #fff;
                border-radius: 16px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.1);
                padding: 30px;
            }
        </style>
    </head>
    <body class="bg-light">
        <div class="wrapper">
            <div class="container">
                <div class="otp-wrapper">
                    <h4 class="text-center text-primary mb-4">Xác minh mã OTP</h4>

                    <!-- Thông báo lỗi -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">${error}</div>
                    </c:if>

                    <!-- Thông báo thành công -->
                    <c:if test="${not empty message}">
                        <div class="alert alert-success">${message}</div>
                    </c:if>

                    <!-- Form nhập OTP -->
                    <form method="post" action="${pageContext.request.contextPath}/enter-otp">
                        <input type="hidden" name="email" value="${param.email}" />
                        <div class="mb-3">
                            <label class="form-label">Nhập mã OTP</label>
                            <input type="text" class="form-control" name="otp" placeholder="Mã OTP đã gửi đến email" required />
                        </div>
                        <div class="d-grid mb-2">
                            <button type="submit" class="btn btn-primary">Xác nhận OTP</button>
                        </div>
                    </form>

                    <!-- Form gửi lại mã OTP -->
                    <form method="post" action="${pageContext.request.contextPath}/enter-otp">
                        <input type="hidden" name="email" value="${param.email}" />
                        <input type="hidden" name="action" value="resend" />
                        <div class="d-grid">
                            <button type="submit" class="btn btn-outline-secondary">Gửi lại mã OTP</button>
                        </div>
                    </form>

                </div>
            </div>

            <%@ include file="../layouts/footer.jsp" %>
        </div>

        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/scripts.js"></script>
    </body>
</html>
