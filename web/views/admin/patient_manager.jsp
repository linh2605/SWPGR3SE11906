<%@ page import="java.util.ArrayList" %>
<%@ page import="model.Patient" %>
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
        <%@include file="../layouts/admin-side-bar.jsp"%>
        <div class="content">
            <h2>Quản lý bệnh nhân</h2>
            <% ArrayList<Patient> patients = (ArrayList<Patient>) request.getAttribute("patients");%>
            <table class="table table-bordered align-middle text-center">
                <thead class="table-light">
                <tr>
                    <th>ID</th>
                    <th>Username</th>
                    <th>Fullname</th>
                    <th>Email</th>
                    <th>Phone Number</th>
                    <th>Gender</th>
                    <th>Date of birth</th>
                    <th>Address</th>
                    <th>Avatar</th>
                    <th>Action</th>
                </tr>
                </thead>
                <tbody>
                <% for (int i = 0; i < patients.size(); i++) { %>
                <tr>
                    <td><%=patients.get(i).getUser().getUser_id()%></td>
                    <td><%=patients.get(i).getUser().getUsername()%></td>
                    <td><%=patients.get(i).getUser().getFullname()%></td>
                    <td><%=patients.get(i).getUser().getEmail()%></td>
                    <td><%=patients.get(i).getUser().getPhone()%></td>
                    <td><%=patients.get(i).getGender()%></td>
                    <td><%=patients.get(i).getDate_of_birth()%></td>
                    <td><%=patients.get(i).getAddress()%></td>
                    <td><a href="<%=patients.get(i).getImage_url().startsWith("http") ? patients.get(i).getImage_url() : request.getContextPath() + "/views/assets/" + patients.get(i).getImage_url()%>">link avatar</a></td>
                    <td>
                        <a href="javascript:void(0)" class="text-warning"
                           onclick="populateUpdateForm(
                                   '<%=patients.get(i).getPatient_id()%>',
                                   '<%=patients.get(i).getUser().getUsername()%>',
                                   '<%=patients.get(i).getUser().getFullname()%>',
                                   '<%=patients.get(i).getUser().getEmail()%>',
                                   '<%=patients.get(i).getUser().getPhone()%>',
                                   '<%=patients.get(i).getGender()%>',
                                   '<%=patients.get(i).getDate_of_birth()%>',
                                   '<%=patients.get(i).getAddress().replaceAll("'", "\\\\'")%>'
                                   )">
                            Update
                        </a>
                        |
                        <a href="javascript:void(0)" class="text-danger ms-2" onclick="showDeleteModal('<%=patients.get(i).getUser().getUser_id()%>')">
                            Delete
                        </a>
                    </td>
                </tr>
                <% } %>
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