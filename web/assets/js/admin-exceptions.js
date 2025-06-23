// Admin Schedule Exceptions Management JavaScript
document.addEventListener('DOMContentLoaded', function() {
    // Initialize event listeners
    initializeEventListeners();
    
    // Update statistics
    updateStatistics();
});

function initializeEventListeners() {
    // Reject form
    const rejectForm = document.getElementById('rejectForm');
    if (rejectForm) {
        rejectForm.addEventListener('submit', handleRejectException);
    }
    
    // Filter events
    document.getElementById('filterDoctor')?.addEventListener('change', filterExceptions);
    document.getElementById('filterType')?.addEventListener('change', filterExceptions);
    document.getElementById('filterStatus')?.addEventListener('change', filterExceptions);
    document.getElementById('filterDate')?.addEventListener('change', filterExceptions);
}

// View exception detail
function viewExceptionDetail(exceptionId) {
    // Load exception detail (will be handled by backend later)
    console.log('Viewing exception detail:', exceptionId);
    
    // For now, show mock data
    const content = `
        <div class="row">
            <div class="col-md-6">
                <h6>Thông tin yêu cầu</h6>
                <p><strong>ID:</strong> ${exceptionId}</p>
                <p><strong>Bác sĩ:</strong> Dr. Nguyễn Văn A</p>
                <p><strong>Ngày ngoại lệ:</strong> 02/06/2025</p>
                <p><strong>Loại yêu cầu:</strong> <span class="badge bg-info">Nghỉ phép</span></p>
                <p><strong>Giờ làm việc mới:</strong> Nghỉ cả ngày</p>
                <p><strong>Trạng thái:</strong> <span class="badge bg-warning text-dark">Chờ duyệt</span></p>
            </div>
            <div class="col-md-6">
                <h6>Chi tiết</h6>
                <p><strong>Lý do:</strong> Nghỉ lễ gia đình</p>
                <p><strong>Ngày tạo:</strong> 31/05/2025 12:00:00</p>
                <p><strong>Ngày cập nhật:</strong> 31/05/2025 12:00:00</p>
            </div>
        </div>
        <div class="row mt-3">
            <div class="col-12">
                <h6>Lịch làm việc bị ảnh hưởng</h6>
                <div class="table-responsive">
                    <table class="table table-sm">
                        <thead>
                            <tr>
                                <th>Thứ</th>
                                <th>Ca làm việc</th>
                                <th>Giờ làm việc</th>
                                <th>Số BN đã đặt</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>Thứ 2</td>
                                <td>Sáng</td>
                                <td>08:00 - 12:00</td>
                                <td>5</td>
                            </tr>
                            <tr>
                                <td>Thứ 2</td>
                                <td>Chiều</td>
                                <td>13:00 - 17:00</td>
                                <td>3</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    `;
    
    document.getElementById('exceptionDetailContent').innerHTML = content;
    
    // Show action buttons if status is pending
    const actionButtons = document.getElementById('actionButtons');
    if (actionButtons) {
        actionButtons.style.display = 'block';
        
        // Set up action button handlers
        document.getElementById('approveBtn').onclick = () => approveException(exceptionId);
        document.getElementById('rejectBtn').onclick = () => showRejectModal(exceptionId);
    }
    
    new bootstrap.Modal(document.getElementById('exceptionDetailModal')).show();
}

// Approve exception
function approveException(exceptionId) {
    if (confirm('Bạn có chắc chắn muốn duyệt yêu cầu này không?')) {
        // Approve exception (will be handled by backend later)
        console.log('Approving exception:', exceptionId);
        
        // For now, show success message
        showAlert('Duyệt yêu cầu thành công!', 'success');
        
        // Update row status
        updateExceptionStatus(exceptionId, 'Đã duyệt', 'bg-success');
        
        // Close modal
        bootstrap.Modal.getInstance(document.getElementById('exceptionDetailModal')).hide();
        
        // Update statistics
        updateStatistics();
    }
}

// Show reject modal
function showRejectModal(exceptionId) {
    document.getElementById('rejectExceptionId').value = exceptionId;
    document.getElementById('rejectReason').value = '';
    
    // Close detail modal and open reject modal
    bootstrap.Modal.getInstance(document.getElementById('exceptionDetailModal')).hide();
    new bootstrap.Modal(document.getElementById('rejectModal')).show();
}

