// Admin Working Schedules Management JavaScript
document.addEventListener('DOMContentLoaded', function() {
    // Load schedules on page load
    loadSchedules();
    
    // Event listeners
    setupEventListeners();
});

function setupEventListeners() {
    // Add schedule form
    const addScheduleForm = document.getElementById('addScheduleForm');
    if (addScheduleForm) {
        addScheduleForm.addEventListener('submit', handleAddSchedule);
    }
    
    // Edit schedule form
    const editScheduleForm = document.getElementById('editScheduleForm');
    if (editScheduleForm) {
        editScheduleForm.addEventListener('submit', handleEditSchedule);
    }
    
    // Filter inputs
    const doctorFilter = document.getElementById('doctorFilter');
    if (doctorFilter) {
        doctorFilter.addEventListener('change', filterSchedules);
    }
    
    const dayFilter = document.getElementById('dayFilter');
    if (dayFilter) {
        dayFilter.addEventListener('change', filterSchedules);
    }
    
    const shiftFilter = document.getElementById('shiftFilter');
    if (shiftFilter) {
        shiftFilter.addEventListener('change', filterSchedules);
    }
    
    // Search input
    const searchInput = document.getElementById('searchInput');
    if (searchInput) {
        searchInput.addEventListener('input', filterSchedules);
    }
}

function loadSchedules() {
    // Hiển thị loading
    showLoading();
    
    // Gọi API để lấy danh sách lịch làm việc
    fetch(`${window.contextPath}/admin/working-schedules?action=list`, {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json',
        }
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        return response.json();
    })
    .then(data => {
        displaySchedules(data.schedules || []);
        loadDoctors(data.doctors || []);
        loadShifts(data.shifts || []);
    })
    .catch(error => {
        console.error('Error loading schedules:', error);
        // Fallback to mock data for now
        displaySchedules(getMockSchedules());
        loadDoctors(getMockDoctors());
        loadShifts(getMockShifts());
    })
    .finally(() => {
        hideLoading();
    });
}

