// Admin Shifts Management JavaScript
document.addEventListener('DOMContentLoaded', function() {
    initializeShiftsPage();
});

function initializeShiftsPage() {
    // Initialize tooltips
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });

    // Initialize form validation
    setupFormValidation();
    
    // Initialize real-time validation
    setupRealTimeValidation();
}

function setupFormValidation() {
    const addForm = document.querySelector('#addShiftModal form');
    const editForm = document.querySelector('#editShiftModal form');
    
    if (addForm) {
        addForm.addEventListener('submit', validateShiftForm);
    }
    
    if (editForm) {
        editForm.addEventListener('submit', validateShiftForm);
    }
}

function validateShiftForm(event) {
    const form = event.target;
    const name = form.querySelector('[name="name"]').value.trim();
    const startTime = form.querySelector('[name="startTime"]').value;
    const endTime = form.querySelector('[name="endTime"]').value;
    
    // Clear previous error messages
    clearFormErrors(form);
    
    let isValid = true;
    
    // Validate name
    if (!name) {
        showFieldError(form, 'name', 'Tên ca làm việc là bắt buộc');
        isValid = false;
    } else if (name.length < 2) {
        showFieldError(form, 'name', 'Tên ca làm việc phải có ít nhất 2 ký tự');
        isValid = false;
    }
    
    // Validate time
    if (!startTime) {
        showFieldError(form, 'startTime', 'Giờ bắt đầu là bắt buộc');
        isValid = false;
    }
    
    if (!endTime) {
        showFieldError(form, 'endTime', 'Giờ kết thúc là bắt buộc');
        isValid = false;
    }
    
    if (startTime && endTime && startTime >= endTime) {
        showFieldError(form, 'endTime', 'Giờ kết thúc phải lớn hơn giờ bắt đầu');
        isValid = false;
    }
    
    if (!isValid) {
        event.preventDefault();
        showAlert('Vui lòng kiểm tra lại thông tin nhập vào', 'danger');
    }
}

function setupRealTimeValidation() {
    // Real-time name validation
    const nameInputs = document.querySelectorAll('[name="name"]');
    nameInputs.forEach(input => {
        input.addEventListener('blur', function() {
            validateShiftName(this);
        });
    });
    
    // Real-time time validation
    const timeInputs = document.querySelectorAll('[name="startTime"], [name="endTime"]');
    timeInputs.forEach(input => {
        input.addEventListener('change', function() {
            validateTimeRange(this);
        });
    });
}

function validateShiftName(input) {
    const name = input.value.trim();
    const form = input.closest('form');
    
    if (name && name.length < 2) {
        showFieldError(form, input.name, 'Tên ca làm việc phải có ít nhất 2 ký tự');
        return false;
    }
    
    clearFieldError(form, input.name);
    return true;
}

function validateTimeRange(input) {
    const form = input.closest('form');
    const startTime = form.querySelector('[name="startTime"]').value;
    const endTime = form.querySelector('[name="endTime"]').value;
    
    if (startTime && endTime && startTime >= endTime) {
        showFieldError(form, 'endTime', 'Giờ kết thúc phải lớn hơn giờ bắt đầu');
        return false;
    }
    
    clearFieldError(form, 'endTime');
    return true;
}

function showFieldError(form, fieldName, message) {
    const field = form.querySelector(`[name="${fieldName}"]`);
    if (field) {
        field.classList.add('is-invalid');
        
        // Remove existing error message
        const existingError = field.parentNode.querySelector('.invalid-feedback');
        if (existingError) {
            existingError.remove();
        }
        
        // Add new error message
        const errorDiv = document.createElement('div');
        errorDiv.className = 'invalid-feedback';
        errorDiv.textContent = message;
        field.parentNode.appendChild(errorDiv);
    }
}

function clearFieldError(form, fieldName) {
    const field = form.querySelector(`[name="${fieldName}"]`);
    if (field) {
        field.classList.remove('is-invalid');
        const errorDiv = field.parentNode.querySelector('.invalid-feedback');
        if (errorDiv) {
            errorDiv.remove();
        }
    }
}

