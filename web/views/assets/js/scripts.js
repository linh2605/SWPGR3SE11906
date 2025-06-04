// Đặt biến toàn cục để sử dụng ở nhiều nơi
let calendar;

// Lấy role_id và contextPath từ server (phải được gán trong .jsp)
const roleId = window.roleId || null;
const contextPath = window.contextPath || '';

document.addEventListener('DOMContentLoaded', function () {
    // Kiểm tra trạng thái đăng nhập
    checkLoginStatus();

    // Hiệu ứng fade-in
    const fadeElements = document.querySelectorAll('.content, .login-box');
    fadeElements.forEach((el, index) => {
        el.classList.add('fade-in');
        el.style.animationDelay = `${index * 0.2}s`;
    });

    // Hiệu ứng hover cho nút và sidebar
    const buttons = document.querySelectorAll('.btn-primary, .sidebar a');
    buttons.forEach(button => {
        button.addEventListener('mouseover', () => button.style.transform = 'scale(1.02)');
        button.addEventListener('mouseout', () => button.style.transform = 'scale(1)');
    });

    // Khởi tạo carousel
    if (typeof bootstrap !== 'undefined' && bootstrap.Carousel) {
        const bannerEl = document.getElementById('carouselBanner');
        if (bannerEl) new bootstrap.Carousel(bannerEl, { interval: 3000, ride: 'carousel' });

        const doctorEl = document.getElementById('doctorCarousel');
        if (doctorEl) new bootstrap.Carousel(doctorEl, { interval: 3000, ride: 'carousel' });
    }

    // Khởi tạo bản đồ OpenStreetMap
    if (typeof L !== 'undefined' && document.getElementById('map')) {
        const map = L.map('map').setView([21.0134, 105.5265], 15);
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            maxZoom: 19,
            attribution: '© OpenStreetMap contributors'
        }).addTo(map);

        const marker = L.marker([21.0134, 105.5265]).addTo(map);
        marker.on('click', function () {
            const lat = 21.0134, lng = 105.5265;
            const label = encodeURIComponent('Đại học FPT, Khu Công nghệ cao Hòa Lạc, Thạch Thất, Hà Nội');
            const url = `geo:${lat},${lng}?q=${lat},${lng}(${label})`;
            window.location.href = url;
            setTimeout(() => {
                window.open(`https://www.openstreetmap.org/?mlat=${lat}&mlon=${lng}#map=15/${lat}/${lng}`, '_blank');
            }, 500);
        });
    }

    // Logic cho các trang dashboard
    ['appointments', 'doctorDashboard', 'receptionistDashboard'].forEach(pageId => {
        if (document.getElementById('calendar') && document.getElementById(pageId)) {
            const calendarEl = document.getElementById('calendar');
            calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: 'dayGridMonth',
                events: function(fetchInfo, successCallback, failureCallback) {
                    let url = '';
                    if (pageId === 'appointments') url = `${contextPath}/getAppointments`;
                    else if (pageId === 'doctorDashboard') url = `${contextPath}/getDoctorAppointments`;
                    else if (pageId === 'receptionistDashboard') url = `${contextPath}/getAllAppointments`;

                    $.ajax({
                        url: url,
                        method: 'GET',
                        dataType: 'json',
                        success: function(data) {
                            const events = data.map(appt => ({
                                id: appt.id,
                                title: `Hẹn với ${appt.doctor} (${appt.patient})`,
                                start: appt.dateTime,
                                className: 'fc-event-' + appt.status
                            }));
                            successCallback(events);
                        },
                        error: function(xhr, status, error) {
                            console.error(`Error fetching ${pageId} appointments:`, error);
                            failureCallback(error);
                        }
                    });
                },
                eventClick: function(info) {
                    alert(`Chi tiết lịch hẹn:\nID: ${info.event.id}\nTên: ${info.event.title}\nThời gian: ${info.event.start.toLocaleString('vi-VN')}`);
                }
            });
            calendar.render();

            // Điền bộ lọc
            populateFilters(pageId);
        }

        const appointmentList = document.getElementById('appointmentList');
        if (appointmentList && document.getElementById(pageId)) {
            function loadAppointments() {
                let url = '';
                if (pageId === 'appointments') url = `${contextPath}/getAppointments`;
                else if (pageId === 'doctorDashboard') url = `${contextPath}/getDoctorAppointments`;
                else if (pageId === 'receptionistDashboard') url = `${contextPath}/getAllAppointments`;

                $.ajax({
                    url: url,
                    method: 'GET',
                    dataType: 'json',
                    success: function(data) {
                        appointmentList.innerHTML = '';
                        data.forEach(appt => {
                            const row = document.createElement('tr');
                            let actions = `<button class="btn btn-sm btn-primary" onclick="viewDetails('${appt.id}')">Xem</button>`;
                            if (pageId === 'receptionistDashboard') {
                                if (appt.status === 'pending') {
                                    actions += `
                                        <button class="btn btn-sm btn-success" onclick="updateStatus('${appt.id}', 'completed')">Hoàn thành</button>
                                        <button class="btn btn-sm btn-danger" onclick="updateStatus('${appt.id}', 'canceled')">Hủy</button>
                                    `;
                                } else {
                                    actions += `
                                        <button class="btn btn-sm btn-success" disabled>Hoàn thành</button>
                                        <button class="btn btn-sm btn-danger" disabled>Hủy</button>
                                    `;
                                }
                            }
                            row.innerHTML = `
                                <td>${appt.id}</td>
                                <td>${new Date(appt.dateTime).toLocaleString('vi-VN')}</td>
                                <td>${appt.doctor}</td>
                                <td>${appt.patient}</td>
                                <td>${appt.status === 'pending' ? 'Đang chờ' : appt.status === 'completed' ? 'Hoàn thành' : 'Đã hủy'}</td>
                                <td>${actions}</td>
                            `;
                            appointmentList.appendChild(row);
                        });
                    },
                    error: function(xhr, status, error) {
                        console.error(`Error loading ${pageId} appointments:`, error);
                    }
                });
            }

            loadAppointments();

            document.getElementById('filterDate')?.addEventListener('change', filterAppointments);
            document.getElementById('filterDoctor')?.addEventListener('change', filterAppointments);
            document.getElementById('filterPatient')?.addEventListener('change', filterAppointments);
            document.getElementById('filterStatus')?.addEventListener('change', filterAppointments);
            document.getElementById('search')?.addEventListener('input', filterAppointments);
            document.getElementById('filterButton')?.addEventListener('click', filterAppointments);
            document.getElementById('syncCalendarBtn')?.addEventListener('click', syncWithExternalCalendar);
        }
    });

    // Form đặt lịch
    if (document.getElementById('bookingForm')) {
        const bookingForm = document.getElementById('bookingForm');
        bookingForm.addEventListener('submit', function (e) {
            e.preventDefault();
            alert('Đặt lịch thành công! Chúng tôi sẽ liên hệ để xác nhận.');
            this.reset();
            bootstrap.Modal.getInstance(document.getElementById('bookingModal')).hide();
        });
    }

    // Form góp ý
    const feedbackForm = document.querySelector('form[action="feedback"]');
    if (feedbackForm) {
        feedbackForm.addEventListener('submit', function (e) {
            e.preventDefault();
            alert('Cảm ơn bạn đã góp ý! Chúng tôi sẽ xem xét và phản hồi sớm nhất.');
            this.reset();
            bootstrap.Modal.getInstance(document.getElementById('feedbackModal')).hide();
        });
    }
});

