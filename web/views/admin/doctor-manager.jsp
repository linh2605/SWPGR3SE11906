
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
            <h2>Quản lý bác sĩ</h2>
            <table class="table table-bordered table-striped">
                <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Gender</th>
                    <th>Date of Birth</th>
                    <th>Phone Number</th>
                    <th>Image</th>
                    <th>Specialization</th>
                    <th>Degree</th>
                    <th>Experience (Years)</th>
                    <th>Working</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td>1</td>
                    <td>Dr. Nguyễn Văn A</td>
                    <td>MALE</td>
                    <td>1980-01-15</td>
                    <td>0901234567</td>
                    <td><img src="https://via.placeholder.com/50" alt="Doctor Image" style="width:50px;height:50px;"></td>
                    <td>Cardiology</td>
                    <td>MD</td>
                    <td>15</td>
                    <td><span class="badge bg-success">Yes</span></td>
                </tr>
                <tr>
                    <td>2</td>
                    <td>Dr. Trần Thị B</td>
                    <td>FEMALE</td>
                    <td>1985-06-30</td>
                    <td>0912345678</td>
                    <td><img src="https://via.placeholder.com/50" alt="Doctor Image" style="width:50px;height:50px;"></td>
                    <td>Dermatology</td>
                    <td>PhD</td>
                    <td>10</td>
                    <td><span class="badge bg-danger">No</span></td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>

    <%@ include file="../layouts/footer.jsp" %>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js" integrity="sha384-j1CDi7MgGQ12Z7Qab0qlWQ/Qqz24Gc6BM0thvEMVjHnfYGF0rmFCozFSxQBxwHKO" crossorigin="anonymous"></script>
<script src="${pageContext.request.contextPath}/views/assets/js/scripts.js"></script>
</body>
</html>