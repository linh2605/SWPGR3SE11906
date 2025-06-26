<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ include file="doctor-auth.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Doctor Dashboard - G3 Hospital</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
</head>
<body>
    <div class="wrapper">
        <%@ include file="../layouts/header.jsp" %>
        <div class="main">
            <%@include file="../layouts/doctor-side-bar.jsp"%>
            <div class="content">
                <h2>Chào mừng đến với bảng điều khiển Bác sĩ!</h2>
                <p>Chọn một mục từ thanh bên để bắt đầu quản lý.</p>
                <div class="container mt-5">
                    <div class="row g-4">
                        <div class="col-md-3">
                            <div class="card text-white stat-card" style="background-color: #17a2b8;">
                                <div class="card-header fw-bold">
                                    <i class="bi bi-calendar-check"></i> Lịch làm việc
                                </div>
                                <div class="card-body">
                                    <a href="${pageContext.request.contextPath}/doctor-schedule" class="btn btn-light">Xem lịch</a>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card text-white stat-card" style="background-color: #28a745;">
                                <div class="card-header fw-bold">
                                    <i class="bi bi-people"></i> Quản lý bệnh nhân
                                </div>
                                <div class="card-body">
                                    <a href="${pageContext.request.contextPath}/doctorupdate" class="btn btn-light">Xem danh sách</a>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card text-white stat-card" style="background-color: #6f42c1;">
                                <div class="card-header fw-bold">
                                    <i class="bi bi-calendar-event"></i> Lịch hẹn
                                </div>
                                <div class="card-body">
                                    <a href="${pageContext.request.contextPath}/views/appointment/doctorDashboard.jsp" class="btn btn-light">Xem lịch hẹn</a>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card text-white stat-card" style="background-color: #ffc107;">
                                <div class="card-header fw-bold">
                                    <i class="bi bi-clock"></i> Yêu cầu ngoại lệ
                                </div>
                                <div class="card-body">
                                    <a href="${pageContext.request.contextPath}/doctor/exceptions" class="btn btn-light">Xem yêu cầu</a>
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