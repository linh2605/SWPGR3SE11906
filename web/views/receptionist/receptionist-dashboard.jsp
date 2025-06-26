<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ include file="receptionist-auth.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Receptionist Dashboard - G3 Hospital</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
</head>
<body>
    <div class="wrapper">
        <%@ include file="../layouts/header.jsp" %>
        <div class="main">
            <%@include file="../layouts/receptionist-side-bar.jsp"%>
            <div class="content">
                <h2>Chào mừng đến với bảng điều khiển Lễ tân!</h2>
                <p>Chọn một mục từ thanh bên để bắt đầu quản lý.</p>
                <div class="container mt-5">
                    <div class="row g-4">
                        <div class="col-md-4">
                            <div class="card text-white stat-card" style="background-color: #17a2b8;">
                                <div class="card-header fw-bold">
                                    <i class="bi bi-calendar-check"></i> Quản lý lịch hẹn
                                </div>
                                <div class="card-body">
                                    <a href="${pageContext.request.contextPath}/views/appointment/receptionistDashboard.jsp" class="btn btn-light">Xem lịch hẹn</a>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card text-white stat-card" style="background-color: #28a745;">
                                <div class="card-header fw-bold">
                                    <i class="bi bi-people"></i> Quản lý bệnh nhân
                                </div>
                                <div class="card-body">
                                    <a href="${pageContext.request.contextPath}/receptionistuplate" class="btn btn-light">Xem danh sách</a>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card text-white stat-card" style="background-color: #6f42c1;">
                                <div class="card-header fw-bold">
                                    <i class="bi bi-calendar-event"></i> Tất cả lịch hẹn
                                </div>
                                <div class="card-body">
                                    <a href="${pageContext.request.contextPath}/getAllAppointments" class="btn btn-light">Xem tất cả</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <%@ include file="../layouts/footer.jsp" %>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/scripts.js"></script>
</body>
</html> 