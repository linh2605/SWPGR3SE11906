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
    <!-- Thay DataTables -->
    <link href="https://unpkg.com/tabulator-tables@5.5.0/dist/css/tabulator.min.css" rel="stylesheet">
    <script src="https://unpkg.com/tabulator-tables@5.5.0/dist/js/tabulator.min.js"></script>
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
                <div class="card-body" style="overflow-x: auto; max-width: 100%;">
                    <div id="patient-table"></div>
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
                            <input pattern=".*[^ ].*" class="form-control" id="username" name="username" required>
                        </div>
                        <div class="col-md-6">
                            <label for="password" class="form-label">Password</label>
                            <input pattern=".*[^ ].*" type="password" class="form-control" id="password" name="password" required>
                        </div>
                        <div class="col-md-6">
                            <label for="fullName" class="form-label">Họ tên</label>
                            <input pattern=".*[^ ].*" maxlength="100" class="form-control" id="fullname" name="fullname" required>
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
                            <textarea pattern=".*[^ ].*" maxlength="100" class="form-control" id="address" name="address" rows="3"></textarea>
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
                            <input pattern=".*[^ ].*" class="form-control" id="update_username" name="username" required disabled>
                        </div>
                        <div class="col-md-6">
                            <label for="update_fullName" class="form-label">Họ tên</label>
                            <input pattern=".*[^ ].*" maxlength="100" class="form-control" id="update_fullname" name="fullname" required>
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
<script src="https://cdn.datatables.net/2.3.2/js/dataTables.min.js"></script>
<%@include file="../layouts/toastr.jsp"%>
<script>
    new DataTable("#table", {
        "language": {
            "url": "https://cdn.datatables.net/plug-ins/1.10.25/i18n/Vietnamese.json"
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
<script>
    const table = new Tabulator("#patient-table", {
        height: "auto",
        ajaxURL: "<%=request.getContextPath()%>/api/patients",
        ajaxConfig: "GET",
        layout: "fitColumns",
        pagination: "local",               // <- bật phân trang local
        paginationSize: 10,               // <- số dòng mỗi trang
        paginationSizeSelector: [5, 10, 20, 50, 100], // <- tùy chọn hiển thị
        placeholder: "Không có dữ liệu",
        columns: [
            // { title: "ID", field: "patientId", hozAlign: "center", headerFilter: "input", width: 70 },
            { title: "Username", field: "username", headerFilter: "input" },
            { title: "Họ tên", field: "fullname", headerFilter: "input" },
            { title: "Email", field: "email", headerFilter: "input" },
            { title: "SĐT", field: "phone", headerFilter: "input" },
            { title: "Giới tính", field: "gender", hozAlign: "center", headerFilter: "input" },
            { title: "Ngày sinh", field: "date_of_birth", hozAlign: "center", headerFilter: "input" },
            { title: "Địa chỉ", field: "address", headerFilter: "input" },
            /*{
                title: "Avatar", field: "image_url", hozAlign: "center", headerSort: false, headerFilter: false, width: 70,
                formatter: function(cell) {
                    let url = cell.getValue();
                    if (!url) return "<i class='bi bi-person-circle' style='font-size: 24px; color: #6c757d;'></i>";
                    if (!url.startsWith("http")) url = "' + request.getContextPath() + '/assets/" + url;
                    return "<img src='" + (url.startsWith('http') ? url : '<%=request.getContextPath()%>/' + url ) + "' style='width: 32px; height: 32px; border-radius: 50%; object-fit: cover;'>";
                }
            },*/
            {
                title: "Thao tác", hozAlign: "center", headerSort: false, width: 250,
                formatter: function(cell) {
                    const data = cell.getData();
                    return `
                        <button onclick="location.href='<%=request.getContextPath()%>/admin/patient?id=`+data.patientId+`'" class="btn btn-sm btn-primary">
                            <i class="bi bi-eye"></i>
                        </button>
                        <button class='btn btn-sm btn-warning me-1' title='Sửa'
                            onclick="populateUpdateForm(
                                '` + data.userId + `',
                                '` + data.username + `',
                                '` + data.fullname + `',
                                '` + data.email + `',
                                '` + data.phone + `',
                                '` + data.gender + `',
                                '` + data.date_of_birth + `',
                                '` + data.address + `'
                            )">
                            <i class='bi bi-pencil'></i>
                        </button>
                        <button class='btn btn-sm btn-danger' title='Xóa'
                            onclick="showDeleteModal('` + data.userId + `')">
                            <i class='bi bi-trash'></i>
                        </button>`;
                }
            }
        ]
    });
</script>
</body>
</html>