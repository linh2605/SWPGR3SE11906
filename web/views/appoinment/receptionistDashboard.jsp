<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page session="true" %>
<html lang="vi">
<head>
    <title>Bảng điều khiển lễ tân - G3 Hospital</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4Q6Gf2aSP4eDXB8Miphtr37CMZZQ5oXLH2yaXMJ2w8e2ZtHTl7GptT4jmndRuHDT" crossorigin="anonymous">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <!-- FullCalendar CSS -->
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/styles.css">
    <%
        Integer roleId = null;
        if (session == null || (roleId = (Integer) session.getAttribute("role_id")) == null || roleId != 3) {
            response.sendRedirect(request.getContextPath() + "/views/home/login.jsp?error=access_denied");
            return;
        }
    %>
    <script>
        window.roleId = <%= roleId %>;
        window.contextPath = '<%= request.getContextPath() %>';
    </script>
</head>
  <body id="receptionistDashboard">
    <!-- Header -->
    <%@ include file="../layouts/header.jsp" %>

    <!-- Main Content -->
    <main class="container my-5">
        <h2 class="section-title text-center mb-4">QUẢN LÝ LỊCH HẸN</h2>

        <!-- Nút đồng bộ -->
        <div class="text-end mb-3">
            <button class="btn sync-btn" id="syncCalendarBtn">
                <i class="bi bi-calendar-plus"></i> Đồng bộ với lịch ngoài
            </button>
        </div>

        <!-- Bộ lọc -->
        <div class="filter-bar row g-3">
            <div class="col-md-3">
                <label for="filterDate" class="form-label">Lọc theo ngày</label>
                <select id="filterDate" class="form-select">
                    <option value="">Tất cả</option>
                </select>
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
                    <option value="pending">Đang chờ</option>
                    <option value="completed">Hoàn thành</option>
                    <option value="canceled">Đã hủy</option>
                </select>
            </div>
            <div class="col-md-3">
                <label for="search" class="form-label">Tìm kiếm</label>
                <input type="text" id="search" class="form-control" placeholder="Tìm theo bệnh nhân...">
            </div>
            <div class="col-md-12 text-end">
                <button class="btn btn-primary mt-3" id="filterButton">
                    <i class="bi bi-funnel"></i> Lọc lịch hẹn
                </button>
            </div>
        </div>

        <!-- Lịch FullCalendar -->
        <div id="calendar"></div>

        <!-- Danh sách chi tiết -->
        <div class="appointment-table">
            <h3 class="section-title mb-3">Danh sách lịch hẹn</h3>
            <table class="table table-bordered table-hover">
                <thead>
                    <tr>
                        <th>ID Hẹn</th>
                        <th>Ngày giờ</th>
                        <th>Bác sĩ</th>
                        <th>Bệnh nhân</th>
                        <th>Trạng thái</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody id="appointmentList">
                    <!-- Dữ liệu sẽ được thêm động bằng JS -->
                </tbody>
            </table>
        </div>
    </main>

    <!-- Footer -->
    <%@ include file="../layouts/footer.jsp" %>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js" integrity="sha384-j1CDi7MgGQ12Z7Qab0qlWQ/Qqz24Gc6BM0thvEMVjHnfYGF0rmFCozFSxQBxwHKO" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="${pageContext.request.contextPath}/views/assets/js/scripts.js"></script>
</body>
</html>