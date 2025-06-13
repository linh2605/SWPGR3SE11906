<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<html lang="vi">
<head>
    <title>Giới thiệu - G3 Hospital</title>
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
            <img src="https://picsum.photos/1200/300" alt="G3 Hospital Introduction" class="img-fluid rounded banner-img">
        </div>

        <!-- Giới thiệu chung -->
        <section class="mb-5 introduction-section fade-in">
            <h2 class="section-title text-center mb-4">GIỚI THIỆU VỀ G3 HOSPITAL</h2>
            <div class="row align-items-center">
                <div class="col-md-6">
                    <p>Thành lập vào năm 2025, G3 Hospital là một dự án học tập tiên phong trong mô hình "bệnh viện số hóa" tại Việt Nam. Với sứ mệnh mang đến trải nghiệm y tế ảo chất lượng cao, chúng tôi tập trung vào việc mô phỏng các quy trình khám chữa bệnh hiện đại, kết hợp công nghệ và giáo dục để phục vụ cộng đồng học thuật.</p>
                    <p>G3 Hospital không chỉ là một nền tảng học tập mà còn là nơi thể hiện sự sáng tạo và đam mê của đội ngũ sinh viên, hướng tới tương lai của ngành y tế số hóa.</p>
                </div>
                <div class="col-md-6">
                    <img src="https://picsum.photos/500/400" alt="G3 Hospital Facility" class="img-fluid rounded section-img">
                </div>
            </div>
        </section>

        <!-- Lịch sử hình thành -->
        <section class="mb-5 bg-light-blue history-section fade-in">
            <h2 class="section-title text-center mb-4">LỊCH SỬ HÌNH THÀNH</h2>
            <div class="row">
                <div class="col-md-12">
                    <p>Bắt đầu từ một ý tưởng của nhóm sinh viên đam mê công nghệ y tế, G3 Hospital được xây dựng với hơn 50 giao diện và tính năng mô phỏng. Từ năm 2023, dự án đã phát triển mạnh mẽ, thu hút sự quan tâm từ các trường đại học và tổ chức giáo dục, trở thành một nền tảng học tập độc đáo trong lĩnh vực y tế ảo.</p>
                    <p>Chúng tôi tự hào là nơi tiên phong trong việc ứng dụng công nghệ số hóa vào giáo dục y khoa tại Việt Nam.</p>
                </div>
            </div>
        </section>

        <!-- Đội ngũ y bác sĩ -->
        <section class="mb-5 team-section fade-in">
            <h2 class="section-title text-center mb-4">ĐỘI NGŨ Y BÁC SĨ</h2>
            <div class="row align-items-center">
                <div class="col-md-6">
                    <p>Đội ngũ G3 Hospital bao gồm 5 thành viên xuất sắc, được đào tạo từ các trường đại học hàng đầu tại Việt Nam. Mỗi thành viên đóng góp chuyên môn riêng, từ lập trình đến thiết kế giao diện, đảm bảo chất lượng vượt trội trong việc mô phỏng các quy trình y tế.</p>
                    <p>Các "bác sĩ ảo" được thiết kế dựa trên mô hình thực tế, mang lại trải nghiệm chân thực cho người học.</p>
                </div>
                <div class="col-md-6">
                    <img src="https://picsum.photos/500/400" alt="G3 Hospital Doctors" class="img-fluid rounded section-img">
                </div>
            </div>
        </section>

        <!-- Cơ sở vật chất -->
        <section class="mb-5 bg-light-blue facilities-section fade-in">
            <h2 class="section-title text-center mb-4">CƠ SỞ VẬT CHẤT</h2>
            <div class="row">
                <div class="col-md-12">
                    <p>Hệ thống G3 Hospital được tích hợp công nghệ tối tân và các công cụ hiện đại, cho phép người dùng trải nghiệm như trong một bệnh viện chuyên nghiệp. Chúng tôi sử dụng các mô hình ảo để tái hiện cơ sở vật chất, từ phòng khám đến phòng phẫu thuật, hướng tới việc bổ sung thêm tính năng AI trong tương lai.</p>
                </div>
            </div>
        </section>

        <!-- Hợp tác quốc tế -->
        <section class="mb-5 cooperation-section fade-in">
            <h2 class="section-title text-center mb-4">HỢP TÁC QUỐC TẾ</h2>
            <div class="row align-items-center">
                <div class="col-md-6">
                    <p>G3 Hospital hợp tác với các nhóm học thuật trong nước để phát triển thêm tính năng và mở rộng quy mô dự án. Dù là một mô hình ảo, chúng tôi hướng tới việc kết nối với các tổ chức giáo dục quốc tế trong tương lai, mang lại giá trị học thuật vượt trội.</p>
                </div>
                <div class="col-md-6">
                    <img src="https://picsum.photos/500/400" alt="G3 Hospital International" class="img-fluid rounded section-img">
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