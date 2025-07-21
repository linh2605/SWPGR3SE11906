<%@ include file="admin-auth.jsp" %>

<%@ page import="java.util.ArrayList" %>
<%@ page import="models.Patient" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard - Bệnh nhân đã xóa | G3 Hospital</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4Q6Gf2aSP4eDXB8Miphtr37CMZZQ5oXLH2yaXMJ2w8e2ZtHTl7GptT4jmndRuHDT" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/2.3.2/css/dataTables.dataTables.min.css">
</head>
<body>
<div class="wrapper">
    <%@ include file="../layouts/header.jsp" %>
    <!-- BODY -->
    <div class="main">
        <%@include file="../layouts/admin-side-bar.jsp"%>
        <div class="content">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="section-title">Bệnh nhân đã xóa mềm</h2>
                <a href="${pageContext.request.contextPath}/admin/patient" class="btn btn-primary">
                    <i class="bi bi-arrow-left"></i> Quay lại
                </a>
            </div>
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">Danh sách bệnh nhân đã xóa mềm</h5>
                </div>
                <div class="card-body">
                    <% ArrayList<Patient> deletedPatients = (ArrayList<Patient>) request.getAttribute("deletedPatients"); %>
                    <div class="table-responsive">
                        <table class="table table-striped table-hover align-middle text-center" id="table">
                            <thead>
                                <tr>
                                    <th class="text-center">ID</th>
                                    <th class="text-start">Họ tên</th>
                                    <th class="text-center">Giới tính</th>
                                    <th class="text-center">Ngày sinh</th>
                                    <th class="text-center">Số điện thoại</th>
                                    <th class="text-center">Ảnh</th>
                                    <th class="text-start">Địa chỉ</th>
                                    <th class="text-center">Trạng thái</th>
                                    <th class="text-center">Ngày xóa</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (int i = 0; i < deletedPatients.size(); i++) { %>
                                <tr>
                                    <td class="text-center"><%=deletedPatients.get(i).getPatient_id()%></td>
                                    <td class="text-start"><%=deletedPatients.get(i).getUser().getFullName()%></td>
                                    <td class="text-center"><%=deletedPatients.get(i).getGender()%></td>
                                    <td class="text-center"><%=deletedPatients.get(i).getDate_of_birth()%></td>
                                    <td class="text-center"><%=deletedPatients.get(i).getUser().getPhone()%></td>
                                    <td class="text-center">
                                        <% String img = deletedPatients.get(i).getImage_url(); %>
                                        <% if (img == null || img.isEmpty()) { %>
                                            <i class="bi bi-person-circle" style="font-size:2rem;color:#bbb;"></i>
                                        <% } else { %>
                                            <img src="<%= (img != null && img.startsWith("http")) ? img : (img != null && !img.isEmpty() ? request.getContextPath() + "/assets/" + img : request.getContextPath() + "/assets/default-avatar.jpg") %>" alt="avatar" style="width:40px;height:40px;object-fit:cover;border-radius:50%;border:1px solid #ccc;">
                                        <% } %>
                                    </td>
                                    <td class="text-start"><%=deletedPatients.get(i).getAddress()%></td>
                                    <td class="text-center">
                                        <span class="badge bg-secondary">Đã xóa</span>
                                    </td>
                                    <td class="text-center">
                                        <% if (deletedPatients.get(i).getCreated_at() != null) { %>
                                            <%= deletedPatients.get(i).getCreated_at() %>
                                        <% } else { %>
                                            <span class="text-muted">N/A</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <button type="button" class="btn btn-sm btn-success" title="Khôi phục"
                                            onclick="restorePatient('<%= deletedPatients.get(i).getUser().getUserId() %>', '<%= deletedPatients.get(i).getUser().getFullName() %>')">
                                            <i class="bi bi-arrow-clockwise"></i>
                                        </button>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js" integrity="sha384-4Q6Gf2aSP4eDXB8Miphtr37CMZZQ5oXLH2yaXMJ2w8e2ZtHTl7GptT4jmndRuHDT" crossorigin="anonymous"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.datatables.net/2.3.2/js/dataTables.js"></script>
<script>
    new DataTable("#table");
</script>
</body>
<%@include file="../layouts/toastr.jsp"%>
<script>
    function restorePatient(userId, patientName) {
        if (confirm('Bạn có chắc muốn khôi phục bệnh nhân "' + patientName + '"?\n\nBệnh nhân sẽ được hiển thị lại trong danh sách chính.')) {
            fetch('${pageContext.request.contextPath}/admin/restore-patient', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'user_id=' + userId
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    toastr.success('Khôi phục bệnh nhân thành công!');
                    // Reload trang để cập nhật danh sách
                    setTimeout(() => {
                        location.reload();
                    }, 1000);
                } else {
                    toastr.error('Khôi phục bệnh nhân thất bại: ' + (data.message || 'Lỗi không xác định'));
                }
            })
            .catch(error => {
                console.error('Error:', error);
                toastr.error('Có lỗi xảy ra khi khôi phục bệnh nhân');
            });
        }
    }
</script>
</html> 