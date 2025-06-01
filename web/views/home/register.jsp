<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Đăng Ký - G3 Hospital</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4Q6Gf2aSP4eDXB8Miphtr37CMZZQ5oXLH2yaXMJ2w8e2ZtHTl7GptT4jmndRuHDT" crossorigin="anonymous">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/styles.css">
</head>
<body>
    <div class="wrapper">
        <%@ include file="../layouts/header.jsp" %>


        <!-- Registration Box -->
        <div class="login-container">
            <div class="login-box">
                <h2>ĐĂNG KÝ</h2>
                <p>Mời bạn điền thông tin để tạo tài khoản mới</p>
                <form action="register" method="post">
                    <input type="email" name="email" placeholder="Email" required>
                    <input type="text" name="fullname" placeholder="Họ tên" required>
                    <input type="text" name="address" placeholder="Địa chỉ" required>
                    <input type="text" name="phone" placeholder="Số điện thoại" required>
                    <input type="password" name="password" placeholder="Mật khẩu" required>
                    <input type="password" name="confirmPassword" placeholder="Xác nhận mật khẩu" required>
                    <div class="checkbox-group">
                        <label><input type="checkbox" name="terms" required> Tôi đồng ý với các điều khoản sử dụng</label>
                    </div>
                    <button type="submit">ĐĂNG KÝ</button>
                </form>
            </div>
        </div>


        <%@ include file="../layouts/footer.jsp" %>
    </div>


    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js" integrity="sha384-j1CDi7MgGQ12Z7Qab0qlWQ/Qqz24Gc6BM0thvEMVjHnfYGF0rmFCozFSxQBxwHKO" crossorigin="anonymous"></script>
    <script src="${pageContext.request.contextPath}/views/assets/js/scripts.js"></script>
</body>
</html>