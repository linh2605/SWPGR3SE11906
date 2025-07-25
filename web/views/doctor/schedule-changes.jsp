<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Yêu Cầu Đổi Ca Dài Hạn - G3 Hospital</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/2.3.2/css/dataTables.dataTables.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
    <style>
    .badge {
        font-size: 1em;
        padding: 0.5em 1em;
        border-radius: 0.5em;
    }
    .table td, .table th {
        vertical-align: middle;
        word-break: break-word;
    }
    a[title="Xem chi tiết"] {
        display: inline-block !important;
    }
    </style>
</head>
<body>
    <div class="wrapper">
        <%@ include file="../layouts/header.jsp" %>
        <div class="container">
            <%@ include file="../layouts/doctor-side-bar.jsp" %>
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
                <!-- Nút thao tác -->
                <div class="mb-3">
                    <a href="${pageContext.request.contextPath}/doctor/schedule" class="btn btn-secondary">
                        <i class="bi bi-arrow-left"></i> Quay lại lịch làm việc
                    </a>
                    <a href="${pageContext.request.contextPath}/doctor/schedule-changes?action=add" class="btn btn-primary me-2">
                        <i class="bi bi-plus-circle"></i> Gửi yêu cầu đổi ca
                    </a>
                    <a href="${pageContext.request.contextPath}/doctor/schedule-changes?action=add&cancel=1" class="btn btn-danger">
                        <i class="bi bi-x-circle"></i> Gửi yêu cầu hủy ca
                    </a>
                </div>
                <!-- Bảng yêu cầu đổi ca -->
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">Danh sách yêu cầu đổi ca dài hạn</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-striped" id="table">
                                <thead>
                                    <tr>
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
                                                                                <a href="${pageContext.request.contextPath}/doctor/schedule-changes?action=detail&id=<c:out value='${change.changeId}'/>" class="btn btn-outline-primary btn-sm" title="Xem chi tiết">
                                    <i class="bi bi-eye"></i>
                                </a>
                                <c:if test="${change.status == 'pending'}">
                                    <a href="${pageContext.request.contextPath}/doctor/schedule-changes?action=cancel&id=<c:out value='${change.changeId}'/>" class="btn btn-outline-primary btn-sm" onclick="return confirm('Bạn có chắc chắn muốn hủy yêu cầu này?');" title="Hủy yêu cầu">
                                        <i class="bi bi-x-circle"></i>
                                    </a>
                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty changes}">
                                        <tr>
                                            <td colspan="8" class="text-center">Chưa có yêu cầu đổi ca nào</td>
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
    <script src="https://cdn.datatables.net/2.3.2/js/dataTables.min.js">
    <script>
        // Tắt thông báo lỗi DataTables
        $.fn.dataTable.ext.errMode = 'none';
    </script></script>
    <script src="${pageContext.request.contextPath}/assets/js/scripts.js">
<script src="${pageContext.request.contextPath}/assets/js/jwt-manager.js"></script></script>
    <script>
        // Tắt DataTables để kiểm tra lỗi hiển thị nút con mắt
        // $(document).ready(function() {
        //     $('#table').DataTable({
        //         language: {
        //             "language": {
        //         "sProcessing": "Đang xử lý...",
        //         "sLengthMenu": "Xem _MENU_ mục",
        //         "sZeroRecords": "Không tìm thấy dữ liệu",
        //         "sInfo": "Đang xem _START_ đến _END_ trong tổng số _TOTAL_ mục",
        //         "sInfoEmpty": "Đang xem 0 đến 0 trong tổng số 0 mục",
        //         "sInfoFiltered": "(được lọc từ _MAX_ mục)",
        //         "sInfoPostFix": "",
        //         "sSearch": "Tìm:",
        //         "sUrl": "",
        //         "oPaginate": {
        //             "sFirst": "Đầu",
        //             "sPrevious": "Trước",
        //             "sNext": "Tiếp",
        //             "sLast": "Cuối"
        //         }
        //     }
        //     },
        //     pageLength: 10,
        //     responsive: true,
        //     order: [[3, 'desc']]
        // });
        // });
    </script>
</body>
</html> 