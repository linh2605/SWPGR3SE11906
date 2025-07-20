// Global context path
window.contextPath = window.contextPath || '';

// Đặt biến toàn cục để sử dụng ở nhiều nơi
let calendar;

// Flag để tránh multiple sync operations
let syncInProgress = false;

// Intercept console.log to capture appointments data
let capturedAppointments = null;
const originalConsoleLog = console.log;
console.log = function(...args) {
    // Check if this is the appointments data log
    if (args.length >= 2 && typeof args[0] === 'string' && args[0].includes('Appointments data:') && Array.isArray(args[1])) {
        capturedAppointments = args[1];
        console.log('🎯 Captured appointments from console log:', capturedAppointments.length, 'items');
    }
    // Call original console.log
    return originalConsoleLog.apply(console, args);
};

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
                displayEventTime: false,
                eventTimeFormat: { hour: '2-digit', minute: '2-digit', meridiem: false },
                views: {
                    dayGridMonth: { displayEventTime: false },
                    timeGridWeek: { displayEventTime: false },
                    timeGridDay: { displayEventTime: false }
                },
                events: function(fetchInfo, successCallback, failureCallback) {
                    let url = '';
                    if (pageId === 'appointments') url = `${contextPath}/getAppointments`;
                    else if (pageId === 'doctorDashboard') url = `${contextPath}/getDoctorAppointments`;
                    else if (pageId === 'receptionistDashboard') url = `${contextPath}/getAllAppointments`;

                    $.ajax({
                        url: url,
                        method: 'GET',
                        data: {
                            // Để calendar hiển thị trong khoảng thời gian được yêu cầu
                            start: fetchInfo.start.toISOString(),
                            end: fetchInfo.end.toISOString(),
                            // Nhưng khi sync sẽ lấy tất cả
                            viewOnly: true
                        },
                        dataType: 'json',
                        success: function(data) {
                            const events = data.map(appt => ({
                                id: appt.id,
                                title: `${appt.service ? appt.service.name : ''}${appt.shiftText ? ' - ' + appt.shiftText : ''}${appt.doctor && appt.doctor.user ? ' - BS. ' + appt.doctor.user.fullName : ''}`.replace(/^ - /, ''),
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
            
            // For receptionist dashboard, try again after a delay to ensure data is loaded
            if (pageId === 'receptionistDashboard') {
                setTimeout(() => {
                    console.log('🔄 Retrying filter population for receptionist dashboard...');
                    populateFilters(pageId);
                }, 2000);
            }
        }

        const appointmentList = document.getElementById('appointmentList');
        if (appointmentList && document.getElementById(pageId)) {
            // Enable filtering for all pages - removed doctor filter
            document.getElementById('filterDate')?.addEventListener('change', filterAppointments);
            document.getElementById('filterPatient')?.addEventListener('change', filterAppointments);
            document.getElementById('filterStatus')?.addEventListener('change', filterAppointments);
            document.getElementById('search')?.addEventListener('input', filterAppointments);
            // Remove filterButton listener - auto filter on change instead
        }
    });

    // Đảm bảo nút đồng bộ luôn hoạt động
    const syncBtn = document.getElementById('syncCalendarBtn');
    if (syncBtn) {
        // Remove existing listeners first
        syncBtn.removeEventListener('click', syncWithExternalCalendar);
        // Add new listener
        syncBtn.addEventListener('click', function(e) {
            e.preventDefault();
            e.stopPropagation();
            console.log('🖱️ Sync button clicked');
            syncWithExternalCalendar();
        });
    }

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
                priceDisplay.style.display = 'flex';
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
                alert('Vui lòng chọn ngày khám');
                e.preventDefault();
                return;
            }
            if (!shift) {
                alert('Vui lòng chọn ca khám');
                e.preventDefault();
                return;
            }
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

// Điền dữ liệu cho bộ lọc - simplified without doctor filter
function populateFilters(pageId) {
    console.log('🔍 Populating filters for:', pageId);
    
    // Chỉ cần populate date filter từ table
    const dates = new Set();
    
    // Extract dates from table
    let rows = document.querySelectorAll('#appointmentList tr');
    if (rows.length === 0) {
        rows = document.querySelectorAll('#appointmentTable tbody tr');
    }
    if (rows.length === 0) {
        rows = document.querySelectorAll('table tbody tr');
    }
    
    console.log('📊 Found', rows.length, 'table rows for date extraction');
    
    rows.forEach((row, index) => {
        const cells = row.querySelectorAll('td');
        if (cells.length >= 2) {
            const dateCell = cells[1].textContent.trim();
            if (dateCell && dateCell.length > 0 && !dateCell.match(/^\d+$/)) {
                // Try to parse and format the date
                try {
                    let dateStr = '';
                    if (dateCell.includes('/')) {
                        dateStr = dateCell;
                    } else if (dateCell.includes('-')) {
                        const date = new Date(dateCell);
                        dateStr = date.toLocaleDateString('vi-VN');
                    } else {
                        dateStr = dateCell;
                    }
                    if (dateStr && dateStr !== 'Invalid Date') {
                        dates.add(dateStr);
                    }
                } catch (e) {
                    // Skip invalid dates
                }
            }
        }
    });
    
    console.log('📅 Dates found:', Array.from(dates));
    
    // Populate date filter
    const filterDate = document.getElementById('filterDate');
    if (filterDate) {
        // Keep the date input as is - no need to populate options
        console.log('✅ Date filter ready for user input');
    }
    
    console.log('✅ Filters populated successfully (simplified)');
}

function extractAppointmentsFromTableForFilter() {
    console.log('🔍 Extracting appointments from table for filter...');
    const appointments = [];
    
    // Try different table selectors
    let rows = document.querySelectorAll('#appointmentList tr');
    if (rows.length === 0) {
        rows = document.querySelectorAll('#appointmentTable tbody tr');
    }
    if (rows.length === 0) {
        rows = document.querySelectorAll('table tbody tr');
    }
    
    console.log('📊 Found', rows.length, 'table rows to extract from');
    
    rows.forEach((row, index) => {
        const cells = row.querySelectorAll('td');
        if (cells.length >= 4) {
            const cellTexts = Array.from(cells).map(cell => cell.textContent.trim());
            
            // Skip first row if it has too many cells (might be header)
            if (index === 0 && cellTexts.length > 20) {
                console.log(`⏭️ Skipping row ${index + 1} (likely header with ${cellTexts.length} cells)`);
                return;
            }
            
            console.log(`📝 Row ${index + 1} cells (${cellTexts.length}):`, cellTexts.slice(0, 8));
            
            // Extract based on typical table structure: [STT, Date, Shift, Patient, Doctor, Service, Status, Actions]
            let doctorName = '';
            let patientName = '';
            let dateStr = '';
            let status = '';
            
            // Extract date (usually column 1)
            if (cellTexts[1] && cellTexts[1].length > 0) {
                dateStr = cellTexts[1];
            }
            
            // Extract patient (usually column 3)
            if (cellTexts[3] && cellTexts[3].length > 1) {
                patientName = cellTexts[3];
            }
            
            // Extract doctor - try multiple approaches
            // Method 1: Column 4 (typical doctor position)
            if (cellTexts[4] && cellTexts[4].length > 1 && !cellTexts[4].match(/^\d+$/)) {
                doctorName = cellTexts[4];
            }
            
            // Method 2: Search for cell containing "BS." or doctor-like name
            if (!doctorName || doctorName === 'Không có thông tin') {
                for (let i = 0; i < Math.min(cellTexts.length, 8); i++) { // Only check first 8 columns
                    const cell = cellTexts[i];
                    if (cell && (cell.includes('BS.') || cell.includes('Bác sĩ') || 
                                (cell.length > 3 && !cell.match(/^\d+$/) && !cell.includes('/') && 
                                 !cell.toLowerCase().includes('chờ') && !cell.toLowerCase().includes('hoàn thành')))) {
                        // Additional check: make sure it's not patient name (different from column 3)
                        if (cell !== patientName && cell.length > 2) {
                            doctorName = cell;
                            console.log(`🏥 Found doctor in column ${i}: "${doctorName}"`);
                            break;
                        }
                    }
                }
            }
            
            // Extract status (usually last few columns)
            if (cellTexts[6] && cellTexts[6].length > 0) {
                status = cellTexts[6];
            } else if (cellTexts[cellTexts.length - 2]) {
                status = cellTexts[cellTexts.length - 2];
            }
            
            // Clean doctor name
            if (doctorName) {
                doctorName = doctorName.replace(/^BS\.\s*/, '').trim();
                if (doctorName === '' || doctorName === 'null' || doctorName === 'undefined') {
                    doctorName = 'Không có thông tin';
                }
            } else {
                doctorName = 'Không có thông tin';
            }
            
            const appointment = {
                id: index + 1,
                date: dateStr,
                patientName: patientName || '',
                doctorName: doctorName,
                status: status || ''
            };
            
            console.log(`📋 Extracted appointment ${index + 1}:`, appointment);
            appointments.push(appointment);
        }
    });
    
    console.log('📋 Final extracted appointments:', appointments);
    return appointments;
}

function populateFiltersFromAPI(pageId) {
    let url = '';
    if (pageId === 'appointments') url = `${contextPath}/getAppointments`;
    else if (pageId === 'doctorDashboard') url = `${contextPath}/getDoctorAppointments`;
    else if (pageId === 'receptionistDashboard') url = `${contextPath}/getAllAppointments`;

    console.log('🔍 Populating filters from API:', url);

    $.ajax({
        url: url,
        method: 'GET',
        dataType: 'json',
        success: function(data) {
            console.log('📊 Filter data received from API:', data);
            processAppointmentsForFilters(data);
        },
        error: function(xhr, status, error) {
            console.error('❌ Error populating filters from API:', error);
            
            // Fallback: populate with empty options
            populateEmptyFilters();
        }
    });
}

function processAppointmentsForFilters(data) {
    console.log('📊 Processing appointments for filters:', data);
    console.log('📝 First appointment structure:', JSON.stringify(data[0], null, 2));
    
    const dates = new Set();
    const doctors = new Set();
    const patients = new Set();

    data.forEach((appt, index) => {
        if (index < 3) {
            console.log(`🔍 Processing appointment ${index + 1}:`, appt);
        }
        
        // Extract date with multiple approaches
        let dateStr = '';
        if (appt.dateTime) {
            dateStr = new Date(appt.dateTime).toLocaleDateString('vi-VN');
        } else if (appt.appointmentDateTime) {
            dateStr = new Date(appt.appointmentDateTime).toLocaleDateString('vi-VN');
        } else if (appt.date) {
            // Handle different date formats
            if (typeof appt.date === 'string' && appt.date.includes('-')) {
                dateStr = new Date(appt.date).toLocaleDateString('vi-VN');
            } else if (typeof appt.date === 'object' && appt.date.time) {
                dateStr = new Date(appt.date.time).toLocaleDateString('vi-VN');
            } else {
                dateStr = appt.date.toString();
            }
        }
        if (dateStr && dateStr !== 'Invalid Date') {
            dates.add(dateStr);
            if (index < 3) console.log(`📅 Date extracted: "${dateStr}"`);
        }

        // Extract doctor name with extensive checking
        let doctorName = '';
        
        // Method 1: Direct doctorName property
        if (appt.doctorName) {
            doctorName = appt.doctorName.replace(/^BS\.\s*/, ''); // Remove BS. prefix if present
        }
        // Method 2: Nested doctor.user.fullName
        else if (appt.doctor && appt.doctor.user && appt.doctor.user.fullName) {
            doctorName = appt.doctor.user.fullName;
        }
        // Method 3: Direct doctor property as string
        else if (typeof appt.doctor === 'string') {
            doctorName = appt.doctor.replace(/^BS\.\s*/, '');
        }
        // Method 4: Check for any property containing doctor info
        else {
            for (let key in appt) {
                if (key.toLowerCase().includes('doctor') && appt[key]) {
                    if (typeof appt[key] === 'string') {
                        doctorName = appt[key].replace(/^BS\.\s*/, '');
                        console.log(`🏥 Found doctor in property "${key}": "${doctorName}"`);
                        break;
                    } else if (typeof appt[key] === 'object' && appt[key].fullName) {
                        doctorName = appt[key].fullName;
                        console.log(`🏥 Found doctor in property "${key}.fullName": "${doctorName}"`);
                        break;
                    } else if (typeof appt[key] === 'object' && appt[key].user && appt[key].user.fullName) {
                        doctorName = appt[key].user.fullName;
                        console.log(`🏥 Found doctor in property "${key}.user.fullName": "${doctorName}"`);
                        break;
                    }
                }
            }
        }
        
        if (doctorName && doctorName !== 'null' && doctorName !== 'undefined' && doctorName.length > 1) {
            doctors.add(doctorName);
            if (index < 3) console.log(`👨‍⚕️ Doctor extracted: "${doctorName}"`);
        } else {
            if (index < 3) console.log(`❌ No doctor found for appointment ${index + 1}`, appt);
        }

        // Extract patient name with extensive checking
        let patientName = '';
        
        // Method 1: Direct patientName property
        if (appt.patientName) {
            patientName = appt.patientName;
        }
        // Method 2: Nested patient.user.fullName
        else if (appt.patient && appt.patient.user && appt.patient.user.fullName) {
            patientName = appt.patient.user.fullName;
        }
        // Method 3: Direct patient property as string
        else if (typeof appt.patient === 'string') {
            patientName = appt.patient;
        }
        // Method 4: Check for any property containing patient info
        else {
            for (let key in appt) {
                if (key.toLowerCase().includes('patient') && appt[key]) {
                    if (typeof appt[key] === 'string') {
                        patientName = appt[key];
                        break;
                    } else if (typeof appt[key] === 'object' && appt[key].fullName) {
                        patientName = appt[key].fullName;
                        break;
                    } else if (typeof appt[key] === 'object' && appt[key].user && appt[key].user.fullName) {
                        patientName = appt[key].user.fullName;
                        break;
                    }
                }
            }
        }
        
        if (patientName && patientName !== 'null' && patientName !== 'undefined' && patientName.length > 1) {
            patients.add(patientName);
            if (index < 3) console.log(`👤 Patient extracted: "${patientName}"`);
        }
    });

    console.log('📅 Dates found:', Array.from(dates));
    console.log('👨‍⚕️ Doctors found:', Array.from(doctors));
    console.log('👤 Patients found:', Array.from(patients));

    // Populate date filter
    const filterDate = document.getElementById('filterDate');
    if (filterDate) {
        filterDate.innerHTML = '<option value="">Tất cả</option>';
        Array.from(dates).sort().forEach(date => {
            filterDate.innerHTML += `<option value="${date}">${date}</option>`;
        });
        console.log('✅ Date filter populated with', dates.size, 'options');
    }

    // Populate doctor filter
    const filterDoctor = document.getElementById('filterDoctor');
    if (filterDoctor) {
        filterDoctor.innerHTML = '<option value="">Tất cả</option>';
        if (doctors.size > 0) {
            Array.from(doctors).sort().forEach(doctor => {
                // Use doctor name as value (without BS. prefix) and display with BS. prefix
                const displayName = doctor.includes('BS.') ? doctor : `BS. ${doctor}`;
                const valueName = doctor.replace(/^BS\.\s*/, ''); // Remove BS. prefix for value
                filterDoctor.innerHTML += `<option value="${valueName}">${displayName}</option>`;
            });
            console.log('✅ Doctor filter populated with', doctors.size, 'options');
        } else {
            filterDoctor.innerHTML += '<option value="">Không tìm thấy bác sĩ</option>';
            console.log('⚠️ No doctors found to populate filter');
        }
    }

    // Populate patient filter
    const filterPatient = document.getElementById('filterPatient');
    if (filterPatient) {
        filterPatient.innerHTML = '<option value="">Tất cả</option>';
        Array.from(patients).sort().forEach(patient => {
            filterPatient.innerHTML += `<option value="${patient}">${patient}</option>`;
        });
        console.log('✅ Patient filter populated with', patients.size, 'options');
    }
}

function populateEmptyFilters() {
    const filterDoctor = document.getElementById('filterDoctor');
    const filterPatient = document.getElementById('filterPatient');
    const filterDate = document.getElementById('filterDate');
    
    if (filterDoctor) filterDoctor.innerHTML = '<option value="">Tất cả (lỗi tải dữ liệu)</option>';
    if (filterPatient) filterPatient.innerHTML = '<option value="">Tất cả (lỗi tải dữ liệu)</option>';
    if (filterDate) filterDate.innerHTML = '<option value="">Tất cả (lỗi tải dữ liệu)</option>';
}

// Utilities
function removeDiacritics(str) {
    return str.normalize("NFD").replace(/[\u0300-\u036f]/g, "").toLowerCase();
}

function filterAppointments() {
    console.log('🔍 Filtering appointments...');
    
    const dateFilter = (document.getElementById('filterDate')?.value || '').trim();
    const patientFilter = removeDiacritics(document.getElementById('filterPatient')?.value || '').trim();
    const statusFilter = (document.getElementById('filterStatus')?.value || '').trim();
    const searchText = removeDiacritics(document.getElementById('search')?.value || '').trim();
    
    console.log('🔍 Filters:', {dateFilter, patientFilter, statusFilter, searchText});
    
    // Try different table selectors
    let rows = document.querySelectorAll('#appointmentList tr');
    if (rows.length === 0) {
        rows = document.querySelectorAll('#appointmentTable tbody tr');
    }
    if (rows.length === 0) {
        rows = document.querySelectorAll('table tbody tr');
    }
    
    console.log('📊 Found', rows.length, 'table rows to filter');
    
    let visibleCount = 0;
    
    rows.forEach((row, index) => {
        const cells = row.querySelectorAll('td');
        if (cells.length < 4) return; // Skip rows with too few cells
        
        // Extract text from cells
        const cellTexts = Array.from(cells).map(cell => cell.textContent.trim());
        
        // More precise column identification
        let datetime = '';
        let patient = '';
        let status = '';
        
        // Based on typical table structure: [STT, Date, Shift, Patient, Doctor, Service, Status, Actions]
        if (cellTexts.length >= 7) {
            datetime = cellTexts[1]; // Column 2: Date
            patient = cellTexts[3];  // Column 4: Patient
            status = cellTexts[6];   // Column 7: Status
        } else {
            // Fallback: pattern matching
            for (let i = 0; i < cellTexts.length; i++) {
                const text = cellTexts[i];
                
                // Date patterns - more specific
                if (!datetime && (text.match(/\d{1,2}\/\d{1,2}\/\d{4}/) || text.includes('tháng') || text.match(/\d{4}-\d{2}-\d{2}/))) {
                    datetime = text;
                }
                
                // Status patterns
                if (!status) {
                    const lowerText = text.toLowerCase();
                    if (lowerText.includes('chờ') || lowerText.includes('pending') ||
                        lowerText.includes('hoàn thành') || lowerText.includes('completed') ||
                        lowerText.includes('đã hủy') || lowerText.includes('hủy') || lowerText.includes('canceled') ||
                        lowerText.includes('xác nhận') || lowerText.includes('confirmed')) {
                        status = text;
                    }
                }
                
                // Patient name - exclude obvious non-names
                if (!patient && text.length > 2 && 
                    !text.includes('BS.') && 
                    !text.includes('/') && !text.includes('-') &&
                    !text.toLowerCase().includes('chờ') &&
                    !text.toLowerCase().includes('hoàn thành') &&
                    !text.toLowerCase().includes('hủy') &&
                    !text.toLowerCase().includes('xác nhận') &&
                    !text.match(/^\d+$/)) { // Not just numbers
                    patient = text;
                }
            }
        }
        
        // Apply filters with improved matching
        
        // Date filter - handle multiple date formats
        let matchesDate = true;
        if (dateFilter) {
            // Convert filter date to multiple formats for comparison
            const filterDate = new Date(dateFilter);
            const filterDateVN = filterDate.toLocaleDateString('vi-VN');
            const filterDateISO = dateFilter; // yyyy-mm-dd format
            
            matchesDate = datetime.includes(filterDateVN) || 
                         datetime.includes(filterDateISO) ||
                         datetime.includes(dateFilter);
        }
        
        // Patient filter
        const matchesPatient = !patientFilter || removeDiacritics(patient).includes(patientFilter);
        
        // Status filter with Vietnamese mapping
        let matchesStatus = true;
        if (statusFilter) {
            const statusLower = status.toLowerCase();
            switch (statusFilter) {
                case 'pending':
                    matchesStatus = statusLower.includes('chờ') || statusLower.includes('pending');
                    break;
                case 'confirmed':
                    matchesStatus = statusLower.includes('xác nhận') || statusLower.includes('confirmed');
                    break;
                case 'completed':
                    matchesStatus = statusLower.includes('hoàn thành') || statusLower.includes('completed');
                    break;
                case 'canceled':
                    matchesStatus = statusLower.includes('hủy') || statusLower.includes('canceled');
                    break;
                default:
                    matchesStatus = statusLower.includes(statusFilter.toLowerCase());
            }
        }
        
        // Search filter
        const matchesSearch = !searchText || removeDiacritics(patient).includes(searchText);
        
        const isVisible = matchesDate && matchesPatient && matchesStatus && matchesSearch;
        
        if (index < 3) { // Log first 3 rows for debugging
            console.log(`📝 Row ${index + 1}:`, {
                cellTexts: cellTexts.slice(0, 8), // Show first 8 cells
                extracted: {datetime, patient, status},
                filters: {matchesDate, matchesPatient, matchesStatus, matchesSearch},
                visible: isVisible
            });
        }
        
        row.style.display = isVisible ? '' : 'none';
        if (isVisible) visibleCount++;
    });
    
    console.log('✅ Filtering complete:', visibleCount, 'of', rows.length, 'rows visible');
    
    // Show message if no results
    if (visibleCount === 0 && rows.length > 0) {
        console.log('⚠️ No rows match the filter criteria');
    }
}

function viewDetails(id) {
    alert('Xem chi tiết lịch hẹn ID: ' + id);
}

function syncWithExternalCalendar() {
    // Kiểm tra nếu đang sync
    if (syncInProgress) {
        console.log('⚠️ Sync already in progress, ignoring duplicate call');
        return;
    }
    
    syncInProgress = true;
    console.log('🔄 Bắt đầu đồng bộ lịch hẹn...');
    
    try {
        // Ưu tiên lấy dữ liệu từ trang trước, sau đó mới thử API
        if (tryGetDataFromPage()) {
            console.log('✅ Lấy dữ liệu từ trang thành công!');
            return;
        }
        
        console.log('⚠️ Không tìm thấy dữ liệu trong trang, thử API...');
        syncFromAPI();
    } finally {
        // Reset flag sau 3 giây để cho phép sync tiếp theo
        setTimeout(() => {
            syncInProgress = false;
            console.log('🔓 Sync flag reset');
        }, 3000);
    }
}

function tryGetDataFromPage() {
    console.log('🔍 Tìm kiếm dữ liệu trong trang...');
    
    let appointments = [];
    
    // Thử lấy từ các biến global có thể có
    const possibleVariables = [
        'appointments',
        'appointmentsData', 
        'allAppointments',
        'receptionistAppointments',
        'doctorAppointments',
        'appointmentList'
    ];
    
    for (let varName of possibleVariables) {
        if (window[varName] && Array.isArray(window[varName])) {
            appointments = window[varName];
            console.log(`📋 Found data in window.${varName}:`, appointments.length, 'items');
            console.log(`📝 Sample from window.${varName}:`, appointments[0]);
            break;
        }
    }
    
    // Thử tìm bất kỳ property nào của window có chứa array
    if (appointments.length === 0) {
        console.log('🔍 Scanning all window properties...');
        for (let prop in window) {
            try {
                if (window[prop] && Array.isArray(window[prop]) && window[prop].length > 0) {
                    // Kiểm tra xem array có chứa object giống appointment không
                    const sample = window[prop][0];
                    if (sample && typeof sample === 'object' && 
                        (sample.id || sample.patientName || sample.doctorName || sample.date || sample.dateTime)) {
                        appointments = window[prop];
                        console.log(`📋 Found appointments-like data in window.${prop}:`, appointments.length, 'items');
                        console.log(`📝 Sample from window.${prop}:`, sample);
                        break;
                    }
                }
            } catch (e) {
                // Skip properties that can't be accessed
            }
        }
    }
    
    // Thử lấy từ calendar instance
    if (appointments.length === 0) {
        const calendarInstances = [window.calendar, window.receptionistCalendar, window.doctorCalendar];
        for (let cal of calendarInstances) {
            if (cal && cal.getEvents) {
                const events = cal.getEvents();
                if (events && events.length > 0) {
                    console.log('📅 Found events in calendar instance:', events.length);
                    generateICSFile(events);
                    return true;
                }
            }
        }
    }
    
    // Thử lấy từ DOM table
    if (appointments.length === 0) {
        appointments = extractAppointmentsFromTable();
    }
    
    // Thử lấy từ localStorage hoặc sessionStorage
    if (appointments.length === 0) {
        const storageKeys = ['appointments', 'appointmentsData', 'receptionistData'];
        for (let key of storageKeys) {
            try {
                const stored = localStorage.getItem(key) || sessionStorage.getItem(key);
                if (stored) {
                    const parsed = JSON.parse(stored);
                    if (Array.isArray(parsed)) {
                        appointments = parsed;
                        console.log(`💾 Found data in storage.${key}:`, appointments.length, 'items');
                        break;
                    }
                }
            } catch (e) {
                // Ignore parse errors
            }
        }
    }
    
    if (appointments.length === 0) {
        console.log('❌ Không tìm thấy dữ liệu nào trong trang');
        return false;
    }
    
    console.log('🎉 Tìm thấy', appointments.length, 'lịch hẹn trong trang!');
    console.log('📝 Sample appointment:', appointments[0]);
    
    // Chuyển đổi và tạo file ICS
    const events = convertAppointmentsToEvents(appointments);
    if (events.length > 0) {
        generateICSFile(events);
        return true;
    }
    
    return false;
}

function extractAppointmentsFromTable() {
    console.log('🔍 Trying to extract from table...');
    const appointments = [];
    
    // Tìm table appointments
    const table = document.querySelector('#appointmentTable tbody, #appointmentList, table tbody');
    if (!table) {
        console.log('❌ Không tìm thấy table');
        return appointments;
    }
    
    const rows = table.querySelectorAll('tr');
    console.log('📊 Found', rows.length, 'rows in table');
    
    // Debug: Log table headers to understand structure
    const headerRow = document.querySelector('#appointmentTable thead tr, table thead tr');
    if (headerRow) {
        const headers = Array.from(headerRow.querySelectorAll('th')).map(th => th.textContent.trim());
        console.log('📋 Table headers:', headers);
    }
    
    rows.forEach((row, index) => {
        const cells = row.querySelectorAll('td');
        console.log(`📝 Row ${index + 1}:`, Array.from(cells).map(cell => cell.textContent.trim()));
        
        if (cells.length >= 4) {
            // Cố gắng extract thông tin từ table row
            const appointment = {
                id: index + 1,
                queueNumber: cells[0]?.textContent?.trim(),
                date: cells[1]?.textContent?.trim(),
                shift: cells[2]?.textContent?.trim(),
                patientName: cells[3]?.textContent?.trim(),
                doctorName: cells[4]?.textContent?.trim(),
                serviceName: cells[5]?.textContent?.trim(),
                status: cells[6]?.textContent?.trim()
            };
            
            console.log(`🔍 Parsed appointment ${index + 1}:`, appointment);
            
            // Tạo datetime từ date string - cải thiện parsing
            if (appointment.date) {
                try {
                    let dateTime = null;
                    
                    // Try different date formats
                    const formats = [
                        // Vietnamese format: dd/mm/yyyy
                        /(\d{1,2})\/(\d{1,2})\/(\d{4})/,
                        // ISO format: yyyy-mm-dd
                        /(\d{4})-(\d{1,2})-(\d{1,2})/,
                        // Long Vietnamese format: "Thứ hai, 1 tháng 7, 2025"
                        /(\d{1,2})\s+tháng\s+(\d{1,2}),?\s+(\d{4})/,
                        // English format: July 1, 2025
                        /(\w+)\s+(\d{1,2}),?\s+(\d{4})/
                    ];
                    
                    for (let format of formats) {
                        const match = appointment.date.match(format);
                        if (match) {
                            if (format === formats[0]) { // dd/mm/yyyy
                                dateTime = `${match[3]}-${match[2].padStart(2,'0')}-${match[1].padStart(2,'0')}T09:00:00`;
                                break;
                            } else if (format === formats[1]) { // yyyy-mm-dd
                                dateTime = `${match[1]}-${match[2].padStart(2,'0')}-${match[3].padStart(2,'0')}T09:00:00`;
                                break;
                            } else if (format === formats[2]) { // dd tháng mm, yyyy
                                dateTime = `${match[3]}-${match[2].padStart(2,'0')}-${match[1].padStart(2,'0')}T09:00:00`;
                                break;
                            }
                        }
                    }
                    
                    // Fallback: try to find any 4-digit year and use current date
                    if (!dateTime) {
                        const yearMatch = appointment.date.match(/(\d{4})/);
                        if (yearMatch) {
                            const now = new Date();
                            dateTime = `${yearMatch[1]}-${(now.getMonth() + 1).toString().padStart(2,'0')}-${now.getDate().toString().padStart(2,'0')}T09:00:00`;
                        } else {
                            // Last resort: use today's date
                            const now = new Date();
                            dateTime = `${now.getFullYear()}-${(now.getMonth() + 1).toString().padStart(2,'0')}-${now.getDate().toString().padStart(2,'0')}T09:00:00`;
                        }
                    }
                    
                    appointment.dateTime = dateTime;
                    console.log(`📅 Parsed date "${appointment.date}" -> "${dateTime}"`);
                    
                } catch (e) {
                    console.log('❌ Error parsing date:', appointment.date, e);
                    // Fallback to today
                    const now = new Date();
                    appointment.dateTime = `${now.getFullYear()}-${(now.getMonth() + 1).toString().padStart(2,'0')}-${now.getDate().toString().padStart(2,'0')}T09:00:00`;
                }
            }
            
            appointments.push(appointment);
        }
    });
    
    console.log('📋 Extracted', appointments.length, 'appointments from table');
    return appointments;
}

function convertAppointmentsToEvents(appointments) {
    console.log('🔄 Converting appointments to events...');
    
    const events = appointments.map((appt, idx) => {
        // Xử lý title
        let title = '';
        if (appt.service && appt.service.name) {
            title += appt.service.name;
        } else if (appt.serviceName) {
            title += appt.serviceName;
        }
        
        if (appt.shiftText) {
            title += (title ? ' - ' : '') + appt.shiftText;
        } else if (appt.shift) {
            title += (title ? ' - ' : '') + appt.shift;
        }
        
        if (appt.doctor && appt.doctor.user && appt.doctor.user.fullName) {
            title += (title ? ' - BS. ' : 'BS. ') + appt.doctor.user.fullName;
        } else if (appt.doctorName) {
            title += (title ? ' - BS. ' : 'BS. ') + appt.doctorName;
        }
        
        if (appt.patient && appt.patient.user && appt.patient.user.fullName) {
            title += (title ? ' - ' : '') + appt.patient.user.fullName;
        } else if (appt.patientName) {
            title += (title ? ' - ' : '') + appt.patientName;
        }

        // Xử lý thời gian
        let startTime = null;
        if (appt.dateTime) {
            startTime = new Date(appt.dateTime);
        } else if (appt.appointmentDateTime) {
            startTime = new Date(appt.appointmentDateTime);
        } else if (appt.date) {
            startTime = new Date(appt.date);
        }

        const event = {
            id: appt.id || `appt_${idx}`,
            title: title || 'Lịch hẹn',
            start: startTime,
            extendedProps: appt
        };
        
        if (idx < 3) { // Log first 3 events for debugging
            console.log(`📅 Event ${idx + 1}:`, event);
        }
        
        return event;
    }).filter(event => event.start && !isNaN(event.start.getTime())); // Chỉ lấy những event có thời gian hợp lệ

    console.log('✨ Converted to', events.length, 'valid events');
    return events;
}

function syncFromAPI() {
    const contextPath = window.contextPath || '';
    console.log('🌍 Context Path:', contextPath);
    console.log('📍 Current URL:', window.location.href);
    
    // Xác định API endpoint dựa trên trang hiện tại
    let apiUrls = [];
    
    if (document.getElementById('receptionistDashboard')) {
        console.log('📋 Detected: Receptionist Dashboard');
        apiUrls = [
            contextPath + '/getAllAppointments',
            contextPath + '/api/receptionist/appointments'
        ];
    } else if (document.getElementById('doctorDashboard') || document.getElementById('doctor-appointments')) {
        console.log('👨‍⚕️ Detected: Doctor Dashboard');
        apiUrls = [
            contextPath + '/getDoctorAppointments'
        ];
    } else if (document.getElementById('appointments')) {
        console.log('📅 Detected: Appointments Page');
        apiUrls = [
            contextPath + '/getAppointments'
        ];
    } else {
        console.log('❓ Unknown page, trying all endpoints...');
        apiUrls = [
            contextPath + '/getAllAppointments',
            contextPath + '/api/receptionist/appointments',
            contextPath + '/getDoctorAppointments',
            contextPath + '/getAppointments'
        ];
    }

    console.log('🎯 API URLs to try:', apiUrls);
    
    // Thử từng API endpoint cho đến khi thành công
    tryApiEndpoints(apiUrls, 0);
}

function tryApiEndpoints(apiUrls, index) {
    if (index >= apiUrls.length) {
        alert('❌ Không thể tải dữ liệu từ bất kỳ API endpoint nào. Vui lòng thử lại sau.');
        return;
    }
    
    const apiUrl = apiUrls[index];
    console.log(`🔄 Trying endpoint ${index + 1}/${apiUrls.length}:`, apiUrl);
    
    $.ajax({
        url: apiUrl,
        method: 'GET',
        data: {
            // Thêm tham số để lấy tất cả lịch hẹn, không giới hạn theo ngày
            getAllData: true,
            includeHistory: true,
            includeFuture: true,
            // Loại bỏ filter theo ngày
            startDate: '', 
            endDate: '',
            // Tăng page size để lấy nhiều dữ liệu hơn
            page: 1,
            size: 10000
        },
        dataType: 'json',
        timeout: 10000, // 10 seconds timeout
        success: function(data) {
            console.log('✅ Success from:', apiUrl);
            console.log('📊 Raw data received:', data);
            
            // Xử lý response có thể là array hoặc object có thuộc tính data
            let appointments = [];
            if (Array.isArray(data)) {
                appointments = data;
                console.log('📋 Data is array with', appointments.length, 'items');
            } else if (data && data.data && Array.isArray(data.data)) {
                appointments = data.data;
                console.log('📋 Data.data is array with', appointments.length, 'items');
            } else if (data && data.appointments && Array.isArray(data.appointments)) {
                appointments = data.appointments;
                console.log('📋 Data.appointments is array with', appointments.length, 'items');
            } else if (data && typeof data === 'object') {
                console.log('📋 Data is object, trying to find array property...');
                // Tìm thuộc tính là array đầu tiên
                for (let key in data) {
                    if (Array.isArray(data[key])) {
                        appointments = data[key];
                        console.log(`📋 Found array in data.${key} with`, appointments.length, 'items');
                        break;
                    }
                }
            }
            
            if (!appointments || appointments.length === 0) {
                console.log('⚠️ No appointments found from this endpoint, trying next...');
                tryApiEndpoints(apiUrls, index + 1);
                return;
            }

            console.log('🎉 Found', appointments.length, 'appointments!');
            console.log('📝 Sample appointment:', appointments[0]);

            // Chuyển đổi dữ liệu thành format event
            const events = appointments.map((appt, idx) => {
                // Xử lý title
                let title = '';
                if (appt.service && appt.service.name) {
                    title += appt.service.name;
                }
                if (appt.shiftText) {
                    title += (title ? ' - ' : '') + appt.shiftText;
                }
                if (appt.doctor && appt.doctor.user && appt.doctor.user.fullName) {
                    title += (title ? ' - BS. ' : 'BS. ') + appt.doctor.user.fullName;
                }
                if (appt.patient && appt.patient.user && appt.patient.user.fullName) {
                    title += (title ? ' - ' : '') + appt.patient.user.fullName;
                }
                if (appt.patientName) {
                    title += (title ? ' - ' : '') + appt.patientName;
                }
                if (appt.doctorName) {
                    title += (title ? ' - BS. ' : 'BS. ') + appt.doctorName;
                }
                if (appt.serviceName) {
                    title += (title ? ' - ' : '') + appt.serviceName;
                }

                // Xử lý thời gian
                let startTime = null;
                if (appt.dateTime) {
                    startTime = new Date(appt.dateTime);
                } else if (appt.appointmentDateTime) {
                    startTime = new Date(appt.appointmentDateTime);
                } else if (appt.date) {
                    startTime = new Date(appt.date);
                }

                const event = {
                    id: appt.id || `appt_${idx}`,
                    title: title || 'Lịch hẹn',
                    start: startTime,
                    extendedProps: appt
                };
                
                if (idx < 3) { // Log first 3 events for debugging
                    console.log(`📅 Event ${idx + 1}:`, event);
                }
                
                return event;
            }).filter(event => event.start); // Chỉ lấy những event có thời gian hợp lệ

            console.log('✨ Converted to', events.length, 'valid events');
            
            if (events.length === 0) {
                console.log('⚠️ No valid events after conversion, trying next endpoint...');
                tryApiEndpoints(apiUrls, index + 1);
                return;
            }
            
            generateICSFile(events);
        },
        error: function(xhr, status, error) {
            console.error(`❌ Error from ${apiUrl}:`, {
                status: xhr.status,
                statusText: xhr.statusText,
                error: error,
                responseText: xhr.responseText?.substring(0, 500) // First 500 chars
            });
            
            // Kiểm tra nếu response là HTML (lỗi đăng nhập hoặc access denied)
            if (xhr.responseText && xhr.responseText.includes('<html')) {
                alert('Phiên đăng nhập đã hết hạn hoặc bạn không có quyền truy cập. Vui lòng đăng nhập lại.');
                return;
            }
            
            // Thử endpoint tiếp theo
            console.log(`🔄 Trying next endpoint...`);
            tryApiEndpoints(apiUrls, index + 1);
        }
    });
}

function generateICSFile(events) {
    let icsContent = [
        'BEGIN:VCALENDAR',
        'VERSION:2.0',
        'PRODID:-//G3 Hospital//EN',
        'CALSCALE:GREGORIAN'
    ];

    events.forEach(event => {
        if (!event.start) return; // Skip events without start time
        
        icsContent.push('BEGIN:VEVENT');
        icsContent.push('UID:' + event.id + '@g3hospital.vn');
        icsContent.push('DTSTAMP:' + new Date().toISOString().replace(/[-:]/g, '').split('.')[0] + 'Z');
        icsContent.push('DTSTART:' + event.start.toISOString().replace(/[-:]/g, '').split('.')[0] + 'Z');
        
        // Thêm thời gian kết thúc (1 giờ sau thời gian bắt đầu)
        const endTime = new Date(event.start.getTime() + 60 * 60 * 1000);
        icsContent.push('DTEND:' + endTime.toISOString().replace(/[-:]/g, '').split('.')[0] + 'Z');
        
        // Escape special characters trong title
        const title = event.title.replace(/[,;\\]/g, '\\$&').replace(/\n/g, '\\n');
        icsContent.push('SUMMARY:' + title);
        
        // Thêm mô tả nếu có
        if (event.extendedProps && event.extendedProps.note) {
            const description = event.extendedProps.note.replace(/[,;\\]/g, '\\$&').replace(/\n/g, '\\n');
            icsContent.push('DESCRIPTION:' + description);
        }
        
        icsContent.push('END:VEVENT');
    });

    icsContent.push('END:VCALENDAR');
    
    // Tạo và download file
    const blob = new Blob([icsContent.join('\r\n')], { 
        type: 'text/calendar;charset=utf-8' 
    });
    const url = URL.createObjectURL(blob);

    const a = document.createElement('a');
    a.href = url;
    a.download = 'lich-hen-g3hospital-' + new Date().toISOString().split('T')[0] + '.ics';
    a.style.display = 'none';
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);

    // Reset sync flag ngay sau khi download
    syncInProgress = false;
    console.log('🔓 Sync completed, flag reset');

    alert('🎉 Đã xuất TOÀN BỘ lịch hẹn thành công!\n\n' +
          '📁 File: ' + a.download + '\n' +
          '📅 Tổng số: ' + events.length + ' lịch hẹn (bao gồm quá khứ & tương lai)\n\n' +
          '💡 Bạn có thể import file này vào:\n' +
          '• Google Calendar\n' +
          '• Microsoft Outlook\n' +
          '• Apple Calendar\n' +
          '• Các ứng dụng lịch khác hỗ trợ định dạng .ics');
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

    // Thêm event listener cho tất cả các nút đồng bộ có thể có
    document.querySelectorAll('#syncCalendarBtn, .sync-calendar-btn, [data-action="sync-calendar"]').forEach(btn => {
        if (!btn.hasAttribute('data-listener-added')) {
            btn.setAttribute('data-listener-added', 'true');
            btn.addEventListener('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                console.log('🖱️ Sync button clicked:', btn.id || btn.className);
                syncWithExternalCalendar();
            });
        }
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

    // Fetch doctor list for filter - simplified
    function loadDoctorsForFilter() {
        console.log('🔍 Loading filters (simplified without doctor filter)...');
        populateFilters('receptionistDashboard');
    }

    // Fetch and render appointments
    function loadAppointments(page = 1, loadAll = false) {
        const doctorId = document.getElementById('filterDoctor').value;
        const date = document.getElementById('filterDate').value;
        const status = document.getElementById('filterStatus').value;
        
        const params = {
            doctorId, 
            date: loadAll ? '' : date, // Bỏ filter ngày khi loadAll
            status, 
            page, 
            size: loadAll ? 10000 : pageSize // Tăng size khi loadAll
        };
        
        if (loadAll) {
            params.getAllData = true;
            params.includeHistory = true;
            params.includeFuture = true;
        }
        
        $.get(contextPath + '/api/receptionist/appointments', params, function(resp) {
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
            displayEventTime: false,
            eventTimeFormat: { hour: '2-digit', minute: '2-digit', meridiem: false },
            views: {
                dayGridMonth: { displayEventTime: false },
                timeGridWeek: { displayEventTime: false },
                timeGridDay: { displayEventTime: false }
            },
            events: events
        });
        window.receptionistCalendar.render();
    }

    // Render table
    function renderTable(appointments) {
        const tableBody = document.querySelector('#appointmentTable tbody');
        if (!tableBody) return;
        tableBody.innerHTML = '';
        if (!appointments || appointments.length === 0) {
            tableBody.innerHTML = '<tr><td colspan="8" class="text-center">Không có lịch hẹn nào</td></tr>';
            return;
        }
        appointments.forEach((appointment, index) => {
            const row = document.createElement('tr');
            // Format ngày tháng
            let formattedDate = '';
            if (appointment.date) {
                const date = new Date(appointment.date);
                formattedDate = date.toLocaleDateString('vi-VN', {
                    weekday: 'long', year: 'numeric', month: 'long', day: 'numeric'
                });
            }
            // Lấy tên trạng thái tiếng Việt
            const statusDisplay = getStatusDisplay(appointment.status);
            // Lấy badge màu trạng thái
            const statusBadge = `<span class="badge ${getStatusBadgeClass(appointment.status)}">${statusDisplay}</span>`;
            // Lấy badge ca làm
            const shiftBadge = `<span class="badge bg-primary">${appointment.shift || ''}</span>`;
            // Render row
            row.innerHTML = `
                <td class="text-center">${appointment.queueNumber}</td>
                <td>${formattedDate}</td>
                <td class="text-center">${shiftBadge}</td>
                <td>${appointment.patientName || 'N/A'}</td>
                ${appointment.doctorName !== undefined ? `<td>${appointment.doctorName || 'N/A'}</td>` : ''}
                <td>${appointment.serviceName || 'N/A'}</td>
                <td class="text-center">${statusBadge}</td>
                <td class="text-center">
                    <button class="btn btn-sm btn-info" onclick="viewDetails(${appointment.id})">
                        <i class="bi bi-eye"></i> Xem chi tiết
                    </button>
                    ${roleId === 3 ? `
                        <button class="btn btn-sm btn-warning" onclick="updateStatus(${appointment.id}, 'pending')">
                            <i class="bi bi-clock"></i>
                        </button>
                        <button class="btn btn-sm btn-success" onclick="updateStatus(${appointment.id}, 'completed')">
                            <i class="bi bi-check"></i>
                        </button>
                        <button class="btn btn-sm btn-danger" onclick="updateStatus(${appointment.id}, 'canceled')">
                            <i class="bi bi-x"></i>
                        </button>
                    ` : ''}
                </td>
            `;
            tableBody.appendChild(row);
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

    // Thêm event listener cho nút đồng bộ
    $(document).ready(function() {
        const syncBtn = document.getElementById('syncCalendarBtn');
        if (syncBtn && !syncBtn.hasAttribute('data-listener-added')) {
            syncBtn.setAttribute('data-listener-added', 'true');
            syncBtn.addEventListener('click', function() {
                console.log('Sync button clicked from receptionist dashboard');
                syncWithExternalCalendar();
            });
        }
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
            displayEventTime: false,
            eventTimeFormat: { hour: '2-digit', minute: '2-digit', meridiem: false },
            views: {
                dayGridMonth: { displayEventTime: false },
                timeGridWeek: { displayEventTime: false },
                timeGridDay: { displayEventTime: false }
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
    function renderTable(appointments) {
        const tableBody = document.querySelector('#appointmentTable tbody');
        if (!tableBody) return;
        tableBody.innerHTML = '';
        if (!appointments || appointments.length === 0) {
            tableBody.innerHTML = '<tr><td colspan="8" class="text-center">Không có lịch hẹn nào</td></tr>';
            return;
        }
        appointments.forEach((appointment, index) => {
            const row = document.createElement('tr');
            // Format ngày tháng
            let formattedDate = '';
            if (appointment.date) {
                const date = new Date(appointment.date);
                formattedDate = date.toLocaleDateString('vi-VN', {
                    weekday: 'long', year: 'numeric', month: 'long', day: 'numeric'
                });
            }
            // Lấy tên trạng thái tiếng Việt
            const statusDisplay = getStatusDisplay(appointment.status);
            // Lấy badge màu trạng thái
            const statusBadge = `<span class="badge ${getStatusBadgeClass(appointment.status)}">${statusDisplay}</span>`;
            // Lấy badge ca làm
            const shiftBadge = `<span class="badge bg-primary">${appointment.shift || ''}</span>`;
            // Render row
            row.innerHTML = `
                <td class="text-center">${appointment.queueNumber}</td>
                <td>${formattedDate}</td>
                <td class="text-center">${shiftBadge}</td>
                <td>${appointment.patientName || 'N/A'}</td>
                ${appointment.doctorName !== undefined ? `<td>${appointment.doctorName || 'N/A'}</td>` : ''}
                <td>${appointment.serviceName || 'N/A'}</td>
                <td class="text-center">${statusBadge}</td>
                <td class="text-center">
                    <button class="btn btn-sm btn-info" onclick="viewDetails(${appointment.id})">
                        <i class="bi bi-eye"></i> Xem chi tiết
                    </button>
                    ${roleId === 3 ? `
                        <button class="btn btn-sm btn-warning" onclick="updateStatus(${appointment.id}, 'pending')">
                            <i class="bi bi-clock"></i>
                        </button>
                        <button class="btn btn-sm btn-success" onclick="updateStatus(${appointment.id}, 'completed')">
                            <i class="bi bi-check"></i>
                        </button>
                        <button class="btn btn-sm btn-danger" onclick="updateStatus(${appointment.id}, 'canceled')">
                            <i class="bi bi-x"></i>
                        </button>
                    ` : ''}
                </td>
            `;
            tableBody.appendChild(row);
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

    // Thêm event listener cho nút đồng bộ
    $(document).ready(function() {
        const syncBtn = document.getElementById('syncCalendarBtn');
        if (syncBtn && !syncBtn.hasAttribute('data-listener-added')) {
            syncBtn.setAttribute('data-listener-added', 'true');
            syncBtn.addEventListener('click', function() {
                console.log('Sync button clicked from doctor dashboard');
                syncWithExternalCalendar();
            });
        }
    });

    // Init
    $(function() {
        loadAppointments(1);
    });
}

function getStatusBadgeClass(status) {
    switch (status) {
        case 'pending': return 'bg-warning';
        case 'completed': return 'bg-success';
        case 'canceled': return 'bg-danger';
        default: return 'bg-secondary';
    }
}

// Global function to manually populate filters (for debugging)
window.debugPopulateFilters = function() {
    console.log('🔧 Manual filter population triggered');
    populateFilters('receptionistDashboard');
};

// Examination Packages Filter
function initPackageFilter() {
    const searchInput = document.getElementById('searchInput');
    const priceFilter = document.getElementById('priceFilter');
    const durationFilter = document.getElementById('durationFilter');
    const packageItems = document.querySelectorAll('.package-item');

    if (!searchInput || !priceFilter || !durationFilter || packageItems.length === 0) {
        return; // Exit if elements don't exist
    }

    function filterPackages() {
        const searchTerm = searchInput.value.toLowerCase();
        const priceRange = priceFilter.value;
        const durationRange = durationFilter.value;

        packageItems.forEach(item => {
            const name = item.dataset.name;
            const price = parseInt(item.dataset.price);
            const duration = parseInt(item.dataset.duration);

            let showItem = true;

            // Search filter
            if (searchTerm && !name.includes(searchTerm)) {
                showItem = false;
            }

            // Price filter
            if (priceRange) {
                const [min, max] = priceRange.split('-').map(p => p === '+' ? Infinity : parseInt(p));
                if (price < min || (max !== Infinity && price > max)) {
                    showItem = false;
                }
            }

            // Duration filter
            if (durationRange) {
                const [min, max] = durationRange.split('-').map(d => d === '+' ? Infinity : parseInt(d));
                if (duration < min || (max !== Infinity && duration > max)) {
                    showItem = false;
                }
            }

            item.style.display = showItem ? 'block' : 'none';
        });
    }

    searchInput.addEventListener('input', filterPackages);
    priceFilter.addEventListener('change', filterPackages);
    durationFilter.addEventListener('change', filterPackages);
}

// Initialize package filter when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    initPackageFilter();
});