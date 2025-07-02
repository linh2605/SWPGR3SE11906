<%@ page import="models.ExaminationPackage" %>
<%@ page import="dal.ExaminationPackageDao" %>
<%@ page import="java.util.List" %>
<%@ page import="models.Specialty" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>G3 Hospital - Trang chủ</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap" rel="stylesheet">
        <!-- Bootstrap Icons -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <!-- Custom CSS (đã bao gồm Leaflet CSS) -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
    </head>
    <body>
        <!-- Nhúng header và navbar -->
        <%@ include file="../layouts/header.jsp" %>

        <!-- Banner Carousel -->
        <section class="banner mb-4">
            <div id="carouselBanner" class="carousel slide" data-bs-ride="carousel">
                <div class="carousel-inner">
                    <div class="carousel-item active">
                        <img src="assets/Blue White Modern Professional Medical Business Facebook Cover.png" class="d-block w-100" alt="Banner 1">
                        <div class="carousel-caption d-none d-md-block">
                           
                        </div>
                    </div>
                    <div class="carousel-item">
                        <img src="assets/Blue White Modern Professional Medical Business Facebook Cover (1).png" class="d-block w-100" alt="Banner 2">
                        <div class="carousel-caption d-none d-md-block">
                            
                        </div>
                    </div>
                    <div class="carousel-item">
                        <img src="assets/Blue White Modern Professional Medical Business Facebook Cover (2).png" class="d-block w-100" alt="Banner 2">
                        <div class="carousel-caption d-none d-md-block">
                            
                        </div>
                    </div>
                </div>
                <button class="carousel-control-prev" type="button" data-bs-target="#carouselBanner" data-bs-slide="prev">
                    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                    <span class="visually-hidden">Previous</span>
                </button>
                <button class="carousel-control-next" type="button" data-bs-target="#carouselBanner" data-bs-slide="next">
                    <span class="carousel-control-next-icon" aria-hidden="true"></span>
                    <span class="visually-hidden">Next</span>
                </button>
            </div>
        </section>

        <!-- Thanh chức năng -->
        <section class="function-bar">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-auto">
