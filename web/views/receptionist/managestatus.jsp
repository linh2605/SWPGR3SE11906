<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ include file="receptionist-auth.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Receptionist Dashboard - G3 Hospital</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/2.3.2/css/dataTables.dataTables.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
    
    <style>
        .btn-update {
            width: 100%; /* Đảm bảo chiều rộng của tất cả các button là 100% */
            height: 40px; /* Đảm bảo chiều cao của tất cả các button bằng nhau */
            margin: 5px 0; /* Khoảng cách giữa các button */
            text-align: center; /* Căn giữa văn bản trong button */
        }
    </style>
</head>
<body>
<div class="wrapper">
    <%@ include file="../layouts/header.jsp" %>

    <div class="content">
        <div class="container mt-5">
            <h2 class="mb-4">Danh sách bệnh nhân đang chờ</h2>

            <c:if test="${not empty message}">
                <div class="alert alert-success">${message}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <table class="table table-bordered table-hover" id="table">
                <thead class="table-primary">
                    <tr>
                        <!-- Thêm cột số thứ tự -->
                        <th>STT</th>
                        <th>ID</th>
                        <th>Họ tên</th>
                        <th>Trạng thái hiện tại</th>
                        <th>Cập nhật trạng thái</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="p" items="${patients}" varStatus="status">
                        <tr>
                            <!-- Hiển thị số thứ tự -->
                            <td>${status.index + 1}</td>
                            <td>${p.patientId}</td>
                            <td>${p.fullName}</td>
                            <td>${p.statusDescription}</td>
                            <td>
                                <form action="receptionistuplate" method="post" class="d-flex gap-2">
                                    <input type="hidden" name="patientId" value="${p.patientId}" />

                                    <!-- Kiểm tra trạng thái của bệnh nhân để hiển thị các button phù hợp -->
                                    <c:choose>
                                        <c:when test="${p.statusCode == 1}">
                                            <button type="submit" name="statusCode" value="2" class="btn btn-primary btn-sm btn-update">Check-in</button>
                                        </c:when>
                                        <c:when test="${p.statusCode == 2}">
                                            <button type="submit" name="statusCode" value="3" class="btn btn-warning btn-sm btn-update">Đang đợi khám</button>
                                        </c:when>
                                        <c:when test="${p.statusCode == 9}">
                                            <button type="submit" name="statusCode" value="3" class="btn btn-success btn-sm btn-update">Thanh toán xong</button>
                                        </c:when>
                                        <c:otherwise>
                                            <!-- Các trạng thái khác hiển thị button -->
                                            <button type="submit" class="btn btn-success btn-sm btn-update">Cập nhật</button>
                                        </c:otherwise>
                                    </c:choose>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
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
            order: [[0, 'asc']]
        });
    });
</script>
</body>
</html>
