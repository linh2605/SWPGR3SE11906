<%@ page import="java.util.List" %>
<%@ page import="models.HealthConsultation, models.Doctor, models.Patient" %>
<%@ include file="admin-auth.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Quản lý tư vấn sức khỏe</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4Q6Gf2aSP4eDXB8Miphtr37CMZZQ5oXLH2yaXMJ2w8e2ZtHTl7GptT4jmndRuHDT" crossorigin="anonymous">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/2.3.2/css/dataTables.dataTables.min.css">
</head>
<body>
<div class="wrapper">
    <%@ include file="../layouts/header.jsp" %>
    <div class="main">
        <%@ include file="../layouts/admin-side-bar.jsp" %>
        <div class="content">
            <h2>Quản lý tư vấn sức khỏe</h2>
            <button class="btn btn-primary mb-3" data-bs-toggle="modal" data-bs-target="#createModal">Thêm tư vấn</button>

            <%
                List<HealthConsultation> list = (List<HealthConsultation>) request.getAttribute("consultations");
            %>

            <table class="table table-bordered table-striped">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Bác sĩ</th>
                    <th>Bệnh nhân</th>
                    <th>Chi tiết</th>
                    <th>Ngày tạo</th>
                    <th>Hành động</th>
                </tr>
                </thead>
                <tbody>
                <% for (HealthConsultation hc : list) { %>
                <tr>
                    <td><%= hc.getConsultation_id() %></td>
                    <td><%= hc.getDoctor().getUser().getFullName() %></td>
                    <td><%= hc.getPatient().getUser().getFullName() %></td>
                    <td><%= hc.getDetail() %></td>
                    <td><%= hc.getCreated_at() %></td>
                    <td>
                        <form method="post" class="d-inline">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="id" value="<%= hc.getConsultation_id() %>">
                            <button class="btn btn-danger btn-sm" onclick="return confirm('Xác nhận xoá?')">Xoá</button>
                        </form>
                        <button type="button" class="btn btn-warning btn-sm"
                                onclick="populateUpdateModal(
                                        '<%= hc.getConsultation_id() %>',
                                        `<%= hc.getDetail().replace("`", "\\`") %>`,
                                        `<%= hc.getDoctor().getUser().getFullName() %>`,
                                        `<%= hc.getPatient().getUser().getFullName() %>`
                                        )">
                            Update
                        </button>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>

        <!-- Modal tạo mới -->
        <div class="modal fade" id="createModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
                <form method="post" class="modal-content p-3">
                    <input type="hidden" name="action" value="create">
                    <div class="modal-header">
                        <h5 class="modal-title">Tạo tư vấn mới</h5>
                        <button class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <label>Bác sĩ</label>
                        <select name="doctor_id" class="form-select mb-2" required>
                            <% for (Doctor d : (List<Doctor>) request.getAttribute("doctors")) { %>
                            <option value="<%= d.getDoctor_id() %>"><%= d.getUser().getFullName() %></option>
                            <% } %>
                        </select>
                        <label>Bệnh nhân</label>
                        <select name="patient_id" class="form-select mb-2" required>
                            <% for (Patient p : (List<Patient>) request.getAttribute("patients")) { %>
                            <option value="<%= p.getPatient_id() %>"><%= p.getUser().getFullName() %></option>
                            <% } %>
                        </select>
                        <label>Chi tiết tư vấn</label>
                        <textarea name="detail" class="form-control" required></textarea>
                    </div>
                    <div class="modal-footer">
                        <button class="btn btn-success" type="submit">Tạo</button>
                    </div>
                </form>
            </div>
        </div>
        <!-- Modal cập nhật -->
        <div class="modal fade" id="updateModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
                <form method="post" class="modal-content p-3">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" id="update_id">

                    <div class="modal-header">
                        <h5 class="modal-title">Cập nhật tư vấn</h5>
                        <button class="btn-close" data-bs-dismiss="modal"></button>
                    </div>

                    <div class="modal-body">
                        <div class="mb-3">
                            <label>Bác sĩ</label>
                            <input type="text" id="update_doctor_name" class="form-control" disabled>
                        </div>
                        <div class="mb-3">
                            <label>Bệnh nhân</label>
                            <input type="text" id="update_patient_name" class="form-control" disabled>
                        </div>
                        <div class="mb-3">
                            <label>Chi tiết tư vấn</label>
                            <textarea name="detail" id="update_detail" class="form-control" required></textarea>
                        </div>
                    </div>

                    <div class="modal-footer">
                        <button class="btn btn-primary" type="submit">Cập nhật</button>
                        <button class="btn btn-secondary" type="button" data-bs-dismiss="modal">Huỷ</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function populateUpdateModal(id, detail, doctorName, patientName) {
        document.getElementById("update_id").value = id;
        document.getElementById("update_detail").value = detail;
        document.getElementById("update_doctor_name").value = doctorName;
        document.getElementById("update_patient_name").value = patientName;

        const modal = new bootstrap.Modal(document.getElementById("updateModal"));
        modal.show();
    }
</script>
</body>
</html>
