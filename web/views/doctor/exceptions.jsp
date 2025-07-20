<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="true" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Yêu Cầu Ngoại Lệ - G3 Hospital</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/2.3.2/css/dataTables.dataTables.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
</head>
<body>
    <div class="wrapper">
        <%@ include file="../layouts/header.jsp" %>
        <div class="container">
            <%@ include file="../layouts/doctor-side-bar.jsp" %>
            <div class="content">
                <h2 class="section-title">Quản lý yêu cầu ngoại lệ</h2>
                
                <!-- Thông báo -->
                <c:if test="${param.success == 'added'}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        Gửi yêu cầu thành công!
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                <c:if test="${param.success == 'updated'}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        Cập nhật yêu cầu thành công!
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                <c:if test="${param.success == 'deleted'}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        Xóa yêu cầu thành công!
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                <c:if test="${param.error != null}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        Có lỗi xảy ra: ${param.error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                
                <!-- Nút thao tác -->
                <div class="mb-3">
                    <a href="${pageContext.request.contextPath}/doctor-schedule" class="btn btn-secondary">
                        <i class="bi bi-arrow-left"></i> Quay lại lịch làm việc
                    </a>
                    <a href="${pageContext.request.contextPath}/doctor-schedule?action=add-exception" class="btn btn-primary">
                        <i class="bi bi-plus-circle"></i> Tạo yêu cầu mới
                    </a>
                </div>
                
                <!-- Bảng ngoại lệ -->
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">Danh sách yêu cầu</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-striped" id="table">
                                <thead>
                                    <tr>
                                        <th>Ngày</th>
                                        <th>Loại</th>
                                        <th>Giờ làm việc</th>
                                        <th>Lý do</th>
                                        <th>Trạng thái</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="exception" items="${exceptions}">
                                        <tr>
                                            <td>${exception.exceptionDate}</td>
                                            <td>${exception.exceptionType}</td>
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
                                            <td>${exception.reason}</td>
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
                                            <td>
                                                <c:if test="${exception.status == 'Chờ duyệt'}">
                                                                                        <a href="${pageContext.request.contextPath}/doctor-schedule?action=edit-exception&id=${exception.exceptionId}" 
                                       class="btn btn-sm btn-outline-primary" title="Chỉnh sửa">
                                        <i class="bi bi-pencil"></i>
                                    </a>
                                    <button class="btn btn-sm btn-outline-danger" 
                                            onclick="deleteException(${exception.exceptionId})" title="Xóa">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty exceptions}">
                                        <tr>
                                            <td colspan="6" class="text-center">Chưa có yêu cầu ngoại lệ nào</td>
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
    $(document).ready(function() {
        $('#table').DataTable({
            language: {
                "language": {
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
        }
            },
            pageLength: 10,
            responsive: true,
            order: [[0, 'desc']]
        });
    });
    
    function deleteException(exceptionId) {
        if (confirm('Bạn có chắc chắn muốn xóa yêu cầu này không?')) {
            window.location.href = '${pageContext.request.contextPath}/doctor-schedule?action=delete-exception&id=' + exceptionId;
        }
    }
    </script>
</body>
</html> 