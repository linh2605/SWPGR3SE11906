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

                <!-- Loading indicator -->
                <div id="loading" class="text-center" style="display: none;">
                    <div class="spinner-border text-primary" role="status">
                        <span class="visually-hidden">Đang tải...</span>
                    </div>
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
                                <label for="doctorFilter" class="form-label">Bác sĩ</label>
                                <select class="form-select" id="doctorFilter">
                                    <option value="">Tất cả bác sĩ</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label for="dayFilter" class="form-label">Thứ</label>
                                <select class="form-select" id="dayFilter">
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
                                <label for="shiftFilter" class="form-label">Ca làm việc</label>
                                <select class="form-select" id="shiftFilter">
                                    <option value="">Tất cả ca</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label for="searchInput" class="form-label">Tìm kiếm</label>
                                <input type="text" class="form-control" id="searchInput" placeholder="Tìm kiếm...">
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
                            <table class="table table-striped table-hover" id="schedulesTable">
                                <thead>
                                    <tr>
                                        <th>Bác sĩ</th>
                                        <th>Thứ</th>
                                        <th>Ca làm việc</th>
                                        <th>Giờ bắt đầu</th>
                                        <th>Giờ kết thúc</th>
                                        <th>Trạng thái</th>
                                        <th>Ngày tạo</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <!-- Data will be loaded by JavaScript -->
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
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="dayOfWeek" class="form-label">Thứ *</label>
                                    <select class="form-select" id="dayOfWeek" name="dayOfWeek" required>
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
                                        <option value="">Chọn ca</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="isActive" class="form-label">Trạng thái</label>
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" id="isActive" name="isActive" checked>
                                        <label class="form-check-label" for="isActive">
                                            Hoạt động
                                        </label>
                                    </div>
                                </div>
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
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="editDayOfWeek" class="form-label">Thứ *</label>
                                    <select class="form-select" id="editDayOfWeek" name="dayOfWeek" required>
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
                                        <option value="">Chọn ca</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="editIsActive" class="form-label">Trạng thái</label>
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" id="editIsActive" name="isActive">
                                        <label class="form-check-label" for="editIsActive">
                                            Hoạt động
                                        </label>
                                    </div>
                                </div>
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
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6">
                            <p><strong>Bác sĩ:</strong> <span id="detailDoctorName"></span></p>
                            <p><strong>Thứ:</strong> <span id="detailDayOfWeek"></span></p>
                            <p><strong>Ca:</strong> <span id="detailShiftName"></span></p>
                        </div>
                        <div class="col-md-6">
                            <p><strong>Giờ bắt đầu:</strong> <span id="detailStartTime"></span></p>
                            <p><strong>Giờ kết thúc:</strong> <span id="detailEndTime"></span></p>
                            <p><strong>Trạng thái:</strong> <span id="detailIsActive"></span></p>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12">
                            <p><strong>Ngày tạo:</strong> <span id="detailCreatedDate"></span></p>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/admin-schedules.js"></script>
</body>
</html> 