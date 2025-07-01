<%@ page import="models.ExaminationPackage" %>
<%@ page import="models.Specialty" %>
<%@ page import="java.util.List" %>
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

            <% List<ExaminationPackage> examinationPackages = (List<ExaminationPackage>) request.getAttribute("examinationPackages"); %>
            <% List<Specialty> allSpecialties = (List<Specialty>) request.getAttribute("specialties"); %>
            
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
                                <th>Chuyên khoa</th>
                                <th class="text-center">Giá (VND)</th>
                                <th class="text-center">Thời lượng</th>
                                <th>Thao tác</th>
                            </tr>
                            </thead>
                            <tbody>
                            <% for (ExaminationPackage p : examinationPackages) { %>
                            <tr>
                                <td class="text-center"><%= p.getPackageId() %></td>
                                <td><%= p.getName() %></td>
                                <td><%= p.getDescription() %></td>
                                <td>
                                    <% for (Specialty s : p.getSpecialties()) { %>
                                    <span class="badge bg-info me-1"><%= s.getName() %></span>
                                    <% } %>
                                </td>
                                <td class="text-center"><%= String.format("%,.0f", p.getPrice()) %></td>
                                <td class="text-center"><%= p.getDuration() %> phút</td>
                                <td>
                                    <button type="button" class="btn btn-sm btn-warning edit-btn" title="Chỉnh sửa"
                                            data-id="<%= p.getPackageId() %>"
                                            data-name="<%= p.getName() %>"
                                            data-description="<%= p.getDescription() %>"
                                            data-price="<%= p.getPrice() %>"
                                            data-duration="<%= p.getDuration() %>"
                                            data-specialties="<%= p.getSpecialties().stream().map(s -> s.getSpecialtyId() + "").collect(java.util.stream.Collectors.joining(",")) %>"
                                            data-bs-toggle="modal" data-bs-target="#updatePackageModal">
                                        <i class="bi bi-pencil"></i>
                                    </button>
                                    <button type="button" class="btn btn-sm btn-danger" title="Xóa"
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
                <form id="createForm" method="post" action="${pageContext.request.contextPath}/admin/examination-manage">
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
                                <div class="col-md-6">
                                    <label class="form-label">Thời lượng (phút)</label>
                                    <input type="number" name="duration" class="form-control" required min="1">
                                </div>
                                <div class="col-md-12">
                                    <label class="form-label">Mô tả</label>
                                    <textarea name="description" class="form-control" rows="3"></textarea>
                                </div>
                                <div class="col-md-12">
                                    <label class="form-label">Chuyên khoa</label>
                                    <div class="row">
                                        <% for (Specialty s : allSpecialties) { %>
                                        <div class="col-md-4">
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox" name="specialty_ids" value="<%= s.getSpecialtyId() %>" id="specialty_create_<%= s.getSpecialtyId() %>">
                                                <label class="form-check-label" for="specialty_create_<%= s.getSpecialtyId() %>"><%= s.getName() %></label>
                                            </div>
                                        </div>
                                        <% } %>
                                    </div>
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
                <form method="post" action="${pageContext.request.contextPath}/admin/examination-manage">
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
                                <div class="col-md-6">
                                    <label class="form-label">Thời lượng (phút)</label>
                                    <input type="number" name="duration" id="update_duration" class="form-control" required min="1">
                                </div>
                                <div class="col-md-12">
                                    <label class="form-label">Mô tả</label>
                                    <textarea name="description" id="update_description" class="form-control" rows="3"></textarea>
                                </div>
                                <div class="col-md-12">
                                    <label class="form-label">Chuyên khoa</label>
                                    <div class="row">
                                        <% for (Specialty s : allSpecialties) { %>
                                        <div class="col-md-4">
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox" name="specialty_ids" value="<%= s.getSpecialtyId() %>" id="specialty_update_<%= s.getSpecialtyId() %>">
                                                <label class="form-check-label" for="specialty_update_<%= s.getSpecialtyId() %>"><%= s.getName() %></label>
                                            </div>
                                        </div>
                                        <% } %>
                                    </div>
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
<script src="https://cdn.datatables.net/2.3.2/js/dataTables.min.js"></script>

<%@include file="../layouts/toastr.jsp"%>

<script>
    new DataTable("#table", {
        "language": {
            "url": "//cdn.datatables.net/plug-ins/1.10.25/i18n/Vietnamese.json"
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
            const duration = btn.dataset.duration;
            const specialtyIds = btn.dataset.specialties ? btn.dataset.specialties.split(',').map(id => parseInt(id)) : [];

            document.getElementById('update_package_id').value = id;
            document.getElementById('update_name').value = name;
            document.getElementById('update_description').value = description;
            document.getElementById('update_price').value = price;
            document.getElementById('update_duration').value = duration;

            // Uncheck all checkboxes first
            document.querySelectorAll("#updatePackageModal input[type='checkbox']").forEach(cb => cb.checked = false);

            // Re-check selected specialties
            specialtyIds.forEach(specialtyId => {
                const checkbox = document.getElementById("specialty_update_" + specialtyId);
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