// Handle reject form
function handleRejectException(e) {
    e.preventDefault();
    
    const formData = new FormData(e.target);
    const data = Object.fromEntries(formData.entries());
    
    if (!data.rejectReason.trim()) {
        showAlert('Vui lòng nhập lý do từ chối!', 'danger');
        return;
    }
    
    // Show loading
    const submitBtn = e.target.querySelector('button[type="submit"]');
    const originalText = submitBtn.innerHTML;
    submitBtn.innerHTML = '<i class="bi bi-hourglass-split"></i> Đang xử lý...';
    submitBtn.disabled = true;
    
    // Reject exception (will be handled by backend later)
    console.log('Rejecting exception:', data);
    
    // For now, show success message
    setTimeout(() => {
        showAlert('Từ chối yêu cầu thành công!', 'success');
        bootstrap.Modal.getInstance(document.getElementById('rejectModal')).hide();
        
        // Update row status
        updateExceptionStatus(data.exceptionId, 'Đã từ chối', 'bg-danger');
        
        submitBtn.innerHTML = originalText;
        submitBtn.disabled = false;
        
        // Update statistics
        updateStatistics();
    }, 1000);
}

// Update exception status in table
function updateExceptionStatus(exceptionId, newStatus, badgeClass) {
    const row = document.querySelector(`tr[data-exception-id="${exceptionId}"]`);
    if (row) {
        // Update status cell
        const statusCell = row.cells[6];
        statusCell.innerHTML = `<span class="badge ${badgeClass}">${newStatus}</span>`;
        
        // Update data attribute
        row.setAttribute('data-status', newStatus);
        
        // Update action buttons
        const actionCell = row.cells[8];
        if (newStatus === 'Chờ duyệt') {
            actionCell.innerHTML = `
                <button class="btn btn-sm btn-outline-primary" onclick="viewExceptionDetail(${exceptionId})">
                    <i class="bi bi-eye"></i>
                </button>
                <button class="btn btn-sm btn-outline-success" onclick="approveException(${exceptionId})">
                    <i class="bi bi-check-circle"></i>
                </button>
                <button class="btn btn-sm btn-outline-danger" onclick="rejectException(${exceptionId})">
                    <i class="bi bi-x-circle"></i>
                </button>
            `;
        } else {
            actionCell.innerHTML = `
                <button class="btn btn-sm btn-outline-primary" onclick="viewExceptionDetail(${exceptionId})">
                    <i class="bi bi-eye"></i>
                </button>
            `;
        }
    }
}

// Filter exceptions
function filterExceptions() {
    const doctorFilter = document.getElementById('filterDoctor').value;
    const typeFilter = document.getElementById('filterType').value;
    const statusFilter = document.getElementById('filterStatus').value;
    const dateFilter = document.getElementById('filterDate').value;
    
    const rows = document.querySelectorAll('#exceptionTableBody tr');
    
    rows.forEach(row => {
        if (row.cells.length < 9) return; // Skip empty rows
        
        const doctor = row.cells[1].textContent.trim();
        const date = row.cells[2].textContent.trim();
        const type = row.cells[3].textContent.trim();
        const status = row.cells[6].textContent.trim();
        
        const matchesDoctor = !doctorFilter || doctor.includes(doctorFilter);
        const matchesType = !typeFilter || type.includes(typeFilter);
        const matchesStatus = !statusFilter || status.includes(statusFilter);
        const matchesDate = !dateFilter || date.includes(dateFilter);
        
        row.style.display = (matchesDoctor && matchesType && matchesStatus && matchesDate) ? '' : 'none';
    });
}

// Reset filters
function resetFilters() {
    document.getElementById('filterDoctor').value = '';
    document.getElementById('filterType').value = '';
    document.getElementById('filterStatus').value = '';
    document.getElementById('filterDate').value = '';
    
    const rows = document.querySelectorAll('#exceptionTableBody tr');
    rows.forEach(row => {
        row.style.display = '';
    });
}

// Update statistics
function updateStatistics() {
    const rows = document.querySelectorAll('#exceptionTableBody tr');
    let pendingCount = 0;
    let approvedCount = 0;
    let rejectedCount = 0;
    
    rows.forEach(row => {
        if (row.cells.length >= 9) {
            const status = row.cells[6].textContent.trim();
            if (status.includes('Chờ duyệt')) {
                pendingCount++;
            } else if (status.includes('Đã duyệt')) {
                approvedCount++;
            } else if (status.includes('Đã từ chối')) {
                rejectedCount++;
            }
        }
    });
    
    // Update statistics display
    const pendingElement = document.getElementById('pendingCount');
    const approvedElement = document.getElementById('approvedCount');
    const rejectedElement = document.getElementById('rejectedCount');
    
    if (pendingElement) pendingElement.textContent = pendingCount;
    if (approvedElement) approvedElement.textContent = approvedCount;
    if (rejectedElement) rejectedElement.textContent = rejectedCount;
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
window.viewExceptionDetail = viewExceptionDetail;
window.approveException = approveException;
window.rejectException = showRejectModal;
window.filterExceptions = filterExceptions;
window.resetFilters = resetFilters; 