<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<div class="sidebar">
    <h3>RECEPTIONIST DASHBOARD</h3>
    <a href="${pageContext.request.contextPath}/receptionist/dashboard">
        <i class="bi bi-speedometer2"></i> Dashboard
    </a>
    <a href="${pageContext.request.contextPath}/receptionist/appointments">
        <i class="bi bi-calendar-event"></i> Quản lý lịch hẹn
    </a>
    <a href="${pageContext.request.contextPath}/receptionistuplate">
        <i class="bi bi-people"></i> Danh sách bệnh nhân
    </a>
    <a href="${pageContext.request.contextPath}/ProfileServlet">
        <i class="bi bi-person-circle"></i> Hồ sơ cá nhân
    </a>
</div> 