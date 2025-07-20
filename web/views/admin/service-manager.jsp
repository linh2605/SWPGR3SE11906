
<%@ page import="models.Service" %>
<%@ page import="java.util.List" %>
<%@ page import="models.Doctor" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ include file="admin-auth.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quản lý gói khám - Admin Dashboard</title>
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
        <%@include file="../layouts/admin-side-bar.jsp"%>
        <div class="content">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="section-title">Quản lý gói khám</h2>
                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#createPackageModal" title="Thêm gói khám">
                    <i class="bi bi-plus-circle"></i>
                </button>
            </div>

            <% List<Service> services = (List<Service>) request.getAttribute("services");%>
            <% List<Doctor> doctors = (List<Doctor>) request.getAttribute("doctors"); %>

            <!-- Bảng gói khám -->
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">Danh sách gói khám</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-striped table-hover" id="table">
                            <thead>
                            <tr>
                                <th class="text-center">ID</th>
                                <th>Tên gói</th>
                                <th>Mô tả</th>
                                <th>Bác sĩ phụ  trách</th>
                                <th class="text-center">Giá (VND)</th>
                                <th class="text-center">Ảnh</th>
                                <th>Thao tác</th>
                            </tr>
                            </thead>
                            <tbody>
                            <% for (Service p : services) { %>
                            <tr>
                                <td class="text-center"><%= p.getServiceId() %></td>
                                <td><%= p.getName() %></td>
                                <td><%= p.getDetail() %></td>
                                <td><%= p.getDoctors().stream().map(s -> s.getUser().getFullName()).collect(java.util.stream.Collectors.joining(", ")) %></td>
                                <td class="text-center"><%= String.format("%,d", p.getPrice()) %></td>
                                <td class="text-center">
                                    <img src="<%= request.getContextPath() + "/assets/" + p.getImage() %>" alt="" style="width: 50px; height: 50px; object-fit: cover;">
                                </td>
                                <td>
                                    <button type="button" class="btn btn-sm btn-warning edit-btn" title="Chỉnh sửa"
                                            data-id="<%= p.getServiceId() %>"
                                            data-name="<%= p.getName() %>"
                                            data-description="<%= p.getDetail() %>"
                                            data-price="<%= p.getPrice() %>"
                                            data-type="<%= p.getType() %>"
                                            data-doctors="<%= p.getDoctors().stream().map(s -> s.getDoctor_id() + "").collect(java.util.stream.Collectors.joining(",")) %>"
                                            data-bs-toggle="modal" data-bs-target="#updatePackageModal">
                                        <i class="bi bi-pencil"></i>
                                    </button>
                                    <button type="button" class="btn btn-sm btn-danger" title="Xóa"
                                            onclick="confirmDelete('<%= p.getServiceId() %>')">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                    <form id="deleteForm_<%= p.getServiceId() %>" action="<%= request.getContextPath() %>/admin/examination-manage" method="post" style="display:none;">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="id" value="<%= p.getServiceId() %>">
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

        <!-- Modal thêm gói khám -->
        <div class="modal fade" id="createPackageModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <form id="createForm" method="post" action="${pageContext.request.contextPath}/admin/examination-manage" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="add">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Thêm gói khám mới</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label">Tên gói</label>
                                    <input type="text" name="name" class="form-control" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Giá (VND)</label>
                                    <input type="number" name="price" class="form-control" required step="1000" min="0">
                                </div>
                                <div class="col-md-12">
                                    <label class="form-label">Mô tả</label>
                                    <textarea name="detail" class="form-control" rows="3"></textarea>
                                </div>
                                <div class="col-md-12">
                                    <label class="form-label">Bác sĩ phụ trách</label>
                                    <div class="row">
                                        <% for (Doctor s : doctors) { %>
                                        <div class="col-md-4">
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox" name="doctorIds" value="<%= s.getDoctor_id() %>" id="doctor_create_<%= s.getDoctor_id() %>">
                                                <label class="form-check-label" for="doctor_create_<%= s.getDoctor_id() %>"><%= s.getUser().getFullName() %></label>
                                            </div>
                                        </div>
                                        <% } %>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Ảnh</label>
                                    <input type="file" name="image" class="form-control" required accept="image/*">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label" for="type">Loại dịch vụ</label>
                                    <select class="form-control" name="type" id="type">
                                        <option value="COMBO">COMBO</option>
                                        <option value="SPECIALIST">SPECIALIST</option>
                                        <option value="DEPARTMENT">DEPARTMENT</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="submit" class="btn btn-primary">Thêm gói khám</button>
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <!-- Modal cập nhật gói khám -->
        <div class="modal fade" id="updatePackageModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <form method="post" action="${pageContext.request.contextPath}/admin/examination-manage" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="edit">
                    <input type="hidden" name="id" id="update_package_id">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Cập nhật gói khám</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label">Tên gói</label>
                                    <input type="text" name="name" id="update_name" class="form-control" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Giá (VND)</label>
                                    <input type="number" name="price" id="update_price" class="form-control" required step="1000" min="0">
                                </div>
                                <div class="col-md-12">
                                    <label class="form-label" for="update_detail">Mô tả</label>
                                    <textarea name="detail" id="update_detail" class="form-control" rows="3"></textarea>
                                </div>
                                <div class="col-md-12">
                                    <label class="form-label">Bác sĩ phụ trách</label>
                                    <div class="row">
                                        <% for (Doctor s : doctors) { %>
                                        <div class="col-md-4">
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox" name="doctorIds" value="<%= s.getDoctor_id() %>" id="doctor_update_<%= s.getDoctor_id() %>">
                                                <label class="form-check-label" for="doctor_update_<%= s.getDoctor_id() %>"><%= s.getUser().getFullName() %></label>
                                            </div>
                                        </div>
                                        <% } %>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Ảnh (bỏ trống nếu không muốn cập nhật)</label>
                                    <input type="file" name="image" class="form-control" accept="image/*">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label" for="update_type">Loại dịch vụ</label>
                                    <select class="form-control" name="update_type" id="update_type">
                                        <option value="COMBO">COMBO</option>
                                        <option value="SPECIALIST">SPECIALIST</option>
                                        <option value="DEPARTMENT">DEPARTMENT</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="submit" class="btn btn-primary">Cập nhật</button>
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        </div>
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
            const name = btn.dataset.name;
            const description = btn.dataset.description;
            const price = btn.dataset.price;
            const type = btn.dataset.type;
            const doctors = btn.dataset.doctors ? btn.dataset.doctors.split(',').map(id => parseInt(id)) : [];

            document.getElementById('update_package_id').value = id;
            document.getElementById('update_name').value = name;
            document.getElementById('update_detail').value = description;
            document.getElementById('update_price').value = price;
            document.getElementById('update_type').value = type;

            // Uncheck all checkboxes first
            document.querySelectorAll("#updatePackageModal input[type='checkbox']").forEach(cb => cb.checked = false);

            // Re-check selected specialties
            doctors.forEach(specialtyId => {
                const checkbox = document.getElementById("doctor_update_" + specialtyId);
                if (checkbox) checkbox.checked = true;
            });
        }
    });

    function confirmDelete(id) {
        if (confirm("Bạn có chắc chắn muốn xóa gói khám này?")) {
            document.getElementById("deleteForm_" + id).submit();
        }
    }

    // Validation for duplicate package names
    document.getElementById("createForm").addEventListener("submit", function (e) {
        const inputName = document.querySelector("#createForm input[name='name']").value.trim().toLowerCase();

        // Check existing names in the table
        const existingNames = Array.from(document.querySelectorAll("#table tbody tr td:nth-child(2)"))
            .map(td => td.textContent.trim().toLowerCase());

        if (existingNames.includes(inputName)) {
            e.preventDefault();
            toastr.error("Tên gói khám đã tồn tại!");
        }
    });
</script>
</body>
</html>
