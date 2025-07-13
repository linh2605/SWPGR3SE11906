<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="true" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Lịch làm việc - G3 Hospital</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/2.3.2/css/dataTables.dataTables.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
</head>
<body>
    <div class="wrapper">
        <%@ include file="../layouts/header.jsp" %>
        <div class="container">
            <%@ include file="../layouts/doctor-side-bar.jsp" %>
            <div class="content">
                <h2 class="section-title">Lịch làm việc của tôi</h2>
                
                <!-- Thông báo -->
                <c:if test="${param.success != null}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        Yêu cầu của bạn đã được gửi thành công!
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                <c:if test="${param.error != null}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        Có lỗi xảy ra: ${param.error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                
                <!-- Nút thao tác -->
                <div class="mb-3">
                    <a href="${pageContext.request.contextPath}/doctor-schedule?action=exceptions" class="btn btn-warning">
                        <i class="bi bi-calendar-x"></i> Gửi yêu cầu ngoại lệ
                    </a>
                </div>
                
                <!-- Bảng lịch làm việc -->
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">Lịch làm việc hàng tuần</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-striped" id="scheduleTable">
                                <thead>
                                    <tr>
                                        <th>Thứ</th>
                                        <th>Ca</th>
                                        <th>Giờ bắt đầu</th>
                                        <th>Giờ kết thúc</th>
                                        <th>Số bệnh nhân tối đa</th>
                                        <th>Trạng thái</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="schedule" items="${schedules}">
                                        <tr>
                                            <td>${schedule.weekDay}</td>
                                            <td>${schedule.shift.name}</td>
                                            <td>${schedule.shift.startTime}</td>
                                            <td>${schedule.shift.endTime}</td>
                                            <td>${schedule.maxPatients}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${schedule.active}">
                                                        <span class="badge bg-success">Hoạt động</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">Tạm dừng</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty schedules}">
                                        <tr>
                                            <td colspan="6" class="text-center">Chưa có lịch làm việc nào</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                
                <!-- Bảng ngoại lệ gần đây -->
                <div class="card mt-4">
                    <div class="card-header">
                        <h5 class="mb-0">Yêu cầu ngoại lệ gần đây</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-striped" id="exceptionsTable">
                                <thead>
                                    <tr>
                                        <th>Ngày</th>
                                        <th>Loại</th>
                                        <th>Lý do</th>
                                        <th>Trạng thái</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="exception" items="${exceptions}">
                                        <tr>
                                            <td>${exception.exceptionDate}</td>
                                            <td>${exception.exceptionType}</td>
                                            <td>${exception.reason}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${exception.status == 'Chờ duyệt'}">
                                                        <span class="badge bg-warning text-dark">Chờ duyệt</span>
                                                    </c:when>
                                                    <c:when test="${exception.status == 'Đã duyệt'}">
                                                        <span class="badge bg-success">Đã duyệt</span>
                                                    </c:when>
                                                    <c:when test="${exception.status == 'Đã từ chối'}">
                                                        <span class="badge bg-danger">Đã từ chối</span>
                                                    </c:when>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:if test="${exception.status == 'Chờ duyệt'}">
                                                    <a href="${pageContext.request.contextPath}/doctor-schedule?action=edit-exception&id=${exception.exceptionId}" 
                                                       class="btn btn-sm btn-outline-primary" title="Chỉnh sửa">
                                                        <i class="bi bi-pencil"></i>
                                                    </a>
                                                    <button class="btn btn-sm btn-outline-danger" 
                                                            onclick="deleteException(${exception.exceptionId})" title="Xóa">
                                                        <i class="bi bi-trash"></i>
                                                    </button>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty exceptions}">
                                        <tr>
                                            <td colspan="5" class="text-center">Chưa có yêu cầu ngoại lệ nào</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <%@ include file="../layouts/footer.jsp" %>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/scripts.js"></script>
    
    <script>
        function deleteException(exceptionId) {
            if (confirm('Bạn có chắc chắn muốn xóa yêu cầu này không?')) {
                window.location.href = '${pageContext.request.contextPath}/doctor-schedule?action=delete-exception&id=' + exceptionId;
            }
        }
    </script>
</body>
</html> 