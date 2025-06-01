<%-- 
    Document   : giaodien_patientmanager
    Created on : May 28, 2025, 5:08:45 AM
    Author     : THANH
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Patient Manager</title>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
        }

        .sidebar {
            width: 200px;
            background-color: #0f172a;
            color: white;
            height: 100vh;
            float: left;
            padding: 20px;
            box-sizing: border-box;
        }

        .main {
            margin-left: 200px;
            padding: 20px;
        }

        h1 {
            font-size: 28px;
        }

        .search-bar {
            float: right;
            margin-top: -50px;
        }

        .search-bar input[type="text"] {
            padding: 5px;
            width: 200px;
        }

        .search-bar input[type="submit"] {
            padding: 5px 10px;
            background-color: #1d4ed8;
            color: white;
            border: none;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: left;
        }

        th {
            background-color: #f3f4f6;
        }

        .action {
            color: #1d4ed8;
            cursor: pointer;
        }

        .icon {
            text-align: center;
        }

        .pagination {
            margin-top: 20px;
            text-align: right;
        }

        .pagination span, .pagination a {
            margin: 0 5px;
            padding: 6px 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            text-decoration: none;
            color: black;
        }

        .pagination .active {
            background-color: #3b82f6;
            color: white;
        }
    </style>
</head>
<body>

<div class="sidebar">
    <img src="images/avatar.png" alt="Avatar" width="64" height="64" style="border-radius: 50%;">
    <h3>Parker Whitson</h3>
    <p>parker@gmail.com</p>
    <p>Patient manage</p>
</div>

<div class="main">
    <h1>Patient manager</h1>

    <div class="search-bar">
        <form action="search.jsp" method="get">
            <input type="text" name="query" placeholder="🔍 Search..." />
            <input type="submit" value="Search" />
        </form>
    </div>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>FullName</th>
                <th>Number Phone</th>
                <th>Birth of date</th>
                <th>Avatar</th>
                <th>Address</th>
                <th>Action</th>
                <th class="icon">📩</th>
            </tr>
        </thead>
        <tbody>
            <%
                String[] names = {
                    "Nguyễn Văn A", "Phạm Thị B", "Trần Ngọc C", "Doãn Chí D", "Đỗ Ngọc E", "Hà Chí G", "Vũ Văn H",
                    "Lê Quốc I", "Hồ Quang K", "Trịnh Tuấn L", "Phùng Quang M", "Hoàng Hải N", "Bùi Đình P",
                    "Dương Quang Q", "Đinh Sơn S", "Vũ Như T", "Trương Thanh V"
                };
                String[] addresses = {
                    "328 Ba Trieu Street", "406 Tran Hung Dao Street, Ward 2, District 5", "41 Tran Quy, Ward 4, Dist.11",
                    "5/5 CACH MANG THANG TAM STREET", "B1.3-2, Ward 12, Dist.10", "82 Giai Phong St, Ward 14",
                    "59 Pho Duc Chinh Street", "287-289 Hung Vuong, Ward 9, Dist.5", "125 Phan Van Truong St.",
                    "96 Tran Hung Dao", "3B Giang Vo St., Lane 43", "83 Chua Boc, Trung Liet Ward",
                    "23 Kim Dong Street, Lane 19", "83A Le Van Viet, KP3", "32 National Highway 19",
                    "129 Au Co, Ward 14", "44 Ly Thuong Kiet st., Ward"
                };

                for (int i = 0; i < names.length; i++) {
            %>
            <tr>
                <td><%= i + 1 %></td>
                <td><%= names[i] %></td>
                <td>0123456789</td>
                <td>01/01/2000</td>
                <td><a href="#">link avatar</a></td>
                <td><%= addresses[i] %></td>
                <td class="action">View( Or Edit)</td>
                <td class="icon"><img src="images/01.png" alt="action" width="30" height="20" style="border-radius: 20%;"></td>
            </tr>
            <% } %>
        </tbody>
    </table>

    <div class="pagination">
        <span>Previous</span>
        <a href="#">1</a>
        <span class="active">2</span>
        <a href="#">3</a>
        <a href="#">4</a>
        <a href="#">5</a>
        <a href="#">Next</a>
    </div>
</div>

</body>
</html>

