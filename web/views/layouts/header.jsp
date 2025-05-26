<%-- 
    Document   : header
    Created on : May 23, 2025, 3:20:14 PM
    Author     : HoangAnh
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<header class="header">
    <nav class="navbar navbar-expand-lg navbar-light">
        <div class="container">
            <a class="navbar-brand" href="#">
                <img src="https://picsum.photos/150/60" alt="G3 Hospital Logo">
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item"><a class="nav-link" href="#">Giới thiệu</a></li>
                    <li class="nav-item"><a class="nav-link" href="../home/doctor-list.jsp">Bác sĩ</a></li>
                    <li class="nav-item"><a class="nav-link" href="#">Chuyên khoa</a></li>
                    <li class="nav-item"><a class="nav-link" href="#">Tư vấn sức khỏe</a></li>
                    <li class="nav-item"><a class="nav-link" href="#">Bài viết</a></li>
                    <li class="nav-item"><a class="nav-link" href="#">Thư viện media</a></li>
                </ul>
                <div class="d-flex align-items-center">
                    <span class="hotline me-3">Hỗ trợ tư vấn: 0976054728</span>
                    <a href="${pageContext.request.contextPath}/views/home/login.jsp" class="btn btn-outline-primary">
                        Đăng ký / Đăng nhập
                    </a>


                </div>
            </div>
        </div>
    </nav>
</header>