document.addEventListener('DOMContentLoaded', function () {
    // Hiệu ứng fade-in cho content
    const fadeElements = document.querySelectorAll('.content, .login-box');
    fadeElements.forEach((el, index) => {
        el.classList.add('fade-in');
        el.style.animationDelay = `${index * 0.2}s`;
    });

    // Hiệu ứng hover cho nút và liên kết trong sidebar
    const buttons = document.querySelectorAll('.btn-primary, .sidebar a');
    buttons.forEach(button => {
        button.addEventListener('mouseover', () => {
            button.style.transform = 'scale(1.02)';
        });
        button.addEventListener('mouseout', () => {
            button.style.transform = 'scale(1)';
        });
    });

    // Khởi tạo carousel banner nếu tồn tại
    if (typeof bootstrap !== 'undefined' && bootstrap.Carousel) {
        console.log('Initializing carousel banner...');
        var bannerEl = document.getElementById('carouselBanner');
        if (bannerEl) {
            var carouselBanner = new bootstrap.Carousel(bannerEl, {
                interval: 3000,
                ride: 'carousel'
            });
            console.log('Carousel banner initialized.');
        } else {
            console.warn('#carouselBanner not found.');
        }

        console.log('Initializing doctor carousel...');
        var doctorEl = document.getElementById('doctorCarousel');
        if (doctorEl) {
            var doctorCarousel = new bootstrap.Carousel(doctorEl, {
                interval: 3000,
                ride: 'carousel'
            });
            console.log('Doctor carousel initialized.');
        } else {
            console.warn('#doctorCarousel not found.');
        }
    } else {
        console.warn('Bootstrap JS is not loaded properly.');
    }

    // Khởi tạo bản đồ OpenStreetMap với Leaflet nếu tồn tại
    if (typeof L !== 'undefined' && document.getElementById('map')) {
        console.log('Initializing map...');
        var map = L.map('map').setView([21.0134, 105.5265], 15);
        console.log('Map view set.');

        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            maxZoom: 19,
            attribution: '© <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
        }).addTo(map);
        console.log('Tile layer added to map.');

        var marker = L.marker([21.0134, 105.5265]).addTo(map);
        console.log('Marker added to map.');

        marker.on('click', function () {
            console.log('Marker clicked.');
            var lat = 21.0134;
            var lng = 105.5265;
            var label = encodeURIComponent('Đại học FPT, Khu Công nghệ cao Hòa Lạc, Thạch Thất, Hà Nội');
            var url = `geo:${lat},${lng}?q=${lat},${lng}(${label})`;
            window.location.href = url;
            setTimeout(function () {
                console.log('Opening fallback map URL...');
                window.open(`https://www.openstreetmap.org/?mlat=${lat}&mlon=${lng}#map=15/${lat}/${lng}`, '_blank');
            }, 500);
        });
    } else {
        console.warn('Leaflet JS is not loaded properly or map element not found.');
    }

    // Logic cho trang appointments.jsp
    if (document.getElementById('calendar')) {
        console.log('Initializing appointments page...');
        var calendarEl = document.getElementById('calendar');
        if (!calendarEl) {
            console.error('Calendar element not found!');
            return;
        }
        console.log('Calendar element found, initializing FullCalendar...');
        var calendar = new FullCalendar.Calendar(calendarEl, {
            initialView: 'dayGridMonth',
            events: [
                {
                    id: '1',
                    title: 'Hẹn với ThS.BSCKI Trịnh Minh Thanh',
                    start: '2025-05-27T10:00:00',
                    className: 'fc-event-pending'
                },
                {
                    id: '2',
                    title: 'Hẹn với ThS.BS Nguyễn Văn Hải',
                    start: '2025-05-28T14:00:00',
                    className: 'fc-event-completed'
                }
            ],
            eventClick: function (info) {
                console.log('Event clicked:', info.event.id);
                alert(
                    'Chi tiết lịch hẹn:\nID: ' +
                    info.event.id +
                    '\nTên: ' +
                    info.event.title +
                    '\nThời gian: ' +
                    info.event.start.toLocaleString()
                );
            }
        });
        calendar.render();
        console.log('FullCalendar rendered.');

        var appointmentList = document.getElementById('appointmentList');
        if (!appointmentList) {
            console.error('Appointment list element not found!');
            return;
        }
        console.log('Appointment list element found, populating data...');
        const appointments = [
            {
                id: '1',
                datetime: '27/05/2025 10:00',
                doctor: 'ThS.BSCKI Trịnh Minh Thanh',
                patient: 'Nguyễn Văn A',
                status: 'Đang chờ'
            },
            {
                id: '2',
                datetime: '28/05/2025 14:00',
                doctor: 'ThS.BS Nguyễn Văn Hải',
                patient: 'Trần Thị B',
                status: 'Hoàn thành'
            }
        ];
        appointments.forEach(appt => {
            const row = document.createElement('tr');
            row.innerHTML = `
                <td>${appt.id}</td>
                <td>${appt.datetime}</td>
                <td>${appt.doctor}</td>
                <td>${appt.patient}</td>
                <td>${appt.status}</td>
                <td>
                    <button class="btn btn-sm btn-primary" onclick="viewDetails('${appt.id}')">Xem</button>
                    <button class="btn btn-sm btn-danger" onclick="cancelAppointment('${appt.id}')">Hủy</button>
                </td>
            `;
            appointmentList.appendChild(row);
        });
        console.log('Appointment data populated.');

        document.getElementById('filterDate').addEventListener('change', filterAppointments);
        document.getElementById('filterDoctor').addEventListener('change', filterAppointments);
        document.getElementById('filterStatus').addEventListener('change', filterAppointments);
        document.getElementById('search').addEventListener('input', filterAppointments);
        console.log('Filter event listeners attached.');

        const syncBtn = document.getElementById('syncCalendarBtn');
        if (syncBtn) {
            syncBtn.addEventListener('click', syncWithExternalCalendar);
            console.log('Sync button event listener attached.');
        } else {
            console.error('Sync button not found!');
        }
    }

    // Logic cho form đặt lịch (index.jsp)
    if (document.getElementById('bookingForm')) {
        console.log('Initializing booking form...');
        const bookingForm = document.getElementById('bookingForm');
        bookingForm.addEventListener('submit', function (e) {
            e.preventDefault();
            console.log('Form submitted:', this.elements);
            alert('Đặt lịch thành công! Chúng tôi sẽ liên hệ để xác nhận.');
            this.reset();
            bootstrap.Modal.getInstance(document.getElementById('bookingModal')).hide();
        });
        console.log('Booking form event listener attached.');
    }
    if (document.getElementById('filterButton')) {
        document.getElementById('filterButton').addEventListener('click', filterAppointments);
    }
    
    // Logic cho form góp ý
    if (document.querySelector('form[action="feedback"]')) {
        console.log('Initializing feedback form...');
        const feedbackForm = document.querySelector('form[action="feedback"]');
        feedbackForm.addEventListener('submit', function (e) {
            e.preventDefault();
            console.log('Feedback submitted:', this.elements);
            alert('Cảm ơn bạn đã góp ý! Chúng tôi sẽ xem xét và phản hồi sớm nhất.');
            this.reset();
            bootstrap.Modal.getInstance(document.getElementById('feedbackModal')).hide();
        });
        console.log('Feedback form event listener attached.');
    }
});

