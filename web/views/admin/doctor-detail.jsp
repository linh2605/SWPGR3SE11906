<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard - G3 Hospital</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4Q6Gf2aSP4eDXB8Miphtr37CMZZQ5oXLH2yaXMJ2w8e2ZtHTl7GptT4jmndRuHDT" crossorigin="anonymous">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/styles.css">
</head>
<body>
<div class="wrapper">
    <%@ include file="../layouts/header.jsp" %>
    <!-- BODY -->
    <div class="main">
        <div class="sidebar">
            <h3>ADMIN DASHBOARD</h3>
            <a href="doctorManager.jsp">Quản lý bác sĩ</a>
            <a href="userManager.jsp">Quản lý bệnh nhân</a>
        </div>
        <div class="content">
            <!-- Nội dung chính tại đây -->
            <h2>Thông tin chi tiết về bác sĩ XXX</h2>
            <div class="container mt-5">
                <form>
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label">ID</label>
                            <input type="text" class="form-control" value="1" readonly>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Name</label>
                            <input type="text" class="form-control" value="Dr. Nguyễn Văn A">
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-4">
                            <label class="form-label">Gender</label>
                            <select class="form-select">
                                <option selected>MALE</option>
                                <option>FEMALE</option>
                                <option>OTHER</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Date of Birth</label>
                            <input type="date" class="form-control" value="1980-01-15">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Phone Number</label>
                            <input type="text" class="form-control" value="0901234567">
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Image URL</label>
                        <input type="text" class="form-control" value="https://via.placeholder.com/100">
                        <div class="mt-2">
                            <img src="https://via.placeholder.com/100" alt="Doctor Image" style="width:100px;height:100px;">
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label">Specialization</label>
                            <input type="text" class="form-control" value="Cardiology">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Degree</label>
                            <input type="text" class="form-control" value="MD">
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label">Experience (Years)</label>
                            <input type="number" class="form-control" value="15">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Working</label>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" checked id="workingCheck">
                                <label class="form-check-label" for="workingCheck">
                                    Currently Working
                                </label>
                            </div>
                        </div>
                    </div>

                    <div class="text-end">
                        <button type="submit" class="btn btn-primary">Update Doctor</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <%@ include file="../layouts/footer.jsp" %>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js" integrity="sha384-j1CDi7MgGQ12Z7Qab0qlWQ/Qqz24Gc6BM0thvEMVjHnfYGF0rmFCozFSxQBxwHKO" crossorigin="anonymous"></script>
<script src="${pageContext.request.contextPath}/views/assets/js/scripts.js"></script>
</body>
</html>