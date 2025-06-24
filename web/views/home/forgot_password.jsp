<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="../layouts/header.jsp" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quên mật khẩu - G3 Hospital</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
    <style>
        .forgot-password-card {
            max-width: 500px;
            margin: 60px auto;
            padding: 30px;
            border-radius: 16px;
            background: #ffffff;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body class="bg-light">
<div class="wrapper">
    <div class="container">
        <div class="forgot-password-card">
            <h4 class="text-center text-primary mb-4">Quên mật khẩu</h4>

            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>
            <c:if test="${not empty message}">
                <div class="alert alert-success">${message}</div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/views/home/forgot-password">
                <div class="mb-3">
                    <label class="form-label">Email</label>
                    <input type="email" name="email" class="form-control" placeholder="Nhập email của bạn" required>
                </div>
                <div class="d-grid mb-3">
                    <button type="submit" class="btn btn-primary">Gửi liên kết đặt lại mật khẩu</button>
                </div>
                <div class="text-center">
                    <a href="${pageContext.request.contextPath}/login">Quay lại đăng nhập</a>
                </div>
            </form>
        </div>
    </div>

    <%@ include file="../layouts/footer.jsp" %>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
