// Admin Working Schedules Management JavaScript
document.addEventListener('DOMContentLoaded', function() {
    // Initialize event listeners
    initializeEventListeners();
    
    // Update statistics
    updateStatistics();
});

function initializeEventListeners() {
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
    
    // Filter events
    document.getElementById('filterDoctor')?.addEventListener('change', filterSchedules);
    document.getElementById('filterWeekDay')?.addEventListener('change', filterSchedules);
    document.getElementById('filterShift')?.addEventListener('change', filterSchedules);
    document.getElementById('filterStatus')?.addEventListener('change', filterSchedules);
}

// Handle add schedule
function handleAddSchedule(e) {
    e.preventDefault();
    
    const formData = new FormData(e.target);
    const data = Object.fromEntries(formData.entries());
    
    // Validate form
    if (!validateScheduleForm(data)) {
        return;
    }
    
    // Show loading
    const submitBtn = e.target.querySelector('button[type="submit"]');
    const originalText = submitBtn.innerHTML;
    submitBtn.innerHTML = '<i class="bi bi-hourglass-split"></i> Đang xử lý...';
    submitBtn.disabled = true;
    
    // Submit form (will be handled by backend later)
    console.log('Adding schedule:', data);
    
    // For now, show success message
    setTimeout(() => {
        showAlert('Thêm lịch làm việc thành công!', 'success');
        bootstrap.Modal.getInstance(document.getElementById('addScheduleModal')).hide();
        e.target.reset();
        submitBtn.innerHTML = originalText;
        submitBtn.disabled = false;
    }, 1000);
}

// Handle edit schedule
function handleEditSchedule(e) {
    e.preventDefault();
    
    const formData = new FormData(e.target);
    const data = Object.fromEntries(formData.entries());
    
    // Validate form
    if (!validateScheduleForm(data)) {
        return;
    }
    
    // Show loading
    const submitBtn = e.target.querySelector('button[type="submit"]');
    const originalText = submitBtn.innerHTML;
    submitBtn.innerHTML = '<i class="bi bi-hourglass-split"></i> Đang xử lý...';
    submitBtn.disabled = true;
    
    // Submit form (will be handled by backend later)
    console.log('Updating schedule:', data);
    
    // For now, show success message
    setTimeout(() => {
        showAlert('Cập nhật lịch làm việc thành công!', 'success');
        bootstrap.Modal.getInstance(document.getElementById('editScheduleModal')).hide();
        submitBtn.innerHTML = originalText;
        submitBtn.disabled = false;
    }, 1000);
}

// Validate schedule form
function validateScheduleForm(data) {
    if (!data.doctorId) {
        showAlert('Vui lòng chọn bác sĩ!', 'danger');
        return false;
    }
    
    if (!data.weekDay) {
        showAlert('Vui lòng chọn thứ!', 'danger');
        return false;
    }
    
    if (!data.shiftId) {
        showAlert('Vui lòng chọn ca làm việc!', 'danger');
        return false;
    }
    
    if (!data.maxPatients || data.maxPatients < 1 || data.maxPatients > 50) {
        showAlert('Số bệnh nhân tối đa phải từ 1-50!', 'danger');
        return false;
    }
    
    return true;
}

// View schedule detail
function viewScheduleDetail(scheduleId) {
    // Load schedule detail (will be handled by backend later)
    console.log('Viewing schedule detail:', scheduleId);
    
    // For now, show mock data
    const content = `
        <div class="row">
            <div class="col-md-6">
                <h6>Thông tin cơ bản</h6>
                <p><strong>ID:</strong> ${scheduleId}</p>
                <p><strong>Bác sĩ:</strong> Dr. Nguyễn Văn A</p>
                <p><strong>Thứ:</strong> Thứ 2</p>
                <p><strong>Ca làm việc:</strong> Sáng (08:00 - 12:00)</p>
                <p><strong>Số BN tối đa:</strong> 15</p>
                <p><strong>Trạng thái:</strong> <span class="badge bg-success">Hoạt động</span></p>
            </div>
            <div class="col-md-6">
                <h6>Thống kê</h6>
                <p><strong>Ngày tạo:</strong> 31/05/2025</p>
                <p><strong>Lần cập nhật cuối:</strong> 31/05/2025</p>
                <p><strong>Số lịch hẹn đã đặt:</strong> 8</p>
                <p><strong>Số lịch hẹn đã hoàn thành:</strong> 6</p>
            </div>
        </div>
    `;
    
    document.getElementById('scheduleDetailContent').innerHTML = content;
    new bootstrap.Modal(document.getElementById('scheduleDetailModal')).show();
}

