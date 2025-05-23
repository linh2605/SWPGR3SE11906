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
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <!-- Custom CSS (đã bao gồm Leaflet CSS) -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/views/assets/css/styles.css">
</head>
<body>
    <!-- Nhúng header và navbar -->
    <%@ include file="../layouts/header.jsp" %>

    <!-- Banner Carousel -->
    <section class="banner mb-4">
        <div id="carouselBanner" class="carousel slide" data-bs-ride="carousel">
            <div class="carousel-inner">
                <div class="carousel-item active">
                    <img src="https://picsum.photos/1200/400" class="d-block w-100" alt="Banner 1">
                    <div class="carousel-caption d-none d-md-block">
                        <h5>Chăm sóc sức khỏe toàn diện</h5>
                        <p>Đội ngũ bác sĩ chuyên nghiệp, thiết bị hiện đại hàng đầu.</p>
                    </div>
                </div>
                <div class="carousel-item">
                    <img src="https://picsum.photos/1200/400" class="d-block w-100" alt="Banner 2">
                    <div class="carousel-caption d-none d-md-block">
                        <h5>Cấp cứu 24/7</h5>
                        <p>Liên hệ ngay: 0976054728</p>
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
                    <a href="#" class="btn btn-outline-success me-2">
                        <i class="bi bi-calendar-plus"></i> Đặt lịch khám
                    </a>
                </div>
                <div class="col-auto">
                    <a href="#" class="btn btn-outline-success me-2">
                        <i class="bi bi-search"></i> Tìm bác sĩ
                    </a>
                </div>
                <div class="col-auto">
                    <a href="#" class="btn btn-outline-success me-2">
                        <i class="bi bi-chat-left-text"></i> Góp ý
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

    <!-- Main Content -->
    <main class="container my-5">
        <!-- Ưu đãi nổi bật -->
        <section class="promotions mb-5">
            <h2 class="text-center mb-4" style="color: #004d99;">Ưu đãi nổi bật</h2>
            <div class="row">
                <div class="col-md-4 mb-4">
                    <div class="card">
                        <img src="https://picsum.photos/300/200" class="card-img-top" alt="Ưu đãi 1">
                        <div class="card-body">
                            <h5 class="card-title">Gói khám sức khỏe tổng quát</h5>
                            <p class="card-text">Giảm giá 20% cho khách hàng đăng ký trong tháng này.</p>
                            <a href="#" class="btn btn-primary">Xem chi tiết</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 mb-4">
                    <div class="card">
                        <img src="https://picsum.photos/300/200" class="card-img-top" alt="Ưu đãi 2">
                        <div class="card-body">
                            <h5 class="card-title">Khám chuyên khoa miễn phí</h5>
                            <p class="card-text">Miễn phí khám chuyên khoa cho khách hàng trên 60 tuổi.</p>
                            <a href="#" class="btn btn-primary">Xem chi tiết</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 mb-4">
                    <div class="card">
                        <img src="https://picsum.photos/300/200" class="card-img-top" alt="Ưu đãi 3">
                        <div class="card-body">
                            <h5 class="card-title">Gói tầm soát ung thư</h5>
                            <p class="card-text">Ưu đãi đặc biệt cho gói tầm soát ung thư toàn diện.</p>
                            <a href="#" class="btn btn-primary">Xem chi tiết</a>
                        </div>
                    </div>
                </div>
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
                <a href="#" class="btn btn-primary">Xem thêm</a>
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
                            <a href="#" class="btn btn-primary">Xem nhiều hơn</a>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Đội ngũ bác sĩ -->
        <section class="doctors mb-5">
            <h2 class="text-center mb-4" style="color: #004d99;">Đội ngũ bác sĩ</h2>
            <div id="doctorCarousel" class="carousel slide" data-bs-ride="carousel">
                <div class="carousel-inner">
                    <div class="carousel-item active">
                        <div class="row">
                            <div class="col-md-4 mb-4">
                                <div class="card">
                                    <img src="https://picsum.photos/300/250" class="card-img-top" alt="Bác sĩ 1">
                                    <div class="card-body">
                                        <h5 class="card-title">ThS.BSCKI Trịnh Minh Thanh</h5>
                                        <p class="card-text">Khoa Ngoại Tổng Hợp</p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4 mb-4">
                                <div class="card">
                                    <img src="https://picsum.photos/300/250" class="card-img-top" alt="Bác sĩ 2">
                                    <div class="card-body">
                                        <h5 class="card-title">ThS.BS Nguyễn Văn Hải</h5>
                                        <p class="card-text">Khoa Tim Mạch</p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4 mb-4">
                                <div class="card">
                                    <img src="https://picsum.photos/300/250" class="card-img-top" alt="Bác sĩ 3">
                                    <div class="card-body">
                                        <h5 class="card-title">ThS.BS Lê Quang Hải</h5>
                                        <p class="card-text">Khoa Ngoại Chấn Thương Chỉnh Hình</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="carousel-item">
                        <div class="row">
                            <div class="col-md-4 mb-4">
                                <div class="card">
                                    <img src="https://picsum.photos/300/250" class="card-img-top" alt="Bác sĩ 4">
                                    <div class="card-body">
                                        <h5 class="card-title">BSCKI Đinh Văn Hạo</h5>
                                        <p class="card-text">Vật Lý Trị Liệu - Phục Hồi Chức Năng</p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4 mb-4">
                                <div class="card">
                                    <img src="https://picsum.photos/300/250" class="card-img-top" alt="Bác sĩ 5">
                                    <div class="card-body">
                                        <h5 class="card-title">TS.BS Phạm Thị Hồng</h5>
                                        <p class="card-text">Khoa Nội Tiết</p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4 mb-4">
                                <div class="card">
                                    <img src="https://picsum.photos/300/250" class="card-img-top" alt="Bác sĩ 6">
                                    <div class="card-body">
                                        <h5 class="card-title">BSCKII Trần Văn Nam</h5>
                                        <p class="card-text">Khoa Hô Hấp</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
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
            <!-- Nút hiển thị danh sách bác sĩ -->
            <div class="text-center mt-4">
                <a href="#" class="btn btn-primary">Xem danh sách bác sĩ</a>
            </div>
        </section>

        <!-- Chuyên khoa -->
        <section class="specialties">
            <h2 class="text-center mb-4" style="color: #004d99;">Chuyên khoa</h2>
            <div class="row">
                <div class="col-md-3 mb-4">
                    <div class="card">
                        <img src="https://picsum.photos/300/200" class="card-img-top" alt="Cơ Xương Khớp">
                        <div class="card-body">
                            <h5 class="card-title">Cơ Xương Khớp</h5>
                            <p class="card-text">Điều trị các bệnh lý xương khớp cấp và mạn tính.</p>
                            <a href="#" class="btn btn-outline-primary">Tìm hiểu thêm</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 mb-4">
                    <div class="card">
                        <img src="https://picsum.photos/300/200" class="card-img-top" alt="Ngoại Tổng Hợp">
                        <div class="card-body">
                            <h5 class="card-title">Ngoại Tổng Hợp</h5>
                            <p class="card-text">Phẫu thuật và điều trị bệnh lý ngoại khoa.</p>
                            <a href="#" class="btn btn-outline-primary">Tìm hiểu thêm</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 mb-4">
                    <div class="card">
                        <img src="https://picsum.photos/300/200" class="card-img-top" alt="Nhi Khoa">
                        <div class="card-body">
                            <h5 class="card-title">Nhi Khoa</h5>
                            <p class="card-text">Chăm sóc sức khỏe toàn diện cho trẻ em.</p>
                            <a href="#" class="btn btn-outline-primary">Tìm hiểu thêm</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 mb-4">
                    <div class="card">
                        <img src="https://picsum.photos/300/200" class="card-img-top" alt="Sản Khoa">
                        <div class="card-body">
                            <h5 class="card-title">Sản Khoa</h5>
                            <p class="card-text">Hỗ trợ sinh nở và chăm sóc mẹ bầu.</p>
                            <a href="#" class="btn btn-outline-primary">Tìm hiểu thêm</a>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <!-- Bản đồ OpenStreetMap với Leaflet -->
    <section class="map-section mb-4">
        <div id="map" style="height: 300px; width: 100%;"></div>
    </section>

    <!-- Nhúng footer -->
    <%@ include file="../layouts/footer.jsp" %>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    <!-- Leaflet JS cho OpenStreetMap -->
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <!-- Custom JS (đã bao gồm script khởi tạo bản đồ) -->
    <script src="${pageContext.request.contextPath}/views/assets/js/scripts.js"></script>
</body>
</html>