<%-- 
    Document   : passwordResetSuccess
    Created on : 24 thg 6, 2025, 09:59:33
    Author     : auiri
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đổi mật khẩu thành công</title>
    <!-- Tự động chuyển trang sau 5 giây -->
    <meta http-equiv="refresh" content="5; URL=${redirectUrl}">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-5">
        <div class="alert alert-success text-center">
            <h4>✅ Mật khẩu của bạn đã được đổi thành công!</h4>
            <p>Bạn sẽ được chuyển đến trang đăng nhập sau 5 giây...</p>
        </div>
    </div>
</body>
</html>
