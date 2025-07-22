<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ include file="admin-auth.jsp" %>
<%@ page import="java.lang.String" %>
<%
    String editId = request.getParameter("edit");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Quản lý liên hệ - G3 Hospital Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/2.3.2/css/dataTables.dataTables.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
</head>
<body>
<div class="wrapper">
    <%@ include file="../layouts/header.jsp" %>
    <div class="main">
<%@include file="../layouts/admin-side-bar.jsp"%>
        <div class="content">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="section-title">Quản lý liên hệ (Contact Us)</h2>
            </div>
            
            <c:if test="${not empty messages}">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">Danh sách tin nhắn liên hệ</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-striped table-hover align-middle" id="table">
                        <thead>
                        <tr>
                            <th class="text-center">#</th>
                            <th class="text-start">Họ tên</th>
                            <th class="text-start">Email</th>
                            <th class="text-center">SĐT</th>
                            <th class="text-center">Chủ đề</th>
                            <th class="text-start">Nội dung</th>
                            <th class="text-center">Trạng thái</th>
                            <th class="text-center">Ưu tiên</th>
                            <th class="text-center">Ngày gửi</th>
                            <th class="text-center">Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="msg" items="${messages}" varStatus="loop">
                            <tr>
                                <td class="text-center"><c:out value="${loop.index + 1}"/></td>
                                <td class="text-start"><c:out value="${msg.name}"/></td>
                                <td class="text-start"><c:out value="${msg.email}"/></td>
                                <td class="text-center"><c:out value="${msg.phone}"/></td>
                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${msg.subject eq 'service_feedback'}">Góp ý dịch vụ</c:when>
                                        <c:when test="${msg.subject eq 'incident_report'}">Báo cáo sự cố</c:when>
                                        <c:when test="${msg.subject eq 'improvement_suggestion'}">Đề xuất cải thiện</c:when>
                                        <c:when test="${msg.subject eq 'cooperation'}">Liên hệ hợp tác</c:when>
                                        <c:otherwise>Khác</c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-start"><c:out value="${fn:length(msg.message) > 40 ? fn:substring(msg.message, 0, 40) : msg.message}"/><c:if test="${fn:length(msg.message) > 40}">...</c:if></td>
                                <td class="text-center">
                                    <form method="post" action="${pageContext.request.contextPath}/contactManager" style="display:inline;">
                                        <input type="hidden" name="action" value="updateStatus" />
                                        <input type="hidden" name="id" value="${msg.message_id}" />
                                        <select name="status" class="form-select form-select-sm d-inline w-auto" onchange="this.form.submit()">
                                            <option value="pending" ${msg.status eq 'pending' ? 'selected' : ''}>Chờ xử lý</option>
                                            <option value="in_progress" ${msg.status eq 'in_progress' ? 'selected' : ''}>Đang xử lý</option>
                                            <option value="resolved" ${msg.status eq 'resolved' ? 'selected' : ''}>Đã xử lý</option>
                                        </select>
                                    </form>
                                </td>
                                <td class="text-center">
                                    <form method="post" action="${pageContext.request.contextPath}/contactManager" style="display:inline;">
                                        <input type="hidden" name="action" value="updatePriority" />
                                        <input type="hidden" name="id" value="${msg.message_id}" />
                                        <select name="priority" class="form-select form-select-sm d-inline w-auto" onchange="this.form.submit()">
                                            <option value="high" ${msg.priority eq 'high' ? 'selected' : ''}>Cao</option>
                                            <option value="medium" ${msg.priority eq 'medium' ? 'selected' : ''}>Trung bình</option>
                                            <option value="low" ${msg.priority eq 'low' ? 'selected' : ''}>Thấp</option>
                                        </select>
                                    </form>
                                </td>
                                <td class="text-center"><c:out value="${msg.created_at}"/></td>
                                <td class="text-center">
                                    <a href="${pageContext.request.contextPath}/contactManager?view=${msg.message_id}" class="btn btn-outline-primary btn-sm mb-1" title="Xem">
                                        <i class="bi bi-eye"></i>
                                    </a>
                                    <form method="post" action="${pageContext.request.contextPath}/contactManager" style="display:inline;">
                                        <input type="hidden" name="action" value="delete" />
                                        <input type="hidden" name="id" value="${msg.message_id}" />
                                        <button type="button" class="btn btn-outline-primary btn-sm mb-1" title="Xóa" onclick="if(confirm('Bạn có chắc chắn muốn xóa liên hệ này?')) { document.getElementById('deleteForm_${msg.message_id}').submit(); }">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                    </form>
                                    <form id="deleteForm_${msg.message_id}" method="post" action="${pageContext.request.contextPath}/contactManager" style="display:none;">
                                        <input type="hidden" name="action" value="delete" />
                                        <input type="hidden" name="id" value="${msg.message_id}" />
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </c:if>
            <c:if test="${empty messages}">
                <div class="card">
                    <div class="card-body text-center">
                        <div class="alert alert-info mb-0">Chưa có tin nhắn liên hệ nào.</div>
                    </div>
                </div>
            </c:if>
        </div>
    </div>
    <%@ include file="../layouts/footer.jsp" %>
</div>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
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
            order: [[8, 'desc']]
        });
    });
</script>
</body>
</html>