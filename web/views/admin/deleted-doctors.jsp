<%@ include file="admin-auth.jsp" %>

<%@ page import="java.util.ArrayList" %>
<%@ page import="models.Doctor" %>
<%@ page import="java.util.List" %>
<%@ page import="models.Specialty" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard - Bác sĩ đã xóa | G3 Hospital</title>
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
                <h2 class="section-title">Bác sĩ đã xóa mềm</h2>
                <a href="${pageContext.request.contextPath}/admin/doctor" class="btn btn-primary">
                    <i class="bi bi-arrow-left"></i> Quay lại
                </a>
            </div>
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">Danh sách bác sĩ đã xóa mềm</h5>
                </div>
                <div class="card-body">
                    <% ArrayList<Doctor> deletedDoctors = (ArrayList<Doctor>) request.getAttribute("deletedDoctors"); %>
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
                                    <th class="text-start">Chuyên khoa</th>
                                    <th class="text-center">Bằng cấp</th>
                                    <th class="text-start">Kinh nghiệm</th>
                                    <th class="text-center">Trạng thái</th>
                                    <th class="text-center">Ngày xóa</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (int i = 0; i < deletedDoctors.size(); i++) { %>
                                <tr>
                                    <td class="text-center"><%=deletedDoctors.get(i).getDoctor_id()%></td>
                                    <td class="text-start"><%=deletedDoctors.get(i).getUser().getFullName()%></td>
                                    <td class="text-center"><%=deletedDoctors.get(i).getGender()%></td>
                                    <td class="text-center"><%=deletedDoctors.get(i).getDob()%></td>
                                    <td class="text-center"><%=deletedDoctors.get(i).getUser().getPhone()%></td>
                                    <td class="text-center">
                                        <% String img = deletedDoctors.get(i).getImage_url(); %>
                                        <% if (img == null || img.isEmpty()) { %>
                                            <i class="bi bi-person-circle" style="font-size:2rem;color:#bbb;"></i>
                                        <% } else { %>
                                            <img src="<%= (img != null && img.startsWith("http")) ? img : (img != null && !img.isEmpty() ? request.getContextPath() + "/assets/" + img : request.getContextPath() + "/assets/default-avatar.jpg") %>" alt="avatar" style="width:40px;height:40px;object-fit:cover;border-radius:50%;border:1px solid #ccc;">
                                        <% } %>
                                    </td>
                                    <td class="text-start"><%=deletedDoctors.get(i).getSpecialty().getName()%></td>
                                    <td class="text-center"><%=deletedDoctors.get(i).getDegree()%></td>
                                    <td class="text-start"><%=deletedDoctors.get(i).getExperience()%></td>
                                    <td class="text-center">
                                        <span class="badge bg-secondary">Đã xóa</span>
                                    </td>
                                    <td class="text-center">
                                        <% if (deletedDoctors.get(i).getDeletedAt() != null) { %>
                                            <%= deletedDoctors.get(i).getDeletedAt() %>
                                        <% } else { %>
                                            <span class="text-muted">N/A</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <button type="button" class="btn btn-sm btn-success" title="Khôi phục"
                                            onclick="restoreDoctor('<%= deletedDoctors.get(i).getUser().getUserId() %>', '<%= deletedDoctors.get(i).getUser().getFullName() %>')">
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
    function restoreDoctor(userId, doctorName) {
        if (confirm('Bạn có chắc muốn khôi phục bác sĩ "' + doctorName + '"?\n\nBác sĩ sẽ được hiển thị lại trong danh sách chính.')) {
            fetch('${pageContext.request.contextPath}/admin/restore-doctor', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'user_id=' + userId
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    toastr.success('Khôi phục bác sĩ thành công!');
                    // Reload trang để cập nhật danh sách
                    setTimeout(() => {
                        location.reload();
                    }, 1000);
                } else {
                    toastr.error('Khôi phục bác sĩ thất bại: ' + (data.message || 'Lỗi không xác định'));
                }
            })
            .catch(error => {
                console.error('Error:', error);
                toastr.error('Có lỗi xảy ra khi khôi phục bác sĩ');
            });
        }
    }
</script>
</html> 