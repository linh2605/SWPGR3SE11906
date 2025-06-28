<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:if test="${not empty shift}">
    <div class="mb-2"><strong>ID:</strong> ${shift.shiftId}</div>
    <div class="mb-2"><strong>Tên ca:</strong> <span class="badge bg-primary">${shift.name}</span></div>
    <div class="mb-2"><strong>Giờ bắt đầu:</strong> ${shift.startTime}</div>
    <div class="mb-2"><strong>Giờ kết thúc:</strong> ${shift.endTime}</div>
    <div class="mb-2"><strong>Mô tả:</strong> ${shift.description}</div>
</c:if>
<c:if test="${empty shift}">
    <div class="text-danger">Không tìm thấy thông tin ca làm việc.</div>
</c:if> 