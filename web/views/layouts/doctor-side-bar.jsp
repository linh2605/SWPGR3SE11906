<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<div class="sidebar">
    <h3>DOCTOR DASHBOARD</h3>
    <a href="${pageContext.request.contextPath}/doctor/dashboard">Dashboard</a>
    <a href="${pageContext.request.contextPath}/doctorupdate">Trạng thái khách khám</a>
    <a href="${pageContext.request.contextPath}/doctor-schedule">Lịch làm việc của tôi</a>
    <a href="${pageContext.request.contextPath}/doctor/schedule-changes?action=add">Gửi yêu cầu đổi ca dài hạn</a>
    <a href="${pageContext.request.contextPath}/doctor/schedule-changes">Xem yêu cầu đổi ca</a>
    <a href="${pageContext.request.contextPath}/doctor-schedule?action=exceptions">Yêu cầu ngoại lệ</a>
    <a href="${pageContext.request.contextPath}/doctor/appointments">Lịch hẹn của tôi</a>
</div> 