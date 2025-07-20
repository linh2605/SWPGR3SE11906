<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<div class="sidebar">
    <h3>ADMIN DASHBOARD</h3>
    <a href="${pageContext.request.contextPath}/admin/dashboard">
        <i class="bi bi-speedometer2"></i> Dashboard
    </a>
    <a href="${pageContext.request.contextPath}/admin/doctor">
        <i class="bi bi-person-badge"></i> Quản lý bác sĩ
    </a>
    <a href="${pageContext.request.contextPath}/admin/patient">
        <i class="bi bi-people"></i> Quản lý bệnh nhân
    </a>
    <a href="${pageContext.request.contextPath}/contactManager">
        <i class="bi bi-chat-dots"></i> Quản lý liên hệ
    </a>
    <a href="${pageContext.request.contextPath}/admin/shifts">
        <i class="bi bi-clock"></i> Quản lý ca làm việc
    </a>
    <a href="${pageContext.request.contextPath}/admin/working-schedules">
        <i class="bi bi-calendar-week"></i> Quản lý lịch làm việc
    </a>
    <a href="${pageContext.request.contextPath}/admin/schedule-exceptions">
        <i class="bi bi-exclamation-triangle"></i> Duyệt yêu cầu ngoại lệ
    </a>
    <a href="${pageContext.request.contextPath}/admin/schedule-changes">
        <i class="bi bi-arrow-repeat"></i> Duyệt yêu cầu đổi ca
    </a>
    <a href="${pageContext.request.contextPath}/admin/health-consultation">
        <i class="bi bi-heart-pulse"></i> Quản lý tư vấn sức khỏe
    </a>
    <a href="${pageContext.request.contextPath}/admin/examination-manage">
        <i class="bi bi-clipboard2-pulse"></i> Quản lý gói khám
    </a>
    <a href="${pageContext.request.contextPath}/news" class="news-link">
        <i class="bi bi-newspaper"></i> Quản lý tin tức
    </a>
</div>
