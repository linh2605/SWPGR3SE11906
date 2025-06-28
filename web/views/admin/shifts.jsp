<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="admin-auth.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quản lý ca làm việc - Admin Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
</head>

<body>
    <script>
        window.contextPath = '${pageContext.request.contextPath}';
    </script>
    <div class="wrapper">
        <%@ include file="../layouts/header.jsp" %>
        
        <div class="main">
            <%@include file="../layouts/admin-side-bar.jsp"%>
            <div class="content">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2 class="section-title">Quản lý ca làm việc</h2>
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addShiftModal">
                        <i class="bi bi-plus-circle"></i> Thêm ca làm việc
                    </button>
                </div>

                <!-- Thông báo -->
                <c:if test="${param.success != null}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        ${param.success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                <c:if test="${param.error != null}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        ${param.error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Bảng ca làm việc -->
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">Danh sách ca làm việc</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Tên ca</th>
                                        <th>Giờ bắt đầu</th>
                                        <th>Giờ kết thúc</th>
                                        <th>Mô tả</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="shift" items="${shifts}">
                                        <tr>
                                            <td>${shift.shiftId}</td>
                                            <td>
                                                <span class="badge bg-primary">${shift.name}</span>
                                            </td>
                                            <td>${shift.startTime}</td>
                                            <td>${shift.endTime}</td>
                                            <td>
                                                <span class="text-truncate d-inline-block" style="max-width: 200px;" 
                                                      title="${shift.description}">${shift.description}</span>
                                            </td>
                                            <td>
                                                <button class="btn btn-sm btn-outline-primary btn-view-detail" 
                                                        onclick="viewShiftDetail(${shift.shiftId})" 
                                                        style="display: inline-block !important;">
                                                    <i class="bi bi-eye"></i>
                                                </button>
                                                <button class="btn btn-sm btn-outline-warning" onclick="editShift(${shift.shiftId})">
                                                    <i class="bi bi-pencil"></i>
                                                </button>
                                                <button class="btn btn-sm btn-outline-danger" 
                                                        onclick="deleteShift(${shift.shiftId}, this)" 
                                                        data-shift-name="${shift.name}">
                                                    <i class="bi bi-trash"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty shifts}">
                                        <tr>
                                            <td colspan="6" class="text-center">Chưa có ca làm việc nào</td>
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

    <!-- Modal thêm ca làm việc -->
    <div class="modal fade" id="addShiftModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Thêm ca làm việc mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/admin/shifts" method="POST">
                    <input type="hidden" name="action" value="add">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="name" class="form-label">Tên ca làm việc *</label>
                            <input type="text" class="form-control" id="name" name="name" required>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="startTime" class="form-label">Giờ bắt đầu *</label>
                                    <input type="time" class="form-control" id="startTime" name="startTime" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="endTime" class="form-label">Giờ kết thúc *</label>
                                    <input type="time" class="form-control" id="endTime" name="endTime" required>
                                </div>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="description" class="form-label">Mô tả</label>
                            <textarea class="form-control" id="description" name="description" rows="3"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-primary">Thêm ca làm việc</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Modal chỉnh sửa ca làm việc -->
    <div class="modal fade" id="editShiftModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Chỉnh sửa ca làm việc</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/admin/shifts" method="POST">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="shiftId" id="editShiftId">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="editName" class="form-label">Tên ca làm việc *</label>
                            <input type="text" class="form-control" id="editName" name="name" required>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="editStartTime" class="form-label">Giờ bắt đầu *</label>
                                    <input type="time" class="form-control" id="editStartTime" name="startTime" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="editEndTime" class="form-label">Giờ kết thúc *</label>
                                    <input type="time" class="form-control" id="editEndTime" name="endTime" required>
                                </div>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="editDescription" class="form-label">Mô tả</label>
                            <textarea class="form-control" id="editDescription" name="description" rows="3"></textarea>
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

    <!-- Modal chi tiết ca làm việc -->
    <div class="modal fade" id="shiftDetailModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Chi tiết ca làm việc</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="shiftDetailContent">
                    <!-- Nội dung sẽ được load động -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/scripts.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/admin-shifts.js"></script>
</body>
</html> 