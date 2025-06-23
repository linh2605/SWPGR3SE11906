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
                        <span class="badge bg-warning text-dark me-2">
                            <i class="bi bi-clock"></i> Chờ duyệt: <span id="pendingCount">0</span>
                        </span>
                        <span class="badge bg-success me-2">
                            <i class="bi bi-check-circle"></i> Đã duyệt: <span id="approvedCount">0</span>
                        </span>
                        <span class="badge bg-danger">
                            <i class="bi bi-x-circle"></i> Từ chối: <span id="rejectedCount">0</span>
                        </span>
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
                                <label for="filterDoctor" class="form-label">Bác sĩ</label>
                                <select class="form-select" id="filterDoctor">
                                    <option value="">Tất cả bác sĩ</option>
                                    <c:forEach var="doctor" items="${doctors}">
                                        <option value="${doctor.doctorId}">${doctor.user.fullName}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label for="filterType" class="form-label">Loại yêu cầu</label>
                                <select class="form-select" id="filterType">
                                    <option value="">Tất cả</option>
                                    <option value="Nghỉ phép">Nghỉ phép</option>
                                    <option value="Thay đổi giờ làm">Thay đổi giờ làm</option>
                                    <option value="Khẩn cấp">Khẩn cấp</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label for="filterStatus" class="form-label">Trạng thái</label>
                                <select class="form-select" id="filterStatus">
                                    <option value="">Tất cả</option>
                                    <option value="Chờ duyệt">Chờ duyệt</option>
                                    <option value="Đã duyệt">Đã duyệt</option>
                                    <option value="Đã từ chối">Đã từ chối</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label for="filterDate" class="form-label">Ngày</label>
                                <input type="date" class="form-control" id="filterDate">
                            </div>
                        </div>
                        <div class="row mt-3">
                            <div class="col-12">
                                <button class="btn btn-primary" onclick="filterExceptions()">
                                    <i class="bi bi-funnel"></i> Lọc
                                </button>
                                <button class="btn btn-secondary" onclick="resetFilters()">
                                    <i class="bi bi-arrow-clockwise"></i> Làm mới
                                </button>
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
                            <table class="table table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Bác sĩ</th>
                                        <th>Ngày</th>
                                        <th>Loại yêu cầu</th>
                                        <th>Giờ làm việc mới</th>
                                        <th>Lý do</th>
                                        <th>Trạng thái</th>
                                        <th>Ngày tạo</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody id="exceptionTableBody">
                                    <c:forEach var="exception" items="${exceptions}">
                                        <tr data-exception-id="${exception.exceptionId}" 
                                            data-status="${exception.status}">
                                            <td>${exception.exceptionId}</td>
                                            <td>${exception.doctorName}</td>
                                            <td>${exception.exceptionDate}</td>
                                            <td>
                                                <span class="badge bg-info">${exception.exceptionType}</span>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${exception.exceptionType == 'Thay đổi giờ làm' && exception.newShift != null}">
                                                        ${exception.newShift.name} (${exception.newShift.startTime} - ${exception.newShift.endTime})
                                                    </c:when>
                                                    <c:otherwise>
                                                        Nghỉ cả ngày
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <span class="text-truncate d-inline-block" style="max-width: 200px;" 
                                                      title="${exception.reason}">${exception.reason}</span>
                                            </td>
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
                                            <td>${exception.createdAt}</td>
                                            <td>
                                                <button class="btn btn-sm btn-outline-primary" onclick="viewExceptionDetail(${exception.exceptionId})">
                                                    <i class="bi bi-eye"></i>
                                                </button>
                                                <c:if test="${exception.status == 'Chờ duyệt'}">
                                                    <button class="btn btn-sm btn-outline-success" onclick="approveException(${exception.exceptionId})">
                                                        <i class="bi bi-check-circle"></i>
                                                    </button>
                                                    <button class="btn btn-sm btn-outline-danger" onclick="rejectException(${exception.exceptionId})">
                                                        <i class="bi bi-x-circle"></i>
                                                    </button>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty exceptions}">
                                        <tr>
                                            <td colspan="9" class="text-center">Chưa có yêu cầu ngoại lệ nào</td>
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

    <!-- Modal chi tiết yêu cầu ngoại lệ -->
    <div class="modal fade" id="exceptionDetailModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Chi tiết yêu cầu ngoại lệ</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="exceptionDetailContent">
                    <!-- Nội dung sẽ được load động -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    <div id="actionButtons" style="display: none;">
                        <button type="button" class="btn btn-success" id="approveBtn">
                            <i class="bi bi-check-circle"></i> Duyệt
                        </button>
                        <button type="button" class="btn btn-danger" id="rejectBtn">
                            <i class="bi bi-x-circle"></i> Từ chối
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal từ chối yêu cầu -->
    <div class="modal fade" id="rejectModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Từ chối yêu cầu</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form id="rejectForm">
                    <input type="hidden" id="rejectExceptionId" name="exceptionId">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="rejectReason" class="form-label">Lý do từ chối *</label>
                            <textarea class="form-control" id="rejectReason" name="rejectReason" 
                                      rows="3" required placeholder="Nhập lý do từ chối..."></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-danger">Từ chối</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/scripts.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/admin-exceptions.js"></script>
</body>
</html> 