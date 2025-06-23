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
        marker.bindPopup('Đại học FPT, Khu Công nghệ cao Hòa Lạc, Thạch Thất, Hà Nội');
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
                                title: `Hẹn với ${appt.doctor && appt.doctor.user ? appt.doctor.user.fullName : ''} (${appt.patient && appt.patient.user ? appt.patient.user.fullName : ''})`,
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
                    // Lấy tên bác sĩ và bệnh nhân từ event object (nếu có)
                    const event = info.event;
                    // Tìm lại dữ liệu gốc từ data nếu cần
                    let doctorName = '';
                    let patientName = '';
                    if (event.extendedProps && event.extendedProps.doctor && event.extendedProps.doctor.user) {
                        doctorName = event.extendedProps.doctor.user.fullName;
                    }
                    if (event.extendedProps && event.extendedProps.patient && event.extendedProps.patient.user) {
                        patientName = event.extendedProps.patient.user.fullName;
                    }
                    // Nếu không có thì fallback lấy từ title
                    if (!doctorName || !patientName) {
                        const match = event.title.match(/Hẹn với (.*?) \((.*?)\)/);
                        if (match) {
                            doctorName = match[1];
                            patientName = match[2];
                        }
                    }
                    alert(`Chi tiết lịch hẹn:\nID: ${event.id}\nBác sĩ: ${doctorName}\nBệnh nhân: ${patientName}\nThời gian: ${event.start.toLocaleString('vi-VN')}`);
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
                            // Thêm log kiểm tra dữ liệu
                            console.log('Doctor:', appt.doctor, 'Patient:', appt.patient);
                            row.innerHTML = `
                                <td>${appt.id}</td>
                                <td>${new Date(appt.dateTime).toLocaleString('vi-VN')}</td>
                                <td>${appt.doctor && appt.doctor.user && typeof appt.doctor.user.fullName === 'string' ? appt.doctor.user.fullName : JSON.stringify(appt.doctor)}</td>
                                <td>${appt.patient && appt.patient.user && typeof appt.patient.user.fullName === 'string' ? appt.patient.user.fullName : JSON.stringify(appt.patient)}</td>
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

//    // Form đặt lịch
//    if (document.getElementById('bookingForm')) {
//        const bookingForm = document.getElementById('bookingForm');
//        bookingForm.addEventListener('submit', function (e) {
//            e.preventDefault();
//            alert('Đặt lịch thành công! Chúng tôi sẽ liên hệ để xác nhận.');
//            this.reset();
//            bootstrap.Modal.getInstance(document.getElementById('bookingModal')).hide();
//        });
//    }

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

    // Contact form validation
    const contactForm = document.getElementById('contactForm');
    if (contactForm) {
        contactForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Validate form
            const name = document.getElementById('name').value.trim();
            const email = document.getElementById('email').value.trim();
            const phone = document.getElementById('phone').value.trim();
            const subject = document.getElementById('subject').value;
            const message = document.getElementById('message').value.trim();
            
            // Kiểm tra tên
            if (name.length < 2) {
                showAlert('Vui lòng nhập họ tên hợp lệ', 'danger');
                return;
            }
            
            // Kiểm tra email
            const emailRegex = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;
            if (!emailRegex.test(email)) {
                showAlert('Vui lòng nhập email hợp lệ', 'danger');
                return;
            }
            
            // Kiểm tra số điện thoại
            const phoneRegex = /^[0-9]{10,15}$/;
            if (!phoneRegex.test(phone)) {
                showAlert('Vui lòng nhập số điện thoại hợp lệ (10-15 số)', 'danger');
                return;
            }
            
            // Kiểm tra mục đích liên hệ
            if (!subject) {
                showAlert('Vui lòng chọn mục đích liên hệ', 'danger');
                return;
            }
            
            // Kiểm tra nội dung
            if (message.length < 10) {
                showAlert('Vui lòng nhập nội dung ít nhất 10 ký tự', 'danger');
                return;
            }
            
            // Hiển thị thông báo đang xử lý
            showAlert('Đang gửi tin nhắn...', 'info');
            
            // Gửi form
            this.submit();
        });
    }

    // Register form validation
    const registerForm = document.querySelector('form[action="register"]');
    if (registerForm) {
        registerForm.addEventListener('submit', function(e) {
            const email = this.querySelector('input[name="email"]').value;
            const phone = this.querySelector('input[name="phone"]').value;
            
            if (!validateEmail(email)) {
                e.preventDefault();
                alert('Vui lòng nhập email hợp lệ');
                return;
            }
            
            if (!validatePhone(phone)) {
                e.preventDefault();
                alert('Vui lòng nhập số điện thoại hợp lệ (10-15 số)');
                return;
            }
        });
    }

    // Doctor/Patient form validation
    const doctorForm = document.querySelector('form[action*="doctor"]');
    const patientForm = document.querySelector('form[action*="patient"]');
    
    [doctorForm, patientForm].forEach(form => {
        if (form) {
            form.addEventListener('submit', function(e) {
                const email = this.querySelector('input[name="email"]')?.value;
                const phone = this.querySelector('input[name="phone"]')?.value;
                
                if (email && !validateEmail(email)) {
                    e.preventDefault();
                    alert('Vui lòng nhập email hợp lệ');
                    return;
                }
                
                if (phone && !validatePhone(phone)) {
                    e.preventDefault();
                    alert('Vui lòng nhập số điện thoại hợp lệ (10-15 số)');
                    return;
                }
            });
        }
    });
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

// Validation functions
function validateEmail(email) {
    const regex = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;
    return regex.test(email);
}

function validatePhone(phone) {
    const regex = /^[0-9]{10,15}$/;
    return regex.test(phone);
}

// Hàm hiển thị thông báo
function showAlert(message, type = 'success') {
    // Xóa thông báo cũ nếu có
    const existingAlert = document.querySelector('.alert');
    if (existingAlert) {
        existingAlert.remove();
    }
    
    // Tạo thông báo mới
    const alertDiv = document.createElement('div');
    alertDiv.className = `alert alert-${type} alert-dismissible fade show`;
    alertDiv.role = 'alert';
    alertDiv.innerHTML = `
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    `;
    
    // Thêm vào form
    const form = document.getElementById('contactForm');
    form.insertBefore(alertDiv, form.firstChild);
    
    // Tự động ẩn sau 5 giây nếu là thông báo thành công
    if (type === 'success') {
        setTimeout(() => {
            alertDiv.remove();
        }, 5000);
    }
}

// Xử lý thông báo chuyển hướng
document.addEventListener('DOMContentLoaded', function() {
    const urlParams = new URLSearchParams(window.location.search);
    const status = urlParams.get('status');
    
    if (status === 'success') {
        showAlert('Cảm ơn bạn đã liên hệ! Chúng tôi sẽ phản hồi sớm nhất có thể.', 'success');
    } else if (status === 'error') {
        showAlert('Có lỗi xảy ra! Vui lòng thử lại sau.', 'danger');
    }
});