<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quên Mật Khẩu - G3 Hospital</title>
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

        .forgot-password-box {
            background-color: #fff;
            padding: 40px 30px;
            border-radius: 12px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
            text-align: center;
            max-width: 400px;
            width: 100%;
        }

        .forgot-password-box h2 {
            font-weight: 700;
            color: #003366;
            margin-bottom: 10px;
        }

        .forgot-password-box p {
            color: #555;
            margin-bottom: 20px;
        }

        .forgot-password-box input[type="email"] {
            width: 100%;
            padding: 12px 15px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }

        .forgot-password-box button {
            width: 100%;
            padding: 12px;
            background-color: #0056b3;
            color: white;
            border: none;
            border-radius: 6px;
            font-weight: 600;
        }

        .forgot-password-box a {
            display: block;
            margin-top: 15px;
            color: #0056b3;
            font-size: 14px;
            text-decoration: none;
        }

        .forgot-password-box a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="wrapper">
        <%@ include file="../layouts/header.jsp" %>

        <div class="content-center">
            <div class="forgot-password-box">
                <h2>QUÊN MẬT KHẨU</h2>
                <p>Nhập email của bạn để đặt lại mật khẩu</p>
                <form action="forgotPassword" method="post">
                    <input type="email" name="email" placeholder="Email của bạn" required>
                    <button type="submit">GỬI YÊU CẦU</button>
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
