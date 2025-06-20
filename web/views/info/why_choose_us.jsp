<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<html lang="vi">
<head>
    <title>Lý Do Ưu Việt - G3 Hospital</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
</head>
<body>
    <!-- Header -->
    <jsp:include page="../layouts/header.jsp" />

    <!-- Main Content -->
    <main class="container my-5">
        <!-- Banner Image -->
        <div class="text-center mb-5 fade-in">
            <img src="https://picsum.photos/1200/300" alt="Lý Do Ưu Việt G3 Hospital" class="img-fluid rounded banner-img">
        </div>

        <!-- Lý do 1: Công nghệ Tiên Phong -->
        <section class="mb-5 technology-section fade-in">
            <h2 class="section-title text-center mb-4">CÔNG NGHỆ TIÊN PHONG HÀNG ĐẦU</h2>
            <div class="row align-items-center">
                <div class="col-md-6">
                    <p>G3 Hospital tự hào áp dụng công nghệ tiên tiến nhất trong ngành y tế, từ hệ thống chẩn đoán hình ảnh hiện đại đến các thiết bị điều trị tối tân. Chúng tôi không ngừng cập nhật công nghệ mới để mang lại kết quả chính xác và hiệu quả cao nhất cho bệnh nhân.</p>
                    <p>Với hạ tầng công nghệ vững mạnh, G3 Hospital cam kết dẫn đầu trong việc nâng cao chất lượng chăm sóc sức khỏe tại Việt Nam.</p>
                </div>
                <div class="col-md-6">
                    <img src="https://picsum.photos/500/400" alt="Công nghệ G3 Hospital" class="img-fluid rounded section-img">
                </div>
            </div>
        </section>

        <!-- Lý do 2: Đội Ngũ Thượng Hạng -->
        <section class="mb-5 bg-light-blue elite-team-section fade-in">
            <h2 class="section-title text-center mb-4">ĐỘI NGŨ BÁC SĨ THƯỢNG HẠNG</h2>
            <div class="row">
                <div class="col-md-12">
                    <p>G3 Hospital quy tụ đội ngũ bác sĩ và chuyên gia hàng đầu, được đào tạo bài bản từ các trường y danh tiếng trong và ngoài nước. Với kinh nghiệm phong phú và tâm huyết với nghề, chúng tôi mang đến sự chăm sóc tận tình, chuyên sâu cho từng bệnh nhân.</p>
                    <p>Mỗi bác sĩ tại G3 Hospital là biểu tượng của uy tín và sự tận tâm trong ngành y tế.</p>
                </div>
            </div>
        </section>

        <!-- Lý do 3: Dịch Vụ Tận Tâm -->
        <section class="mb-5 experience-section fade-in">
            <h2 class="section-title text-center mb-4">DỊCH VỤ TẬN TÂM ĐẲNG CẤP</h2>
            <div class="row align-items-center">
                <div class="col-md-6">
                    <p>Tại G3 Hospital, mỗi bệnh nhân được chăm sóc với sự tận tâm và chuyên nghiệp. Từ quy trình khám chữa bệnh mượt mà đến đội ngũ nhân viên hỗ trợ chu đáo, chúng tôi cam kết mang lại trải nghiệm y tế đáng tin cậy và thoải mái.</p>
                    <p>Mọi chi tiết đều được tối ưu để bạn cảm nhận sự khác biệt vượt trội trong từng khoảnh khắc.</p>
                </div>
                <div class="col-md-6">
                    <img src="https://picsum.photos/500/400" alt="Dịch vụ G3 Hospital" class="img-fluid rounded section-img">
                </div>
            </div>
        </section>

        <!-- Lý do 4: Cơ Sở Vật Chất Hiện Đại -->
        <section class="mb-5 bg-light-blue education-section fade-in">
            <h2 class="section-title text-center mb-4">CƠ SỞ VẬT CHẤT HIỆN ĐẠI</h2>
            <div class="row">
                <div class="col-md-12">
                    <p>G3 Hospital sở hữu cơ sở vật chất tiên tiến với phòng khám, phòng phẫu thuật và khu vực điều trị đạt chuẩn quốc tế. Tất cả được thiết kế để tối ưu hóa quá trình chữa trị, mang lại môi trường an toàn và tiện nghi cho bệnh nhân.</p>
                    <p>Chúng tôi không ngừng đầu tư để xây dựng một không gian y tế hàng đầu, xứng tầm với kỳ vọng của bạn.</p>
                </div>
            </div>
        </section>

        <!-- Lý do 5: Cam Kết Chăm Sóc Lâu Dài -->
        <section class="mb-5 sustainability-section fade-in">
            <h2 class="section-title text-center mb-4">CAM KẾT CHĂM SÓC LÂU DÀI</h2>
            <div class="row align-items-center">
                <div class="col-md-6">
                    <p>G3 Hospital cam kết đồng hành cùng bạn trên hành trình sức khỏe suốt đời. Với các chương trình chăm sóc sức khỏe định kỳ và dịch vụ hậu mãi vượt trội, chúng tôi đặt sức khỏe cộng đồng lên hàng đầu.</p>
                    <p>Mỗi bước tiến của chúng tôi là minh chứng cho sứ mệnh bảo vệ và nâng cao chất lượng sống của bạn.</p>
                </div>
                <div class="col-md-6">
                    <img src="https://picsum.photos/500/400" alt="Cam kết G3 Hospital" class="img-fluid rounded section-img">
                </div>
            </div>
        </section>
    </main>

    <!-- Footer -->
    <jsp:include page="../layouts/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/scripts.js"></script>
</body>
</html>