// Điền dữ liệu cho bộ lọc
function populateFilters(pageId) {
    let url = '';
    if (pageId === 'appointments') url = `${contextPath}/getAppointments`;
    else if (pageId === 'doctorDashboard') url = `${contextPath}/getDoctorAppointments`;
    else if (pageId === 'receptionistDashboard') url = `${contextPath}/getAllAppointments`;

    $.ajax({
        url: url,
        method: 'GET',
        dataType: 'json',
        success: function(data) {
            const dates = new Set();
            const doctors = new Set();
            const patients = new Set();

            data.forEach(appt => {
                const date = new Date(appt.dateTime).toLocaleDateString('vi-VN');
                dates.add(date);
                doctors.add(appt.doctor);
                patients.add(appt.patient);
            });

            const filterDate = document.getElementById('filterDate');
            if (filterDate) {
                filterDate.innerHTML = '<option value="">Tất cả</option>';
                dates.forEach(date => {
                    filterDate.innerHTML += `<option value="${date}">${date}</option>`;
                });
            }

            const filterDoctor = document.getElementById('filterDoctor');
            if (filterDoctor) {
                filterDoctor.innerHTML = '<option value="">Tất cả</option>';
                doctors.forEach(doctor => {
                    filterDoctor.innerHTML += `<option value="${doctor}">${doctor}</option>`;
                });
            }

            const filterPatient = document.getElementById('filterPatient');
            if (filterPatient) {
                filterPatient.innerHTML = '<option value="">Tất cả</option>';
                patients.forEach(patient => {
                    filterPatient.innerHTML += `<option value="${patient}">${patient}</option>`;
                });
            }
        }
    });
}

