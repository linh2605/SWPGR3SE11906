
<%@ page import="models.ExaminationPackage" %>
<%@ page import="models.Specialty" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quản lý gói khám - Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/2.3.2/css/dataTables.dataTables.min.css">
</head>
<body>
<div class="wrapper">
    <%@ include file="../layouts/header.jsp" %>
    <div class="main">
        <%@include file="../layouts/admin-side-bar.jsp"%>
        <div class="content">
            <h2>Quản lý gói khám</h2>
            <button class="btn btn-primary mb-3" data-bs-toggle="modal" data-bs-target="#createPackageModal">Thêm gói khám</button>

            <% List<ExaminationPackage> examinationPackages = (List<ExaminationPackage>) request.getAttribute("examinationPackages"); %>
            <% List<Specialty> allSpecialties = (List<Specialty>) request.getAttribute("specialties"); %>
            <table class="table table-bordered table-striped" id="table">
                <thead class="table-light">
                <tr>
                    <th>ID</th>
                    <th>Package name</th>
                    <th>Description</th>
                    <th>Specialities</th>
                    <th>Price</th>
                    <th>Duration</th>
                    <th>Action</th>
                </tr>
                </thead>
                <tbody>
                <% for (ExaminationPackage p : examinationPackages) { %>
                <tr>
                    <td><%= p.getPackageId() %></td>
                    <td><%= p.getName() %></td>
                    <td><%= p.getDescription() %></td>
                    <td>
                        <% for (Specialty s : p.getSpecialties()) { %>
                        <span class="badge bg-info"><%= s.getName() %></span>
                        <% } %>
                    </td>
                    <td><%= p.getPrice() %></td>
                    <td><%= p.getDuration() %> phút</td>
                    <td>
                        <a class="text-warning" href="javascript:void(0)" onclick="populateUpdateForm(<%= p.getPackageId() %>, '<%= p.getName().replace("'", "\\'") %>', '<%= p.getDescription().replace("'", "\\'") %>', <%= p.getPrice() %>, <%= p.getDuration() %>, [<%= p.getSpecialties().stream().map(s -> s.getSpecialtyId() + "").collect(java.util.stream.Collectors.joining(",")) %>])" data-bs-toggle="modal" data-bs-target="#updatePackageModal">Update</a>|<br>
                        <form id="deleteForm_<%= p.getPackageId() %>" action="<%= request.getContextPath() %>/admin/examination-manage" method="post" style="display:inline;">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="id" value="<%= p.getPackageId() %>">
                            <a href="javascript:void(0)" class="text-danger" onclick="confirmDelete('<%= p.getPackageId() %>')">Delete</a>
                        </form>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>

        <!-- Modal thêm gói khám -->
        <div class="modal fade" id="createPackageModal" tabindex="-1">
            <div class="modal-dialog">
                <form id="createForm" method="post" action="${pageContext.request.contextPath}/admin/examination-manage">
                    <input type="hidden" name="action" value="add">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Thêm gói khám</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <div class="mb-3">
                                <label class="form-label">Tên gói</label>
                                <input type="text" name="name" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Mô tả</label>
                                <textarea name="description" class="form-control"></textarea>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Giá</label>
                                <input type="number" name="price" class="form-control" required step="0.01" min="0">
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Thời lượng (phút)</label>
                                <input type="number" name="duration" class="form-control" required min="1">
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Chuyên khoa</label>
                                <% for (Specialty s : allSpecialties) { %>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="specialty_ids" value="<%= s.getSpecialtyId() %>" id="specialty_create_<%= s.getSpecialtyId() %>">
                                    <label class="form-check-label" for="specialty_create_<%= s.getSpecialtyId() %>"><%= s.getName() %></label>
                                </div>
                                <% } %>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="submit" class="btn btn-success">Tạo</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <!-- Modal cập nhật gói khám -->
        <div class="modal fade" id="updatePackageModal" tabindex="-1">
            <div class="modal-dialog">
                <form method="post" action="${pageContext.request.contextPath}/admin/examination-manage">
                    <input type="hidden" name="action" value="edit">
                    <input type="hidden" name="id" id="update_package_id">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Cập nhật gói khám</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <div class="mb-3">
                                <label class="form-label">Tên gói</label>
                                <input type="text" name="name" id="update_name" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Mô tả</label>
                                <textarea name="description" id="update_description" class="form-control"></textarea>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Giá</label>
                                <input type="number" name="price" id="update_price" class="form-control" required step="0.01" min="0">
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Thời lượng (phút)</label>
                                <input type="number" name="duration" id="update_duration" class="form-control" required min="1">
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Chuyên khoa</label>
                                <% for (Specialty s : allSpecialties) { %>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="specialty_ids" value="<%= s.getSpecialtyId() %>" id="specialty_update_<%= s.getSpecialtyId() %>">
                                    <label class="form-check-label" for="specialty_update_<%= s.getSpecialtyId() %>"><%= s.getName() %></label>
                                </div>
                                <% } %>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="submit" class="btn btn-primary">Cập nhật</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

    </div>
    <%@ include file="../layouts/footer.jsp" %>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<script src="https://cdn.datatables.net/2.3.2/js/dataTables.min.js"></script>
<script>
    new DataTable("#table");

    function populateUpdateForm(id, name, description, price, duration, specialtyIds) {
        document.getElementById('update_package_id').value = id;
        document.getElementById('update_name').value = name;
        document.getElementById('update_description').value = description;
        document.getElementById('update_price').value = price;
        document.getElementById('update_duration').value = duration;

        // Uncheck all checkboxes first
        document.querySelectorAll("#updatePackageModal input[type='checkbox']").forEach(cb => cb.checked = false);

        // Re-check selected specialties
        specialtyIds.forEach(id => {
            const checkbox = document.getElementById("specialty_update_" + id);
            if (checkbox) checkbox.checked = true;
        });
    }
</script>
<%@include file="../layouts/toastr.jsp"%>
<script>
    document.getElementById("createForm").addEventListener("submit", function (e) {
        const inputName = document.querySelector("#createForm input[name='name']").value.trim().toLowerCase();

        // Duyệt tất cả tên gói trong bảng
        const existingNames = Array.from(document.querySelectorAll("#table tbody tr td:nth-child(2)"))
            .map(td => td.textContent.trim().toLowerCase());

        if (existingNames.includes(inputName)) {
            e.preventDefault(); // Ngăn form submit
            toastr.error("Tên gói khám đã tồn tại!");
        }
    });
</script>
<script>
    function confirmDelete(id) {
        if (confirm("Xóa gói này?")) {
            document.getElementById("deleteForm_" + id).submit();
        }
    }
</script>
</body>
</html>
