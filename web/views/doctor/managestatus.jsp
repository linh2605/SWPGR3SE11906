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
                <h2 class="mb-4">🩺 Danh sách bệnh nhân cần khám</h2>

                <!-- Thông báo thành công -->
                <c:if test="${not empty message}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="bi bi-check-circle-fill me-2"></i>${message}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Thông báo lỗi -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Danh sách bệnh nhân -->
                <c:if test="${not empty patients}">
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover align-middle" id="patientsTable">
                            <thead class="table-primary">
                                <tr class="text-center">
                                    <th>STT</th>
                                    <th>ID</th>
                                    <th>Họ tên</th>
                                    <th>Trạng thái</th>
                                    <th>Cập nhật trạng thái</th>
                                    <th>Hồ sơ bệnh án</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="p" items="${patients}" varStatus="status">
                                    <tr>
                                        <td class="text-center">${status.index + 1}</td>
                                        <td class="text-center">${p.patientId}</td>
                                        <td>${p.fullName}</td>
                                        <td class="text-center">
                                            <span class="badge 
                                                <c:choose>
                                                    <c:when test="${p.statusCode == 3}">bg-info</c:when>
                                                    <c:when test="${p.statusCode == 4}">bg-warning</c:when>
                                                    <c:when test="${p.statusCode == 5}">bg-primary</c:when>
                                                    <c:when test="${p.statusCode == 8 || p.statusCode == 9}">bg-success</c:when>
                                                    <c:otherwise>bg-secondary</c:otherwise>
                                                </c:choose>">
                                                ${p.statusDescription}
                                            </span>
                                        </td>

                                        <!-- Button cập nhật trạng thái -->
                                        <td>
                                            <form action="${pageContext.request.contextPath}/doctorupdate" method="post" class="d-flex gap-2">
                                                <input type="hidden" name="patientId" value="${p.patientId}" />

                                                <c:choose>
                                                    <c:when test="${p.statusCode == 4}">
                                                        <div class="btn-group w-100" role="group">
                                                            <button type="submit" name="statusCode" value="5" class="btn btn-outline-primary btn-sm" title="Chờ xét nghiệm">
                                                                <i class="bi bi-clipboard2-pulse"></i>
                                                            </button>
                                                            <button type="submit" name="statusCode" value="9" class="btn btn-outline-success btn-sm" title="Hoàn thành khám">
                                                                <i class="bi bi-check-circle"></i>
                                                            </button>
                                                        </div>
                                                    </c:when>
                                                    <c:when test="${p.statusCode == 3 || p.statusCode == 8}">
                                                        <button type="submit" name="statusCode" value="4" class="btn btn-outline-warning btn-sm w-100" title="Bắt đầu khám">
                                                            <i class="bi bi-person-video2"></i>
                                                        </button>
                                                    </c:when>
                                                </c:choose>
                                            </form>
                                        </td>

                                        <!-- Quản lý hồ sơ bệnh án -->
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${p.statusCode == 4}">
                                                    <div class="btn-group" role="group">
                                                        <a href="${pageContext.request.contextPath}/medicalRecord?action=list&patientId=${p.patientId}" 
                                                           class="btn btn-outline-info btn-sm" title="Xem hồ sơ bệnh án">
                                                            <i class="bi bi-folder2-open"></i> Xem
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/medicalRecord?action=addForm&patientId=${p.patientId}" 
                                                           class="btn btn-outline-success btn-sm" title="Thêm hồ sơ bệnh án">
                                                            <i class="bi bi-plus-circle"></i> Thêm
                                                        </a>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted fst-italic">
                                                        <i class="bi bi-exclamation-circle"></i> Chỉ xem khi đang khám
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:if>

                <!-- Nếu không có bệnh nhân -->
                <c:if test="${empty patients}">
                    <div class="alert alert-info text-center">
                        <i class="bi bi-info-circle me-2"></i> Không có bệnh nhân nào đang chờ khám.
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <%@ include file="../layouts/footer.jsp" %>
</div>

<!-- Scripts -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.7/js/dataTables.bootstrap5.min.js"></script>
<script>
    $(document).ready(function() {
        $('#patientsTable').DataTable({
            language: {
                "sProcessing": "Đang xử lý...",
                "sLengthMenu": "Hiển thị _MENU_ mục",
                "sZeroRecords": "Không tìm thấy dữ liệu",
                "sInfo": "Hiển thị _START_ đến _END_ của _TOTAL_ mục",
                "sInfoEmpty": "Không có dữ liệu",
                "sSearch": "Tìm kiếm:",
                "oPaginate": {
                    "sFirst": "Đầu",
                    "sPrevious": "Trước",
                    "sNext": "Tiếp",
                    "sLast": "Cuối"
                }
            },
            responsive: true,
            pageLength: 10,
//            lengthMenu: [ [10, 20, 30, 40], [10, 20, 30, 40] ],
            order: [[0, 'asc']],
            columnDefs: [
                { orderable: false, targets: [4,5] } // Disable sorting on actions
            ]
        });

        // Tự động đóng alert sau 5 giây
        setTimeout(function() {
            $('.alert').alert('close');
        }, 5000);
    });
</script>
</body>
</html>
