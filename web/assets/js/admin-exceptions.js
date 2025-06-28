// Admin Schedule Exceptions Management JavaScript
document.addEventListener('DOMContentLoaded', function() {
    // Load exceptions on page load
    loadExceptions();
    
    // Event listeners
    setupEventListeners();
});

function setupEventListeners() {
    // Filter inputs
    const doctorFilter = document.getElementById('doctorFilter');
    if (doctorFilter) {
        doctorFilter.addEventListener('change', filterExceptions);
    }
    
    const statusFilter = document.getElementById('statusFilter');
    if (statusFilter) {
        statusFilter.addEventListener('change', filterExceptions);
    }
    
    const dateFilter = document.getElementById('dateFilter');
    if (dateFilter) {
        dateFilter.addEventListener('change', filterExceptions);
    }
    
    // Search input
    const searchInput = document.getElementById('searchInput');
    if (searchInput) {
        searchInput.addEventListener('input', filterExceptions);
    }
}

function loadExceptions() {
    // Hiển thị loading
    showLoading();
    
    // Gọi API để lấy danh sách ngoại lệ
    fetch(`${window.contextPath}/admin/schedule-exceptions?action=list`, {
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
        displayExceptions(data.exceptions || []);
        loadDoctors(data.doctors || []);
    })
    .catch(error => {
        console.error('Error loading exceptions:', error);
        // Fallback to mock data for now
        displayExceptions(getMockExceptions());
        loadDoctors(getMockDoctors());
    })
    .finally(() => {
        hideLoading();
    });
}

function displayExceptions(exceptions) {
    const tbody = document.querySelector('#exceptionsTable tbody');
    if (!tbody) return;
    
    tbody.innerHTML = '';
    
    if (exceptions.length === 0) {
        tbody.innerHTML = '<tr><td colspan="8" class="text-center">Không có yêu cầu ngoại lệ nào</td></tr>';
        return;
    }
    
    exceptions.forEach(exception => {
        const row = document.createElement('tr');
        const statusBadge = getStatusBadge(exception.status);
        
        row.innerHTML = `
            <td>${exception.doctorName || 'N/A'}</td>
            <td>${exception.exceptionDate || 'N/A'}</td>
            <td>${exception.exceptionType || 'N/A'}</td>
            <td>${exception.newShiftName || 'N/A'}</td>
            <td>${exception.reason || 'N/A'}</td>
            <td>${statusBadge}</td>
            <td>${exception.submittedDate || 'N/A'}</td>
            <td>
                <button class="btn btn-sm btn-info" onclick="viewExceptionDetail(${exception.exceptionId})">
                    <i class="bi bi-eye"></i>
                </button>
                ${exception.status === 'Chờ duyệt' ? `
                    <button class="btn btn-sm btn-success" onclick="approveException(${exception.exceptionId})">
                        <i class="bi bi-check"></i>
                    </button>
                    <button class="btn btn-sm btn-danger" onclick="rejectException(${exception.exceptionId})">
                        <i class="bi bi-x"></i>
                    </button>
                ` : ''}
            </td>
        `;
        tbody.appendChild(row);
    });
}

function getStatusBadge(status) {
    switch (status) {
        case 'Chờ duyệt':
            return '<span class="badge bg-warning">Chờ duyệt</span>';
        case 'Đã duyệt':
            return '<span class="badge bg-success">Đã duyệt</span>';
        case 'Từ chối':
            return '<span class="badge bg-danger">Từ chối</span>';
        default:
            return '<span class="badge bg-secondary">Không xác định</span>';
    }
}

function loadDoctors(doctors) {
    const doctorFilter = document.getElementById('doctorFilter');
    
    if (doctorFilter) {
        doctorFilter.innerHTML = '<option value="">Tất cả bác sĩ</option>';
        doctors.forEach(doctor => {
            doctorFilter.innerHTML += `<option value="${doctor.doctorId}">${doctor.fullName}</option>`;
        });
    }
}

function approveException(exceptionId) {
    if (confirm('Bạn có chắc chắn muốn duyệt yêu cầu ngoại lệ này?')) {
        fetch(`${window.contextPath}/admin/schedule-exceptions`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                action: 'approve',
                exceptionId: exceptionId
            })
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(result => {
            if (result.success) {
                showAlert('Duyệt yêu cầu ngoại lệ thành công!', 'success');
                loadExceptions();
            } else {
                showAlert(result.message || 'Có lỗi xảy ra', 'error');
            }
        })
        .catch(error => {
            console.error('Error approving exception:', error);
            showAlert('Có lỗi xảy ra khi duyệt yêu cầu ngoại lệ', 'error');
        });
    }
}

