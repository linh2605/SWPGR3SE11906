<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<div class="sidebar">
    <h3>DOCTOR DASHBOARD</h3>
    <a href="${pageContext.request.contextPath}/doctor/dashboard">Dashboard</a>
    <a href="${pageContext.request.contextPath}/doctorupdate">Quản lý bệnh nhân</a>
    <a href="${pageContext.request.contextPath}/doctor-schedule">Lịch làm việc</a>
    <a href="${pageContext.request.contextPath}/views/appointment/doctorDashboard.jsp">Lịch hẹn</a>
    <a href="${pageContext.request.contextPath}/doctor-schedule?action=exceptions">Yêu cầu ngoại lệ</a>
    <a href="${pageContext.request.contextPath}/ProfileServlet">Hồ sơ cá nhân</a>
</div> 