function displaySchedules(schedules) {
    const tbody = document.querySelector('#schedulesTable tbody');
    if (!tbody) return;
    
    tbody.innerHTML = '';
    
    if (schedules.length === 0) {
        tbody.innerHTML = '<tr><td colspan="8" class="text-center">Không có lịch làm việc nào</td></tr>';
        return;
    }
    
    schedules.forEach(schedule => {
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${schedule.doctorName || 'N/A'}</td>
            <td>${schedule.dayOfWeek || 'N/A'}</td>
            <td>${schedule.shiftName || 'N/A'}</td>
            <td>${schedule.startTime || 'N/A'}</td>
            <td>${schedule.endTime || 'N/A'}</td>
            <td>
                <span class="badge ${schedule.isActive ? 'bg-success' : 'bg-secondary'}">
                    ${schedule.isActive ? 'Hoạt động' : 'Không hoạt động'}
                </span>
            </td>
            <td>${schedule.createdDate || 'N/A'}</td>
            <td>
                <button class="btn btn-sm btn-info" onclick="viewScheduleDetail(${schedule.scheduleId})">
                    <i class="bi bi-eye"></i>
                </button>
                <button class="btn btn-sm btn-warning" onclick="editSchedule(${schedule.scheduleId})">
                    <i class="bi bi-pencil"></i>
                </button>
                <button class="btn btn-sm btn-danger" onclick="deleteSchedule(${schedule.scheduleId})">
                    <i class="bi bi-trash"></i>
                </button>
            </td>
        `;
        tbody.appendChild(row);
    });
}

function loadDoctors(doctors) {
    const doctorFilter = document.getElementById('doctorFilter');
    const doctorSelect = document.getElementById('doctorId');
    
    if (doctorFilter) {
        doctorFilter.innerHTML = '<option value="">Tất cả bác sĩ</option>';
        doctors.forEach(doctor => {
            doctorFilter.innerHTML += `<option value="${doctor.doctorId}">${doctor.fullName}</option>`;
        });
    }
    
    if (doctorSelect) {
        doctorSelect.innerHTML = '<option value="">Chọn bác sĩ</option>';
        doctors.forEach(doctor => {
            doctorSelect.innerHTML += `<option value="${doctor.doctorId}">${doctor.fullName}</option>`;
        });
    }
}

function loadShifts(shifts) {
    const shiftFilter = document.getElementById('shiftFilter');
    const shiftSelect = document.getElementById('shiftId');
    
    if (shiftFilter) {
        shiftFilter.innerHTML = '<option value="">Tất cả ca</option>';
        shifts.forEach(shift => {
            shiftFilter.innerHTML += `<option value="${shift.shiftId}">${shift.name}</option>`;
        });
    }
    
    if (shiftSelect) {
        shiftSelect.innerHTML = '<option value="">Chọn ca</option>';
        shifts.forEach(shift => {
            shiftSelect.innerHTML += `<option value="${shift.shiftId}">${shift.name}</option>`;
        });
    }
}

function handleAddSchedule(event) {
    event.preventDefault();
    
    const formData = new FormData(event.target);
    const data = Object.fromEntries(formData.entries());
    
    // Validation
    if (!data.doctorId || !data.dayOfWeek || !data.shiftId) {
        showAlert('Vui lòng điền đầy đủ thông tin bắt buộc', 'error');
        return;
    }
    
    // Gọi API để thêm lịch làm việc
    fetch(`${window.contextPath}/admin/working-schedules`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(data)
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        return response.json();
    })
    .then(result => {
        if (result.success) {
            showAlert('Thêm lịch làm việc thành công!', 'success');
            closeModal('addScheduleModal');
            loadSchedules();
            event.target.reset();
        } else {
            showAlert(result.message || 'Có lỗi xảy ra', 'error');
        }
    })
    .catch(error => {
        console.error('Error adding schedule:', error);
        showAlert('Có lỗi xảy ra khi thêm lịch làm việc', 'error');
    });
}

function handleEditSchedule(event) {
    event.preventDefault();
    
    const formData = new FormData(event.target);
    const data = Object.fromEntries(formData.entries());
    
    // Validation
    if (!data.scheduleId || !data.doctorId || !data.dayOfWeek || !data.shiftId) {
        showAlert('Vui lòng điền đầy đủ thông tin bắt buộc', 'error');
        return;
    }
    
    // Gọi API để cập nhật lịch làm việc
    fetch(`${window.contextPath}/admin/working-schedules`, {
        method: 'PUT',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(data)
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        return response.json();
    })
    .then(result => {
        if (result.success) {
            showAlert('Cập nhật lịch làm việc thành công!', 'success');
            closeModal('editScheduleModal');
            loadSchedules();
        } else {
            showAlert(result.message || 'Có lỗi xảy ra', 'error');
        }
    })
    .catch(error => {
        console.error('Error updating schedule:', error);
        showAlert('Có lỗi xảy ra khi cập nhật lịch làm việc', 'error');
    });
}

function editSchedule(scheduleId) {
    // Gọi API để lấy thông tin lịch làm việc
    fetch(`${window.contextPath}/admin/working-schedules?action=edit&id=${scheduleId}`, {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json',
        }
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        return response.json();
    })
    .then(schedule => {
        // Điền thông tin vào form
        document.getElementById('editScheduleId').value = schedule.scheduleId;
        document.getElementById('editDoctorId').value = schedule.doctorId;
        document.getElementById('editDayOfWeek').value = schedule.dayOfWeek;
        document.getElementById('editShiftId').value = schedule.shiftId;
        document.getElementById('editIsActive').checked = schedule.isActive;
        
        openModal('editScheduleModal');
    })
    .catch(error => {
        console.error('Error loading schedule:', error);
        showAlert('Có lỗi xảy ra khi tải thông tin lịch làm việc', 'error');
    });
}

function deleteSchedule(scheduleId) {
    if (confirm('Bạn có chắc chắn muốn xóa lịch làm việc này?')) {
        fetch(`${window.contextPath}/admin/working-schedules?action=delete&id=${scheduleId}`, {
            method: 'DELETE',
            headers: {
                'Content-Type': 'application/json',
            }
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(result => {
            if (result.success) {
                showAlert('Xóa lịch làm việc thành công!', 'success');
                loadSchedules();
            } else {
                showAlert(result.message || 'Có lỗi xảy ra', 'error');
            }
        })
        .catch(error => {
            console.error('Error deleting schedule:', error);
            showAlert('Có lỗi xảy ra khi xóa lịch làm việc', 'error');
        });
    }
}

function viewScheduleDetail(scheduleId) {
    // Gọi API để lấy chi tiết lịch làm việc
    fetch(`${window.contextPath}/admin/working-schedules?action=detail&id=${scheduleId}`, {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json',
        }
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        return response.json();
    })
    .then(schedule => {
        // Hiển thị thông tin trong modal
        document.getElementById('detailDoctorName').textContent = schedule.doctorName;
        document.getElementById('detailDayOfWeek').textContent = schedule.dayOfWeek;
        document.getElementById('detailShiftName').textContent = schedule.shiftName;
        document.getElementById('detailStartTime').textContent = schedule.startTime;
        document.getElementById('detailEndTime').textContent = schedule.endTime;
        document.getElementById('detailIsActive').textContent = schedule.isActive ? 'Hoạt động' : 'Không hoạt động';
        document.getElementById('detailCreatedDate').textContent = schedule.createdDate;
        
        openModal('scheduleDetailModal');
    })
    .catch(error => {
        console.error('Error loading schedule detail:', error);
        showAlert('Có lỗi xảy ra khi tải thông tin chi tiết', 'error');
    });
}

function filterSchedules() {
    const doctorFilter = document.getElementById('doctorFilter').value;
    const dayFilter = document.getElementById('dayFilter').value;
    const shiftFilter = document.getElementById('shiftFilter').value;
    const searchTerm = document.getElementById('searchInput').value.toLowerCase();
    
    const rows = document.querySelectorAll('#schedulesTable tbody tr');
    
    rows.forEach(row => {
        const doctorName = row.cells[0].textContent.toLowerCase();
        const dayOfWeek = row.cells[1].textContent.toLowerCase();
        const shiftName = row.cells[2].textContent.toLowerCase();
        
        const matchesDoctor = !doctorFilter || doctorName.includes(doctorFilter.toLowerCase());
        const matchesDay = !dayFilter || dayOfWeek.includes(dayFilter.toLowerCase());
        const matchesShift = !shiftFilter || shiftName.includes(shiftFilter.toLowerCase());
        const matchesSearch = !searchTerm || 
            doctorName.includes(searchTerm) || 
            dayOfWeek.includes(searchTerm) || 
            shiftName.includes(searchTerm);
        
        if (matchesDoctor && matchesDay && matchesShift && matchesSearch) {
            row.style.display = '';
        } else {
            row.style.display = 'none';
        }
    });
}

// Utility functions
function openModal(modalId) {
    const modal = document.getElementById(modalId);
    if (modal) {
        const bootstrapModal = new bootstrap.Modal(modal);
        bootstrapModal.show();
    }
}

function closeModal(modalId) {
    const modal = document.getElementById(modalId);
    if (modal) {
        const bootstrapModal = bootstrap.Modal.getInstance(modal);
        if (bootstrapModal) {
            bootstrapModal.hide();
        }
    }
}

function showAlert(message, type) {
    // Sử dụng toastr nếu có
    if (typeof toastr !== 'undefined') {
        toastr[type](message);
    } else {
        alert(message);
    }
}

function showLoading() {
    const loading = document.getElementById('loading');
    if (loading) {
        loading.style.display = 'block';
    }
}

function hideLoading() {
    const loading = document.getElementById('loading');
    if (loading) {
        loading.style.display = 'none';
    }
}

// Mock data functions (fallback)
function getMockSchedules() {
    return [
        {
            scheduleId: 1,
            doctorName: 'Dr. Nguyễn Văn A',
            dayOfWeek: 'Thứ 2',
            shiftName: 'Ca sáng',
            startTime: '08:00',
            endTime: '12:00',
            isActive: true,
            createdDate: '2024-01-15'
        },
        {
            scheduleId: 2,
            doctorName: 'Dr. Trần Thị B',
            dayOfWeek: 'Thứ 3',
            shiftName: 'Ca chiều',
            startTime: '13:00',
            endTime: '17:00',
            isActive: true,
            createdDate: '2024-01-16'
        }
    ];
}

function getMockDoctors() {
    return [
        { doctorId: 1, fullName: 'Dr. Nguyễn Văn A' },
        { doctorId: 2, fullName: 'Dr. Trần Thị B' },
        { doctorId: 3, fullName: 'Dr. Lê Văn C' }
    ];
}

function getMockShifts() {
    return [
        { shiftId: 1, name: 'Ca sáng' },
        { shiftId: 2, name: 'Ca chiều' },
        { shiftId: 3, name: 'Ca tối' }
    ];
} 