<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="admin-auth.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Duyệt yêu cầu ngoại lệ - Admin Dashboard</title>
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
                    <h2 class="section-title">Duyệt yêu cầu ngoại lệ</h2>
                    <div>
                        <a href="${pageContext.request.contextPath}/admin/schedule-exceptions" class="btn btn-outline-primary">
                            <i class="bi bi-arrow-clockwise"></i> Làm mới
                        </a>
                    </div>
                </div>

                <!-- Thông báo -->
                <c:if test="${param.success != null}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        Thao tác thành công!
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                <c:if test="${param.error != null}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        Có lỗi xảy ra: ${param.error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Bộ lọc -->
                <form method="get" action="${pageContext.request.contextPath}/admin/schedule-exceptions" class="card mb-4 p-3 shadow-sm">
                    <div class="row g-3 align-items-end">
                        <div class="col-md-3">
                            <label for="doctorId" class="form-label">Bác sĩ</label>
                            <select class="form-select" id="doctorId" name="doctorId">
                                <option value="">Tất cả bác sĩ</option>
                                <c:forEach var="doctor" items="${doctors}">
                                    <option value="${doctor.doctor_id}" <c:if test="${filterDoctorId != null && filterDoctorId == doctor.doctor_id}">selected</c:if>>
                                        Dr. ${doctor.user.fullName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <label for="status" class="form-label">Trạng thái</label>
                            <select class="form-select" id="status" name="status">
                                <option value="">Tất cả</option>
                                <option value="Chờ duyệt" <c:if test="${filterStatus == 'Chờ duyệt'}">selected</c:if>>Chờ duyệt</option>
                                <option value="Đã duyệt" <c:if test="${filterStatus == 'Đã duyệt'}">selected</c:if>>Đã duyệt</option>
                                <option value="Đã từ chối" <c:if test="${filterStatus == 'Đã từ chối'}">selected</c:if>>Từ chối</option>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <label for="date" class="form-label">Ngày</label>
                            <input type="date" class="form-control" id="date" name="date" value="${filterDate}">
                        </div>
                        <div class="col-md-3">
                            <label for="keyword" class="form-label">Tìm kiếm</label>
                            <input type="text" class="form-control" id="keyword" name="keyword" placeholder="Tìm kiếm..." value="${filterKeyword}">
                        </div>
                        <div class="col-md-2 d-grid">
                            <button type="submit" class="btn btn-primary"><i class="bi bi-search"></i> Lọc</button>
                        </div>
                    </div>
                </form>

                <!-- Bảng yêu cầu ngoại lệ -->
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">Danh sách yêu cầu ngoại lệ</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-striped table-hover" id="table">
                                <thead>
                                    <tr>
                                        <th>Bác sĩ</th>
                                        <th>Ngày ngoại lệ</th>
                                        <th>Loại ngoại lệ</th>
                                        <th>Ca mới</th>
                                        <th>Lý do</th>
                                        <th>Trạng thái</th>
                                        <th>Ngày gửi</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty exceptions}">
                                            <tr>
                                                <td colspan="8" class="text-center">Không có yêu cầu ngoại lệ nào</td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="exception" items="${exceptions}">
                                                <tr>
                                                    <td>${exception.doctorName}</td>
                                                    <td>${exception.exceptionDate}</td>
                                                    <td>${exception.exceptionType}</td>
                                                    <td>${exception.newShiftName}</td>
                                                    <td>${exception.reason}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${exception.status == 'Chờ duyệt'}">
                                                                <span class="badge bg-warning">Chờ duyệt</span>
                                                            </c:when>
                                                            <c:when test="${exception.status == 'Đã duyệt'}">
                                                                <span class="badge bg-success">Đã duyệt</span>
                                                            </c:when>
                                                            <c:when test="${exception.status == 'Đã từ chối'}">
                                                                <span class="badge bg-danger">Từ chối</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-secondary">${exception.status}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>${exception.createdAt}</td>
                                                    <td>
                                                        <c:if test="${exception.status == 'Chờ duyệt'}">
                                                            <form method="post" action="${pageContext.request.contextPath}/admin/schedule-exceptions" style="display: inline;">
                                                                <input type="hidden" name="action" value="approve">
                                                                <input type="hidden" name="exceptionId" value="${exception.exceptionId}">
                                                                <button type="submit" class="btn btn-sm btn-success" onclick="return confirm('Bạn có chắc chắn muốn duyệt yêu cầu này?')" title="Duyệt">
                                                                    <i class="bi bi-check"></i>
                                                                </button>
                                                            </form>
                                                            <form method="post" action="${pageContext.request.contextPath}/admin/schedule-exceptions" style="display: inline;">
                                                                <input type="hidden" name="action" value="reject">
                                                                <input type="hidden" name="exceptionId" value="${exception.exceptionId}">
                                                                <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Bạn có chắc chắn muốn từ chối yêu cầu này?')" title="Từ chối">
                                                                    <i class="bi bi-x"></i>
                                                                </button>
                                                            </form>
                                                        </c:if>
                                                        <!-- Nút xem chi tiết luôn hiển thị -->
                                                        <button type="button" class="btn btn-sm btn-info" data-bs-toggle="modal" data-bs-target="#exceptionDetailModal${exception.exceptionId}" title="Xem chi tiết">
                                                            <i class="bi bi-eye"></i>
                                                        </button>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%@ include file="../layouts/footer.jsp" %>
    </div>

    <!-- Scripts -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.datatables.net/2.3.2/js/dataTables.min.js">
<script src="${pageContext.request.contextPath}/assets/js/jwt-manager.js"></script>
    <script>
        // Tắt thông báo lỗi DataTables
        $.fn.dataTable.ext.errMode = 'none';
    </script></script>
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
                order: [[6, 'desc']]
            });
        });
    </script>

    <!-- Modal chi tiết ngoại lệ cho từng exception -->
    <c:forEach var="exception" items="${exceptions}">
    <div class="modal fade" id="exceptionDetailModal${exception.exceptionId}" tabindex="-1" aria-labelledby="exceptionDetailModalLabel${exception.exceptionId}" aria-hidden="true">
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="exceptionDetailModalLabel${exception.exceptionId}">Chi tiết ngoại lệ</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <ul class="list-group list-group-flush">
              <li class="list-group-item"><b>Bác sĩ:</b> ${exception.doctorName}</li>
              <li class="list-group-item"><b>Ngày ngoại lệ:</b> ${exception.exceptionDate}</li>
              <li class="list-group-item"><b>Loại ngoại lệ:</b> ${exception.exceptionType}</li>
              <li class="list-group-item"><b>Ca mới:</b> ${exception.newShiftName}</li>
              <li class="list-group-item"><b>Lý do:</b> ${exception.reason}</li>
              <li class="list-group-item"><b>Trạng thái:</b> 
                <c:choose>
                  <c:when test="${exception.status == 'Chờ duyệt'}"><span class="badge bg-warning">Chờ duyệt</span></c:when>
                  <c:when test="${exception.status == 'Đã duyệt'}"><span class="badge bg-success">Đã duyệt</span></c:when>
                  <c:when test="${exception.status == 'Đã từ chối'}"><span class="badge bg-danger">Từ chối</span></c:when>
                  <c:otherwise><span class="badge bg-secondary">${exception.status}</span></c:otherwise>
                </c:choose>
              </li>
              <li class="list-group-item"><b>Ngày gửi:</b> ${exception.createdAt}</li>
            </ul>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
          </div>
        </div>
      </div>
    </div>
    </c:forEach>
</body>
</html> 