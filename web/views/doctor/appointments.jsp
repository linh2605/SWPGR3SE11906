<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Lịch hẹn của tôi - G3 Hospital</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
</head>
<body>
    <div class="wrapper">
        <%@ include file="../layouts/header.jsp" %>
        <div class="container">
            <%@ include file="../layouts/doctor-side-bar.jsp" %>
            <div class="content">
                <h2 class="section-title">Lịch hẹn của tôi</h2>
                
                <!-- Thông báo -->
                <c:if test="${param.success != null}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        Thao tác thành công!
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                <c:if test="${param.error != null}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        Có lỗi xảy ra: ${param.error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                
                <!-- Bảng lịch hẹn -->
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">Danh sách lịch hẹn</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Bệnh nhân</th>
                                        <th>Ngày hẹn</th>
                                        <th>Giờ hẹn</th>
                                        <th>Ghi chú</th>
                                        <th>Trạng thái</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="appointment" items="${appointments}">
                                        <tr>
                                            <td>${appointment.id}</td>
                                            <td>${appointment.patient.user.fullName}</td>
                                            <td>${appointment.appointmentDate}</td>
                                            <td>${appointment.appointmentTime}</td>
                                            <td>${appointment.notes != null ? appointment.notes : '---'}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${appointment.status == 'pending'}">
                                                        <span class="badge bg-warning text-dark">Chờ khám</span>
                                                    </c:when>
                                                    <c:when test="${appointment.status == 'completed'}">
                                                        <span class="badge bg-success">Đã hoàn thành</span>
                                                    </c:when>
                                                    <c:when test="${appointment.status == 'cancelled'}">
                                                        <span class="badge bg-danger">Đã hủy</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">${appointment.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:if test="${appointment.status == 'pending'}">
                                                    <button class="btn btn-sm btn-success" onclick="updateStatus(${appointment.id}, 'completed')">
                                                        <i class="bi bi-check-circle"></i> Hoàn thành
                                                    </button>
                                                    <button class="btn btn-sm btn-danger" onclick="updateStatus(${appointment.id}, 'cancelled')">
                                                        <i class="bi bi-x-circle"></i> Hủy
                                                    </button>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty appointments}">
                                        <tr>
                                            <td colspan="7" class="text-center">Chưa có lịch hẹn nào</td>
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
        function updateStatus(appointmentId, status) {
            if (confirm('Bạn có chắc chắn muốn cập nhật trạng thái lịch hẹn này?')) {
                // Gửi request cập nhật trạng thái
                fetch('${pageContext.request.contextPath}/update-appointment-status', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'appointmentId=' + appointmentId + '&status=' + status
                })
                .then(response => {
                    if (response.ok) {
                        location.reload();
                    } else {
                        alert('Có lỗi xảy ra khi cập nhật trạng thái');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Có lỗi xảy ra khi cập nhật trạng thái');
                });
            }
        }
    </script>
</body>
</html> 