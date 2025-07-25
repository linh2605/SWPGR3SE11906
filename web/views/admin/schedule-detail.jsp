<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="admin-auth.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Chi tiết lịch làm việc</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
</head>
<body>
<div class="container mt-4">
    <h2 class="mb-4">Chi tiết lịch làm việc</h2>
    <a href="${pageContext.request.contextPath}/admin/working-schedules" class="btn btn-secondary mb-3">Quay lại</a>
    <c:if test="${not empty schedule}">
        <table class="table table-bordered">
            <tr>
                <th>Bác sĩ</th>
                <td>${not empty schedule.doctorName ? schedule.doctorName : schedule.doctorId}</td>
            </tr>
            <tr>
                <th>Thứ</th>
                <td>${schedule.weekDay}</td>
            </tr>
            <tr>
                <th>Ca làm việc</th>
                <td>${not empty schedule.shift && not empty schedule.shift.name ? schedule.shift.name : schedule.shiftId}</td>
            </tr>
            <tr>
                <th>Số bệnh nhân tối đa</th>
                <td>${schedule.maxPatients}</td>
            </tr>
            <tr>
                <th>Trạng thái</th>
                <td>${schedule.active ? 'Hoạt động' : 'Không hoạt động'}</td>
            </tr>
        </table>
    </c:if>
    <c:if test="${empty schedule}">
        <div class="alert alert-danger">Không tìm thấy thông tin lịch làm việc!</div>
    </c:if>
</div>
</body>
</html> 