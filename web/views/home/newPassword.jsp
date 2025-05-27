<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Đặt Lại Mật Khẩu - G3 Hospital</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/styles.css">
    <style>
        body {
            background-color: #f0f8ff;
            font-family: 'Montserrat', sans-serif;
            margin: 0;
            padding: 0;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .wrapper {
            flex: 1;
            display: flex;
            flex-direction: column;
        }

        .content-center {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .new-password-box {
            background-color: #fff;
            padding: 40px 30px;
            border-radius: 12px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
            text-align: center;
            max-width: 400px;
            width: 100%;
        }

        .new-password-box h2 {
            font-weight: 700;
            color: #003366;
            margin-bottom: 10px;
        }

        .new-password-box p {
            color: #555;
            margin-bottom: 20px;
        }

        .new-password-box input[type="password"] {
            width: 100%;
            padding: 12px 15px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }

        .new-password-box button {
            width: 100%;
            padding: 12px;
            background-color: #0056b3;
            color: white;
            border: none;
            border-radius: 6px;
            font-weight: 600;
        }

        .new-password-box a {
            display: block;
            margin-top: 15px;
            color: #0056b3;
            font-size: 14px;
            text-decoration: none;
        }

        .new-password-box a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="wrapper">
        <%@ include file="../layouts/header.jsp" %>

        <div class="content-center">
            <div class="new-password-box">
                <h2>ĐẶT LẠI MẬT KHẨU</h2>
                <p>Nhập mật khẩu mới cho tài khoản của bạn</p>
                <form action="resetPassword" method="post">
                    <!-- Có thể truyền thêm mã token hoặc email ẩn nếu cần -->
                    <input type="hidden" name="email" value="${param.email}">
                    <input type="password" name="newPassword" placeholder="Mật khẩu mới" required>
                    <input type="password" name="confirmPassword" placeholder="Xác nhận mật khẩu" required>
                    <button type="submit">CẬP NHẬT MẬT KHẨU</button>
                </form>
                <a href="login.jsp">Quay lại trang đăng nhập</a>
            </div>
        </div>

        <%@ include file="../layouts/footer.jsp" %>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/views/assets/js/scripts.js"></script>
</body>
</html>