// Edit schedule
function editSchedule(scheduleId) {
    // Load schedule data (will be handled by backend later)
    console.log('Editing schedule:', scheduleId);
    
    // For now, populate with mock data
    document.getElementById('editScheduleId').value = scheduleId;
    document.getElementById('editDoctorId').value = '1';
    document.getElementById('editWeekDay').value = 'Thứ 2';
    document.getElementById('editShiftId').value = '1';
    document.getElementById('editMaxPatients').value = '15';
    document.getElementById('editIsActive').checked = true;
    
    new bootstrap.Modal(document.getElementById('editScheduleModal')).show();
}

// Delete schedule
function deleteSchedule(scheduleId) {
    if (confirm('Bạn có chắc chắn muốn xóa lịch làm việc này không?')) {
        // Delete schedule (will be handled by backend later)
        console.log('Deleting schedule:', scheduleId);
        
        // For now, show success message
        showAlert('Xóa lịch làm việc thành công!', 'success');
        
        // Remove row from table
        const row = document.querySelector(`tr[data-schedule-id="${scheduleId}"]`);
        if (row) {
            row.remove();
        }
    }
}

// Filter schedules
function filterSchedules() {
    const doctorFilter = document.getElementById('filterDoctor').value;
    const weekDayFilter = document.getElementById('filterWeekDay').value;
    const shiftFilter = document.getElementById('filterShift').value;
    const statusFilter = document.getElementById('filterStatus').value;
    
    const rows = document.querySelectorAll('#scheduleTableBody tr');
    
    rows.forEach(row => {
        if (row.cells.length < 8) return; // Skip empty rows
        
        const doctor = row.cells[1].textContent.trim();
        const weekDay = row.cells[2].textContent.trim();
        const shift = row.cells[3].textContent.trim();
        const status = row.cells[6].textContent.trim();
        
        const matchesDoctor = !doctorFilter || doctor.includes(doctorFilter);
        const matchesWeekDay = !weekDayFilter || weekDay === weekDayFilter;
        const matchesShift = !shiftFilter || shift.includes(shiftFilter);
        const matchesStatus = !statusFilter || 
            (statusFilter === 'true' && status.includes('Hoạt động')) ||
            (statusFilter === 'false' && status.includes('Tạm dừng'));
        
        row.style.display = (matchesDoctor && matchesWeekDay && matchesShift && matchesStatus) ? '' : 'none';
    });
}

// Reset filters
function resetFilters() {
    document.getElementById('filterDoctor').value = '';
    document.getElementById('filterWeekDay').value = '';
    document.getElementById('filterShift').value = '';
    document.getElementById('filterStatus').value = '';
    
    const rows = document.querySelectorAll('#scheduleTableBody tr');
    rows.forEach(row => {
        row.style.display = '';
    });
}

// Update statistics
function updateStatistics() {
    const rows = document.querySelectorAll('#scheduleTableBody tr');
    let totalSchedules = 0;
    let activeSchedules = 0;
    let inactiveSchedules = 0;
    
    rows.forEach(row => {
        if (row.cells.length >= 8) {
            totalSchedules++;
            const status = row.cells[6].textContent.trim();
            if (status.includes('Hoạt động')) {
                activeSchedules++;
            } else if (status.includes('Tạm dừng')) {
                inactiveSchedules++;
            }
        }
    });
    
    // Update statistics display if exists
    const totalElement = document.getElementById('totalSchedules');
    const activeElement = document.getElementById('activeSchedules');
    const inactiveElement = document.getElementById('inactiveSchedules');
    
    if (totalElement) totalElement.textContent = totalSchedules;
    if (activeElement) activeElement.textContent = activeSchedules;
    if (inactiveElement) inactiveElement.textContent = inactiveSchedules;
}

// Show alert
function showAlert(message, type = 'success') {
    // Remove existing alerts
    const existingAlerts = document.querySelectorAll('.alert');
    existingAlerts.forEach(alert => alert.remove());
    
    // Create new alert
    const alertDiv = document.createElement('div');
    alertDiv.className = `alert alert-${type} alert-dismissible fade show`;
    alertDiv.role = 'alert';
    alertDiv.innerHTML = `
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;
    
    // Insert at the top of content
    const content = document.querySelector('.content');
    content.insertBefore(alertDiv, content.firstChild);
    
    // Auto remove after 5 seconds
    setTimeout(() => {
        alertDiv.remove();
    }, 5000);
}

// Export functions for global access
window.viewScheduleDetail = viewScheduleDetail;
window.editSchedule = editSchedule;
window.deleteSchedule = deleteSchedule;
window.filterSchedules = filterSchedules;
window.resetFilters = resetFilters; 