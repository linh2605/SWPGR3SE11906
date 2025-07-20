<%-- 
    Document   : admin-dashboard
    Created on : May 26, 2025, 5:17:03 AM
    Author     : tamthui
--%>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ include file="admin-auth.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard - G3 Hospital</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4Q6Gf2aSP4eDXB8Miphtr37CMZZQ5oXLH2yaXMJ2w8e2ZtHTl7GptT4jmndRuHDT" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
</head>
<body>
    <div class="wrapper">
        <%@ include file="../layouts/header.jsp" %>
        <!-- BODY -->
        <div class="main">
            <%@include file="../layouts/admin-side-bar.jsp"%>
            <div class="content">
                <!-- Loading indicator -->
                <div id="loading" class="text-center" style="display: none;">
                    <div class="spinner-border text-primary" role="status">
                        <span class="visually-hidden">Đang tải...</span>
                    </div>
                </div>

                <!-- Nội dung chính tại đây -->
                <h2>Chào mừng đến với bảng điều khiển Admin!</h2>
                <p>Chọn một mục từ thanh bên để bắt đầu quản lý.</p>
                <div class="container mt-5">
                    <div class="row g-4">
                        <!-- Working Schedules -->
                        <div class="col-md-3">
                            <div class="card text-white stat-card" style="background-color: #17a2b8;">
                                <div class="card-header fw-bold">
                                    <i class="bi bi-calendar-check"></i> Lịch làm việc
                                </div>
                                <div class="card-body">
                                    <h4 class="card-title" id="totalSchedules">${totalSchedules}</h4>
                                    <p class="card-text fw-bold">Tổng số lịch làm việc</p>
                                </div>
                            </div>
                        </div>

                        <!-- Active Schedules -->
                        <div class="col-md-3">
                            <div class="card text-white stat-card" style="background-color: #28a745;">
                                <div class="card-header fw-bold">
                                    <i class="bi bi-calendar-plus"></i> Đang hoạt động
                                </div>
                                <div class="card-body">
                                    <h4 class="card-title" id="activeSchedules">${activeSchedules}</h4>
                                    <p class="card-text fw-bold">Lịch làm việc đang hoạt động</p>
                                </div>
                            </div>
                        </div>

                        <!-- Pending Exceptions -->
                        <div class="col-md-3">
                            <div class="card text-dark stat-card" style="background-color: #ffc107;">
                                <div class="card-header fw-bold">
                                    <i class="bi bi-clock"></i> Chờ duyệt
                                </div>
                                <div class="card-body">
                                    <h4 class="card-title" id="pendingExceptions">${pendingExceptions}</h4>
                                    <p class="card-text fw-bold">Yêu cầu ngoại lệ chờ duyệt</p>
                                </div>
                            </div>
                        </div>

                        <!-- Total Doctors -->
                        <div class="col-md-3">
                            <div class="card text-white stat-card" style="background-color: #6f42c1;">
                                <div class="card-header fw-bold">
                                    <i class="bi bi-people"></i> Bác sĩ
                                </div>
                                <div class="card-body">
                                    <h4 class="card-title" id="totalDoctors">${totalDoctors}</h4>
                                    <p class="card-text fw-bold">Tổng số bác sĩ</p>
                                </div>
                            </div>
                        </div>

                        <!-- Total Patients -->
                        <div class="col-md-3">
                            <div class="card text-white stat-card" style="background-color: #20c997;">
                                <div class="card-header fw-bold">
                                    <i class="bi bi-person-heart"></i> Bệnh nhân
                                </div>
                                <div class="card-body">
                                    <h4 class="card-title" id="totalPatients">${totalPatients}</h4>
                                    <p class="card-text fw-bold">Tổng số bệnh nhân</p>
                                </div>
                            </div>
                        </div>

                        <!-- Total Appointments -->
                        <div class="col-md-3">
                            <div class="card text-white stat-card" style="background-color: #fd7e14;">
                                <div class="card-header fw-bold">
                                    <i class="bi bi-calendar-event"></i> Lịch hẹn
                                </div>
                                <div class="card-body">
                                    <h4 class="card-title" id="totalAppointments">${totalAppointments}</h4>
                                    <p class="card-text fw-bold">Tổng số lịch hẹn</p>
                                </div>
                            </div>
                        </div>

                        <!-- Pending Appointments -->
                        <div class="col-md-3">
                            <div class="card text-dark stat-card" style="background-color: #e83e8c;">
                                <div class="card-header fw-bold">
                                    <i class="bi bi-hourglass-split"></i> Chờ xử lý
                                </div>
                                <div class="card-body">
                                    <h4 class="card-title" id="pendingAppointments">${pendingAppointments}</h4>
                                    <p class="card-text fw-bold">Lịch hẹn chờ xử lý</p>
                                </div>
                            </div>
                        </div>

                        <!-- Total Contacts -->
                        <div class="col-md-3">
                            <div class="card text-white stat-card" style="background-color: #6c757d;">
                                <div class="card-header fw-bold">
                                    <i class="bi bi-chat-dots"></i> Liên hệ
                                </div>
                                <div class="card-body">
                                    <h4 class="card-title" id="totalContacts">${totalContacts}</h4>
                                    <p class="card-text fw-bold">Tổng tin nhắn liên hệ</p>
                                </div>
                            </div>
                        </div>

                        <!-- Quick Stats -->
                        <div class="col-12">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="mb-0">
                                        <i class="bi bi-graph-up"></i> Thống kê nhanh
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <div class="row g-3">
                                        <div class="col-md-3">
                                            <div class="d-flex align-items-center">
                                                <div class="flex-shrink-0">
                                                    <i class="bi bi-person-check text-success fs-3"></i>
                                                </div>
                                                <div class="flex-grow-1 ms-3">
                                                    <h6 class="mb-0">Bác sĩ có sẵn</h6>
                                                    <h4 class="mb-0 text-success">${availableDoctors}</h4>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="d-flex align-items-center">
                                                <div class="flex-shrink-0">
                                                    <i class="bi bi-exclamation-triangle text-warning fs-3"></i>
                                                </div>
                                                <div class="flex-grow-1 ms-3">
                                                    <h6 class="mb-0">Yêu cầu khẩn cấp</h6>
                                                    <h4 class="mb-0 text-warning">${urgentExceptions}</h4>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="d-flex align-items-center">
                                                <div class="flex-shrink-0">
                                                    <i class="bi bi-envelope text-info fs-3"></i>
                                                </div>
                                                <div class="flex-grow-1 ms-3">
                                                    <h6 class="mb-0">Tin nhắn chưa đọc</h6>
                                                    <h4 class="mb-0 text-info">${unreadContacts}</h4>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="d-flex align-items-center">
                                                <div class="flex-shrink-0">
                                                    <i class="bi bi-clock-history text-primary fs-3"></i>
                                                </div>
                                                <div class="flex-grow-1 ms-3">
                                                    <h6 class="mb-0">Thời gian phản hồi TB</h6>
                                                    <h4 class="mb-0 text-primary">${avgResponseTime}h</h4>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Recent Activities -->
                        <div class="col-md-8">
                            <div class="card">
                                <div class="card-header d-flex justify-content-between align-items-center">
                                    <h5 class="mb-0">
                                        <i class="bi bi-activity"></i> Hoạt động gần đây
                                    </h5>
                                    <button class="btn btn-sm btn-outline-primary" id="refreshActivities">
                                        <i class="bi bi-arrow-clockwise"></i> Làm mới
                                    </button>
                                </div>
                                <div class="card-body">
                                    <div id="recentActivities">
                                        <!-- Activities will be loaded by JavaScript -->
                                        <div class="text-center">
                                            <div class="spinner-border text-primary" role="status">
                                                <span class="visually-hidden">Đang tải...</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Quick Actions -->
                        <div class="col-md-4">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="mb-0">
                                        <i class="bi bi-lightning"></i> Thao tác nhanh
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <div class="d-grid gap-2">
                                        <button class="btn btn-primary quick-action-btn" data-action="add-schedule">
                                            <i class="bi bi-calendar-plus"></i> Quản lý lịch làm việc
                                        </button>
                                        <button class="btn btn-warning quick-action-btn" data-action="manage-exceptions">
                                            <i class="bi bi-clock"></i> Duyệt yêu cầu ngoại lệ
                                        </button>
                                        <button class="btn btn-info quick-action-btn" data-action="manage-shifts">
                                            <i class="bi bi-clock-history"></i> Quản lý ca làm việc
                                        </button>
                                        <button class="btn btn-success quick-action-btn" data-action="manage-doctors">
                                            <i class="bi bi-people"></i> Quản lý bác sĩ
                                        </button>
                                    </div>
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
    <script src="${pageContext.request.contextPath}/assets/js/jwt-manager.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/admin-dashboard.js"></script>
</body>
</html>