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
                <!-- Nội dung chính tại đây -->
                <h2>Chào mừng đến với bảng điều khiển Admin!</h2>
                <p>Chọn một mục từ thanh bên để bắt đầu quản lý.</p>
                <div class="container mt-5">
                    <div class="row g-4">
                        <!-- Working Schedules -->
                        <div class="col-md-3">
                            <div class="card text-white" style="background-color: #17a2b8;">
                                <div class="card-header fw-bold">
                                    <i class="bi bi-calendar-check"></i> Lịch làm việc
                                </div>
                                <div class="card-body">
                                    <h4 class="card-title" id="totalSchedules">0</h4>
                                    <p class="card-text fw-bold">Tổng số lịch làm việc</p>
                                </div>
                            </div>
                        </div>

                        <!-- Active Schedules -->
                        <div class="col-md-3">
                            <div class="card text-white" style="background-color: #28a745;">
                                <div class="card-header fw-bold">
                                    <i class="bi bi-calendar-plus"></i> Đang hoạt động
                                </div>
                                <div class="card-body">
                                    <h4 class="card-title" id="activeSchedules">0</h4>
                                    <p class="card-text fw-bold">Lịch làm việc đang hoạt động</p>
                                </div>
                            </div>
                        </div>

                        <!-- Pending Exceptions -->
                        <div class="col-md-3">
                            <div class="card text-dark" style="background-color: #ffc107;">
                                <div class="card-header fw-bold">
                                    <i class="bi bi-clock"></i> Chờ duyệt
                                </div>
                                <div class="card-body">
                                    <h4 class="card-title" id="pendingExceptions">0</h4>
                                    <p class="card-text fw-bold">Yêu cầu ngoại lệ chờ duyệt</p>
                                </div>
                            </div>
                        </div>

                        <!-- Total Doctors -->
                        <div class="col-md-3">
                            <div class="card text-white" style="background-color: #6f42c1;">
                                <div class="card-header fw-bold">
                                    <i class="bi bi-people"></i> Bác sĩ
                                </div>
                                <div class="card-body">
                                    <h4 class="card-title" id="totalDoctors">0</h4>
                                    <p class="card-text fw-bold">Tổng số bác sĩ</p>
                                </div>
                            </div>
                        </div>

                        <!-- Recent Activities -->
                        <div class="col-md-8">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="mb-0">
                                        <i class="bi bi-activity"></i> Hoạt động gần đây
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <div class="list-group list-group-flush" id="recentActivities">
                                        <div class="list-group-item">
                                            <div class="d-flex w-100 justify-content-between">
                                                <h6 class="mb-1">Bác sĩ Nguyễn Văn A gửi yêu cầu nghỉ phép</h6>
                                                <small class="text-muted">3 phút trước</small>
                                            </div>
                                            <p class="mb-1">Ngày: 02/06/2025 - Lý do: Nghỉ lễ gia đình</p>
                                        </div>
                                        <div class="list-group-item">
                                            <div class="d-flex w-100 justify-content-between">
                                                <h6 class="mb-1">Cập nhật lịch làm việc bác sĩ Trần Thị B</h6>
                                                <small class="text-muted">1 giờ trước</small>
                                            </div>
                                            <p class="mb-1">Thêm ca tối cho thứ 3 và thứ 5</p>
                                        </div>
                                        <div class="list-group-item">
                                            <div class="d-flex w-100 justify-content-between">
                                                <h6 class="mb-1">Duyệt yêu cầu thay đổi giờ làm</h6>
                                                <small class="text-muted">2 giờ trước</small>
                                            </div>
                                            <p class="mb-1">Bác sĩ Lê Văn C - Chuyển từ ca sáng sang ca chiều</p>
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
                                        <a href="${pageContext.request.contextPath}/admin/working-schedules" class="btn btn-primary">
                                            <i class="bi bi-calendar-plus"></i> Quản lý lịch làm việc
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/schedule-exceptions" class="btn btn-warning">
                                            <i class="bi bi-clock"></i> Duyệt yêu cầu ngoại lệ
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/doctor" class="btn btn-info">
                                            <i class="bi bi-people"></i> Quản lý bác sĩ
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/patient" class="btn btn-success">
                                            <i class="bi bi-person"></i> Quản lý bệnh nhân
                                        </a>
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
    <script src="${pageContext.request.contextPath}/assets/js/scripts.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/admin-dashboard.js"></script>
</body>
</html>