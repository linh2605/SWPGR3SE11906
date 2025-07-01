<%@ include file="admin-auth.jsp" %>

<%@ page import="java.util.ArrayList" %>
<%@ page import="models.Doctor" %>
<%@ page import="java.util.List" %>
<%@ page import="models.Specialty" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard - G3 Hospital</title>
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
                <h2 class="section-title">Quản lý bác sĩ</h2>
                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#createDoctorModal" title="Thêm bác sĩ">
                    <i class="bi bi-plus-circle"></i>
                </button>
            </div>
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">Danh sách bác sĩ</h5>
                </div>
                <div class="card-body">
                    <% ArrayList<Doctor> doctors = (ArrayList<Doctor>) request.getAttribute("doctors"); %>
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
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (int i = 0; i < doctors.size(); i++) { %>
                                <tr>
                                    <td class="text-center"><%=doctors.get(i).getDoctor_id()%></td>
                                    <td class="text-start"><%=doctors.get(i).getUser().getFullName()%></td>
                                    <td class="text-center"><%=doctors.get(i).getGender()%></td>
                                    <td class="text-center"><%=doctors.get(i).getDob()%></td>
                                    <td class="text-center"><%=doctors.get(i).getUser().getPhone()%></td>
                                    <td class="text-center">
                                        <% String img = doctors.get(i).getImage_url(); %>
                                        <% if (img == null || img.isEmpty()) { %>
                                            <i class="bi bi-person-circle" style="font-size:2rem;color:#bbb;"></i>
                                        <% } else { %>
                                            <img src="<%= (img != null && img.startsWith("http")) ? img : (img != null && !img.isEmpty() ? request.getContextPath() + "/assets/" + img : request.getContextPath() + "/assets/default-avatar.jpg") %>" alt="avatar" style="width:40px;height:40px;object-fit:cover;border-radius:50%;border:1px solid #ccc;">
                                        <% } %>
                                    </td>
                                    <td class="text-start"><%=doctors.get(i).getSpecialty().getName()%></td>
                                    <td class="text-center"><%=doctors.get(i).getDegree()%></td>
                                    <td class="text-start"><%=doctors.get(i).getExperience()%></td>
                                    <td class="text-center">
                                        <% if ("active".equalsIgnoreCase(doctors.get(i).getStatus()+"")) { %>
                                            <span class="badge bg-success">active</span>
                                        <% } else { %>
                                            <span class="badge bg-secondary">inactive</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <button type="button" class="btn btn-sm btn-warning" title="Chỉnh sửa"
                                            onclick="populateDoctorUpdateForm(
                                                '<%= doctors.get(i).getDoctor_id() %>',
                                                '<%= doctors.get(i).getUser().getUsername() %>',
                                                '<%= doctors.get(i).getUser().getFullName() %>',
                                                '<%= doctors.get(i).getUser().getEmail() %>',
                                                '<%= doctors.get(i).getUser().getPhone() %>',
                                                '<%= doctors.get(i).getGender() %>',
                                                '<%= doctors.get(i).getDob() %>',
                                                '<%= doctors.get(i).getSpecialty().getSpecialtyId()%>',
                                                '<%= doctors.get(i).getDegree() %>',
                                                '<%= doctors.get(i).getExperience() %>',
                                                '<%= doctors.get(i).getStatus() %>'
                                            )">
                                            <i class="bi bi-pencil"></i>
                                        </button>
                                        <button type="button" class="btn btn-sm btn-danger" title="Xóa"
                                            onclick="showDoctorDeleteModal('<%= doctors.get(i).getUser().getUserId() %>')">
                                            <i class="bi bi-trash"></i>
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
        <!-- Create Doctor Modal -->
        <div class="modal fade" id="createDoctorModal" tabindex="-1" aria-labelledby="createDoctorModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <form method="post" action="${pageContext.request.contextPath}/admin/doctor" enctype="multipart/form-data">
                        <div class="modal-header">
                            <h5 class="modal-title">Thêm bác sĩ</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label for="username" class="form-label">Tên đăng nhập</label>
                                    <input type="text" name="username" id="username" class="form-control" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="password" class="form-label">Mật khẩu</label>
                                    <input type="password" name="password" id="password" class="form-control" required>
                                </div>
                                <div class="col-md-6">
                                        <label for="fullName" class="form-label">Họ tên</label>
                                    <input type="text" name="fullname" id="fullname" class="form-control" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="email" class="form-label">Email</label>
                                    <input type="email" name="email" id="email" class="form-control" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="phone" class="form-label">Số điện thoại</label>
                                    <input type="tel" name="phone" class="form-control"
                                        pattern="0[0-9]{9}" maxlength="10"
                                        title="Số điện thoại phải có 10 chữ số và bắt đầu bằng 0" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="gender" class="form-label">Giới tính</label>
                                    <select name="gender" id="gender" class="form-select" required>
                                        <option value="Male">Nam</option>
                                        <option value="Female">Nữ</option>
                                        <option value="Other">Khác</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label for="dob" class="form-label">Ngày sinh</label>
                                    <input type="date" name="dob" id="dob" class="form-control" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="image" class="form-label">Ảnh đại diện</label>
                                    <input required type="file" name="image" id="image" class="form-control">
                                </div>
                                <div class="col-md-6">
                                    <label for="specialty_id" class="form-label">Chuyên khoa</label>
                                    <select name="specialty_id" id="specialty_id" class="form-select" required>
                                        <%
                                            List<Specialty> specialties = (ArrayList<Specialty>) request.getAttribute("specialties");
                                            for (Specialty spec : specialties) {
                                        %>
                                        <option value="<%= spec.getSpecialtyId() %>"><%= spec.getName() %></option>
                                        <% } %>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label for="degree" class="form-label">Bằng cấp</label>
                                    <input type="text" name="degree" id="degree" class="form-control" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="experience" class="form-label">Kinh nghiệm</label>
                                    <input type="text" name="experience" id="experience" class="form-control" required min="0">
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button class="btn btn-success" type="submit">Tạo</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <%-- Delete doctor modal --%>
        <div class="modal fade" id="deleteDoctorModal" tabindex="-1" aria-labelledby="deleteDoctorModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <form method="post" action="${pageContext.request.contextPath}/admin/user/delete" class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Delete Doctor</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        Are you sure you want to delete this doctor? All related records will also be deleted.
                        <input type="hidden" id="deleteDoctorUserId" name="userId">
                    </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-danger">Confirm Delete</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    </div>
                </form>
            </div>
        </div>
        <%-- Update doctor modal--%>
        <div class="modal fade" id="updateDoctorModal" tabindex="-1" aria-labelledby="updateDoctorModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <form method="post" action="${pageContext.request.contextPath}/admin/doctor/update" enctype="multipart/form-data" class="modal-content p-4 bg-light rounded shadow-sm">
                    <div class="modal-header">
                        <h5 class="modal-title">Update Doctor</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body row g-3">
                        <input type="hidden" id="update_doctor_id" name="doctor_id">
                        <div class="col-md-6">
                            <label>Username</label>
                            <input name="username" id="update_username" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label>Full Name</label>
                            <input name="fullname" id="update_fullname" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label>Email</label>
                            <input name="email" id="update_email" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label>Phone</label>
                            <input pattern="0[0-9]{9}" maxlength="10"
       title="Số điện thoại phải có 10 chữ số và bắt đầu bằng 0" name="phone" id="update_phone" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label>Gender</label>
                            <select name="gender" id="update_gender" class="form-control">
                                <option value="MALE">Male</option>
                                <option value="FEMALE">Female</option>
                                <option value="OTHER">Other</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label>Date of Birth</label>
                            <input type="date" name="dob" id="update_dob" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label>Specialization</label>
                            <select name="specialty_id" id="update_specialty_id" class="form-control">
                                <% for (Specialty s : specialties) { %>
                                <option value="<%= s.getSpecialtyId()%>"><%= s.getName() %></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label>Degree</label>
                            <input name="degree" id="update_degree" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label>Experience</label>
                            <input name="experience" id="update_experience" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label>Status</label>
                            <select name="status" id="update_status" class="form-control">
                                <option value="active">ACTIVE</option>
                                <option value="inactive">INACTIVE</option>
                            </select>
                        </div>
                        <div class="col-md-12">
                            <label>Image (Leave empty if not updating)</label>
                            <input type="file" name="image" class="form-control">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button class="btn btn-primary" type="submit">Update</button>
                        <button class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <%@ include file="../layouts/footer.jsp" %>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js" integrity="sha384-j1CDi7MgGQ12Z7Qab0qlWQ/Qqz24Gc6BM0thvEMVjHnfYGF0rmFCozFSxQBxwHKO" crossorigin="anonymous"></script>
<script src="${pageContext.request.contextPath}/assets/js/scripts.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
<script src="https://cdn.datatables.net/2.3.2/js/dataTables.min.js"></script>
<script>
    new DataTable("#table");
</script>
</body>
<%@include file="../layouts/toastr.jsp"%>
<script>
    function showDoctorDeleteModal(userId) {
        document.getElementById("deleteDoctorUserId").value = userId;
        var deleteModal = new bootstrap.Modal(document.getElementById('deleteDoctorModal'));
        deleteModal.show();
    }

    function populateDoctorUpdateForm(doctorId, username, fullName, email, phone, gender, dob, specialty_id, degree, experience, status) {
        document.getElementById("update_doctor_id").value = doctorId;
        document.getElementById("update_username").value = username;
        document.getElementById("update_fullname").value = fullName;
        document.getElementById("update_email").value = email;
        document.getElementById("update_phone").value = phone;
        document.getElementById("update_gender").value = gender;
        document.getElementById("update_dob").value = dob;
        document.getElementById("update_specialty_id").value = specialty_id;
        document.getElementById("update_degree").value = degree;
        document.getElementById("update_experience").value = experience;
        document.getElementById("update_status").value = status;

        var updateModal = new bootstrap.Modal(document.getElementById('updateDoctorModal'));
        updateModal.show();
    }

</script>
<script>
    // Tính ngày tối đa được chọn (tức là cách đây 18 năm)
    const today = new Date();
    const minDate = new Date(today.getFullYear() - 18, today.getMonth(), today.getDate());

    // Định dạng YYYY-MM-DD
    const formatted = minDate.toISOString().split("T")[0];

    // Áp dụng vào input
    document.getElementById("dob").setAttribute("max", formatted);
    document.getElementById("update_dob").setAttribute("max", formatted);
</script>
</html>