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
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addScheduleModal">
                        <i class="bi bi-plus-circle"></i> Thêm lịch làm việc
                    </button>
                </div>

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

                <!-- Bộ lọc -->
                <div class="card mb-4">
                    <div class="card-body">
                        <div class="row g-3">
                            <div class="col-md-3">
                                <label for="filterDoctor" class="form-label">Bác sĩ</label>
                                <select class="form-select" id="filterDoctor">
                                    <option value="">Tất cả bác sĩ</option>
                                    <c:forEach var="doctor" items="${doctors}">
                                        <option value="${doctor.doctorId}">${doctor.user.fullName}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label for="filterWeekDay" class="form-label">Thứ</label>
                                <select class="form-select" id="filterWeekDay">
                                    <option value="">Tất cả</option>
                                    <option value="Thứ 2">Thứ 2</option>
                                    <option value="Thứ 3">Thứ 3</option>
                                    <option value="Thứ 4">Thứ 4</option>
                                    <option value="Thứ 5">Thứ 5</option>
                                    <option value="Thứ 6">Thứ 6</option>
                                    <option value="Thứ 7">Thứ 7</option>
                                    <option value="Chủ nhật">Chủ nhật</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label for="filterShift" class="form-label">Ca làm việc</label>
                                <select class="form-select" id="filterShift">
                                    <option value="">Tất cả ca</option>
                                    <c:forEach var="shift" items="${shifts}">
                                        <option value="${shift.shiftId}">${shift.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label for="filterStatus" class="form-label">Trạng thái</label>
                                <select class="form-select" id="filterStatus">
                                    <option value="">Tất cả</option>
                                    <option value="true">Hoạt động</option>
                                    <option value="false">Tạm dừng</option>
                                </select>
                            </div>
                        </div>
                        <div class="row mt-3">
                            <div class="col-12">
                                <button class="btn btn-primary" onclick="filterSchedules()">
                                    <i class="bi bi-funnel"></i> Lọc
                                </button>
                                <button class="btn btn-secondary" onclick="resetFilters()">
                                    <i class="bi bi-arrow-clockwise"></i> Làm mới
                                </button>
                            </div>
                        </div>
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
                                        <th>ID</th>
                                        <th>Bác sĩ</th>
                                        <th>Thứ</th>
                                        <th>Ca làm việc</th>
                                        <th>Giờ làm việc</th>
                                        <th>Số BN tối đa</th>
                                        <th>Trạng thái</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody id="scheduleTableBody">
                                    <c:forEach var="schedule" items="${schedules}">
                                        <tr data-schedule-id="${schedule.scheduleId}">
                                            <td>${schedule.scheduleId}</td>
                                            <td>${schedule.doctorName}</td>
                                            <td>${schedule.weekDay}</td>
                                            <td>${schedule.shift.name}</td>
                                            <td>${schedule.shift.startTime} - ${schedule.shift.endTime}</td>
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
                                            <td>
                                                <button class="btn btn-sm btn-outline-primary" onclick="viewScheduleDetail(${schedule.scheduleId})">
                                                    <i class="bi bi-eye"></i>
                                                </button>
                                                <button class="btn btn-sm btn-outline-warning" onclick="editSchedule(${schedule.scheduleId})">
                                                    <i class="bi bi-pencil"></i>
                                                </button>
                                                <button class="btn btn-sm btn-outline-danger" onclick="deleteSchedule(${schedule.scheduleId})">
                                                    <i class="bi bi-trash"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty schedules}">
                                        <tr>
                                            <td colspan="8" class="text-center">Chưa có lịch làm việc nào</td>
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

    <!-- Modal thêm lịch làm việc -->
    <div class="modal fade" id="addScheduleModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Thêm lịch làm việc mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form id="addScheduleForm">
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="doctorId" class="form-label">Bác sĩ *</label>
                                    <select class="form-select" id="doctorId" name="doctorId" required>
                                        <option value="">Chọn bác sĩ</option>
                                        <c:forEach var="doctor" items="${doctors}">
                                            <option value="${doctor.doctorId}">${doctor.user.fullName} - ${doctor.specialty.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="weekDay" class="form-label">Thứ *</label>
                                    <select class="form-select" id="weekDay" name="weekDay" required>
                                        <option value="">Chọn thứ</option>
                                        <option value="Thứ 2">Thứ 2</option>
                                        <option value="Thứ 3">Thứ 3</option>
                                        <option value="Thứ 4">Thứ 4</option>
                                        <option value="Thứ 5">Thứ 5</option>
                                        <option value="Thứ 6">Thứ 6</option>
                                        <option value="Thứ 7">Thứ 7</option>
                                        <option value="Chủ nhật">Chủ nhật</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="shiftId" class="form-label">Ca làm việc *</label>
                                    <select class="form-select" id="shiftId" name="shiftId" required>
                                        <option value="">Chọn ca làm việc</option>
                                        <c:forEach var="shift" items="${shifts}">
                                            <option value="${shift.shiftId}">${shift.name} (${shift.startTime} - ${shift.endTime})</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="maxPatients" class="form-label">Số bệnh nhân tối đa *</label>
                                    <input type="number" class="form-control" id="maxPatients" name="maxPatients" 
                                           min="1" max="50" value="10" required>
                                </div>
                            </div>
                        </div>
                        <div class="mb-3">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="isActive" name="isActive" checked>
                                <label class="form-check-label" for="isActive">
                                    Kích hoạt lịch làm việc
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-primary">Thêm lịch làm việc</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Modal chỉnh sửa lịch làm việc -->
    <div class="modal fade" id="editScheduleModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Chỉnh sửa lịch làm việc</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form id="editScheduleForm">
                    <input type="hidden" id="editScheduleId" name="scheduleId">
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="editDoctorId" class="form-label">Bác sĩ *</label>
                                    <select class="form-select" id="editDoctorId" name="doctorId" required>
                                        <option value="">Chọn bác sĩ</option>
                                        <c:forEach var="doctor" items="${doctors}">
                                            <option value="${doctor.doctorId}">${doctor.user.fullName} - ${doctor.specialty.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="editWeekDay" class="form-label">Thứ *</label>
                                    <select class="form-select" id="editWeekDay" name="weekDay" required>
                                        <option value="">Chọn thứ</option>
                                        <option value="Thứ 2">Thứ 2</option>
                                        <option value="Thứ 3">Thứ 3</option>
                                        <option value="Thứ 4">Thứ 4</option>
                                        <option value="Thứ 5">Thứ 5</option>
                                        <option value="Thứ 6">Thứ 6</option>
                                        <option value="Thứ 7">Thứ 7</option>
                                        <option value="Chủ nhật">Chủ nhật</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="editShiftId" class="form-label">Ca làm việc *</label>
                                    <select class="form-select" id="editShiftId" name="shiftId" required>
                                        <option value="">Chọn ca làm việc</option>
                                        <c:forEach var="shift" items="${shifts}">
                                            <option value="${shift.shiftId}">${shift.name} (${shift.startTime} - ${shift.endTime})</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="editMaxPatients" class="form-label">Số bệnh nhân tối đa *</label>
                                    <input type="number" class="form-control" id="editMaxPatients" name="maxPatients" 
                                           min="1" max="50" required>
                                </div>
                            </div>
                        </div>
                        <div class="mb-3">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="editIsActive" name="isActive">
                                <label class="form-check-label" for="editIsActive">
                                    Kích hoạt lịch làm việc
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-primary">Cập nhật</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Modal chi tiết lịch làm việc -->
    <div class="modal fade" id="scheduleDetailModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Chi tiết lịch làm việc</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="scheduleDetailContent">
                    <!-- Nội dung sẽ được load động -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/scripts.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/admin-schedules.js"></script>
</body>
</html> 