<!--                        <a class="btn btn-outline-success me-2"
                           href="${pageContext.request.contextPath}/views/appointment/make-appointment.jsp"
                           >
                            <i class="bi bi-calendar-plus"></i> Đặt lịch khám
                        </a>-->
                        <a class="btn btn-outline-success me-2"
                           href="${pageContext.request.contextPath}/appointment"
                           >
                            <i class="bi bi-calendar-plus"></i> Đặt Lịch Khám
                        </a>
                    </div>
                    <div class="col-auto">
                        <a href="${pageContext.request.contextPath}/doctors" class="btn btn-outline-success me-2">
                            <i class="bi bi-search"></i> Tìm bác sĩ
                        </a>
                    </div>
                    <div class="col-auto">
                        <a href="${pageContext.request.contextPath}/views/info/contact_us.jsp" class="btn btn-outline-success me-2">
                            <i class="bi bi-chat-left-text"></i> Liên hệ
                        </a>
                    </div>
                    <div class="col-auto">
                        <a href="#" class="btn btn-outline-success">
                            <i class="bi bi-person-plus"></i> Tìm theo mã bệnh
                        </a>
                    </div>
                </div>
            </div>
        </section>

        <!-- Modal Đặt Lịch Khám -->
        <div class="modal fade" id="bookingModal" tabindex="-1" aria-labelledby="bookingModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="bookingModalLabel">Đặt Lịch Khám - G3 Hospital</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form id="bookingForm">
                            <div class="mb-3">
                                <label for="fullName" class="form-label">Họ và Tên</label>
                                <input type="text" class="form-control" id="fullName" name="fullName" required>
                            </div>
                            <div class="mb-3">
                                <label for="phone" class="form-label">Số điện thoại</label>
                                <input type="tel" class="form-control" id="phone" name="phone" required>
                            </div>
                            <div class="mb-3">
                                <label for="email" class="form-label">Email</label>
                                <input type="email" class="form-control" id="email" name="email" required>
                            </div>
                            <div class="mb-3">
                                <label for="specialty" class="form-label">Chuyên Khoa</label>
                                <select class="form-select" id="specialty" name="specialty" required>
                                    <option value="">Chọn chuyên khoa</option>
                                    <option value="co-xuong-khop">Cơ Xương Khớp</option>
                                    <option value="ngoai-tong-hop">Ngoại Tổng Hợp</option>
                                    <option value="nhi-khoa">Nhi Khoa</option>
                                    <option value="san-khoa">Sản Khoa</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="doctor" class="form-label">Bác sĩ</label>
                                <select class="form-select" id="doctor" name="doctor" required>
                                    <option value="">Chọn bác sĩ</option>
                                    <option value="dr1">ThS.BSCKI Trịnh Minh Thanh</option>
                                    <option value="dr2">ThS.BS Nguyễn Văn Hải</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="appointmentDate" class="form-label">Ngày giờ hẹn</label>
                                <input type="datetime-local" class="form-control" id="appointmentDate" name="appointmentDate" required>
                            </div>
                            <div class="mb-3">
                                <label for="note" class="form-label">Ghi chú</label>
                                <textarea class="form-control" id="note" name="note" rows="3"></textarea>
                            </div>
                            <button type="submit" class="btn btn-primary w-100">Đặt lịch</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Main Content -->
        <main class="container my-5">
            <!-- Dịch Vụ Khám Nổi Bật -->
            <section class="promotions mb-5">
                <h2 class="text-center mb-4" style="color: #004d99;">Dịch Vụ Khám Nổi Bật</h2>
                <div class="row">
                    <c:forEach var="service" items="${popularServices}">
                        <div class="col-md-4 mb-4">
                            <div class="card service-card" style="cursor: pointer;" onclick="window.location.href='${pageContext.request.contextPath}/service-detail?id=${service.serviceId}'">
                                <img src="https://picsum.photos/300/200?random=${service.serviceId}" class="card-img-top" alt="${service.name}" style="height: 200px; object-fit: cover;">
                                <div class="card-body text-center">
                                    <h5 class="card-title">${service.name}</h5>
                                    <p class="card-text">${service.detail}</p>
                                    <p class="card-text"><strong>Giá: ${service.price} VNĐ</strong></p>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </section>
            <section class="promotions mb-5">
                <h2 class="text-center mb-4" style="color: #004d99;">Các Gói Khám</h2>
                <div class="row">
                    <%
                            List<ExaminationPackage> examinationPackages = ExaminationPackageDao.getAll();
                            if (examinationPackages != null && !examinationPackages.isEmpty()) {
                                int count = Math.min(3, examinationPackages.size());
                                for (int i = 0; i < count; i++) {
                                    ExaminationPackage pkg = examinationPackages.get(i);
                        %>
                                    <div class="col-md-4 mb-4">
                                        <div class="card p-3 h-100">
                                            <div class="card-body text-center">
                                                <h5 class="card-title"><%= pkg.getName() %></h5>
                                                <p class="card-text"><%= pkg.getDescription() %></p>

                                                <% if (pkg.getSpecialties() != null && !pkg.getSpecialties().isEmpty()) { %>
                                                    <p class="card-text mb-1"><strong>Chuyên Khoa:</strong></p>
                                                    <ul class="list-unstyled">
                                                        <% for (Specialty spec : pkg.getSpecialties()) { %>
                                                            <li>- <%= spec.getName() %></li>
                                                        <% } %>
                                                    </ul>
                                                <% } %>

                                                <p class="card-text"><strong>Giá:</strong> <%= pkg.getPrice() %> VNĐ</p>
                                                <p class="card-text"><strong>Thời lượng:</strong> <%= pkg.getDuration() %> phút</p>
                                                <a href="<%= request.getContextPath() %>/package?id=<%= pkg.getPackageId() %>" class="btn btn-primary mt-2">Xem chi tiết</a>
                                            </div>
                                        </div>
                                    </div>
                        <%
                                }
                            } else {
                        %>
                            <div class="col-12">
                                <p class="text-muted text-center">Không có gói khám nào để hiển thị.</p>
                            </div>
                        <%
                            }
                        %>

                </div>
            </section>

            <!-- Tại sao chọn G3 Hospital -->
            <section class="why-choose-us mb-5">
                <h2 class="text-center mb-4" style="color: #004d99;">Tại sao chọn G3 Hospital?</h2>
                <div class="row">
                    <div class="col-md-3 mb-4">
                        <div class="card h-100">
                            <div class="card-body">
                                <i class="bi bi-person-check"></i>
                                <h5 class="card-title">Đội ngũ bác sĩ chuyên môn cao</h5>
                                <p class="card-text">Đội ngũ bác sĩ hàng đầu, chuyên gia trong nhiều lĩnh vực y tế.</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 mb-4">
                        <div class="card h-100">
                            <div class="card-body">
                                <i class="bi bi-heart-pulse"></i>
                                <h5 class="card-title">Trang thiết bị hiện đại</h5>
                                <p class="card-text">Trang bị công nghệ tiên tiến, hỗ trợ chẩn đoán chính xác.</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 mb-4">
                        <div class="card h-100">
                            <div class="card-body">
                                <i class="bi bi-shield-lock"></i>
                                <h5 class="card-title">Dịch vụ y tế toàn diện</h5>
                                <p class="card-text">Thư giãn trong không gian sang trọng, chăm sóc toàn diện.</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 mb-4">
                        <div class="card h-100">
                            <div class="card-body">
                                <i class="bi bi-globe"></i>
                                <h5 class="card-title">Đảm bảo hợp tác quốc tế</h5>
                                <p class="card-text">Hợp tác với các tổ chức y tế quốc tế hàng đầu.</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="text-center mt-4">
                    <a href="${pageContext.request.contextPath}/views/info/why_choose_us.jsp" class="btn btn-primary">Xem thêm</a>
                </div>
            </section>

            <!-- Giới thiệu về G3 Hospital -->
            <section class="introduction mb-5">
                <h2 class="text-center mb-4" style="color: #004d99;">Giới thiệu về G3 Hospital</h2>
                <div class="row g-0">
                    <div class="col-md-6">
                        <div class="card">
                            <img src="https://picsum.photos/600/400" class="card-img-top" alt="Giới thiệu G3 Hospital">
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-body">
                                <p class="card-text">Năm 2003, Bệnh viện Đa khoa G3 Hospital được thành lập, là bệnh viện tư nhân hàng đầu tại Việt Nam. Với sứ mệnh mang lại dịch vụ y tế chất lượng cao, G3 Hospital không ngừng đầu tư vào cơ sở vật chất hiện đại và đội ngũ bác sĩ chuyên môn xuất sắc.</p>
                                <ul class="list-unstyled">
                                    <li><i class="bi bi-check-circle"></i> Hơn 250 bác sĩ chuyên gia, giàu kinh nghiệm</li>
                                    <li><i class="bi bi-check-circle"></i> Hệ thống trang thiết bị hiện đại, tiên tiến</li>
                                    <li><i class="bi bi-check-circle"></i> Dịch vụ chăm sóc sức khỏe toàn diện</li>
                                    <li><i class="bi bi-check-circle"></i> Hiệu quả điều trị cao, sự hài lòng của bệnh nhân</li>
                                </ul>
                                <a href="${pageContext.request.contextPath}/views/info/about_us.jsp" class="btn btn-primary">Xem nhiều hơn</a>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Đội ngũ bác sĩ - Carousel động 3 bác sĩ/slide -->
            <section class="doctors mb-5">
                <h2 class="text-center mb-4" style="color: #004d99;">Đội ngũ bác sĩ</h2>
                <div id="doctorCarousel" class="carousel slide" data-bs-ride="carousel">
                    <div class="carousel-inner">
                        <c:forEach var="slide" begin="0" end="${(doctors.size() - 1) / 3}" varStatus="slideStatus">
                            <div class="carousel-item${slideStatus.index == 0 ? ' active' : ''}">
                                <div class="row">
                                    <c:forEach var="d" begin="${slideStatus.index * 3}" end="${Math.min((slideStatus.index + 1) * 3 - 1, doctors.size() - 1)}">
                                        <c:set var="doctor" value="${doctors[d]}" />
                                        <div class="col-md-4 mb-4">
                                            <div class="card doctor-card" style="cursor: pointer;" onclick="window.location.href='${pageContext.request.contextPath}/doctor-detail?id=${doctor.doctor_id}'">
                                                <img src="${doctor.image_url}" class="card-img-top" alt="${doctor.user.fullName}" style="height: 200px; object-fit: cover;">
                                                <div class="card-body">
                                                    <h5 class="card-title">${doctor.user.fullName}</h5>
                                                    <p class="card-text">${doctor.specialty.name}</p>
                                                    <p class="card-text"><small>${doctor.degree}</small></p>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    <button class="carousel-control-prev" type="button" data-bs-target="#doctorCarousel" data-bs-slide="prev">
                        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                        <span class="visually-hidden">Previous</span>
                    </button>
                    <button class="carousel-control-next" type="button" data-bs-target="#doctorCarousel" data-bs-slide="next">
                        <span class="carousel-control-next-icon" aria-hidden="true"></span>
                        <span class="visually-hidden">Next</span>
                    </button>
                </div>
                <div class="text-center mt-4">
                    <a href="${pageContext.request.contextPath}/doctors" class="btn btn-primary">Xem danh sách bác sĩ</a>
                </div>
            </section>

        </main>

        <!-- Bản đồ OpenStreetMap với Leaflet -->
        <div>
            <section class="map-section mb-4">
                <div id="map" style="height: 300px; width: 100%;"></div>
            </section>
        </div>


        <!-- Nhúng footer -->
        <%@ include file="../layouts/footer.jsp" %>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
        <!-- Leaflet JS cho OpenStreetMap -->
        <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
        <!-- Custom JS (đã bao gồm script khởi tạo bản đồ) -->
        <script src="${pageContext.request.contextPath}/assets/js/scripts.js"></script>
    </body>
</html>