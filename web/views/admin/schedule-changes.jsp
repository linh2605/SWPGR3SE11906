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
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/2.3.2/css/dataTables.dataTables.min.css">
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
                            <table class="table table-striped align-middle text-center" id="table">
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
                                            <td>${not empty change.doctor && not empty change.doctor.user ? change.doctor.user.fullName : ''}</td>
                                            <td>
                                                <span class="badge ${change.isCancelRequest() ? 'bg-danger' : 'bg-primary'}">
                                                    ${change.typeDisplay}
                                                </span>
                                            </td>
                                            <td>${not empty change.oldShift ? change.oldShift.name : ''} (${not empty change.oldShift ? change.oldShift.startTime : ''} - ${not empty change.oldShift ? change.oldShift.endTime : ''})</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${change.isCancelRequest()}">
                                                        <span class="text-danger">Hủy ca</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${not empty change.newShift ? change.newShift.name : ''} (${not empty change.newShift ? change.newShift.startTime : ''} - ${not empty change.newShift ? change.newShift.endTime : ''})
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
                                                <c:if test="${not empty change.changeId}">
                                                    <a href="${pageContext.request.contextPath}/admin/schedule-changes?action=detail&id=${change.changeId}" class="btn btn-outline-primary btn-sm" title="Xem chi tiết">
                                                        <i class="bi bi-eye"></i>
                                                    </a>
                                                </c:if>
                                                <c:if test="${change.status == 'pending'}">
                                                    <form action="${pageContext.request.contextPath}/admin/schedule-changes" method="post" style="display:inline;">
                                                        <input type="hidden" name="action" value="process">
                                                        <input type="hidden" name="decision" value="approve">
                                                        <input type="hidden" name="changeId" value="${change.changeId}">
                                                        <button type="submit" class="btn btn-success btn-sm" title="Duyệt"><i class="bi bi-check"></i></button>
                                                    </form>
                                                    <form action="${pageContext.request.contextPath}/admin/schedule-changes" method="post" style="display:inline;">
                                                        <input type="hidden" name="action" value="process">
                                                        <input type="hidden" name="decision" value="reject">
                                                        <input type="hidden" name="changeId" value="${change.changeId}">
                                                        <button type="submit" class="btn btn-danger btn-sm" title="Từ chối"><i class="bi bi-x"></i></button>
                                                    </form>
                                                </c:if>
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
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.datatables.net/2.3.2/js/dataTables.min.js"></script>
    <script>
        // Tắt thông báo lỗi DataTables
        $.fn.dataTable.ext.errMode = 'none';
    </script>
    <script src="${pageContext.request.contextPath}/assets/js/scripts.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jwt-manager.js"></script>
    <script>
        $(document).ready(function() {
            $('#table').DataTable({
                language: {
                    "sProcessing": "Đang xử lý...",
                    "sLengthMenu": "Xem _MENU_ mục",
                    "sZeroRecords": "Không tìm thấy dữ liệu",
                    "sInfo": "Đang xem _START_ đến _END_ trong tổng số _TOTAL_ mục",
                    "sInfoEmpty": "Đang xem 0 đến 0 trong tổng số 0 mục",
                    "sInfoFiltered": "(được lọc từ _MAX_ mục)",
                    "sInfoPostFix": "",
                    "sSearch": "Tìm:",
                    "sUrl": "",
                    "oPaginate": {
                        "sFirst": "Đầu",
                        "sPrevious": "Trước",
                        "sNext": "Tiếp",
                        "sLast": "Cuối"
                    }
                },
                pageLength: 10,
                responsive: true,
                order: [[4, 'desc']]
            });
        });
    </script>
</body>
</html> 