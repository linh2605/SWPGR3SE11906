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
            <h2>Quản lý bệnh nhân</h2>
            <table class="table table-bordered align-middle text-center">
                <thead class="table-light">
                <tr>
                    <th>ID</th>
                    <th>FullName</th>
                    <th>Number Phone</th>
                    <th>Birth of date</th>
                    <th>Avatar</th>
                    <th>Address</th>
                    <th>Action</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td>1</td>
                    <td>Nguyễn Văn A</td>
                    <td>0123456789</td>
                    <td>01/01/2000</td>
                    <td><a href="#">link avatar</a></td>
                    <td>328 Ba Trieu Street</td>
                    <td>
                        View( Or Edit)
                        <a href="#" class="ms-2 text-primary">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-envelope" viewBox="0 0 16 16">
                                <path d="M0 4a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V4z"/>
                                <path d="M.05 4.555L8 9.414l7.95-4.86A1.99 1.99 0 0 0 14 4H2c-.73 0-1.378.195-1.95.555z"/>
                            </svg>
                        </a>
                    </td>
                </tr>
                <tr>
                    <td>2</td>
                    <td>Phạm Thị B</td>
                    <td>0123456789</td>
                    <td>01/01/2000</td>
                    <td><a href="#">link avatar</a></td>
                    <td>406 Tran Hung Dao Street, Ward 2, District 5</td>
                    <td>
                        View( Or Edit)
                        <a href="#" class="ms-2 text-primary">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-envelope" viewBox="0 0 16 16">
                                <path d="M0 4a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V4z"/>
                                <path d="M.05 4.555L8 9.414l7.95-4.86A1.99 1.99 0 0 0 14 4H2c-.73 0-1.378.195-1.95.555z"/>
                            </svg>
                        </a>
                    </td>
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