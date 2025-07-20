// Admin Dashboard JavaScript
document.addEventListener('DOMContentLoaded', function() {
    // Load dashboard data on page load
    loadDashboardData();
    
    // Event listeners
    setupEventListeners();
    
    // Initialize animations
    initializeAnimations();
});

function setupEventListeners() {
    // Quick action buttons
    const quickActions = document.querySelectorAll('.quick-action-btn');
    quickActions.forEach(btn => {
        btn.addEventListener('click', handleQuickAction);
    });
    
    // Recent activities refresh
    const refreshBtn = document.getElementById('refreshActivities');
    if (refreshBtn) {
        refreshBtn.addEventListener('click', loadRecentActivities);
    }
}

function loadDashboardData() {
    // Hiển thị loading
    showLoading();
    
    // Gọi API để lấy dữ liệu dashboard
    fetch(`${window.contextPath}/admin/dashboard?action=data`, {
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
        displayStatistics(data.statistics || {});
        displayRecentActivities(data.recentActivities || []);
        displayQuickStats(data.quickStats || {});
    })
    .catch(error => {
        console.error('Error loading dashboard data:', error);
        // Fallback to mock data for now
        displayStatistics(getMockStatistics());
        displayRecentActivities(getMockRecentActivities());
        displayQuickStats(getMockQuickStats());
    })
    .finally(() => {
        hideLoading();
    });
}

function displayStatistics(statistics) {
    // Cập nhật số liệu thống kê
    updateStatCard('totalSchedules', statistics.totalSchedules || 0);
    updateStatCard('activeSchedules', statistics.activeSchedules || 0);
    updateStatCard('pendingExceptions', statistics.pendingExceptions || 0);
    updateStatCard('totalDoctors', statistics.totalDoctors || 0);
    
    // Cập nhật biểu đồ nếu có
    if (statistics.scheduleChart) {
        updateScheduleChart(statistics.scheduleChart);
    }
    
    if (statistics.exceptionChart) {
        updateExceptionChart(statistics.exceptionChart);
    }
}

function displayRecentActivities(activities) {
    const container = document.getElementById('recentActivities');
    if (!container) return;
    
    container.innerHTML = '';
    
    if (activities.length === 0) {
        container.innerHTML = '<p class="text-muted">Không có hoạt động gần đây</p>';
        return;
    }
    
    activities.forEach(activity => {
        const activityElement = document.createElement('div');
        activityElement.className = 'd-flex align-items-center mb-3 p-2 border-bottom';
        activityElement.innerHTML = `
            <div class="flex-shrink-0 me-3">
                <div class="rounded-circle p-2 ${getActivityIconClass(activity.type)}" style="width: 40px; height: 40px; display: flex; align-items: center; justify-content: center;">
                    <i class="bi ${getActivityIcon(activity.type)} text-white"></i>
                </div>
            </div>
            <div class="flex-grow-1">
                <div class="fw-bold">${activity.title}</div>
                <small class="text-muted">${activity.time}</small>
            </div>
        `;
        container.appendChild(activityElement);
    });
}

function displayQuickStats(quickStats) {
    // Cập nhật thống kê nhanh
    const quickStatsContainer = document.getElementById('quickStats');
    if (!quickStatsContainer) return;
    
    quickStatsContainer.innerHTML = `
        <div class="row">
            <div class="col-md-3">
                <div class="quick-stat-card">
                    <div class="stat-icon bg-primary">
                        <i class="bi bi-calendar-check"></i>
                    </div>
                    <div class="stat-content">
                        <h4>${quickStats.todayAppointments || 0}</h4>
                        <p>Lịch hẹn hôm nay</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="quick-stat-card">
                    <div class="stat-icon bg-success">
                        <i class="bi bi-people"></i>
                    </div>
                    <div class="stat-content">
                        <h4>${quickStats.availableDoctors || 0}</h4>
                        <p>Bác sĩ có sẵn</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="quick-stat-card">
                    <div class="stat-icon bg-warning">
                        <i class="bi bi-exclamation-triangle"></i>
                    </div>
                    <div class="stat-content">
                        <h4>${quickStats.urgentExceptions || 0}</h4>
                        <p>Ngoại lệ khẩn cấp</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="quick-stat-card">
                    <div class="stat-icon bg-info">
                        <i class="bi bi-clock"></i>
                    </div>
                    <div class="stat-content">
                        <h4>${quickStats.avgResponseTime || '0h'}</h4>
                        <p>Thời gian phản hồi TB</p>
                    </div>
                </div>
            </div>
        </div>
    `;
}

