<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <title>Technician Dashboard - G3 Hospital</title>
    <meta http-equiv="Cache-Control" content="no-store" />
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
            <%@ include file="../layouts/technician-side-bar.jsp" %>
            
            <div class="content">
                <div class="container-fluid mt-5">
                    <h2 class="mb-4">Danh sách bệnh nhân cần xét nghiệm</h2>

                    <!-- Hiển thị thông báo -->
                    <c:if test="${not empty message}">
                        <div class="alert alert-success">${message}</div>
                    </c:if>
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">${error}</div>
                    </c:if>

                    <!-- Nếu có bệnh nhân -->
                    <c:if test="${not empty patients}">
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
                                                <form action="${pageContext.request.contextPath}/technicianupdate" method="post">
                                                    <input type="hidden" name="patientId" value="${p.patientId}" />

                                                    <c:choose>
                                                        <c:when test="${p.statusCode == 5}">
                                                            <button type="submit" name="statusCode" value="6" class="btn btn-warning btn-sm w-100">Đang xét nghiệm</button>
                                                        </c:when>
                                                        <c:when test="${p.statusCode == 6}">
                                                            <button type="submit" name="statusCode" value="7" class="btn btn-warning btn-sm w-100">Chờ lấy kết quả</button>
                                                        </c:when>
                                                        <c:when test="${p.statusCode == 7}">
                                                            <button type="submit" name="statusCode" value="8" class="btn btn-warning btn-sm w-100">Đã lấy kết quả</button>
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
                    </c:if>

                    <!-- Nếu không có bệnh nhân -->
                    <c:if test="${empty patients}">
                        <div class="alert alert-info">Không có bệnh nhân nào đang chờ xử lý.</div>
                    </c:if>
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
//                lengthMenu: [ [10, 20, 30, 40], [10, 20, 30, 40] ],
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
