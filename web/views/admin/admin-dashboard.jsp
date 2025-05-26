<%-- 
    Document   : admin-dashboard
    Created on : May 26, 2025, 5:17:03 AM
    Author     : tamthui
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <style>
        html, body {
            margin: 0;
            padding: 0;
            height: 100%;
            font-family: Arial, sans-serif;
        }

        /* Tạo layout chính */
        .wrapper {
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        /* HEADER */
        .header {
            background-color: #DDF9F5;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 20px;
        }

        .header-left {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .header-right {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .header a {
            text-decoration: none;
            color: black;
            font-weight: bold;
        }

        /* BODY */
        .main {
            display: flex;
            flex: 1;
            padding: 20px;
        }

        .sidebar {
            background-color: #DDF9F5;
            width: 200px;
            padding: 15px;
            height: auto;
            border-radius: 8px;
            box-shadow: 0 0 5px rgba(0,0,0,0.1);
        }

        .sidebar h3 {
            font-size: 16px;
            margin-bottom: 20px;
            border-bottom: 1px solid #ccc;
            padding-bottom: 10px;
        }

        .sidebar a {
            display: block;
            margin-top: 10px;
            text-decoration: none;
            color: black;
        }

        .content {
            flex-grow: 1;
            padding: 20px;
        }

        /* FOOTER */
        .footer {
            background-color: #f0f0f0;
            display: flex;
            justify-content: space-around;
            padding: 20px;
            font-size: 14px;
        }

        .footer-section {
            max-width: 230px;
        }

        .footer img {
            width: 20px;
            height: 20px;
            vertical-align: middle;
            margin-right: 5px;
        }

        .footer a {
            text-decoration: none;
            color: black;
            display: block;
            margin-top: 5px;
        }
    </style>
</head>
<body>
<div class="wrapper">
    <!-- HEADER -->
    <div class="header">
        <div class="header-left">
            <img src="<a href=https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR_XtyeRiLGBpeTpHUk4kXp8Q8lrrXZyrsAuQ&s>admin</a>" alt="" width="40" height="40">
        </div>
        <div class="header-right">
            🔔
            <a href="adminProfile.jsp">admin</a>
            <a href="logout.jsp">Logout</a>
        </div>
    </div>

    <!-- BODY -->
    <div class="main">
        <div class="sidebar">
            <h3>ADMIN DASHBOARD</h3>
            <a href="doctorManager.jsp">Doctor Manager</a>
        </div>
        <div class="content">
            <!-- Nội dung chính tại đây -->
        </div>
    </div>

    <!-- FOOTER -->
    <div class="footer">
        <div class="footer-section">
            <strong>LOGO Phòng khám</strong><br>
            © Công ty TNHH 1 thành viên<br>
            Mã Số Thuế: 0106486365<br>
            Văn phòng: số nhà 5a7 Khu<br>
            Tập thể Không Quân 916<br>
            Cổ Đông, Sơn Tây, Hà Nội<br><br>
            Got Question? Call us 24/7<br>
            ☎ 0392231547
        </div>

        <div class="footer-section">
            <strong>Về Phòng Khám</strong><br>
            <a href="#">Giới thiệu về chúng tôi</a>
            <a href="#">Chuyên khoa</a>
            <a href="#">Tin tức</a>
            <a href="#">Tuyển dụng</a>
            <a href="#">Hướng dẫn khách hàng</a>
            <a href="#">Báo cáo thực hành Yên Ninh</a>
            <a href="#">Báo cáo thực hành Phúc Trường Minh</a>
        </div>

        <div class="footer-section">
            <strong>Chăm sóc khách hàng</strong><br>
            <a href="#">Chính sách bảo mật</a>
            <a href="#">Hướng dẫn thanh toán</a>
            <a href="#">Trung tâm trợ giúp</a>
            <a href="#">Câu hỏi thường gặp</a>
            <a href="#">Giờ làm việc</a>
            <a href="#">Phòng nội trú</a>
        </div>

        <div class="footer-section">
            <strong>Kết nối với phòng khám</strong><br>
            <a href="#"><img src="facebook.png" alt="Facebook">Facebook</a>
            <a href="#"><img src="instagram.png" alt="Instagram">Instagram</a>
        </div>
    </div>
</div>
</body>
</html>











