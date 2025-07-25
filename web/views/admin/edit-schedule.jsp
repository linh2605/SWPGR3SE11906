<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="admin-auth.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Chỉnh sửa lịch làm việc - Admin Dashboard</title>
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
                    <h2 class="section-title">Chỉnh sửa lịch làm việc</h2>
                    <a href="${pageContext.request.contextPath}/admin/working-schedules" class="btn btn-secondary">
                        <i class="bi bi-arrow-left"></i> Quay lại
                    </a>
                </div>

                <!-- Thông báo -->
                <c:if test="${sessionScope.error != null}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        ${sessionScope.error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <% session.removeAttribute("error"); %>
                </c:if>

                <!-- Form chỉnh sửa lịch làm việc -->
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">Thông tin lịch làm việc</h5>
                    </div>
                    <div class="card-body">
                        <form method="POST" action="${pageContext.request.contextPath}/admin/working-schedules">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="scheduleId" value="${schedule.scheduleId}">
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="doctorId" class="form-label">Bác sĩ <span class="text-danger">*</span></label>
                                        <select class="form-select" id="doctorId" name="doctorId" required>
                                            <option value="">Chọn bác sĩ</option>
                                            <c:forEach var="doctor" items="${doctors}">
                                                <option value="${doctor.doctor_id}" ${doctor.doctor_id == schedule.doctorId ? 'selected' : ''}>
                                                    ${doctor.user.fullName}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="weekDay" class="form-label">Thứ <span class="text-danger">*</span></label>
                                        <select class="form-select" id="weekDay" name="weekDay" required>
                                            <option value="">Chọn thứ</option>
                                            <option value="Thứ 2" ${schedule.weekDay == 'Thứ 2' ? 'selected' : ''}>Thứ 2</option>
                                            <option value="Thứ 3" ${schedule.weekDay == 'Thứ 3' ? 'selected' : ''}>Thứ 3</option>
                                            <option value="Thứ 4" ${schedule.weekDay == 'Thứ 4' ? 'selected' : ''}>Thứ 4</option>
                                            <option value="Thứ 5" ${schedule.weekDay == 'Thứ 5' ? 'selected' : ''}>Thứ 5</option>
                                            <option value="Thứ 6" ${schedule.weekDay == 'Thứ 6' ? 'selected' : ''}>Thứ 6</option>
                                            <option value="Thứ 7" ${schedule.weekDay == 'Thứ 7' ? 'selected' : ''}>Thứ 7</option>
                                            <option value="Chủ nhật" ${schedule.weekDay == 'Chủ nhật' ? 'selected' : ''}>Chủ nhật</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="shiftId" class="form-label">Ca làm việc <span class="text-danger">*</span></label>
                                        <select class="form-select" id="shiftId" name="shiftId" required>
                                            <option value="">Chọn ca</option>
                                            <c:forEach var="shift" items="${shifts}">
                                                <option value="${shift.shiftId}" ${shift.shiftId == schedule.shiftId ? 'selected' : ''}>
                                                    ${shift.name} (${shift.startTime} - ${shift.endTime})
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="maxPatients" class="form-label">Số bệnh nhân tối đa</label>
                                        <input type="number" class="form-control" id="maxPatients" name="maxPatients" 
                                               value="${schedule.maxPatients}" min="1" max="50">
                                        <div class="form-text">Mặc định: 10 bệnh nhân</div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="isActive" class="form-label">Trạng thái</label>
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" id="isActive" name="isActive" 
                                                   ${schedule.active ? 'checked' : ''}>
                                            <label class="form-check-label" for="isActive">
                                                Hoạt động
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="d-flex justify-content-end gap-2">
                                <a href="${pageContext.request.contextPath}/admin/working-schedules" class="btn btn-secondary">
                                    <i class="bi bi-x-circle"></i> Hủy
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-check-circle"></i> Cập nhật lịch làm việc
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <%@ include file="../layouts/footer.jsp" %>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js">
<script src="${pageContext.request.contextPath}/assets/js/jwt-manager.js"></script></script>
</body>
</html> 