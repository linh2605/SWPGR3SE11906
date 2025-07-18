<%-- 
    Document   : list
    Created on : May 26, 2025, 8:29:00 AM
    Author     : tuan
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap" rel="stylesheet">
        <!-- Bootstrap Icons -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <!-- Custom CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/doctor-list.css">

        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/favicon.svg" />

        <title>Danh sách bác sĩ - Hệ thống Quản lý Phòng khám</title>
        <style>
            /* Fix header overlap issue */
            body {
                padding-top: 0;
                font-family: 'Montserrat', sans-serif !important;
            }

            main {
                margin-top: 20px;
            }

            .page-btn.active {
                background-color: #004D99;
                color: white;
            }

            .doctor-list-container {
                padding: 60px 0;
                background-color: #f8f9fa;
            }

            .doctor-card {
                background: white;
                border-radius: 15px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
                transition: transform 0.3s ease, box-shadow 0.3s ease;
                margin-bottom: 30px;
                overflow: hidden;
            }

            .doctor-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 25px rgba(0,0,0,0.15);
            }

            .doctor-image {
                width: 100%;
                height: 200px;
                object-fit: cover;
                border-radius: 10px;
            }

            .doctor-name {
                font-size: 1.2rem;
                font-weight: 600;
                color: #004d99;
                margin-bottom: 10px;
                text-decoration: none;
            }

            .doctor-name:hover {
                color: #0066cc;
                text-decoration: none;
            }

            .doctor-info {
                padding: 20px;
            }

            .doctor-detail-btn {
                background-color: #004d99;
                color: white;
                border: none;
                padding: 8px 16px;
                border-radius: 20px;
                text-decoration: none;
                font-size: 0.9rem;
                transition: all 0.3s ease;
            }

            .doctor-detail-btn:hover {
                background-color: #003366;
                color: white;
                text-decoration: none;
            }

            .specialty-filter {
                background: white;
                border-radius: 15px;
                padding: 20px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
                margin-bottom: 30px;
            }

            .filter-tab {
                background: #f8f9fa;
                border: 2px solid #e9ecef;
                color: #495057;
                padding: 10px 15px;
                margin: 5px;
                border-radius: 25px;
                text-decoration: none;
                transition: all 0.3s ease;
                display: inline-block;
            }

            .filter-tab.active,
            .filter-tab:hover {
                background: #004d99;
                color: white;
                border-color: #004d99;
                text-decoration: none;
            }

            .banner-section {
                background: linear-gradient(rgba(0,77,153,0.7), rgba(0,77,153,0.7)),
                    url('${pageContext.request.contextPath}/assets/pexels-photo-5327590.png');
                background-size: cover;
                background-position: center;
                color: white;
                padding: 100px 0;
                text-align: center;
            }

            .banner-title {
                font-size: 3rem;
                font-weight: 700;
                margin-bottom: 20px;
            }

            .search-box {
                background: white;
                border-radius: 25px;
                padding: 5px;
                margin: 20px 0;
            }

            .search-input {
                border: none;
                padding: 10px 20px;
                border-radius: 20px;
                width: 100%;
                outline: none;
            }

            .breadcrumb {
                background: transparent;
                padding: 0;
                margin: 20px 0;
            }

            .breadcrumb-item a {
                color: white;
                text-decoration: none;
            }

            .breadcrumb-item.active {
                color: #ffd700;
            }

            /* Map section styling */
            .map-section {
                margin: 40px 0;
            }

            #map {
                border-radius: 15px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            }
        </style>
    </head>

    <body>
        <!-- Nhúng header và navbar -->
        <%@ include file="../layouts/header.jsp" %>

        <c:set var="defaultAvatar" value="${pageContext.request.contextPath}/assets/default-avatar.jpg" />

        <main>
            <!-- Banner Section -->
            <section class="banner-section">
                <div class="container">
                    <h1 class="banner-title">Danh sách bác sĩ</h1>

                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb justify-content-center">
                            <li class="breadcrumb-item">
                                <a href="${pageContext.request.contextPath}/">
                                    <i class="bi bi-house-door"></i> Trang chủ 
                                </a>
                            </li>
                            <i class="bi bi-chevron-right" style="font-size: 0.8rem"> </i>
                            <li class="breadcrumb-item active" aria-current="page">
                                Danh sách bác sĩ
                            </li>
                        </ol>
                    </nav>

                    <!-- Search Box -->
                    <div class="row justify-content-center">
                        <div class="col-md-6">
                            <div class="search-box">
                                <input type="text" 
                                       id="doctor-search" 
                                       class="search-input" 
                                       placeholder="Tìm kiếm bác sĩ theo tên...">
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Doctor List Section -->
            <section class="doctor-list-container">
                <div class="container">
                    <div class="row">
                        <!-- Specialty Filter Sidebar -->
                        <div class="col-md-3">
                            <div class="specialty-filter">
                                <h5 class="mb-3">
                                    <i class="bi bi-filter"></i> Lọc theo chuyên khoa
                                </h5>

                                <div class="filter-tabs">
                                    <button class="filter-tab active w-100 mb-2" 
                                            data-specialist-id="all">
                                        Tất cả
                                        <span class="badge bg-primary float-end">${countAllSpecialties}</span>
                                    </button>

                                    <c:forEach var="s" items="${specialties}">
                                        <button class="filter-tab w-100 mb-2" 
                                                data-specialist-id="${s.key.specialtyId}">
                                            ${s.key.name}
                                            <span class="badge bg-secondary float-end">${s.value}</span>
                                        </button>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>

                        <!-- Doctor Grid -->
                        <div class="col-md-9">
                            <div class="row" id="doctor-grid">

                                <c:choose>
                                    <c:when test="${not empty doctors}">
                                        <c:forEach var="d" items="${doctors}">
                                            <div class="col-md-6 doctor-item" data-specialist-id="${d.specialty.specialtyId}">
                                                <div class="doctor-card">
                                                    <div class="p-3">
                                                        <div class="row">
                                                            <div class="col-4">
                                                                <img src="${not empty d.image_url ? d.image_url : defaultAvatar}" 
                                                                     alt="${d.user.fullName}" 
                                                                     class="doctor-image">
                                                            </div>
                                                            <div class="col-8 doctor-info">
                                                                <a href="${pageContext.request.contextPath}/doctors/view?id=${d.doctor_id}" 
                                                                   class="doctor-name">
                                                                    ${d.user.fullName}
                                                                </a>

                                                                <p class="text-muted mb-2">
                                                                    <i class="bi bi-hospital"></i> 
                                                                    ${d.specialty.name}
                                                                </p>

                                                                <div class="mb-2">
                                                                    <small class="text-muted">
                                                                        <i class="bi bi-mortarboard"></i> 
                                                                        ${d.degree}
                                                                    </small>
                                                                </div>

                                                                <div class="mb-3">
                                                                    <small class="text-muted">
                                                                        <i class="bi bi-briefcase"></i> 
                                                                        ${d.experience}
                                                                    </small>
                                                                </div>
                                                                <a href="${pageContext.request.contextPath}/appointment-doctor?id=${d.doctor_id}" 
                                                                   class="btn btn-success quick-action-btn"
                                                                   style="font-size: 0.9rem">
                                                                    <i class="bi bi-calendar-plus"></i> Đặt lịch
                                                                </a>
                                                                <a href="${pageContext.request.contextPath}/doctors/view?id=${d.doctor_id}" 
                                                                   class="btn btn-primary quick-action-btn"
                                                                   style="font-size: 0.9rem">
                                                                    <i class="bi bi-eye"></i> Xem chi tiết
                                                                </a>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="col-12">
                                            <div class="alert alert-info text-center">
                                                <i class="bi bi-info-circle"></i>
                                                <h5>Không có bác sĩ nào được tìm thấy</h5>
                                                <p class="mb-0">Hiện tại chưa có thông tin bác sĩ trong hệ thống hoặc tất cả bác sĩ đang bận.</p>
                                            </div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- Pagination -->
                            <div id="pagination-container" class="mt-4 text-center">
                                <!-- Pagination will be generated by JavaScript -->
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Map Section -->
            <section class="map-section">
                <div class="container">
                    <div class="text-center mb-4">
                        <h3>Vị trí phòng khám</h3>
                        <p class="text-muted">Tìm hiểu vị trí các cơ sở y tế của chúng tôi</p>
                    </div>
                    <div id="map" style="height: 300px; width: 100%;"></div>
                </div>
            </section>
        </main>

        <!-- Footer -->
        <%@ include file="../layouts/footer.jsp" %>

        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/scripts.js"></script>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const specialistButtons = document.querySelectorAll('[data-specialist-id]');
                const allDoctors = Array.from(document.querySelectorAll('.doctor-item'));
                const paginationContainer = document.getElementById('pagination-container');
                const searchInput = document.getElementById('doctor-search');

                const doctorsPerPage = 6; // 6 bác sĩ trên 1 trang
                let currentSpecialistId = 'all';
                let currentPage = 1;
                let currentKeyword = '';

                function normalize(str) {
                    return str.toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, "");
                }

                function getFilteredDoctors() {
                    return allDoctors.filter(doc => {
                        const docSpecId = doc.getAttribute('data-specialist-id');
                        const name = doc.querySelector('.doctor-name')?.textContent || '';
                        const matchSpec = currentSpecialistId === 'all' || docSpecId === currentSpecialistId;
                        const matchKeyword = currentKeyword === '' || normalize(name).includes(normalize(currentKeyword));
                        return matchSpec && matchKeyword;
                    });
                }

                function renderDoctors() {
                    const filteredDoctors = getFilteredDoctors();
                    const totalPages = Math.ceil(filteredDoctors.length / doctorsPerPage);
                    if (currentPage > totalPages && totalPages > 0) {
                        currentPage = 1;
                    }

                    const start = (currentPage - 1) * doctorsPerPage;
                    const end = start + doctorsPerPage;

                    // Hide all doctors
                    allDoctors.forEach(doc => doc.style.display = 'none');

                    // Show filtered doctors for current page
                    filteredDoctors.slice(start, end).forEach(doc => doc.style.display = 'block');

                    renderPagination(totalPages);
                }

                function renderPagination(totalPages) {
                    paginationContainer.innerHTML = '';

                    if (totalPages <= 1)
                        return;

                    const pagination = document.createElement('nav');
                    const ul = document.createElement('ul');
                    ul.className = 'pagination justify-content-center';

                    // Previous button
                    const prevLi = document.createElement('li');
                    prevLi.className = 'page-item ' + (currentPage === 1 ? 'disabled' : '');
                    const prevLink = document.createElement('a');
                    prevLink.className = 'page-link';
                    prevLink.innerHTML = '<i class="bi bi-chevron-left"></i>';
                    prevLink.href = '#';
                    if (currentPage > 1) {
                        prevLink.addEventListener('click', (e) => {
                            e.preventDefault();
                            currentPage--;
                            renderDoctors();
                        });
                    }
                    prevLi.appendChild(prevLink);
                    ul.appendChild(prevLi);

                    // Page numbers
                    for (let i = 1; i <= totalPages; i++) {
                        const li = document.createElement('li');
                        li.className = 'page-item ' + (i === currentPage ? 'active' : '');
                        const link = document.createElement('a');
                        link.className = 'page-link';
                        link.textContent = i;
                        link.href = '#';
                        link.addEventListener('click', (e) => {
                            e.preventDefault();
                            currentPage = i;
                            renderDoctors();
                        });
                        li.appendChild(link);
                        ul.appendChild(li);
                    }

                    // Next button
                    const nextLi = document.createElement('li');
                    nextLi.className = 'page-item ' + (currentPage === totalPages ? 'disabled' : '');
                    const nextLink = document.createElement('a');
                    nextLink.className = 'page-link';
                    nextLink.innerHTML = '<i class="bi bi-chevron-right"></i>';
                    nextLink.href = '#';
                    if (currentPage < totalPages) {
                        nextLink.addEventListener('click', (e) => {
                            e.preventDefault();
                            currentPage++;
                            renderDoctors();
                        });
                    }
                    nextLi.appendChild(nextLink);
                    ul.appendChild(nextLi);

                    pagination.appendChild(ul);
                    paginationContainer.appendChild(pagination);
                }

                // Specialty filter handlers
                specialistButtons.forEach(btn => {
                    btn.addEventListener('click', function () {
                        currentSpecialistId = btn.getAttribute('data-specialist-id');
                        currentPage = 1;

                        // Update active state
                        specialistButtons.forEach(b => b.classList.remove('active'));
                        btn.classList.add('active');

                        renderDoctors();
                    });
                });

                // Search handler
                searchInput.addEventListener('input', function () {
                    currentKeyword = this.value;
                    currentPage = 1;
                    renderDoctors();
                });

                // Initialize map
                if (typeof L !== 'undefined') {
                    const map = L.map('map').setView([21.0285, 105.8542], 13);
                    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                        attribution: '© OpenStreetMap contributors'
                    }).addTo(map);

                    L.marker([21.0285, 105.8542]).addTo(map)
                            .bindPopup('Hệ thống Quản lý Phòng khám')
                            .openPopup();
                }

                // Initial render
                renderDoctors();
            });
        </script>
    </body>
</html>
