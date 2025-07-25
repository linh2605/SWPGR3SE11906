
<%@ page import="models.Service" %>
<%@ page import="java.util.List" %>
<%@ page import="models.Doctor" %>
<%@ page import="models.ExaminationPackage" %>
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

            <% List<ExaminationPackage> packages = (List<ExaminationPackage>) request.getAttribute("packages"); %>
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
                                <th class="text-center">Giá (VND)</th>
                                <th class="text-center">Thời lượng</th>
                                <th class="text-center">Ảnh</th>
                                <th class="text-center">Bác sĩ phụ trách</th>
                                <th class="text-center">Thao tác</th>
                            </tr>
                            </thead>
                            <tbody>
                            <% for (ExaminationPackage p : packages) { %>
                            <tr>
                                <td class="text-center"><%= p.getPackageId() %></td>
                                <td><%= p.getName() %></td>
                                <td><%= p.getDescription() %></td>
                                <td class="text-center"><%= String.format("%,.0f", p.getPrice()) %></td>
                                <td class="text-center"><%= p.getFormattedDuration() %></td>
                                <td class="text-center">
                                    <% String img = p.getImageUrl(); %>
                                    <% if (img == null || img.isEmpty()) { %>
                                        <i class="bi bi-image" style="font-size:2rem;color:#bbb;"></i>
                                    <% } else { %>
                                        <img src="<%= (img != null && img.startsWith("http")) ? img : (img != null && !img.isEmpty() ? request.getContextPath() + "/assets/" + img : request.getContextPath() + "/assets/default-image.svg") %>" alt="avatar" style="width:50px;height:50px;object-fit:cover;border-radius:8px;border:1px solid #ccc;">
                                    <% } %>
                                </td>
                                <td class="text-center">
                                    <% if (p.getDoctors() != null && !p.getDoctors().isEmpty()) { %>
                                        <% for (Doctor d : p.getDoctors()) { %>
                                            <span><%= d.getUser().getFullName() %></span><br>
                                        <% } %>
                                    <% } else { %>
                                        <span>Chưa có bác sĩ phụ trách</span>
                                    <% } %>
                                </td>
                                <td class="text-center">
                                    <button type="button" class="btn btn-outline-primary btn-sm view-btn" title="Xem"
                                        data-id="<%= p.getPackageId() %>"
                                        data-name="<%= p.getName() %>"
                                        data-description="<%= p.getDescription() %>"
                                        data-price="<%= String.format("%,.0f", p.getPrice()) %>"
                                        data-duration="<%= p.getFormattedDuration() %>"
                                        data-img="<%= p.getImageUrl() %>"
                                        data-bs-toggle="modal" data-bs-target="#viewPackageModal">
                                        <i class="bi bi-eye"></i>
                                    </button>
                                    <a href="${pageContext.request.contextPath}/admin/examination-manage?editId=<%= p.getPackageId() %>" class="btn btn-outline-primary btn-sm" title="Sửa">
                                        <i class="bi bi-pencil"></i>
                                    </a>
                                    <button type="button" class="btn btn-outline-primary btn-sm" title="Xóa"
                                        onclick="confirmDelete('<%= p.getPackageId() %>')">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                    <form id="deleteForm_<%= p.getPackageId() %>" action="<%= request.getContextPath() %>/admin/examination-manage" method="post" style="display:none;">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="id" value="<%= p.getPackageId() %>">
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
                                    <input type="number" name="price" class="form-control" id="price" min="0" step="1" required>
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
        <%
            String editId = request.getParameter("editId");
            ExaminationPackage editingPackage = null;
            if (editId != null && packages != null) {
                for (ExaminationPackage pkg : packages) {
                    if (String.valueOf(pkg.getPackageId()).equals(editId)) {
                        editingPackage = pkg;
                        break;
                    }
                }
            }
        %>
        <div class="modal fade<%= editId != null ? " show d-block" : "" %>" id="updatePackageModal" tabindex="-1" <%= editId != null ? "style='display:block;'" : "" %>>
            <div class="modal-dialog modal-lg">
                <form method="post" action="${pageContext.request.contextPath}/admin/examination-manage" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="edit">
                    <input type="hidden" name="id" value="<%= editingPackage != null ? editingPackage.getPackageId() : "" %>">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Cập nhật gói khám</h5>
                            <a href="${pageContext.request.contextPath}/admin/examination-manage" class="btn-close"></a>
                        </div>
                        <div class="modal-body">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label">Tên gói</label>
                                    <input type="text" name="name" class="form-control" required value="<%= editingPackage != null ? editingPackage.getName() : "" %>">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Giá (VND)</label>
                                    <input type="number" name="price" class="form-control" min="0" step="1" required value="<%= editingPackage != null ? editingPackage.getPrice() : "" %>">
                                </div>
                                <div class="col-md-12">
                                    <label class="form-label">Mô tả</label>
                                    <textarea name="detail" class="form-control" rows="3"><%= editingPackage != null ? editingPackage.getDescription() : "" %></textarea>
                                </div>
                                <div class="col-md-12">
                                    <label class="form-label">Bác sĩ phụ trách</label>
                                    <div class="row">
                                        <% if (doctors != null && !doctors.isEmpty()) {
                                            List<Doctor> responsibleDoctors = editingPackage != null ? editingPackage.getDoctors() : null;
                                            for (Doctor s : doctors) { %>
                                            <div class="col-md-4">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="checkbox" name="doctorIds" value="<%= s.getDoctor_id() %>"
                                                        id="doctor_update_<%= s.getDoctor_id() %>"
                                                        <%= responsibleDoctors != null && responsibleDoctors.stream().anyMatch(d -> d.getDoctor_id() == s.getDoctor_id()) ? "checked" : "" %>>
                                                    <label class="form-check-label" for="doctor_update_<%= s.getDoctor_id() %>"><%= s.getUser().getFullName() %></label>
                                                </div>
                                            </div>
                                        <% } } else { %>
                                            <div class="col-12"><span class="text-danger">Không có bác sĩ nào để chọn!</span></div>
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
                            <a href="${pageContext.request.contextPath}/admin/examination-manage" class="btn btn-secondary">Hủy</a>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <!-- Modal chi tiết gói khám -->
        <div class="modal fade" id="viewPackageModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Chi tiết gói khám</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <p><strong>Tên gói:</strong> <span id="view_name"></span></p>
                        <p><strong>Mô tả:</strong> <span id="view_description"></span></p>
                        <p><strong>Giá:</strong> <span id="view_price"></span></p>
                        <p><strong>Thời lượng:</strong> <span id="view_duration"></span></p>
                        <p><strong>Ảnh:</strong><br>
                            <img id="view_img" src="" alt="Ảnh gói khám" style="width:100px;height:100px;object-fit:cover;border-radius:8px;border:1px solid #ccc;">
                        </p>
                    </div>
                </div>
            </div>
        </div>

    </div>
    <%@ include file="../layouts/footer.jsp" %>
</div>

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<script src="https://cdn.datatables.net/2.3.2/js/dataTables.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/jwt-manager.js"></script>

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

    document.addEventListener('click', function(e) {
        if (e.target.closest('.edit-btn')) {
            const btn = e.target.closest('.edit-btn');
            const id = btn.dataset.id;
            const name = btn.dataset.name;
            const description = btn.dataset.description;
            const price = btn.dataset.price;
            const doctors = btn.dataset.doctors ? btn.dataset.doctors.split(',').map(id => parseInt(id)) : [];
            document.getElementById('update_package_id').value = id;
            document.getElementById('update_name').value = name;
            document.getElementById('update_detail').value = description;
            document.getElementById('update_price').value = price;
            // Uncheck all checkboxes first
            document.querySelectorAll("#updatePackageModal input[type='checkbox']").forEach(cb => cb.checked = false);
            // Re-check selected doctors
            doctors.forEach(doctorId => {
                const checkbox = document.getElementById("doctor_update_" + doctorId);
                if (checkbox) checkbox.checked = true;
            });
        }
    });

    // Handle view button click
    document.addEventListener('click', function(e) {
        if (e.target.closest('.view-btn')) {
            const btn = e.target.closest('.view-btn');
            document.getElementById('view_name').textContent = btn.dataset.name;
            document.getElementById('view_description').textContent = btn.dataset.description;
            document.getElementById('view_price').textContent = btn.dataset.price;
            document.getElementById('view_duration').textContent = btn.dataset.duration;
            const img = btn.dataset.img;
            const contextPath = '${pageContext.request.contextPath}';
            document.getElementById('view_img').src = img && img !== 'null' ? (img.startsWith('http') ? img : (img ? (contextPath + '/assets/' + img) : (contextPath + '/assets/default-image.svg'))) : (contextPath + '/assets/default-image.svg');
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
