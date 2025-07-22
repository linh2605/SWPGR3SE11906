<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <title>Quản lý trạng thái bệnh nhân - G3 Hospital</title>
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
            <%@ include file="../layouts/doctor-side-bar.jsp" %>
            
            <div class="content flex-grow-1">
                <div class="container-fluid mt-5">
                    <h2 class="mb-4">Danh sách bệnh nhân cần khám</h2>

                    <!-- Hiển thị thông báo -->
                    <c:if test="${not empty message}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            ${message}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
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
                                            <td>
                                                <span class="badge
                                                    <c:choose>
                                                        <c:when test="${p.statusCode == 3}">bg-info</c:when>
                                                        <c:when test="${p.statusCode == 4}">bg-warning</c:when>
                                                        <c:when test="${p.statusCode == 5}">bg-primary</c:when>
                                                        <c:when test="${p.statusCode == 8}">bg-success</c:when>
                                                        <c:when test="${p.statusCode == 9}">bg-success</c:when>
                                                        <c:otherwise>bg-secondary</c:otherwise>
                                                    </c:choose>">
                                                    ${p.statusDescription}
                                                </span>
                                            </td>
                                            <td>
                                                <form action="${pageContext.request.contextPath}/doctorupdate" method="post" class="d-flex gap-2">
                                                    <input type="hidden" name="patientId" value="${p.patientId}" />
                                                    
                                                    <c:choose>
                                                        <c:when test="${p.statusCode == 4}">
                                                            <div class="btn-group w-100" role="group">
                                                                <button type="submit" name="statusCode" value="5" class="btn btn-outline-primary btn-sm" title="Chờ xét nghiệm">
                                                                    <i class="bi bi-clipboard2-pulse"></i>
                                                                </button>
                                                                <button type="submit" name="statusCode" value="9" class="btn btn-outline-primary btn-sm" title="Hoàn thành khám">
                                                                    <i class="bi bi-check-circle"></i>
                                                                </button>
                                                            </div>
                                                        </c:when>
                                                        <c:when test="${p.statusCode == 8}">
                                                            <button type="submit" name="statusCode" value="4" class="btn btn-outline-primary btn-sm w-100" title="Bắt đầu khám">
                                                                <i class="bi bi-person-video2"></i>
                                                            </button>
                                                        </c:when>
                                                        <c:when test="${p.statusCode == 3}">
                                                            <button type="submit" name="statusCode" value="4" class="btn btn-outline-primary btn-sm w-100" title="Bắt đầu khám">
                                                                <i class="bi bi-person-video2"></i>
                                                            </button>
                                                        </c:when>
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
                        <div class="alert alert-info">
                            <i class="bi bi-info-circle me-2"></i>
                            Không có bệnh nhân nào đang chờ khám.
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <%@ include file="../layouts/footer.jsp" %>
    </div>

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

            // Auto-hide alerts after 5 seconds
            setTimeout(function() {
                $('.alert').alert('close');
            }, 5000);
        });
    </script>
</body>
</html>
