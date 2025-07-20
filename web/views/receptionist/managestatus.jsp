<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ include file="receptionist-auth.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Receptionist Dashboard - G3 Hospital</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.7/css/dataTables.bootstrap5.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
</head>
<body>
<div class="wrapper">
    <%@ include file="../layouts/header.jsp" %>
    
    <div class="d-flex">
        <%@ include file="../layouts/receptionist-side-bar.jsp" %>
        
        <div class="content">
            <div class="container-fluid mt-5">
                <h2 class="mb-4">Danh sách bệnh nhân đang chờ</h2>

                <c:if test="${not empty message}">
                    <div class="alert alert-success">${message}</div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>

                <div class="table-responsive">
                    <table class="table table-bordered table-hover" id="patientsTable">
                        <thead class="table-primary">
                            <tr>
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
                                    <td>${status.index + 1}</td>
                                    <td>${p.patientId}</td>
                                    <td>${p.fullName}</td>
                                    <td>${p.statusDescription}</td>
                                    <td>
                                        <form action="receptionistuplate" method="post">
                                            <input type="hidden" name="patientId" value="${p.patientId}" />

                                            <c:choose>
                                                <c:when test="${p.statusCode == 1}">
                                                    <button type="submit" name="statusCode" value="2" class="btn btn-primary btn-sm w-100">Check-in</button>
                                                </c:when>
                                                <c:when test="${p.statusCode == 2}">
                                                    <button type="submit" name="statusCode" value="3" class="btn btn-warning btn-sm w-100">Đang đợi khám</button>
                                                </c:when>
                                                <c:when test="${p.statusCode == 9}">
                                                    <button type="submit" name="statusCode" value="3" class="btn btn-success btn-sm w-100">Thanh toán xong</button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button type="submit" class="btn btn-success btn-sm w-100">Cập nhật</button>
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
        </div>
    </div>

        </div>
    </div>

    <%@ include file="../layouts/footer.jsp" %>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.7/js/dataTables.bootstrap5.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/scripts.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jwt-manager.js"></script>
    
    <script>
        $(document).ready(function() {
            $('#patientsTable').DataTable({
                language: {
                    "sProcessing": "Đang xử lý...",
                    "sLengthMenu": "Hiển thị _MENU_ mục",
                    "sZeroRecords": "Không tìm thấy dữ liệu",
                    "sInfo": "Đang xem _START_ đến _END_ trong tổng số _TOTAL_ mục",
                    "sInfoEmpty": "Đang xem 0 đến 0 trong tổng số 0 mục",
                    "sInfoFiltered": "(được lọc từ _MAX_ mục)",
                    "sInfoPostFix": "",
                    "sSearch": "Tìm kiếm:",
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
                order: [[0, 'asc']],
                columnDefs: [
                    { orderable: false, targets: 4 } // Không sắp xếp cột "Cập nhật trạng thái"
                ]
            });
        });
    </script>
</body>
</html>
