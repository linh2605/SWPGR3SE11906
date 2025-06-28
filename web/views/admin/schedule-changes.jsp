<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản Lý Yêu Cầu Đổi Ca Dài Hạn - Admin</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
</head>
<body>
    <div class="wrapper">
        <%@ include file="../layouts/header.jsp" %>
        <div class="main">
            <%@ include file="../layouts/admin-side-bar.jsp" %>
            <div class="content">
                <h2 class="section-title">Quản lý yêu cầu đổi ca dài hạn</h2>
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
                <!-- Bảng yêu cầu đổi ca -->
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">Danh sách yêu cầu đổi ca dài hạn</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-striped align-middle text-center">
                                <thead>
                                    <tr>
                                        <th>Bác sĩ</th>
                                        <th>Loại yêu cầu</th>
                                        <th>Ca cũ</th>
                                        <th>Ca mới</th>
                                        <th>Ngày bắt đầu</th>
                                        <th>Ngày kết thúc</th>
                                        <th>Lý do</th>
                                        <th>Trạng thái</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="change" items="${changes}">
                                        <tr>
                                            <td>${change.doctor.user.fullName}</td>
                                            <td>
                                                <span class="badge ${change.isCancelRequest() ? 'bg-danger' : 'bg-primary'}">
                                                    ${change.typeDisplay}
                                                </span>
                                            </td>
                                            <td>${change.oldShift.name} (${change.oldShift.startTime} - ${change.oldShift.endTime})</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${change.isCancelRequest()}">
                                                        <span class="text-danger">Hủy ca</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${change.newShift.name} (${change.newShift.startTime} - ${change.newShift.endTime})
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>${change.effectiveDate}</td>
                                            <td><c:out value="${change.endDate != null ? change.endDate : 'Không xác định'}"/></td>
                                            <td>${change.changeReason}</td>
                                            <td>
                                                <span class="badge ${change.statusBadgeClass}">${change.statusDisplay}</span>
                                            </td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/admin/schedule-changes?action=detail&id=${change.changeId}" class="btn btn-sm btn-info">
                                                    <i class="bi bi-eye"></i> Xem
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty changes}">
                                        <tr>
                                            <td colspan="9" class="text-center">Chưa có yêu cầu đổi ca nào</td>
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
</body>
</html> 