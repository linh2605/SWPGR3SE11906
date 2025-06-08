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
            <%@include file="../layouts/admin-side-bar.jsp"%>
            <div class="content">
                <!-- Nội dung chính tại đây -->
                <h2>Chào mừng đến với bảng điều khiển Admin!</h2>
                <p>Chọn một mục từ thanh bên để bắt đầu quản lý.</p>
                <div class="container mt-5">
                    <div class="row g-4">
                        <!-- New Orders -->
                        <div class="col-md-4">
                            <div class="card text-white" style="background-color: #3498db;">
                                <div class="card-header fw-bold">New Orders</div>
                                <div class="card-body">
                                    <h4 class="card-title">+25</h4>
                                    <p class="card-text fw-bold">+12% versus yesterday</p>
                                </div>
                            </div>
                        </div>

                        <!-- Bounce Rate -->
                        <div class="col-md-4">
                            <div class="card text-dark" style="background-color: #f39c12;">
                                <div class="card-header fw-bold">Bounce Rate</div>
                                <div class="card-body">
                                    <h4 class="card-title">0%</h4>
                                    <p class="card-text">Today</p>
                                </div>
                            </div>
                        </div>

                        <!-- User Registrations -->
                        <div class="col-md-4">
                            <div class="card text-dark" style="background-color: #f39c12;">
                                <div class="card-header fw-bold">User Registrations</div>
                                <div class="card-body">
                                    <h4 class="card-title">+44</h4>
                                    <p class="card-text">+50% versus yesterday</p>
                                </div>
                            </div>
                        </div>

                        <!-- Unique Visitors -->
                        <div class="col-md-6">
                            <div class="card text-white" style="background-color: #27ae60;">
                                <div class="card-header fw-bold">Unique Visitors</div>
                                <div class="card-body">
                                    <h4 class="card-title">1200 Visitor</h4>
                                    <p class="card-text">Visitors per month</p>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>

        <%@ include file="../layouts/footer.jsp" %>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js" integrity="sha384-j1CDi7MgGQ12Z7Qab0qlWQ/Qqz24Gc6BM0thvEMVjHnfYGF0rmFCozFSxQBxwHKO" crossorigin="anonymous"></script>
    <script src="${pageContext.request.contextPath}/views/assets/js/scripts.js"></script>
</body>
</html>