<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page session="true" %>
<html lang="vi">
<head>
    <title>Lịch hẹn của bác sĩ</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
    <%
        Integer roleId = null;
        if (session == null || (roleId = (Integer) session.getAttribute("roleId")) == null || roleId != 2) {
            response.sendRedirect(request.getContextPath() + "/views/home/login.jsp?error=access_denied");
            return;
        }
    %>
    <script>
        window.roleId = <%= roleId %>;
        window.contextPath = '<%= request.getContextPath() %>';
    </script>
</head>
<body id="doctor-appointments">
<%@ include file="../layouts/header.jsp" %>
<main class="container my-5 fade-in">
    <h2 class="section-title text-center mb-4">LỊCH HẸN CỦA TÔI</h2>
    <!-- Filter bar -->
    <div class="row g-3 mb-3">
        <div class="col-md-4">
            <label for="filterDate" class="form-label">Lọc theo ngày</label>
            <input type="date" id="filterDate" class="form-control">
        </div>
        <div class="col-md-4">
            <label for="filterStatus" class="form-label">Lọc theo trạng thái</label>
            <select id="filterStatus" class="form-select">
                <option value="">Tất cả</option>
                <option value="pending">Chờ xác nhận</option>
                <option value="confirmed">Đã xác nhận</option>
                <option value="completed">Hoàn thành</option>
                <option value="canceled">Đã hủy</option>
            </select>
        </div>
        <div class="col-md-4 d-flex align-items-end">
            <button class="btn btn-primary w-100" id="filterButton"><i class="bi bi-funnel"></i> Lọc lịch hẹn</button>
        </div>
    </div>
    <!-- FullCalendar -->
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
<%@ include file="../layouts/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    window.contextPath = '${pageContext.request.contextPath}';
</script>
<script src="${pageContext.request.contextPath}/assets/js/scripts.js">
<script src="${pageContext.request.contextPath}/assets/js/jwt-manager.js"></script></script>
</body>
</html>