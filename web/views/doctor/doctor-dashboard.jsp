<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ include file="doctor-auth.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Doctor Dashboard - G3 Hospital</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
</head>
<body>
<div class="wrapper">
    <%@ include file="../layouts/header.jsp" %>
    <div class="container">
        <%@ include file="../layouts/doctor-side-bar.jsp" %>
        <div class="content">
            <h2 class="section-title">Chào mừng đến với bảng điều khiển Bác sĩ!</h2>
            <div class="row g-4">
                <!-- Tổng số lịch làm việc -->
                <div class="col-md-3">
                    <div class="card text-white stat-card" style="background-color: #17a2b8;">
                        <div class="card-header fw-bold">
                            <i class="bi bi-calendar-check"></i> Lịch làm việc
                        </div>
                        <div class="card-body">
                            <h4 class="card-title">${totalSchedules}</h4>
                            <p class="card-text fw-bold">Tổng số lịch làm việc</p>
                        </div>
                    </div>
                </div>
                <!-- Lịch làm việc đang hoạt động -->
                <div class="col-md-3">
                    <div class="card text-white stat-card" style="background-color: #28a745;">
                        <div class="card-header fw-bold">
                            <i class="bi bi-calendar-plus"></i> Đang hoạt động
                        </div>
                        <div class="card-body">
                            <h4 class="card-title">${activeSchedules}</h4>
                            <p class="card-text fw-bold">Lịch làm việc đang hoạt động</p>
                        </div>
                    </div>
                </div>
                <!-- Yêu cầu ngoại lệ chờ duyệt -->
                <div class="col-md-3">
                    <div class="card text-dark stat-card" style="background-color: #ffc107;">
                        <div class="card-header fw-bold">
                            <i class="bi bi-clock"></i> Ngoại lệ chờ duyệt
                        </div>
                        <div class="card-body">
                            <h4 class="card-title">${pendingExceptions}</h4>
                            <p class="card-text fw-bold">Yêu cầu ngoại lệ chờ duyệt</p>
                        </div>
                    </div>
                </div>
                <!-- Tổng số lịch hẹn -->
                <div class="col-md-3">
                    <div class="card text-white stat-card" style="background-color: #6f42c1;">
                        <div class="card-header fw-bold">
                            <i class="bi bi-people"></i> Lịch hẹn
                        </div>
                        <div class="card-body">
                            <h4 class="card-title">${totalAppointments}</h4>
                            <p class="card-text fw-bold">Tổng số lịch hẹn</p>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Tư vấn sức khỏe Section -->
            <div class="row mt-5">
                <div class="col-12">
                    <div class="card shadow-lg">
                        <div class="card-header bg-primary text-white">
                            <h4 class="mb-0">
                                <i class="bi bi-chat-dots me-2"></i> Tư vấn sức khỏe
                            </h4>
                        </div>
                        <div class="card-body">
                            <div class="row g-4">
                                <!-- Phiên tư vấn chờ phản hồi -->
                                <div class="col-md-4">
                                    <div class="card border-warning">
                                        <div class="card-header bg-warning text-dark">
                                            <h6 class="mb-0">
                                                <i class="bi bi-clock me-2"></i> Chờ phản hồi
                                            </h6>
                                        </div>
                                        <div class="card-body text-center">
                                            <h3 class="text-warning mb-2">${pendingConsultations}</h3>
                                            <p class="mb-3">Phiên tư vấn chờ phản hồi</p>
                                            <a href="${pageContext.request.contextPath}/consultation-chat" class="btn btn-warning">
                                                <i class="bi bi-eye me-1"></i> Xem chi tiết
                                            </a>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Phiên tư vấn đang hoạt động -->
                                <div class="col-md-4">
                                    <div class="card border-success">
                                        <div class="card-header bg-success text-white">
                                            <h6 class="mb-0">
                                                <i class="bi bi-chat-text me-2"></i> Đang tư vấn
                                            </h6>
                                        </div>
                                        <div class="card-body text-center">
                                            <h3 class="text-success mb-2">${activeConsultations}</h3>
                                            <p class="mb-3">Phiên tư vấn đang diễn ra</p>
                                            <a href="${pageContext.request.contextPath}/consultation-chat" class="btn btn-success">
                                                <i class="bi bi-chat me-1"></i> Tham gia chat
                                            </a>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Tổng phiên tư vấn -->
                                <div class="col-md-4">
                                    <div class="card border-info">
                                        <div class="card-header bg-info text-white">
                                            <h6 class="mb-0">
                                                <i class="bi bi-graph-up me-2"></i> Tổng cộng
                                            </h6>
                                        </div>
                                        <div class="card-body text-center">
                                            <h3 class="text-info mb-2">${totalConsultations}</h3>
                                            <p class="mb-3">Tổng số phiên tư vấn</p>
                                            <a href="${pageContext.request.contextPath}/consultation-chat" class="btn btn-info">
                                                <i class="bi bi-list me-1"></i> Xem tất cả
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row mt-4">
                <div class="col-md-12 text-end">
                    <a href="${pageContext.request.contextPath}/doctor/schedule-changes?action=add" class="btn btn-primary btn-lg">
                        <i class="bi bi-arrow-left-right"></i> Gửi yêu cầu đổi ca dài hạn
                    </a>
                </div>
            </div>
        </div>
    </div>
    <%@ include file="../layouts/footer.jsp" %>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js">
<script src="${pageContext.request.contextPath}/assets/js/jwt-manager.js"></script></script>
</body>
</html> 