function rejectException(exceptionId) {
    const reason = prompt('Lý do từ chối (không bắt buộc):');
    
    if (confirm('Bạn có chắc chắn muốn từ chối yêu cầu ngoại lệ này?')) {
        fetch(`${window.contextPath}/admin/schedule-exceptions`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                action: 'reject',
                exceptionId: exceptionId,
                rejectReason: reason
            })
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(result => {
            if (result.success) {
                showAlert('Từ chối yêu cầu ngoại lệ thành công!', 'success');
                loadExceptions();
            } else {
                showAlert(result.message || 'Có lỗi xảy ra', 'error');
            }
        })
        .catch(error => {
            console.error('Error rejecting exception:', error);
            showAlert('Có lỗi xảy ra khi từ chối yêu cầu ngoại lệ', 'error');
        });
    }
}

function viewExceptionDetail(exceptionId) {
    // Gọi API để lấy chi tiết ngoại lệ
    fetch(`${window.contextPath}/admin/schedule-exceptions?action=detail&id=${exceptionId}`, {
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
    .then(exception => {
        // Hiển thị thông tin trong modal
        document.getElementById('detailDoctorName').textContent = exception.doctorName;
        document.getElementById('detailExceptionDate').textContent = exception.exceptionDate;
        document.getElementById('detailExceptionType').textContent = exception.exceptionType;
        document.getElementById('detailNewShiftName').textContent = exception.newShiftName;
        document.getElementById('detailReason').textContent = exception.reason;
        document.getElementById('detailStatus').innerHTML = getStatusBadge(exception.status);
        document.getElementById('detailSubmittedDate').textContent = exception.submittedDate;
        
        if (exception.adminComment) {
            document.getElementById('detailAdminComment').textContent = exception.adminComment;
            document.getElementById('adminCommentSection').style.display = 'block';
        } else {
            document.getElementById('adminCommentSection').style.display = 'none';
        }
        
        openModal('exceptionDetailModal');
    })
    .catch(error => {
        console.error('Error loading exception detail:', error);
        showAlert('Có lỗi xảy ra khi tải thông tin chi tiết', 'error');
    });
}

function filterExceptions() {
    const doctorFilter = document.getElementById('doctorFilter').value;
    const statusFilter = document.getElementById('statusFilter').value;
    const dateFilter = document.getElementById('dateFilter').value;
    const searchTerm = document.getElementById('searchInput').value.toLowerCase();
    
    const rows = document.querySelectorAll('#exceptionsTable tbody tr');
    
    rows.forEach(row => {
        const doctorName = row.cells[0].textContent.toLowerCase();
        const exceptionDate = row.cells[1].textContent.toLowerCase();
        const exceptionType = row.cells[2].textContent.toLowerCase();
        const status = row.cells[5].textContent.toLowerCase();
        
        const matchesDoctor = !doctorFilter || doctorName.includes(doctorFilter.toLowerCase());
        const matchesStatus = !statusFilter || status.includes(statusFilter.toLowerCase());
        const matchesDate = !dateFilter || exceptionDate.includes(dateFilter.toLowerCase());
        const matchesSearch = !searchTerm || 
            doctorName.includes(searchTerm) || 
            exceptionType.includes(searchTerm) || 
            status.includes(searchTerm);
        
        if (matchesDoctor && matchesStatus && matchesDate && matchesSearch) {
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
function getMockExceptions() {
    return [
        {
            exceptionId: 1,
            doctorName: 'Dr. Nguyễn Văn A',
            exceptionDate: '2024-01-20',
            exceptionType: 'Nghỉ phép',
            newShiftName: 'Không có',
            reason: 'Bị ốm, cần nghỉ ngơi',
            status: 'Chờ duyệt',
            submittedDate: '2024-01-18'
        },
        {
            exceptionId: 2,
            doctorName: 'Dr. Trần Thị B',
            exceptionDate: '2024-01-22',
            exceptionType: 'Đổi ca',
            newShiftName: 'Ca tối',
            reason: 'Có việc gia đình vào buổi sáng',
            status: 'Đã duyệt',
            submittedDate: '2024-01-19'
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