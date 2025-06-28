<%@ page import="java.util.ArrayList" %>
<%@ page import="models.Patient" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ include file="admin-auth.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard - G3 Hospital</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4Q6Gf2aSP4eDXB8Miphtr37CMZZQ5oXLH2yaXMJ2w8e2ZtHTl7GptT4jmndRuHDT" crossorigin="anonymous">
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
            <h2>Quản lý bệnh nhân</h2>
            <!-- Button trigger modal -->
            <button type="button" class="btn btn-primary mb-2" data-bs-toggle="modal" data-bs-target="#exampleModal">
                Add a patient
            </button>
            <% ArrayList<Patient> patients = (ArrayList<Patient>) request.getAttribute("patients");%>
            <table class="table table-bordered align-middle text-center" id="table">
                <thead class="table-light">
                <tr>
                    <th>ID</th>
                    <th>Username</th>
                    <th>Full Name</th>
                    <th>Email</th>
                    <th>Phone Number</th>
                    <th>Gender</th>
                    <th>Date of birth</th>
                    <th>Address</th>
                    <th>Avatar</th>
                    <th>Action</th>
                </tr>
                </thead>
                <tbody>
                <% for (int i = 0; i < patients.size(); i++) { 
                    String img = patients.get(i).getImage_url();
                    String imgLink = (img != null && img.startsWith("http")) ? img : (img != null && !img.isEmpty() ? request.getContextPath() + "/views/assets/" + img : request.getContextPath() + "/assets/default-avatar.jpg");
                %>
                <tr>
                    <td><%=patients.get(i).getUser().getUserId()%></td>
                    <td><%=patients.get(i).getUser().getUsername()%></td>
                    <td><%=patients.get(i).getUser().getFullName()%></td>
                    <td><%=patients.get(i).getUser().getEmail()%></td>
                    <td><%=patients.get(i).getUser().getPhone()%></td>
                    <td><%=patients.get(i).getGender()%></td>
                    <td><%=patients.get(i).getDate_of_birth()%></td>
                    <td><%=patients.get(i).getAddress()%></td>
                    <td><a href="<%= imgLink %>">link avatar</a></td>
                    <td>
                        <a href="javascript:void(0)" class="text-warning"
                           onclick="populateUpdateForm(
                                   '<%=patients.get(i).getPatient_id()%>',
                                   '<%=patients.get(i).getUser().getUsername()%>',
                                   '<%=patients.get(i).getUser().getFullName()%>',
                                   '<%=patients.get(i).getUser().getEmail()%>',
                                   '<%=patients.get(i).getUser().getPhone()%>',
                                   '<%=patients.get(i).getGender()%>',
                                   '<%=patients.get(i).getDate_of_birth()%>',
                                   '<%=patients.get(i).getAddress()%>'
                                   )">
                            Update
                        </a>
                        |
                        <a href="javascript:void(0)" class="text-danger ms-2" onclick="showDeleteModal('<%=patients.get(i).getUser().getUserId()%>')">
                            Delete
                        </a>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <!-- CREATE Modal -->
        <div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <form action="${pageContext.request.contextPath}/admin/patient" method="post" enctype="multipart/form-data" class="modal-content p-4 bg-light rounded shadow-sm">
                    <div class="modal-header">
                        <h5 class="modal-title">Create Patient</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body row g-3">
                        <div class="col-md-6">
                            <label for="username" class="form-label">Username</label>
                            <input class="form-control" id="username" name="username" required>
                        </div>
                        <div class="col-md-6">
                            <label for="password" class="form-label">Password</label>
                            <input type="password" class="form-control" id="password" name="password" required>
                        </div>
                        <div class="col-md-6">
                            <label for="fullName" class="form-label">Full Name</label>
                            <input class="form-control" id="fullName" name="fullName" required>
                        </div>
                        <div class="col-md-6">
                            <label for="email" class="form-label">Email</label>
                            <input type="email" class="form-control" id="email" name="email">
                        </div>
                        <div class="col-md-6">
                            <label for="phone" class="form-label">Phone</label>
                            <input class="form-control" id="phone" name="phone">
                        </div>
                        <div class="col-md-6">
                            <label for="gender" class="form-label">Gender</label>
                            <select class="form-select" id="gender" name="gender" required>
                                <option value="">Select Gender</option>
                                <option value="Male">Male</option>
                                <option value="Female">Female</option>
                                <option value="Other">Other</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label for="date_of_birth" class="form-label">Date of Birth</label>
                            <input type="date" class="form-control" id="date_of_birth" name="date_of_birth" required>
                        </div>
                        <div class="col-md-6">
                            <label for="image" class="form-label">Profile Image</label>
                            <input type="file" class="form-control" id="image" name="image" accept="image/*">
                        </div>
                        <div class="col-md-12">
                            <label for="address" class="form-label">Address</label>
                            <textarea class="form-control" id="address" name="address" rows="3"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button class="btn btn-primary" type="submit">Create Patient</button>
                        <button class="btn btn-secondary" data-bs-dismiss="modal" type="button">Cancel</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- DELETE MODAL -->
        <div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <form method="post" action="${pageContext.request.contextPath}/admin/user/delete" class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="deleteModalLabel">Delete Patient</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        Are you sure you want to delete this patient? All related records will also be deleted.
                        <input type="hidden" id="deleteUserId" name="userId">
                    </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-danger">Confirm Delete</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    </div>
                </form>
            </div>
        </div>
        <!-- UPDATE MODAL -->
        <div class="modal fade" id="updateModal" tabindex="-1" aria-labelledby="updateModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <form action="${pageContext.request.contextPath}/admin/patient/update" method="post" enctype="multipart/form-data" class="modal-content p-4 bg-light rounded shadow-sm">
                    <div class="modal-header">
                        <h5 class="modal-title">Update Patient</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body row g-3">
                        <input type="hidden" id="update_patient_id" name="patient_id">
                        <div class="col-md-6">
                            <label for="update_username" class="form-label">Username</label>
                            <input class="form-control" id="update_username" name="username" required>
                        </div>
                        <div class="col-md-6">
                            <label for="update_password" class="form-label">Password</label>
                            <input type="password" class="form-control" id="update_password" name="password">
                        </div>
                        <div class="col-md-6">
                            <label for="update_fullName" class="form-label">Full Name</label>
                            <input class="form-control" id="update_fullName" name="fullName" required>
                        </div>
                        <div class="col-md-6">
                            <label for="update_email" class="form-label">Email</label>
                            <input type="email" class="form-control" id="update_email" name="email">
                        </div>
                        <div class="col-md-6">
                            <label for="update_phone" class="form-label">Phone</label>
                            <input class="form-control" id="update_phone" name="phone">
                        </div>
                        <div class="col-md-6">
                            <label for="update_gender" class="form-label">Gender</label>
                            <select class="form-select" id="update_gender" name="gender">
                                <option value="">Select Gender</option>
                                <option value="Male">Male</option>
                                <option value="Female">Female</option>
                                <option value="Other">Other</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label for="update_date_of_birth" class="form-label">Date of Birth</label>
                            <input type="date" class="form-control" id="update_date_of_birth" name="date_of_birth" required>
                        </div>
                        <div class="col-md-6">
                            <label for="update_image" class="form-label">Profile Image (leave empty to keep current)</label>
                            <input type="file" class="form-control" id="update_image" name="image" accept="image/*">
                        </div>
                        <div class="col-md-12">
                            <label for="update_address" class="form-label">Address</label>
                            <textarea class="form-control" id="update_address" name="address" rows="3"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button class="btn btn-primary" type="submit">Update Patient</button>
                        <button class="btn btn-secondary" data-bs-dismiss="modal" type="button">Cancel</button>
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
</body>
<%@include file="../layouts/toastr.jsp"%>
<script>
    new DataTable("#table")
    function showDeleteModal(userId) {
        document.getElementById("deleteUserId").value = userId;
        var deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
        deleteModal.show();
    }

    function populateUpdateForm(userId, username, fullName, email, phone, gender, dob, address) {
        document.getElementById("update_patient_id").value = userId;
        document.getElementById("update_username").value = username;
        document.getElementById("update_fullName").value = fullName;
        document.getElementById("update_email").value = email;
        document.getElementById("update_phone").value = phone;
        document.getElementById("update_gender").value = gender;
        document.getElementById("update_date_of_birth").value = dob;
        document.getElementById("update_address").value = address;

        var updateModal = new bootstrap.Modal(document.getElementById('updateModal'));
        updateModal.show();
    }
</script>
</html>