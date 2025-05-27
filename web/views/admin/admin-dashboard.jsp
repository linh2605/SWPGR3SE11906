<%-- 
    Document   : admin-dashboard
    Created on : May 26, 2025, 5:17:03 AM
    Author     : tamthui
--%>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard - G3 Hospital</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4Q6Gf2aSP4eDXB8Miphtr37CMZZQ5oXLH2yaXMJ2w8e2ZtHTl7GptT4jmndRuHDT" crossorigin="anonymous">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/styles.css">
</head>
<body>
    <div class="wrapper">
        <%@ include file="../layouts/header.jsp" %>

        <!-- BODY -->
        <div class="main">
            <div class="sidebar">
                <h3>ADMIN DASHBOARD</h3>
                <a href="doctorManager.jsp">Quản lý bác sĩ</a>
                <a href="appointmentManager.jsp">Quản lý lịch hẹn</a>
                <a href="userManager.jsp">Quản lý người dùng</a>
            </div>
            <div class="content">
                <!-- Nội dung chính tại đây -->
                <h2>Chào mừng đến với bảng điều khiển Admin!</h2>
                <p>Chọn một mục từ thanh bên để bắt đầu quản lý.</p>
            </div>
        </div>

        <%@ include file="../layouts/footer.jsp" %>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js" integrity="sha384-j1CDi7MgGQ12Z7Qab0qlWQ/Qqz24Gc6BM0thvEMVjHnfYGF0rmFCozFSxQBxwHKO" crossorigin="anonymous"></script>
    <script src="${pageContext.request.contextPath}/views/assets/js/scripts.js"></script>
</body>
</html>