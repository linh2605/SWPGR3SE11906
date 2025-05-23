document.addEventListener('DOMContentLoaded', function () {
    // Kiểm tra và khởi tạo carousel banner
    if (typeof bootstrap !== 'undefined' && bootstrap.Carousel) {
        var carouselBanner = new bootstrap.Carousel(document.getElementById('carouselBanner'), {
            interval: 3000,
            ride: 'carousel'
        });

        var doctorCarousel = new bootstrap.Carousel(document.getElementById('doctorCarousel'), {
            interval: 3000,
            ride: 'carousel'
        });
    } else {
        console.warn('Bootstrap JS is not loaded properly.');
    }

    // Khởi tạo bản đồ OpenStreetMap với Leaflet
    if (typeof L !== 'undefined' && document.getElementById('map')) {
        // Khởi tạo bản đồ
        var map = L.map('map').setView([21.0134, 105.5265], 15); // Tọa độ Đại học FPT Hòa Lạc

        // Thêm tile layer từ OpenStreetMap
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            maxZoom: 19,
            attribution: '© <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
        }).addTo(map);

        // Thêm marker tại Đại học FPT
        var marker = L.marker([21.0134, 105.5265]).addTo(map);

        // Khi nhấp vào marker, mở ứng dụng bản đồ
        marker.on('click', function() {
            var lat = 21.0134;
            var lng = 105.5265;
            var label = encodeURIComponent('Đại học FPT, Khu Công nghệ cao Hòa Lạc, Thạch Thất, Hà Nội');

            // Tạo URL để mở ứng dụng bản đồ
            var url = `geo:${lat},${lng}?q=${lat},${lng}(${label})`;

            // Thử mở URL, thiết bị sẽ tự chọn ứng dụng bản đồ mặc định
            window.location.href = url;

            // Dự phòng: Nếu không mở được ứng dụng, mở OpenStreetMap trên trình duyệt
            setTimeout(function() {
                window.open(`https://www.openstreetmap.org/?mlat=${lat}&mlon=${lng}#map=15/${lat}/${lng}`, '_blank');
            }, 500);
        });
    } else {
        console.warn('Leaflet JS is not loaded properly or map element not found.');
    }
});