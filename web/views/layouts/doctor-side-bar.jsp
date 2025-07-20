<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<div class="sidebar">
    <h3>DOCTOR DASHBOARD</h3>
    <a href="${pageContext.request.contextPath}/doctor/dashboard">
        <i class="bi bi-speedometer2"></i> Dashboard
    </a>
    <a href="${pageContext.request.contextPath}/doctorupdate">
        <i class="bi bi-people"></i> Trạng thái khách khám
    </a>
    <a href="${pageContext.request.contextPath}/doctor-schedule">
        <i class="bi bi-calendar-week"></i> Lịch làm việc của tôi
    </a>
    <a href="${pageContext.request.contextPath}/doctor/schedule-changes?action=add">
        <i class="bi bi-calendar-plus"></i> Gửi yêu cầu đổi ca dài hạn
    </a>
    <a href="${pageContext.request.contextPath}/doctor/schedule-changes">
        <i class="bi bi-calendar-check"></i> Xem yêu cầu đổi ca
    </a>
    <a href="${pageContext.request.contextPath}/doctor-schedule?action=exceptions">
        <i class="bi bi-exclamation-triangle"></i> Yêu cầu ngoại lệ
    </a>
    <a href="${pageContext.request.contextPath}/doctor/appointments">
        <i class="bi bi-calendar-event"></i> Lịch hẹn của tôi
    </a>
</div> 