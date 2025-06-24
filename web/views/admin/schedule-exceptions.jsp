<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="admin-auth.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Duyệt yêu cầu ngoại lệ - Admin Dashboard</title>
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
                    <h2 class="section-title">Duyệt yêu cầu ngoại lệ</h2>
                    <div>
                        <button class="btn btn-outline-primary" onclick="loadExceptions()">
                            <i class="bi bi-arrow-clockwise"></i> Làm mới
                        </button>
                    </div>
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
                                <label for="statusFilter" class="form-label">Trạng thái</label>
                                <select class="form-select" id="statusFilter">
                                    <option value="">Tất cả</option>
                                    <option value="Chờ duyệt">Chờ duyệt</option>
                                    <option value="Đã duyệt">Đã duyệt</option>
                                    <option value="Từ chối">Từ chối</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label for="dateFilter" class="form-label">Ngày</label>
                                <input type="date" class="form-control" id="dateFilter">
                            </div>
                            <div class="col-md-3">
                                <label for="searchInput" class="form-label">Tìm kiếm</label>
                                <input type="text" class="form-control" id="searchInput" placeholder="Tìm kiếm...">
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Bảng yêu cầu ngoại lệ -->
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">Danh sách yêu cầu ngoại lệ</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-striped table-hover" id="exceptionsTable">
                                <thead>
                                    <tr>
                                        <th>Bác sĩ</th>
                                        <th>Ngày ngoại lệ</th>
                                        <th>Loại ngoại lệ</th>
                                        <th>Ca mới</th>
                                        <th>Lý do</th>
                                        <th>Trạng thái</th>
                                        <th>Ngày gửi</th>
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

    <!-- Modal chi tiết ngoại lệ -->
    <div class="modal fade" id="exceptionDetailModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Chi tiết yêu cầu ngoại lệ</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6">
                            <p><strong>Bác sĩ:</strong> <span id="detailDoctorName"></span></p>
                            <p><strong>Ngày ngoại lệ:</strong> <span id="detailExceptionDate"></span></p>
                            <p><strong>Loại ngoại lệ:</strong> <span id="detailExceptionType"></span></p>
                        </div>
                        <div class="col-md-6">
                            <p><strong>Ca mới:</strong> <span id="detailNewShiftName"></span></p>
                            <p><strong>Trạng thái:</strong> <span id="detailStatus"></span></p>
                            <p><strong>Ngày gửi:</strong> <span id="detailSubmittedDate"></span></p>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12">
                            <p><strong>Lý do:</strong></p>
                            <div class="border rounded p-3 bg-light">
                                <span id="detailReason"></span>
                            </div>
                        </div>
                    </div>
                    <div class="row" id="adminCommentSection" style="display: none;">
                        <div class="col-12">
                            <p><strong>Ghi chú của admin:</strong></p>
                            <div class="border rounded p-3 bg-light">
                                <span id="detailAdminComment"></span>
                            </div>
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
    <script src="${pageContext.request.contextPath}/assets/js/admin-exceptions.js"></script>
</body>
</html> 