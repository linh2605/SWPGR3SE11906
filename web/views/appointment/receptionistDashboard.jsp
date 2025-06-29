<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="vi">
<head>
    <title>Quản lý lịch hẹn - Lễ tân</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4Q6Gf2aSP4eDXB8Miphtr37CMZZQ5oXLH2yaXMJ2w8e2ZtHTl7GptT4jmndRuHDT" crossorigin="anonymous">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <!-- FullCalendar CSS -->
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
    <%
        Integer roleId = null;
        if (session == null || (roleId = (Integer) session.getAttribute("roleId")) == null || roleId != 3) {
            response.sendRedirect(request.getContextPath() + "/views/home/login.jsp?error=access_denied");
            return;
        }
    %>
    <script>
        window.roleId = <%= roleId %>;
        window.contextPath = '<%= request.getContextPath() %>';
    </script>
</head>
<body id="receptionist-dashboard">
    <!-- Header -->
    <%@ include file="../layouts/header.jsp" %>

    <!-- Main Content -->
    <main class="container my-5 fade-in">
        <h2 class="section-title text-center mb-4">QUẢN LÝ LỊCH HẸN</h2>

        <!-- Nút đồng bộ -->
        <div class="text-end mb-3">
            <button class="btn sync-btn" id="syncCalendarBtn">
                <i class="bi bi-calendar-plus"></i> Đồng bộ với lịch ngoài
            </button>
        </div>

        <!-- Bộ lọc -->
        <div class="row g-3 mb-3">
            <div class="col-md-3">
                <label for="filterDate" class="form-label">Lọc theo ngày</label>
                <input type="date" id="filterDate" class="form-control">
            </div>
            <div class="col-md-3">
                <label for="filterDoctor" class="form-label">Lọc theo bác sĩ</label>
                <select id="filterDoctor" class="form-select">
                    <option value="">Tất cả</option>
                </select>
            </div>
            <div class="col-md-3">
                <label for="filterStatus" class="form-label">Lọc theo trạng thái</label>
                <select id="filterStatus" class="form-select">
                    <option value="">Tất cả</option>
                    <option value="pending">Chờ xác nhận</option>
                    <option value="confirmed">Đã xác nhận</option>
                    <option value="completed">Hoàn thành</option>
                    <option value="canceled">Đã hủy</option>
                </select>
            </div>
            <div class="col-md-3 d-flex align-items-end">
                <button class="btn btn-primary w-100" id="filterButton"><i class="bi bi-funnel"></i> Lọc lịch hẹn</button>
            </div>
        </div>

        <!-- Lịch FullCalendar -->
        <div id="calendar"></div>

        <!-- Danh sách chi tiết -->
        <div class="appointment-table mt-4">
            <h3 class="section-title mb-3">Danh sách lịch hẹn</h3>
            <table class="table table-bordered table-hover">
                <thead>
                    <tr>
                        <th>ID Hẹn</th>
                        <th>Ngày giờ</th>
                        <th>Bệnh nhân</th>
                        <th>Bác sĩ</th>
                        <th>Dịch vụ</th>
                        <th>Trạng thái</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody id="appointmentList">
                    <!-- JS render here -->
                </tbody>
            </table>
            <!-- Phân trang -->
            <nav>
                <ul class="pagination justify-content-center" id="pagination">
                    <!-- JS render here -->
                </ul>
            </nav>
        </div>
    </main>

    <!-- Footer -->
    <%@ include file="../layouts/footer.jsp" %>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js" integrity="sha384-j1CDi7MgGQ12Z7Qab0qlWQ/Qqz24Gc6BM0thvEMVjHnfYGF0rmFCozFSxQBxwHKO" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/scripts.js"></script>
</body>
</html>