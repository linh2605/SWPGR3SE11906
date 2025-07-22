<%@ page import="java.util.List" %>
<%@ page import="models.HealthConsultation, models.Doctor, models.Patient" %>
<%@ include file="admin-auth.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Quản lý tư vấn sức khỏe - Admin Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/2.3.2/css/dataTables.dataTables.min.css">
</head>
<body>
<div class="wrapper">
    <%@ include file="../layouts/header.jsp" %>
    <div class="main">
        <%@ include file="../layouts/admin-side-bar.jsp" %>
        <div class="content">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="section-title">Quản lý tư vấn sức khỏe</h2>
                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#createModal" title="Thêm tư vấn">
                    <i class="bi bi-plus-circle"></i>
                </button>
            </div>

            <%
                List<HealthConsultation> list = (List<HealthConsultation>) request.getAttribute("consultations");
            %>

            <!-- Bảng tư vấn sức khỏe -->
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">Danh sách tư vấn sức khỏe</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-striped table-hover" id="table">
                            <thead>
                            <tr>
                                <th class="text-center">ID</th>
                                <th>Bác sĩ</th>
                                <th>Bệnh nhân</th>
                                <th>Chi tiết</th>
                                <th class="text-center">Ngày tạo</th>
                                <th>Thao tác</th>
                            </tr>
                            </thead>
                            <tbody>
                            <% for (HealthConsultation hc : list) { %>
                            <tr>
                                <td class="text-center"><%= hc.getConsultation_id() %></td>
                                <td><%= hc.getDoctor().getUser().getFullName() %></td>
                                <td><%= hc.getPatient().getUser().getFullName() %></td>
                                <td><%= hc.getDetail() %></td>
                                <td class="text-center"><%= hc.getCreated_at() %></td>
                                <td>
                                    <button type="button" class="btn btn-outline-primary btn-sm edit-btn" title="Chỉnh sửa"
                                            data-id="<%= hc.getConsultation_id() %>"
                                            data-detail="<%= hc.getDetail() %>"
                                            data-doctor="<%= hc.getDoctor().getUser().getFullName() %>"
                                            data-patient="<%= hc.getPatient().getUser().getFullName() %>">
                                        <i class="bi bi-pencil"></i>
                                    </button>
                                    <button type="button" class="btn btn-outline-primary btn-sm" title="Xóa"
                                            onclick="if(confirm('Bạn có chắc chắn muốn xóa tư vấn này?')) { document.getElementById('deleteForm_<%= hc.getConsultation_id() %>').submit(); }">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                    <form id="deleteForm_<%= hc.getConsultation_id() %>" method="post" style="display:none;">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="id" value="<%= hc.getConsultation_id() %>">
                                    </form>
                                </td>
                            </tr>
                            <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal tạo mới -->
        <div class="modal fade" id="createModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
                <form method="post" class="modal-content">
                    <input type="hidden" name="action" value="create">
                    <div class="modal-header">
                        <h5 class="modal-title">Tạo tư vấn mới</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Bác sĩ</label>
                            <select name="doctor_id" class="form-select" required>
                                <option value="">Chọn bác sĩ</option>
                                <% for (Doctor d : (List<Doctor>) request.getAttribute("doctors")) { %>
                                <option value="<%= d.getDoctor_id() %>"><%= d.getUser().getFullName() %></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Bệnh nhân</label>
                            <select name="patient_id" class="form-select" required>
                                <option value="">Chọn bệnh nhân</option>
                                <% for (Patient p : (List<Patient>) request.getAttribute("patients")) { %>
                                <option value="<%= p.getPatient_id() %>"><%= p.getUser().getFullName() %></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Chi tiết tư vấn</label>
                            <textarea name="detail" class="form-control" rows="4" required></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-primary">Tạo tư vấn</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    </div>
                </form>
            </div>
        </div>
        
        <!-- Modal cập nhật -->
        <div class="modal fade" id="updateModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
                <form method="post" class="modal-content">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" id="update_id">

                    <div class="modal-header">
                        <h5 class="modal-title">Cập nhật tư vấn</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>

                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Bác sĩ</label>
                            <input type="text" id="update_doctor_name" class="form-control" disabled>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Bệnh nhân</label>
                            <input type="text" id="update_patient_name" class="form-control" disabled>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Chi tiết tư vấn</label>
                            <textarea name="detail" id="update_detail" class="form-control" rows="4" required></textarea>
                        </div>
                    </div>

                    <div class="modal-footer">
                        <button type="submit" class="btn btn-primary">Cập nhật</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <%@ include file="../layouts/footer.jsp" %>
</div>

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<script src="https://cdn.datatables.net/2.3.2/js/dataTables.min.js">
<script src="${pageContext.request.contextPath}/assets/js/jwt-manager.js"></script></script>

<%@include file="../layouts/toastr.jsp"%>

<script>
    new DataTable("#table", {
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
    });

    // Handle edit button click
    document.addEventListener('click', function(e) {
        if (e.target.closest('.edit-btn')) {
            const btn = e.target.closest('.edit-btn');
            const id = btn.dataset.id;
            const detail = btn.dataset.detail;
            const doctorName = btn.dataset.doctor;
            const patientName = btn.dataset.patient;

            document.getElementById("update_id").value = id;
            document.getElementById("update_detail").value = detail;
            document.getElementById("update_doctor_name").value = doctorName;
            document.getElementById("update_patient_name").value = patientName;

            const modal = new bootstrap.Modal(document.getElementById("updateModal"));
            modal.show();
        }
    });
</script>
</body>
</html>