// Utilities
function removeDiacritics(str) {
    return str.normalize("NFD").replace(/[\u0300-\u036f]/g, "").toLowerCase();
}

function filterAppointments() {
    const dateFilter = (document.getElementById('filterDate')?.value || '').trim();
    const doctorFilter = removeDiacritics(document.getElementById('filterDoctor')?.value || document.getElementById('filterPatient')?.value || '').trim();
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
        const matchesDoctor = !doctorFilter || doctor.includes(doctorFilter) || patient.includes(doctorFilter);
        const matchesStatus = !statusFilter || status.includes(statusFilter);
        const matchesSearch = !searchText || patient.includes(searchText) || doctor.includes(searchText);

        row.style.display = (matchesDate && matchesDoctor && matchesStatus && matchesSearch) ? '' : 'none';
    });
}

function viewDetails(id) {
    alert('Xem chi tiết lịch hẹn ID: ' + id);
}

function syncWithExternalCalendar() {
    if (!calendar) return alert('Lịch chưa được tải.');
    const events = calendar.getEvents().map(event => ({
        title: event.title,
        start: event.start.toISOString(),
        end: event.end ? event.end.toISOString() : null
    }));
    const googleCalendarUrl = 'https://www.google.com/calendar/render';
    const eventData = encodeURIComponent(JSON.stringify(events));
    window.open(`${googleCalendarUrl}?action=TEMPLATE&text=Appointments&dates=${events[0].start}/${events[0].end || events[0].start}&details=${eventData}`, '_blank');
    alert('Đồng bộ với Google Calendar. Vui lòng kiểm tra và lưu thủ công.');
}

function updateStatus(id, status) {
    if (roleId != 3) {
        alert('Bạn không có quyền cập nhật trạng thái!');
        return;
    }

    const statusText = status === 'completed' ? 'Hoàn thành' : 'Hủy';
    const confirmMessage = `Bạn có chắc chắn muốn ${statusText.toLowerCase()} lịch hẹn này không?`;
    
    if (confirm(confirmMessage)) {
        $.ajax({
            url: `${contextPath}/update-appointment-status`,
            method: 'POST',
            data: { appointmentId: id, status: status },
            success: function() {
                alert(`Đã ${statusText.toLowerCase()} lịch hẹn thành công!`);
                location.reload();
            },
            error: function(xhr, status, error) {
                alert(`Lỗi khi cập nhật trạng thái: ${error}`);
            }
        });
    }
}

// Initialize WebSocket connection
const ws = new WebSocket('ws://' + window.location.host + '/websocket');

ws.onmessage = function(event) {
    const data = JSON.parse(event.data);
    if (data.type === 'appointment_update') {
        // Update appointment status in UI
        const appointmentRow = document.querySelector(`tr[data-appointment-id="${data.appointmentId}"]`);
        if (appointmentRow) {
            const statusCell = appointmentRow.querySelector('.status-cell');
            if (statusCell) {
                statusCell.textContent = data.status;
                // Update status class for styling
                statusCell.className = 'status-cell ' + data.status.toLowerCase();
            }
        }
        
        // Show notification
        showNotification(`Appointment #${data.appointmentId} has been ${data.status}`);
    }
};

function showNotification(message) {
    const notification = document.createElement('div');
    notification.className = 'notification';
    notification.textContent = message;
    
    document.body.appendChild(notification);
    
    // Remove notification after 5 seconds
    setTimeout(() => {
        notification.remove();
    }, 5000);
}

// Hàm kiểm tra trạng thái đăng nhập
function checkLoginStatus() {
    const userDropdown = document.querySelector('.dropdown');
    const loginButton = document.querySelector('.btn-outline-primary');
    
    if (userDropdown && loginButton) {
        // Nếu có user trong session
        if (window.user) {
            userDropdown.style.display = 'block';
            loginButton.style.display = 'none';
            
            // Cập nhật tên user
            const userNameSpan = userDropdown.querySelector('.text-dark');
            if (userNameSpan) {
                userNameSpan.textContent = window.user.fullName || window.user.username;
            }
            
            // Cập nhật avatar nếu có
            const userAvatar = userDropdown.querySelector('img');
            if (userAvatar && window.user.avatar) {
                userAvatar.src = window.user.avatar;
            }
        } else {
            userDropdown.style.display = 'none';
            loginButton.style.display = 'block';
        }
    }
}