<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="admin-auth.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Chi tiết yêu cầu ngoại lệ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
</head>
<body>
<div class="container mt-4">
    <h2 class="mb-4">Chi tiết yêu cầu ngoại lệ</h2>
    <a href="${pageContext.request.contextPath}/admin/schedule-exceptions" class="btn btn-secondary mb-3">Quay lại</a>
    <c:if test="${not empty exception}">
        <table class="table table-bordered">
            <tr>
                <th>Bác sĩ</th>
                <td>${not empty exception.doctorName ? exception.doctorName : exception.doctorId}</td>
            </tr>
            <tr>
                <th>Ngày ngoại lệ</th>
                <td>${exception.exceptionDate}</td>
            </tr>
            <tr>
                <th>Loại ngoại lệ</th>
                <td>${exception.exceptionType}</td>
            </tr>
            <tr>
                <th>Trạng thái</th>
                <td>${exception.status}</td>
            </tr>
            <tr>
                <th>Ca làm việc mới</th>
                <td>${not empty exception.newShiftName ? exception.newShiftName : (exception.newShiftId != null ? exception.newShiftId : '-')}</td>
            </tr>
            <tr>
                <th>Lý do</th>
                <td>${exception.reason}</td>
            </tr>
        </table>
    </c:if>
    <c:if test="${empty exception}">
        <div class="alert alert-danger">Không tìm thấy thông tin ngoại lệ!</div>
    </c:if>
</div>
</body>
</html> 