function updateStatCard(id, value) {
    const element = document.getElementById(id);
    if (element) {
        // Animate the number
        animateNumber(element, 0, value, 1000);
    }
}

function animateNumber(element, start, end, duration) {
    const startTime = performance.now();
    const difference = end - start;
    
    function updateNumber(currentTime) {
        const elapsed = currentTime - startTime;
        const progress = Math.min(elapsed / duration, 1);
        
        const current = Math.floor(start + (difference * progress));
        element.textContent = current.toLocaleString();
        
        if (progress < 1) {
            requestAnimationFrame(updateNumber);
        }
    }
    
    requestAnimationFrame(updateNumber);
}

function getActivityIconClass(type) {
    switch (type) {
        case 'schedule':
            return 'bg-primary';
        case 'exception':
            return 'bg-warning';
        case 'doctor':
            return 'bg-success';
        case 'system':
            return 'bg-info';
        default:
            return 'bg-secondary';
    }
}

function getActivityIcon(type) {
    switch (type) {
        case 'schedule':
            return 'bi-calendar-plus';
        case 'exception':
            return 'bi-exclamation-triangle';
        case 'appointment':
            return 'bi-calendar-event';
        case 'contact':
            return 'bi-chat-dots';
        case 'doctor':
            return 'bi-person-plus';
        case 'system':
            return 'bi-gear';
        default:
            return 'bi-info-circle';
    }
}

function handleQuickAction(event) {
    const action = event.currentTarget.dataset.action;
    
    switch (action) {
        case 'add-schedule':
            window.location.href = `${window.contextPath}/views/admin/working-schedules.jsp`;
            break;
        case 'manage-exceptions':
            window.location.href = `${window.contextPath}/views/admin/schedule-exceptions.jsp`;
            break;
        case 'manage-shifts':
            window.location.href = `${window.contextPath}/admin/shifts`;
            break;
        case 'manage-doctors':
            window.location.href = `${window.contextPath}/admin/doctor`;
            break;
        default:
            console.log('Unknown action:', action);
    }
}

function loadRecentActivities() {
    // Gọi API để lấy hoạt động gần đây
    fetch(`${window.contextPath}/admin/dashboard?action=activities`, {
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
        displayRecentActivities(data.activities || []);
        showAlert('Đã cập nhật hoạt động gần đây!', 'success');
    })
    .catch(error => {
        console.error('Error loading recent activities:', error);
        showAlert('Có lỗi xảy ra khi tải hoạt động gần đây', 'error');
    });
}

function initializeAnimations() {
    // Animate stat cards on scroll
    const observerOptions = {
        threshold: 0.5,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);
    
    // Observe stat cards
    const statCards = document.querySelectorAll('.stat-card');
    statCards.forEach(card => observer.observe(card));
    
    // Observe activity items
    const activityItems = document.querySelectorAll('.activity-item');
    activityItems.forEach(item => observer.observe(item));
}

// Utility functions
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
function getMockStatistics() {
    return {
        totalSchedules: 45,
        activeSchedules: 38,
        pendingExceptions: 7,
        totalDoctors: 12,
        scheduleChart: {
            labels: ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'],
            data: [8, 7, 9, 6, 8, 5, 3]
        },
        exceptionChart: {
            labels: ['Chờ duyệt', 'Đã duyệt', 'Từ chối'],
            data: [7, 15, 3]
        }
    };
}

function getMockRecentActivities() {
    return [
        {
            type: 'schedule',
            title: 'Thêm lịch làm việc cho Dr. Nguyễn Văn A',
            time: '2 phút trước'
        },
        {
            type: 'exception',
            title: 'Duyệt yêu cầu ngoại lệ của Dr. Trần Thị B',
            time: '15 phút trước'
        },
        {
            type: 'doctor',
            title: 'Cập nhật thông tin Dr. Lê Văn C',
            time: '1 giờ trước'
        },
        {
            type: 'system',
            title: 'Sao lưu dữ liệu hệ thống',
            time: '2 giờ trước'
        }
    ];
}

function getMockQuickStats() {
    return {
        todayAppointments: 23,
        availableDoctors: 8,
        urgentExceptions: 2,
        avgResponseTime: '1.5h'
    };
} 