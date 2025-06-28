<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="admin-auth.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quản lý lịch làm việc - Admin Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
</head>
<body>
    <div class="wrapper">
        <%@ include file="../layouts/header.jsp" %>
        
        <div class="main">
            <%@include file="../layouts/admin-side-bar.jsp"%>
            <div class="content">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2 class="section-title">Quản lý lịch làm việc</h2>
                    <a href="${pageContext.request.contextPath}/admin/working-schedules?action=add" class="btn btn-primary">
                        <i class="bi bi-plus-circle"></i> Thêm lịch làm việc
                    </a>
                </div>

                <!-- Thông báo -->
                <c:if test="${sessionScope.success != null}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        ${sessionScope.success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <% session.removeAttribute("success"); %>
                </c:if>
                <c:if test="${sessionScope.error != null}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        ${sessionScope.error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <% session.removeAttribute("error"); %>
                </c:if>

                <!-- Bộ lọc -->
                <div class="card mb-4">
                    <div class="card-body">
                        <form method="GET" action="${pageContext.request.contextPath}/admin/working-schedules">
                            <input type="hidden" name="action" value="list">
                            <div class="row g-3">
                                <div class="col-md-3">
                                    <label for="doctorFilter" class="form-label">Bác sĩ</label>
                                    <select class="form-select" id="doctorFilter" name="doctorFilter">
                                        <option value="">Tất cả bác sĩ</option>
                                        <c:forEach var="doctor" items="${doctors}">
                                            <option value="${doctor.doctor_id}" ${param.doctorFilter == doctor.doctor_id ? 'selected' : ''}>
                                                ${doctor.user.fullName}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <label for="dayFilter" class="form-label">Thứ</label>
                                    <select class="form-select" id="dayFilter" name="dayFilter">
                                        <option value="">Tất cả</option>
                                        <option value="Thứ 2" ${param.dayFilter == 'Thứ 2' ? 'selected' : ''}>Thứ 2</option>
                                        <option value="Thứ 3" ${param.dayFilter == 'Thứ 3' ? 'selected' : ''}>Thứ 3</option>
                                        <option value="Thứ 4" ${param.dayFilter == 'Thứ 4' ? 'selected' : ''}>Thứ 4</option>
                                        <option value="Thứ 5" ${param.dayFilter == 'Thứ 5' ? 'selected' : ''}>Thứ 5</option>
                                        <option value="Thứ 6" ${param.dayFilter == 'Thứ 6' ? 'selected' : ''}>Thứ 6</option>
                                        <option value="Thứ 7" ${param.dayFilter == 'Thứ 7' ? 'selected' : ''}>Thứ 7</option>
                                        <option value="Chủ nhật" ${param.dayFilter == 'Chủ nhật' ? 'selected' : ''}>Chủ nhật</option>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <label for="shiftFilter" class="form-label">Ca làm việc</label>
                                    <select class="form-select" id="shiftFilter" name="shiftFilter">
                                        <option value="">Tất cả ca</option>
                                        <c:forEach var="shift" items="${shifts}">
                                            <option value="${shift.shiftId}" ${param.shiftFilter == shift.shiftId ? 'selected' : ''}>
                                                ${shift.name}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label">&nbsp;</label>
                                    <div>
                                        <button type="submit" class="btn btn-primary">
                                            <i class="bi bi-search"></i> Lọc
                                        </button>
                                        <a href="${pageContext.request.contextPath}/admin/working-schedules" class="btn btn-secondary">
                                            <i class="bi bi-arrow-clockwise"></i> Làm mới
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Bảng lịch làm việc -->
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">Danh sách lịch làm việc</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th>Bác sĩ</th>
                                        <th>Thứ</th>
                                        <th>Ca làm việc</th>
                                        <th>Giờ bắt đầu</th>
                                        <th>Giờ kết thúc</th>
                                        <th>Số bệnh nhân tối đa</th>
                                        <th>Trạng thái</th>
                                        <th>Ngày tạo</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="schedule" items="${schedules}">
                                        <tr>
                                            <td>
                                                <c:forEach var="doctor" items="${doctors}">
                                                    <c:if test="${doctor.doctor_id == schedule.doctorId}">
                                                        ${doctor.user.fullName}
                                                    </c:if>
                                                </c:forEach>
                                            </td>
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
                                                        <span class="badge bg-secondary">Không hoạt động</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>${schedule.createdAt}</td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/admin/working-schedules?action=detail&id=${schedule.scheduleId}" 
                                                   class="btn btn-sm btn-info" title="Xem chi tiết">
                                                    <i class="bi bi-eye"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/admin/working-schedules?action=edit&id=${schedule.scheduleId}" 
                                                   class="btn btn-sm btn-warning" title="Chỉnh sửa">
                                                    <i class="bi bi-pencil"></i>
                                                </a>
                                                <button class="btn btn-sm btn-danger" title="Xóa"
                                                        onclick="deleteSchedule(${schedule.scheduleId})">
                                                    <i class="bi bi-trash"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty schedules}">
                                        <tr>
                                            <td colspan="9" class="text-center">Không có lịch làm việc nào</td>
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

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function deleteSchedule(scheduleId) {
            if (confirm('Bạn có chắc chắn muốn xóa lịch làm việc này?')) {
                window.location.href = '${pageContext.request.contextPath}/admin/working-schedules?action=delete&id=' + scheduleId;
            }
        }
    </script>
</body>
</html> 