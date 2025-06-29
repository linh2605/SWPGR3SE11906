// Global context path
window.contextPath = window.contextPath || '';

// Đặt biến toàn cục để sử dụng ở nhiều nơi
let calendar;

// Lấy role_id và contextPath từ server (phải được gán trong .jsp)
const roleId = window.roleId || null;

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
            document.getElementById('filterDate')?.addEventListener('change', filterAppointments);
            document.getElementById('filterDoctor')?.addEventListener('change', filterAppointments);
            document.getElementById('filterPatient')?.addEventListener('change', filterAppointments);
            document.getElementById('filterStatus')?.addEventListener('change', filterAppointments);
            document.getElementById('search')?.addEventListener('input', filterAppointments);
            document.getElementById('filterButton')?.addEventListener('click', filterAppointments);
            document.getElementById('syncCalendarBtn')?.addEventListener('click', syncWithExternalCalendar);
        }
    });

    // --- Đặt lịch khám: Logic cho trang make-appointment.jsp ---
    const bookingForm = document.getElementById('bookingForm');
    if (bookingForm) {
        const serviceSelect = document.getElementById('service');
        const appointmentDateInput = document.getElementById('appointmentDate');
        const shiftSelect = document.getElementById('shift');
        const doctorRow = document.getElementById('doctorRow');
        const doctorSelect = document.getElementById('doctor');
        const priceDisplay = document.getElementById('priceDisplay');
        const servicePrice = document.getElementById('servicePrice');

        function loadDoctors() {
            const serviceId = serviceSelect.value;
            const date = appointmentDateInput.value;
            const shiftId = shiftSelect.value;
            if (!serviceId || !date || !shiftId) {
                doctorRow.style.display = 'none';
                doctorSelect.innerHTML = '<option value="" disabled selected>Chọn bác sĩ</option>';
                return;
            }
            fetch(`${contextPath}/getDoctorsByServiceAndDate?serviceId=${serviceId}&date=${encodeURIComponent(date)}&shiftId=${shiftId}`)
                .then(res => {
                    if (!res.ok) throw new Error('Network response was not ok');
                    return res.json();
                })
                .then(doctors => {
                    doctorSelect.innerHTML = '<option value="" disabled selected>Chọn bác sĩ</option>';
                    if (doctors && doctors.length > 0) {
                        doctors.forEach(d => {
                            let name = d.user && d.user.fullName ? d.user.fullName : d.fullName;
                            let degree = d.degree ? d.degree : '';
                            let specialty = d.specialty && d.specialty.name ? d.specialty.name : '';
                            doctorSelect.innerHTML += `<option value="${d.doctor_id}">${specialty} - ${degree} ${name}</option>`;
                        });
                        doctorRow.style.display = '';
                    } else {
                        doctorSelect.innerHTML = '<option value="" disabled selected>Không có bác sĩ phù hợp</option>';
                        doctorRow.style.display = '';
                    }
                })
                .catch(error => {
                    console.error('Error loading doctors:', error);
                    doctorSelect.innerHTML = '<option value="" disabled selected>Lỗi tải bác sĩ</option>';
                    doctorRow.style.display = '';
                });
        }

        serviceSelect.addEventListener('change', function() {
            const price = this.options[this.selectedIndex].getAttribute('data-price');
            if (price && price !== 'null') {
                servicePrice.textContent = new Intl.NumberFormat('vi-VN').format(price);
                priceDisplay.style.display = 'block';
            } else {
                priceDisplay.style.display = 'none';
            }
            loadDoctors();
        });
        appointmentDateInput.addEventListener('change', loadDoctors);
        shiftSelect.addEventListener('change', loadDoctors);

        bookingForm.addEventListener('submit', function(e) {
            const service = serviceSelect.value;
            const doctor = doctorSelect.value;
            const appointmentDate = appointmentDateInput.value;
            const shift = shiftSelect.value;
            if (!service) {
                alert('Vui lòng chọn dịch vụ khám');
                e.preventDefault();
                return;
            }
            if (!doctor) {
                alert('Vui lòng chọn bác sĩ');
                e.preventDefault();
                return;
            }
            if (!appointmentDate) {
                alert('Vui lòng chọn ngày hẹn');
                e.preventDefault();
                return;
            }
            if (!shift) {
                alert('Vui lòng chọn ca làm việc');
                e.preventDefault();
                return;
            }
            const selectedDate = new Date(appointmentDate);
            const now = new Date();
            now.setHours(0, 0, 0, 0);
            if (selectedDate <= now) {
                alert('Ngày hẹn phải trong tương lai');
                e.preventDefault();
                return;
            }
        });
        // Tự động load lại bác sĩ nếu đã chọn dịch vụ khi load trang
        if (serviceSelect && serviceSelect.value) {
            serviceSelect.dispatchEvent(new Event('change'));
        }
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

    // --- FORCE SHOW ALL VIEW DETAIL BUTTONS (SHIFT PAGE) ---
    document.querySelectorAll('.btn-view-detail').forEach(btn => {
        btn.style.display = 'inline-block';
        btn.style.visibility = 'visible';
        btn.classList.remove('d-none');
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
    if (!window.calendar) return alert('Lịch chưa được tải.');
    const events = window.calendar.getEvents();
    if (!events.length) return alert('Không có lịch hẹn nào để đồng bộ.');

    let icsContent = [
        'BEGIN:VCALENDAR',
        'VERSION:2.0',
        'PRODID:-//G3 Hospital//EN'
    ];

    events.forEach(event => {
        icsContent.push('BEGIN:VEVENT');
        icsContent.push('UID:' + event.id + '@g3hospital.vn');
        icsContent.push('DTSTAMP:' + new Date().toISOString().replace(/[-:]/g, '').split('.')[0] + 'Z');
        icsContent.push('DTSTART:' + event.start.toISOString().replace(/[-:]/g, '').split('.')[0] + 'Z');
        if (event.end) {
            icsContent.push('DTEND:' + event.end.toISOString().replace(/[-:]/g, '').split('.')[0] + 'Z');
        }
        icsContent.push('SUMMARY:' + event.title);
        icsContent.push('END:VEVENT');
    });

    icsContent.push('END:VCALENDAR');
    const blob = new Blob([icsContent.join('\r\n')], { type: 'text/calendar' });
    const url = URL.createObjectURL(blob);

    // Tạo link download
    const a = document.createElement('a');
    a.href = url;
    a.download = 'lich-hen-g3hospital.ics';
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);

    alert('Đã xuất file lịch hẹn. Bạn chỉ cần import file này vào Google Calendar!');
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

// ===== SHIFT MANAGEMENT FUNCTIONS =====
function viewShiftDetail(shiftId) {
    // Load shift detail via AJAX
    fetch(getContextPath() + '/admin/shifts?action=detail&id=' + shiftId)
        .then(response => response.text())
        .then(data => {
            document.getElementById('shiftDetailContent').innerHTML = data;
            new bootstrap.Modal(document.getElementById('shiftDetailModal')).show();
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Có lỗi xảy ra khi tải thông tin ca làm việc');
        });
}

function editShift(shiftId) {
    // Load shift data via AJAX
    fetch(getContextPath() + '/admin/shifts?action=get&id=' + shiftId)
        .then(response => response.json())
        .then(data => {
            document.getElementById('editShiftId').value = data.shiftId;
            document.getElementById('editName').value = data.name;
            document.getElementById('editStartTime').value = data.startTime;
            document.getElementById('editEndTime').value = data.endTime;
            document.getElementById('editDescription').value = data.description || '';
            new bootstrap.Modal(document.getElementById('editShiftModal')).show();
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Có lỗi xảy ra khi tải thông tin ca làm việc');
        });
}

function deleteShift(shiftId) {
    const button = event.target.closest('button');
    const shiftName = button.getAttribute('data-shift-name');
    if (confirm('Bạn có chắc chắn muốn xóa ca làm việc "' + shiftName + '"?')) {
        window.location.href = getContextPath() + '/admin/shifts?action=delete&id=' + shiftId;
    }
}

function validateTime() {
    const startTime = document.getElementById('startTime')?.value;
    const endTime = document.getElementById('endTime')?.value;
    
    if (startTime && endTime && startTime >= endTime) {
        alert('Giờ bắt đầu phải nhỏ hơn giờ kết thúc!');
        return false;
    }
    return true;
}

// ===== EXCEPTION FORM HANDLING =====
function initializeExceptionForm() {
    // Set minimum date to today
    const today = new Date().toISOString().split('T')[0];
    const exceptionDateInput = document.getElementById('exceptionDate');
    if (exceptionDateInput) {
        exceptionDateInput.min = today;
    }
    
    const exceptionType = document.getElementById('exceptionType');
    const newShiftSection = document.getElementById('newShiftSection');
    const newShiftId = document.getElementById('newShiftId');
    
    if (exceptionType && newShiftSection && newShiftId) {
        function toggleShiftSection() {
            if (exceptionType.value === 'Thay đổi giờ làm') {
                newShiftSection.style.display = 'block';
                newShiftId.required = true;
            } else {
                newShiftSection.style.display = 'none';
                newShiftId.required = false;
                newShiftId.value = '';
            }
        }
        
        // Check on page load
        toggleShiftSection();
        
        // Add event listener
        exceptionType.addEventListener('change', toggleShiftSection);
    }
}

// ===== SHIFT FORM VALIDATION =====
function initializeShiftForms() {
    // Validation cho form thêm mới
    const addShiftModal = document.getElementById('addShiftModal');
    if (addShiftModal) {
        addShiftModal.addEventListener('show.bs.modal', function () {
            const nameInput = document.getElementById('name');
            const startTimeInput = document.getElementById('startTime');
            const endTimeInput = document.getElementById('endTime');
            const descriptionInput = document.getElementById('description');
            
            if (nameInput) nameInput.value = '';
            if (startTimeInput) startTimeInput.value = '';
            if (endTimeInput) endTimeInput.value = '';
            if (descriptionInput) descriptionInput.value = '';
        });
    }

    // Validation thời gian
    const timeInputs = ['startTime', 'endTime', 'editStartTime', 'editEndTime'];
    timeInputs.forEach(inputId => {
        const input = document.getElementById(inputId);
        if (input) {
            input.addEventListener('change', validateTime);
        }
    });
}

// ===== INITIALIZE ALL SHIFT-RELATED FUNCTIONALITY =====
document.addEventListener('DOMContentLoaded', function() {
    // Initialize exception forms
    initializeExceptionForm();
    
    // Initialize shift forms
    initializeShiftForms();
    
    // Force show all view detail buttons (already added above)
    document.querySelectorAll('.btn-view-detail').forEach(btn => {
        btn.style.display = 'inline-block';
        btn.style.visibility = 'visible';
        btn.classList.remove('d-none');
    });
});

// Helper function to get context path
function getContextPath() {
    return window.contextPath || '';
}

// ========== RECEPTIONIST DASHBOARD ===========
if (document.getElementById('receptionist-dashboard')) {
    const contextPath = window.contextPath || '';
    let currentPage = 1;
    let pageSize = 10;
    let totalPages = 1;

    // Fetch doctor list for filter
    function loadDoctorsForFilter() {
        $.get(contextPath + '/getDoctorsByService', function(doctors) {
            const filterDoctor = document.getElementById('filterDoctor');
            filterDoctor.innerHTML = '<option value="">Tất cả</option>';
            doctors.forEach(d => {
                let name = d.user && d.user.fullName ? d.user.fullName : d.fullName;
                filterDoctor.innerHTML += `<option value="${d.doctor_id}">${name}</option>`;
            });
        });
    }

    // Fetch and render appointments
    function loadAppointments(page = 1) {
        const doctorId = document.getElementById('filterDoctor').value;
        const date = document.getElementById('filterDate').value;
        const status = document.getElementById('filterStatus').value;
        $.get(contextPath + '/api/receptionist/appointments', {
            doctorId, date, status, page, size: pageSize
        }, function(resp) {
            const data = resp.data || resp;
            const totalCount = resp.totalCount || data.length;
            totalPages = Math.ceil(totalCount / pageSize);
            renderCalendar(data);
            renderTable(data);
            renderPagination(page, totalPages);
        });
    }

    // Render FullCalendar
    function renderCalendar(events) {
        if (window.receptionistCalendar) {
            window.receptionistCalendar.removeAllEvents();
            window.receptionistCalendar.addEventSource(events);
            return;
        }
        var calendarEl = document.getElementById('calendar');
        window.receptionistCalendar = new FullCalendar.Calendar(calendarEl, {
            initialView: 'dayGridMonth',
            locale: 'vi',
            headerToolbar: {
                left: 'prev,next today',
                center: 'title',
                right: 'dayGridMonth,timeGridWeek,timeGridDay'
            },
            events: events
        });
        window.receptionistCalendar.render();
    }

    // Render table
    function renderTable(events) {
        const tbody = document.getElementById('appointmentList');
        tbody.innerHTML = '';
        if (!events.length) {
            tbody.innerHTML = `<tr><td colspan="7" class="text-center py-4"><div class="text-muted"><i class="bi bi-calendar-x fs-1"></i><p class="mt-2">Chưa có lịch hẹn nào</p></div></td></tr>`;
            return;
        }
        events.forEach(appt => {
            tbody.innerHTML += `
            <tr>
                <td>${appt.id}</td>
                <td>${appt.start.replace('T', ' ').substring(0, 16)}</td>
                <td>${appt.patientName}</td>
                <td>${appt.doctorName}</td>
                <td>${appt.serviceName}</td>
                <td>${appt.status}</td>
                <td>
                    <div class="btn-group" role="group">
                        <button class="btn btn-sm btn-outline-success" onclick="updateStatus(${appt.id}, 'confirmed')" title="Xác nhận"><i class="bi bi-check-circle"></i></button>
                        <button class="btn btn-sm btn-outline-danger" onclick="updateStatus(${appt.id}, 'canceled')" title="Hủy"><i class="bi bi-x-circle"></i></button>
                        <button class="btn btn-sm btn-outline-info" onclick="updateStatus(${appt.id}, 'completed')" title="Hoàn thành"><i class="bi bi-check2-square"></i></button>
                    </div>
                </td>
            </tr>`;
        });
    }

    // Render pagination (full)
    function renderPagination(page, totalPages) {
        const pag = document.getElementById('pagination');
        pag.innerHTML = '';
        pag.innerHTML += `<li class="page-item${page === 1 ? ' disabled' : ''}"><a class="page-link" href="#" onclick="gotoPage(${page-1});return false;">Trước</a></li>`;
        for (let i = 1; i <= totalPages; i++) {
            pag.innerHTML += `<li class="page-item${i === page ? ' active' : ''}"><a class="page-link" href="#" onclick="gotoPage(${i});return false;">${i}</a></li>`;
        }
        pag.innerHTML += `<li class="page-item${page === totalPages ? ' disabled' : ''}"><a class="page-link" href="#" onclick="gotoPage(${page+1});return false;">Sau</a></li>`;
    }
    window.gotoPage = function(page) {
        if (page < 1 || page > totalPages) return;
        currentPage = page;
        loadAppointments(page);
    }

    // Update status
    window.updateStatus = function(id, status) {
        if (!confirm('Bạn chắc chắn muốn cập nhật trạng thái này?')) return;
        $.post(contextPath + '/update-appointment-status', { appointmentId: id, status }, function(resp) {
            alert('Cập nhật thành công!');
            loadAppointments(currentPage);
        }).fail(function() {
            alert('Cập nhật thất bại!');
        });
    }

    // Filter button
    $('#filterButton').on('click', function() {
        currentPage = 1;
        loadAppointments(1);
    });

    // Init
    $(function() {
        loadDoctorsForFilter();
        loadAppointments(1);
    });
}

// ========== DOCTOR APPOINTMENTS DASHBOARD ===========
if (document.getElementById('doctor-appointments')) {
    const contextPath = window.contextPath || '';
    let currentPage = 1;
    let pageSize = 10;
    let totalPages = 1;
    let doctorAppointments = [];

    // Thêm modal chi tiết nếu chưa có
    if (!document.getElementById('appointmentDetailModal')) {
        const modalHtml = `
        <div class="modal fade" id="appointmentDetailModal" tabindex="-1" aria-labelledby="appointmentDetailModalLabel" aria-hidden="true">
          <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title" id="appointmentDetailModalLabel">Chi tiết lịch hẹn</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
              </div>
              <div class="modal-body" id="appointmentDetailBody">
                <!-- Nội dung render ở JS -->
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
              </div>
            </div>
          </div>
        </div>`;
        document.body.insertAdjacentHTML('beforeend', modalHtml);
    }

    // Fetch and render appointments
    function loadAppointments(page = 1) {
        const date = document.getElementById('filterDate').value;
        const status = document.getElementById('filterStatus').value;
        $.get(contextPath + '/getDoctorAppointments', {
            page: page, 
            size: pageSize
        }, function(resp) {
            // API trả về mảng trực tiếp
            doctorAppointments = resp;
            const totalCount = resp.length;
            totalPages = Math.ceil(totalCount / pageSize);
            renderCalendar(doctorAppointments);
            renderTable(doctorAppointments);
            renderPagination(page, totalPages);
        });
    }

    // Render FullCalendar
    function renderCalendar(events) {
        // Map dữ liệu sang event cho FullCalendar
        const calendarEvents = events.map(appt => ({
            id: appt.id,
            title: `${appt.patient && appt.patient.user ? appt.patient.user.fullName : ''} - ${appt.service ? appt.service.name : ''}`,
            start: appt.appointmentDateTime || appt.start,
            status: typeof appt.status === 'object' ? appt.status.code : (typeof appt.status === 'string' ? appt.status.toLowerCase() : ''),
        }));
        if (window.doctorCalendar) {
            window.doctorCalendar.removeAllEvents();
            window.doctorCalendar.addEventSource(calendarEvents);
            return;
        }
        var calendarEl = document.getElementById('calendar');
        window.doctorCalendar = new FullCalendar.Calendar(calendarEl, {
            initialView: 'dayGridMonth',
            locale: 'vi',
            headerToolbar: {
                left: 'prev,next today',
                center: 'title',
                right: 'dayGridMonth,timeGridWeek,timeGridDay'
            },
            events: calendarEvents
        });
        window.doctorCalendar.render();
    }

    // Helper: map status code sang tên tiếng Việt
    function getStatusDisplay(status) {
        if (!status) return '';
        if (typeof status === 'object' && status.displayName) return status.displayName;
        if (typeof status === 'string') {
            switch (status.toLowerCase()) {
                case 'pending': return 'Chờ xác nhận';
                case 'confirmed': return 'Đã xác nhận';
                case 'in_progress': return 'Đang khám';
                case 'completed': return 'Hoàn thành';
                case 'cancelled':
                case 'canceled': return 'Đã hủy';
                case 'no_show': return 'Không đến';
                default: return status;
            }
        }
        return '';
    }

    // Render table
    function renderTable(events) {
        const tbody = document.getElementById('appointmentList');
        tbody.innerHTML = '';
        if (!events.length) {
            tbody.innerHTML = `<tr><td colspan="6" class="text-center py-4"><div class="text-muted"><i class="bi bi-calendar-x fs-1"></i><p class="mt-2">Chưa có lịch hẹn nào</p></div></td></tr>`;
            return;
        }
        events.forEach((appt, idx) => {
            const statusText = getStatusDisplay(appt.status);
            tbody.innerHTML += `
            <tr>
                <td>${appt.id}</td>
                <td>${appt.appointmentDateTime ? appt.appointmentDateTime.replace('T', ' ').substring(0, 16) : ''}</td>
                <td>${appt.patient && appt.patient.user ? appt.patient.user.fullName : ''}</td>
                <td>${appt.service ? appt.service.name : ''}</td>
                <td>${statusText}</td>
                <td>
                    <button class="btn btn-sm btn-outline-info" onclick="showAppointmentDetailDoctor(${idx})" title="Xem chi tiết"><i class="bi bi-eye"></i></button>
                </td>
            </tr>`;
        });
    }

    // Render pagination (full)
    function renderPagination(page, totalPages) {
        const pag = document.getElementById('pagination');
        pag.innerHTML = '';
        pag.innerHTML += `<li class="page-item${page === 1 ? ' disabled' : ''}"><a class="page-link" href="#" onclick="gotoPageDoctor(${page-1});return false;">Trước</a></li>`;
        for (let i = 1; i <= totalPages; i++) {
            pag.innerHTML += `<li class="page-item${i === page ? ' active' : ''}"><a class="page-link" href="#" onclick="gotoPageDoctor(${i});return false;">${i}</a></li>`;
        }
        pag.innerHTML += `<li class="page-item${page === totalPages ? ' disabled' : ''}"><a class="page-link" href="#" onclick="gotoPageDoctor(${page+1});return false;">Sau</a></li>`;
    }
    window.gotoPageDoctor = function(page) {
        if (page < 1 || page > totalPages) return;
        currentPage = page;
        loadAppointments(page);
    }

    // Show detail modal
    window.showAppointmentDetailDoctor = function(idx) {
        const appt = doctorAppointments[idx];
        const statusText = getStatusDisplay(appt.status);
        const body = document.getElementById('appointmentDetailBody');
        body.innerHTML = `
            <div class="mb-2"><b>Bệnh nhân:</b> ${appt.patient && appt.patient.user ? appt.patient.user.fullName : ''}</div>
            <div class="mb-2"><b>Dịch vụ:</b> ${appt.service ? appt.service.name : ''}</div>
            <div class="mb-2"><b>Thời gian:</b> ${appt.appointmentDateTime ? appt.appointmentDateTime.replace('T', ' ').substring(0, 16) : ''}</div>
            <div class="mb-2"><b>Trạng thái:</b> ${statusText}</div>
            <div class="mb-2"><b>Ghi chú:</b> ${appt.note || ''}</div>
        `;
        const modal = new bootstrap.Modal(document.getElementById('appointmentDetailModal'));
        modal.show();
    }

    // Filter button
    $('#filterButton').on('click', function() {
        currentPage = 1;
        loadAppointments(1);
    });

    // Init
    $(function() {
        loadAppointments(1);
    });
}