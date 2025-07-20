<%@ page import="java.util.ArrayList" %>
<%@ page import="models.Patient" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ include file="admin-auth.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quản lý bệnh nhân - Admin Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
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
                <h2 class="section-title">Quản lý bệnh nhân</h2>
                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#exampleModal" title="Thêm bệnh nhân">
                    <i class="bi bi-plus-circle"></i>
                </button>
            </div>

            <% ArrayList<Patient> patients = (ArrayList<Patient>) request.getAttribute("patients");%>
            
            <!-- Bảng bệnh nhân -->
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">Danh sách bệnh nhân</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-striped table-hover" id="table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Username</th>
                                    <th>Họ tên</th>
                                    <th>Email</th>
                                    <th>Số điện thoại</th>
                                    <th>Giới tính</th>
                                    <th>Ngày sinh</th>
                                    <th>Địa chỉ</th>
                                    <th>Avatar</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                            <% for (int i = 0; i < patients.size(); i++) { 
                                String img = patients.get(i).getImage_url();
                                String imgSrc = (img != null && img.startsWith("http")) ? img : 
                                              (img != null && !img.isEmpty() ? request.getContextPath() + "/assets/" + img : 
                                               request.getContextPath() + "/assets/default-avatar.jpg");
                            %>
                            <tr>
                                <td class="text-center"><%=patients.get(i).getPatient_id()%></td>
                                <td><%=patients.get(i).getUser().getUsername()%></td>
                                <td><%=patients.get(i).getUser().getFullName()%></td>
                                <td><%=patients.get(i).getUser().getEmail()%></td>
                                <td><%=patients.get(i).getUser().getPhone()%></td>
                                <td class="text-center"><%=patients.get(i).getGender()%></td>
                                <td class="text-center"><%=patients.get(i).getDate_of_birth()%></td>
                                <td><%=patients.get(i).getAddress()%></td>
                                <td class="text-center">
                                    <% if (img != null && !img.isEmpty()) { %>
                                        <img src="<%= imgSrc %>" alt="Avatar" style="width: 40px; height: 40px; border-radius: 50%; object-fit: cover;">
                                    <% } else { %>
                                        <i class="bi bi-person-circle" style="font-size: 40px; color: #6c757d;"></i>
                                    <% } %>
                                </td>
                                <td>
                                    <button type="button" class="btn btn-sm btn-warning" title="Chỉnh sửa"
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
                                        <i class="bi bi-pencil"></i>
                                    </button>
                                    <button type="button" class="btn btn-sm btn-danger" title="Xóa"
                                           onclick="showDeleteModal('<%=patients.get(i).getUser().getUserId()%>')">
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

        <!-- CREATE Modal -->
        <div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <form action="${pageContext.request.contextPath}/admin/patient" method="post" enctype="multipart/form-data" class="modal-content p-4 bg-light rounded shadow-sm">
                    <div class="modal-header">
                        <h5 class="modal-title">Thêm bệnh nhân mới</h5>
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
                            <label for="fullName" class="form-label">Họ tên</label>
                            <input maxlength="100" class="form-control" id="fullname" name="fullname" required>
                        </div>
                        <div class="col-md-6">
                            <label for="email" class="form-label">Email</label>
                            <input type="email" class="form-control" id="email" name="email">
                        </div>
                        <div class="col-md-6">
                            <label for="phone" class="form-label">Số điện thoại</label>
                            <input class="form-control" id="phone" name="phone" pattern="0[0-9]{9}" maxlength="10"
                                        title="Số điện thoại phải có 10 chữ số và bắt đầu bằng 0">
                        </div>
                        <div class="col-md-6">
                            <label for="gender" class="form-label">Giới tính</label>
                            <select class="form-select" id="gender" name="gender" required>
                                <option value="">Chọn giới tính</option>
                                <option value="MALE">Nam</option>
                                <option value="FEMALE">Nữ</option>
                                <option value="OTHER">Khác</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label for="date_of_birth" class="form-label">Ngày sinh</label>
                            <input type="date" class="form-control" id="date_of_birth" name="date_of_birth" required>
                        </div>
                        <div class="col-md-6">
                            <label for="image" class="form-label">Ảnh đại diện</label>
                            <input type="file" class="form-control" id="image" name="image" accept="image/*">
                        </div>
                        <div class="col-md-12">
                            <label for="address" class="form-label">Địa chỉ</label>
                            <textarea maxlength="100" class="form-control" id="address" name="address" rows="3"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button class="btn btn-primary" type="submit">Thêm bệnh nhân</button>
                        <button class="btn btn-secondary" data-bs-dismiss="modal" type="button">Hủy</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- DELETE MODAL -->
        <div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <form method="post" action="${pageContext.request.contextPath}/admin/user/delete" class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="deleteModalLabel">Xóa bệnh nhân</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        Bạn có chắc chắn muốn xóa bệnh nhân này? Tất cả các bản ghi liên quan cũng sẽ bị xóa.
                        <input type="hidden" id="deleteUserId" name="userId">
                    </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-danger">Xác nhận xóa</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    </div>
                </form>
            </div>
        </div>
        
        <!-- UPDATE MODAL -->
        <div class="modal fade" id="updateModal" tabindex="-1" aria-labelledby="updateModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <form action="${pageContext.request.contextPath}/admin/patient/update" method="post" enctype="multipart/form-data" class="modal-content p-4 bg-light rounded shadow-sm">
                    <div class="modal-header">
                        <h5 class="modal-title">Cập nhật bệnh nhân</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body row g-3">
                        <input type="hidden" id="update_patient_id" name="patient_id">
                        <div class="col-md-6">
                            <label for="update_username" class="form-label">Username</label>
                            <input class="form-control" id="update_username" name="username" required disabled>
                        </div>
                        <div class="col-md-6">
                            <label for="update_fullName" class="form-label">Họ tên</label>
                            <input maxlength="100" class="form-control" id="update_fullname" name="fullname" required>
                        </div>
                        <div class="col-md-6">
                            <label for="update_email" class="form-label">Email</label>
                            <input type="email" class="form-control" id="update_email" name="email">
                        </div>
                        <div class="col-md-6">
                            <label for="update_phone" class="form-label">Số điện thoại</label>
                            <input class="form-control" id="update_phone" name="phone" pattern="0[0-9]{9}" maxlength="10"
                                        title="Số điện thoại phải có 10 chữ số và bắt đầu bằng 0">
                        </div>
                        <div class="col-md-6">
                            <label for="update_gender" class="form-label">Giới tính</label>
                            <select class="form-select" id="update_gender" name="gender">
                                <option value="">Chọn giới tính</option>
                                <option value="MALE">Nam</option>
                                <option value="FEMALE">Nữ</option>
                                <option value="OTHER">Khác</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label for="update_date_of_birth" class="form-label">Ngày sinh</label>
                            <input type="date" class="form-control" id="update_date_of_birth" name="date_of_birth" required>
                        </div>
                        <div class="col-md-6">
                            <label for="update_image" class="form-label">Ảnh đại diện (để trống nếu không đổi)</label>
                            <input type="file" class="form-control" id="update_image" name="image" accept="image/*">
                        </div>
                        <div class="col-md-12">
                            <label for="update_address" class="form-label">Địa chỉ</label>
                            <textarea maxlength="100" class="form-control" id="update_address" name="address" rows="3"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button class="btn btn-primary" type="submit">Cập nhật</button>
                        <button class="btn btn-secondary" data-bs-dismiss="modal" type="button">Hủy</button>
                    </div>
                </form>
            </div>
        </div>

    </div>
    <%@ include file="../layouts/footer.jsp" %>
</div>

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/scripts.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<script src="https://cdn.datatables.net/2.3.2/js/dataTables.min.js">
<script src="${pageContext.request.contextPath}/assets/js/jwt-manager.js"></script></script>
<script>
    // Tắt thông báo lỗi DataTables
    $.fn.dataTable.ext.errMode = 'none';
</script>

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

    function showDeleteModal(userId) {
        document.getElementById("deleteUserId").value = userId;
        var deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
        deleteModal.show();
    }

    function populateUpdateForm(userId, username, fullName, email, phone, gender, dob, address) {
        document.getElementById("update_patient_id").value = userId;
        document.getElementById("update_username").value = username;
        document.getElementById("update_fullname").value = fullName;
        document.getElementById("update_email").value = email;
        document.getElementById("update_phone").value = phone;
        document.getElementById("update_gender").value = gender;
        document.getElementById("update_date_of_birth").value = dob;
        document.getElementById("update_address").value = address;

        var updateModal = new bootstrap.Modal(document.getElementById('updateModal'));
        updateModal.show();
    }

    // Thiết lập ngày tối đa là hôm nay cho date input
    const today = new Date().toISOString().split("T")[0];
    document.getElementById("update_date_of_birth").setAttribute("max", today);
    document.getElementById("date_of_birth").setAttribute("max", today);
</script>
</body>
</html>