function removeDiacritics(str) {
    return str.normalize("NFD").replace(/[\u0300-\u036f]/g, "").toLowerCase();
}

function filterAppointments() {
    const dateFilter = (document.getElementById('filterDate')?.value || '').trim();
    const doctorFilter = removeDiacritics(document.getElementById('filterDoctor')?.value || '').trim();
    const statusFilter = removeDiacritics(document.getElementById('filterStatus')?.value || '').trim();
    const searchText = removeDiacritics(document.getElementById('search')?.value || '').trim();

    const rows = document.querySelectorAll('#appointmentList tr');

    rows.forEach(row => {
        const cells = row.querySelectorAll('td');
        if (cells.length < 5) return;

        const datetime = cells[1].textContent.trim();
        const doctor = removeDiacritics(cells[2].textContent.trim());
        const patient = removeDiacritics(cells[3].textContent.trim());
        const status = removeDiacritics(cells[4].textContent.trim());

        const matchesDate = !dateFilter || datetime.includes(dateFilter);
        const matchesDoctor = !doctorFilter || doctor.includes(doctorFilter);
        const matchesStatus = !statusFilter || status.includes(statusFilter);
        const matchesSearch = !searchText || patient.includes(searchText) || doctor.includes(searchText);

        row.style.display = (matchesDate && matchesDoctor && matchesStatus && matchesSearch) ? '' : 'none';
    });
}

function viewDetails(id) {
    console.log('Viewing details for appointment ID:', id);
    alert('Xem chi tiết lịch hẹn ID: ' + id);
}

function cancelAppointment(id) {
    console.log('Canceling appointment ID:', id);
    if (confirm('Bạn có chắc muốn hủy lịch hẹn ID: ' + id + '?')) {
        alert('Đã hủy lịch hẹn ID: ' + id);
    }
}

function syncWithExternalCalendar() {
    console.log('Syncing with external calendar...');
    alert('Đồng bộ với lịch ngoài: Tính năng này sẽ tích hợp với Google Calendar hoặc Outlook.');
}