function clearFormErrors(form) {
    const invalidFields = form.querySelectorAll('.is-invalid');
    invalidFields.forEach(field => {
        field.classList.remove('is-invalid');
    });
    
    const errorMessages = form.querySelectorAll('.invalid-feedback');
    errorMessages.forEach(error => {
        error.remove();
    });
}

function showAlert(message, type = 'info') {
    const alertContainer = document.createElement('div');
    alertContainer.className = `alert alert-${type} alert-dismissible fade show`;
    alertContainer.innerHTML = `
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;
    
    const content = document.querySelector('.content');
    content.insertBefore(alertContainer, content.firstChild);
    
    // Auto remove after 5 seconds
    setTimeout(() => {
        if (alertContainer.parentNode) {
            alertContainer.remove();
        }
    }, 5000);
}

// AJAX functions for shift management
function loadShiftData(shiftId) {
    return fetch(`${getContextPath()}/admin/shifts?action=get&id=${shiftId}`)
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        });
}

function loadShiftDetail(shiftId) {
    return fetch(`${getContextPath()}/admin/shifts?action=detail&id=${shiftId}`)
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.text();
        });
}

function deleteShift(shiftId, btn) {
    const shiftName = btn.getAttribute('data-shift-name');
    if (confirm(`Bạn có chắc chắn muốn xóa ca làm việc "${shiftName}"?`)) {
        window.location.href = `${getContextPath()}/admin/shifts?action=delete&id=${shiftId}`;
    }
}

function editShift(shiftId) {
    loadShiftData(shiftId)
        .then(data => {
            populateEditForm(data);
            const editModal = new bootstrap.Modal(document.getElementById('editShiftModal'));
            editModal.show();
        })
        .catch(error => {
            console.error('Error loading shift data:', error);
            showAlert('Có lỗi xảy ra khi tải thông tin ca làm việc', 'danger');
        });
}

function viewShiftDetail(shiftId) {
    loadShiftDetail(shiftId)
        .then(data => {
            document.getElementById('shiftDetailContent').innerHTML = data;
            const detailModal = new bootstrap.Modal(document.getElementById('shiftDetailModal'));
            detailModal.show();
        })
        .catch(error => {
            console.error('Error loading shift detail:', error);
            showAlert('Có lỗi xảy ra khi tải chi tiết ca làm việc', 'danger');
        });
}

function populateEditForm(data) {
    document.getElementById('editShiftId').value = data.shiftId;
    document.getElementById('editName').value = data.name;

    // Xử lý startTime, endTime về dạng HH:mm (24h)
    let start = '';
    let end = '';
    if (data.startTime) {
        // Lấy đúng HH:mm từ HH:mm:ss hoặc HH:mm:ss.SSS
        const match = data.startTime.match(/^([0-9]{2}):([0-9]{2})/);
        start = match ? `${match[1]}:${match[2]}` : '';
    }
    if (data.endTime) {
        const match = data.endTime.match(/^([0-9]{2}):([0-9]{2})/);
        end = match ? `${match[1]}:${match[2]}` : '';
    }

    document.getElementById('editStartTime').value = start;
    document.getElementById('editEndTime').value = end;
    document.getElementById('editDescription').value = data.description || '';
}

function getContextPath() {
    return window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2));
}

// Utility functions
function formatTime(timeString) {
    if (!timeString) return '';
    const time = new Date(`2000-01-01T${timeString}`);
    return time.toLocaleTimeString('vi-VN', { 
        hour: '2-digit', 
        minute: '2-digit' 
    });
}

function formatDateTime(dateTimeString) {
    if (!dateTimeString) return '';
    const date = new Date(dateTimeString);
    return date.toLocaleString('vi-VN');
}

// Export functions for global access
window.shiftManagement = {
    editShift,
    viewShiftDetail,
    deleteShift,
    showAlert
}; 