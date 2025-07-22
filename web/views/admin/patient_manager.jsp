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
                            <textarea> pattern=".*[^ ].*" maxlength="100" class="form-control" id="address" name="address" rows="3"></textarea>
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

    function softDeletePatient(patientId, patientName) {
        if (confirm('Bạn có chắc muốn xóa mềm bệnh nhân "' + patientName + '"?\n\nBệnh nhân sẽ bị ẩn khỏi danh sách nhưng dữ liệu vẫn được lưu trữ.')) {
            fetch('${pageContext.request.contextPath}/admin/soft-delete-patient', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'patient_id=' + patientId
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    toastr.success('Xóa mềm bệnh nhân thành công!');
                    // Reload trang để cập nhật danh sách
                    setTimeout(() => {
                        location.reload();
                    }, 1000);
                } else {
                    toastr.error('Xóa mềm bệnh nhân thất bại: ' + (data.message || 'Lỗi không xác định'));
                }
            })
            .catch(error => {
                console.error('Error:', error);
                toastr.error('Có lỗi xảy ra khi xóa mềm bệnh nhân');
            });
        }
    }

    // Xử lý thay đổi status
    document.addEventListener('DOMContentLoaded', function() {
        const statusSelects = document.querySelectorAll('.status-select');
        
        statusSelects.forEach(select => {
            select.addEventListener('change', function() {
                const patientId = this.getAttribute('data-patient-id');
                const newStatus = this.value;
                const originalValue = this.getAttribute('data-original-value');
                
                // Lưu giá trị ban đầu nếu chưa có
                if (!originalValue) {
                    this.setAttribute('data-original-value', this.value);
                }
                
                // Hiển thị confirm dialog
                if (confirm('Bạn có chắc muốn thay đổi trạng thái bệnh nhân này?')) {
                    updatePatientStatus(patientId, newStatus);
                } else {
                    // Khôi phục giá trị ban đầu
                    this.value = originalValue || this.value;
                }
            });
        });
    });

    function updatePatientStatus(patientId, status) {
        fetch('${pageContext.request.contextPath}/admin/patient/status', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'patientId=' + patientId + '&status=' + status
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // Cập nhật giá trị ban đầu
                const select = document.querySelector(`[data-patient-id="${patientId}"]`);
                select.setAttribute('data-original-value', status);
                
                // Hiển thị thông báo thành công
                toastr.success('Cập nhật trạng thái thành công!');
            } else {
                // Khôi phục giá trị ban đầu nếu lỗi
                const select = document.querySelector(`[data-patient-id="${patientId}"]`);
                select.value = select.getAttribute('data-original-value');
                toastr.error('Cập nhật trạng thái thất bại: ' + (data.message || 'Lỗi không xác định'));
            }
        })
        .catch(error => {
            console.error('Error:', error);
            // Khôi phục giá trị ban đầu nếu lỗi
            const select = document.querySelector(`[data-patient-id="${patientId}"]`);
            select.value = select.getAttribute('data-original-value');
            toastr.error('Có lỗi xảy ra khi cập nhật trạng thái');
        });
    }

    // Thiết lập ngày tối đa là hôm nay cho date input
    const today = new Date().toISOString().split("T")[0];
    document.getElementById("update_date_of_birth").setAttribute("max", today);
    document.getElementById("date_of_birth").setAttribute("max", today);
</script>
<script>
    // Hàm mở modal cập nhật bệnh nhân từ Tabulator
    function editPatient(data) {
        data = decodeURIComponent(data)
        const d = typeof data === 'string' ? JSON.parse(data) : data;
        document.getElementById("update_patient_id").value = d.patientId ?? "";
        document.getElementById("update_username").value = d.username ?? "";
        document.getElementById("update_fullname").value = d.fullname ?? "";
        document.getElementById("update_email").value = d.email ?? "";
        document.getElementById("update_phone").value = d.phone ?? "";
        document.getElementById("update_gender").value = d.gender ?? "";
        document.getElementById("update_date_of_birth").value = d.date_of_birth ?? "";
        document.getElementById("update_address").value = d.address ?? "";
        const modal = new bootstrap.Modal(document.getElementById('updateModal'));
        modal.show();
    }

    // Tabulator bảng bệnh nhân
    const table = new Tabulator("#patient-table", {
        height: "auto",
        ajaxURL: "<%=request.getContextPath()%>/api/patients",
        ajaxConfig: "GET",
        layout: "fitColumns",
        pagination: "local",
        paginationSize: 10,
        paginationSizeSelector: [5, 10, 20, 50, 100],
        placeholder: "Không có dữ liệu",
        columns: [
            { title: "Username", field: "username", headerFilter: "input" },
            { title: "Họ tên", field: "fullname", headerFilter: "input" },
            { title: "Email", field: "email", headerFilter: "input" },
            { title: "SĐT", field: "phone", headerFilter: "input" },
            { title: "Giới tính", field: "gender", hozAlign: "center", headerFilter: "input" },
            { title: "Ngày sinh", field: "date_of_birth", hozAlign: "center", headerFilter: "input" },
            { title: "Địa chỉ", field: "address", headerFilter: "input" },
            {
                title: "Thao tác", hozAlign: "center", headerSort: false, width: 250,
                formatter: function(cell) {
                    const data = cell.getData();
                    return `
                        <button onclick="location.href='<%=request.getContextPath()%>/admin/patient?id=`+data.patientId+`'" class="btn btn-outline-primary btn-sm" title="Xem">
                            <i class="bi bi-eye"></i>
                        </button>
                        <button class='btn btn-outline-primary btn-sm me-1' title='Sửa'
                            onclick="editPatient('` + encodeURIComponent(JSON.stringify(data)) + `')">
                            <i class='bi bi-pencil'></i>
                        </button>
                        <button class='btn btn-outline-primary btn-sm' title='Xóa mềm'
                            onclick="softDeletePatient('` + data.patientId + `', '` + data.fullname + `')">
                            <i class='bi bi-archive'></i>
                        </button>`;
                }
            }
        ]
    });
</script>
</body>
</html>