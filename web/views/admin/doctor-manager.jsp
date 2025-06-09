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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/styles.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/2.3.2/css/dataTables.dataTables.min.css">
</head>
<body>
<div class="wrapper">
    <%@ include file="../layouts/header.jsp" %>
    <!-- BODY -->
    <div class="main">
        <%@include file="../layouts/admin-side-bar.jsp"%>
        <div class="content">
            <h2>Quản lý bác sĩ</h2>
            <!-- Button trigger create modal -->
            <button class="btn btn-primary mb-3" data-bs-toggle="modal" data-bs-target="#createDoctorModal">Thêm bác sĩ</button>
            <%ArrayList<Doctor> doctors  = (ArrayList<Doctor>) request.getAttribute("doctors");%>
            <table class="table table-bordered table-striped" id="table">
                <thead class="table-light">
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Gender</th>
                    <th>Date of Birth</th>
                    <th>Phone</th>
                    <th>Image</th>
                    <th>Specialization</th>
                    <th>Degree</th>
                    <th>Experience</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <% for (int i = 0; i < doctors.size(); i++) { %>
                <tr>
                    <td><%=doctors.get(i).getDoctor_id()%></td>
                    <td><%=doctors.get(i).getUser().getFullname()%></td>
                    <td><%=doctors.get(i).getGender()%></td>
                    <td><%=doctors.get(i).getDob()%></td>
                    <td><%=doctors.get(i).getUser().getPhone()%></td>
                    <td><a href="<%=doctors.get(i).getImage_url().startsWith("http") ? doctors.get(i).getImage_url() : request.getContextPath() + "/views/assets/" + doctors.get(i).getImage_url()%>">link avatar</a></td>
                    <td><%=doctors.get(i).getSpecialty().getName()%></td>
                    <td><%=doctors.get(i).getDegree()%></td>
                    <td><%=doctors.get(i).getExperience()%></td>
                    <td><%=doctors.get(i).getStatus()%></td>
                    <td>
                        <a href="javascript:void(0)" class="text-warning"
                           onclick="populateDoctorUpdateForm(
                                   '<%= doctors.get(i).getDoctor_id() %>',
                                   '<%= doctors.get(i).getUser().getUsername() %>',
                                   '<%= doctors.get(i).getUser().getFullname() %>',
                                   '<%= doctors.get(i).getUser().getEmail() %>',
                                   '<%= doctors.get(i).getUser().getPhone() %>',
                                   '<%= doctors.get(i).getGender() %>',
                                   '<%= doctors.get(i).getDob() %>',
                                   '<%= doctors.get(i).getSpecialty().getSpecialty_id() %>',
                                   '<%= doctors.get(i).getDegree() %>',
                                   '<%= doctors.get(i).getExperience() %>',
                                   '<%= doctors.get(i).getStatus() %>'
                                   )">Update</a>
                        |
                        <a href="javascript:void(0)" class="text-danger ms-2"
                           onclick="showDoctorDeleteModal('<%= doctors.get(i).getUser().getUser_id() %>')">Delete</a>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
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
                                    <label for="fullname" class="form-label">Họ tên</label>
                                    <input type="text" name="fullname" id="fullname" class="form-control" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="email" class="form-label">Email</label>
                                    <input type="email" name="email" id="email" class="form-control" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="phone" class="form-label">Số điện thoại</label>
                                    <input type="text" name="phone" id="phone" class="form-control" required>
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
                                    <input type="file" name="image" id="image" class="form-control">
                                </div>
                                <div class="col-md-6">
                                    <label for="specialty_id" class="form-label">Chuyên khoa</label>
                                    <select name="specialty_id" id="specialty_id" class="form-select" required>
                                        <%
                                            List<Specialty> specialties = (ArrayList<Specialty>) request.getAttribute("specialties");
                                            for (Specialty spec : specialties) {
                                        %>
                                        <option value="<%= spec.getSpecialty_id() %>"><%= spec.getName() %></option>
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
                        <input type="hidden" id="deleteDoctorUserId" name="user_id">
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
                            <label>Fullname</label>
                            <input name="fullname" id="update_fullname" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label>Email</label>
                            <input name="email" id="update_email" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label>Phone</label>
                            <input name="phone" id="update_phone" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label>Gender</label>
                            <select name="gender" id="update_gender" class="form-control">
                                <option value="Male">Male</option>
                                <option value="Female">Female</option>
                                <option value="Other">Other</option>
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
                                <option value="<%= s.getSpecialty_id() %>"><%= s.getName() %></option>
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
                            <input required type="file" name="image" class="form-control">
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
<script src="${pageContext.request.contextPath}/views/assets/js/scripts.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
<script src="https://cdn.datatables.net/2.3.2/js/dataTables.min.js"></script>
</body>
<script>
    new DataTable("#table")
    function showDoctorDeleteModal(userId) {
        document.getElementById("deleteDoctorUserId").value = userId;
        var deleteModal = new bootstrap.Modal(document.getElementById('deleteDoctorModal'));
        deleteModal.show();
    }

    function populateDoctorUpdateForm(doctorId, username, fullname, email, phone, gender, dob, specialty_id, degree, experience, status) {
        document.getElementById("update_doctor_id").value = doctorId;
        document.getElementById("update_username").value = username;
        document.getElementById("update_fullname").value = fullname;
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
</html>