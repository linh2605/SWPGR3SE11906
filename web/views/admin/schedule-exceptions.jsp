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
                        <a href="${pageContext.request.contextPath}/admin/schedule-exceptions" class="btn btn-outline-primary">
                            <i class="bi bi-arrow-clockwise"></i> Làm mới
                        </a>
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
                <form method="get" action="${pageContext.request.contextPath}/admin/schedule-exceptions" class="card mb-4 p-3 shadow-sm">
                    <div class="row g-3 align-items-end">
                        <div class="col-md-3">
                            <label for="doctorId" class="form-label">Bác sĩ</label>
                            <select class="form-select" id="doctorId" name="doctorId">
                                <option value="">Tất cả bác sĩ</option>
                                <c:forEach var="doctor" items="${doctors}">
                                    <option value="${doctor.doctor_id}" <c:if test="${filterDoctorId != null && filterDoctorId == doctor.doctor_id}">selected</c:if>>
                                        Dr. ${doctor.user.fullName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <label for="status" class="form-label">Trạng thái</label>
                            <select class="form-select" id="status" name="status">
                                <option value="">Tất cả</option>
                                <option value="pending" <c:if test="${filterStatus == 'pending'}">selected</c:if>>Chờ duyệt</option>
                                <option value="approved" <c:if test="${filterStatus == 'approved'}">selected</c:if>>Đã duyệt</option>
                                <option value="rejected" <c:if test="${filterStatus == 'rejected'}">selected</c:if>>Từ chối</option>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <label for="date" class="form-label">Ngày</label>
                            <input type="date" class="form-control" id="date" name="date" value="${filterDate}">
                        </div>
                        <div class="col-md-3">
                            <label for="keyword" class="form-label">Tìm kiếm</label>
                            <input type="text" class="form-control" id="keyword" name="keyword" placeholder="Tìm kiếm..." value="${filterKeyword}">
                        </div>
                        <div class="col-md-2 d-grid">
                            <button type="submit" class="btn btn-primary"><i class="bi bi-search"></i> Lọc</button>
                        </div>
                    </div>
                </form>

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
                                    <c:choose>
                                        <c:when test="${empty exceptions}">
                                            <tr>
                                                <td colspan="8" class="text-center">Không có yêu cầu ngoại lệ nào</td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="exception" items="${exceptions}">
                                                <tr>
                                                    <td>${exception.doctorName}</td>
                                                    <td>${exception.exceptionDate}</td>
                                                    <td>${exception.exceptionType}</td>
                                                    <td>${exception.newShiftName}</td>
                                                    <td>${exception.reason}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${exception.status == 'pending'}">
                                                                <span class="badge bg-warning">Chờ duyệt</span>
                                                            </c:when>
                                                            <c:when test="${exception.status == 'approved'}">
                                                                <span class="badge bg-success">Đã duyệt</span>
                                                            </c:when>
                                                            <c:when test="${exception.status == 'rejected'}">
                                                                <span class="badge bg-danger">Từ chối</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-secondary">${exception.status}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>${exception.createdAt}</td>
                                                    <td>
                                                        <c:if test="${exception.status == 'pending'}">
                                                            <form method="post" action="${pageContext.request.contextPath}/admin/schedule-exceptions" style="display: inline;">
                                                                <input type="hidden" name="action" value="approve">
                                                                <input type="hidden" name="exceptionId" value="${exception.exceptionId}">
                                                                <button type="submit" class="btn btn-sm btn-success" onclick="return confirm('Bạn có chắc chắn muốn duyệt yêu cầu này?')">
                                                                    <i class="bi bi-check"></i>
                                                                </button>
                                                            </form>
                                                            <form method="post" action="${pageContext.request.contextPath}/admin/schedule-exceptions" style="display: inline;">
                                                                <input type="hidden" name="action" value="reject">
                                                                <input type="hidden" name="exceptionId" value="${exception.exceptionId}">
                                                                <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Bạn có chắc chắn muốn từ chối yêu cầu này?')">
                                                                    <i class="bi bi-x"></i>
                                                                </button>
                                                            </form>
                                                        </c:if>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
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
</body>
</html> 