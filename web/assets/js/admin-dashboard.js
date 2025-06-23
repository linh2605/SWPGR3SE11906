// Admin Dashboard JavaScript
document.addEventListener('DOMContentLoaded', function() {
    // Load dashboard statistics
    loadDashboardStatistics();
    
    // Load recent activities
    // loadRecentActivities(); // Tạm thời vô hiệu hóa để gỡ lỗi
    
    // Auto refresh every 30 seconds
    setInterval(loadDashboardStatistics, 30000);
});

// Load dashboard statistics
function loadDashboardStatistics() {
    // This will be replaced with actual API calls when backend is ready
    console.log('Loading dashboard statistics...');
    
    // For now, show mock data
    updateStatisticsDisplay({
        totalSchedules: 24,
        activeSchedules: 20,
        pendingExceptions: 3,
        totalDoctors: 8
    });
}

// Update statistics display
function updateStatisticsDisplay(stats) {
    const totalSchedulesElement = document.getElementById('totalSchedules');
    const activeSchedulesElement = document.getElementById('activeSchedules');
    const pendingExceptionsElement = document.getElementById('pendingExceptions');
    const totalDoctorsElement = document.getElementById('totalDoctors');
    
    if (totalSchedulesElement) {
        totalSchedulesElement.textContent = stats.totalSchedules;
        animateNumber(totalSchedulesElement, stats.totalSchedules);
    }
    
    if (activeSchedulesElement) {
        activeSchedulesElement.textContent = stats.activeSchedules;
        animateNumber(activeSchedulesElement, stats.activeSchedules);
    }
    
    if (pendingExceptionsElement) {
        pendingExceptionsElement.textContent = stats.pendingExceptions;
        animateNumber(pendingExceptionsElement, stats.pendingExceptions);
        
        // Add warning indicator if there are pending exceptions
        if (stats.pendingExceptions > 0) {
            pendingExceptionsElement.parentElement.parentElement.style.boxShadow = '0 0 10px rgba(255, 193, 7, 0.5)';
        } else {
            pendingExceptionsElement.parentElement.parentElement.style.boxShadow = 'none';
        }
    }
    
    if (totalDoctorsElement) {
        totalDoctorsElement.textContent = stats.totalDoctors;
        animateNumber(totalDoctorsElement, stats.totalDoctors);
    }
}

// Animate number counting
function animateNumber(element, targetNumber) {
    const currentNumber = parseInt(element.textContent) || 0;
    const increment = (targetNumber - currentNumber) / 20;
    let current = currentNumber;
    
    const timer = setInterval(() => {
        current += increment;
        if ((increment > 0 && current >= targetNumber) || (increment < 0 && current <= targetNumber)) {
            element.textContent = targetNumber;
            clearInterval(timer);
        } else {
            element.textContent = Math.floor(current);
        }
    }, 50);
}

// Load recent activities
function loadRecentActivities() {
    // This will be replaced with actual API calls when backend is ready
    console.log('Loading recent activities...');
    
    const activities = [
        {
            title: 'Bác sĩ Nguyễn Văn A gửi yêu cầu nghỉ phép',
            time: '3 phút trước',
            description: 'Ngày: 02/06/2025 - Lý do: Nghỉ lễ gia đình',
            type: 'exception'
        },
        {
            title: 'Cập nhật lịch làm việc bác sĩ Trần Thị B',
            time: '1 giờ trước',
            description: 'Thêm ca tối cho thứ 3 và thứ 5',
            type: 'schedule'
        },
        {
            title: 'Duyệt yêu cầu thay đổi giờ làm',
            time: '2 giờ trước',
            description: 'Bác sĩ Lê Văn C - Chuyển từ ca sáng sang ca chiều',
            type: 'approval'
        }
    ];
    
    updateActivitiesDisplay(activities);
}

// Update activities display
function updateActivitiesDisplay(activities) {
    const activitiesContainer = document.getElementById('recentActivities');
    if (!activitiesContainer) return;
    
    // Clear existing activities
    activitiesContainer.innerHTML = '';
    
    // Add new activities
    activities.forEach(activity => {
        const activityElement = createActivityElement(activity);
        activitiesContainer.appendChild(activityElement);
    });
}

// Create activity element
function createActivityElement(activity) {
    const listGroupItem = document.createElement('div');
    listGroupItem.className = 'list-group-item';
    
    // Add animation class
    listGroupItem.classList.add('fade-in');
    
    // Set icon based on activity type
    let icon = 'bi-activity';
    let iconColor = 'text-primary';
    
    switch (activity.type) {
        case 'exception':
            icon = 'bi-exclamation-triangle';
            iconColor = 'text-warning';
            break;
        case 'schedule':
            icon = 'bi-calendar-check';
            iconColor = 'text-success';
            break;
        case 'approval':
            icon = 'bi-check-circle';
            iconColor = 'text-info';
            break;
    }
    
    listGroupItem.innerHTML = `
        <div class="d-flex w-100 justify-content-between">
            <h6 class="mb-1">
                <i class="bi ${icon} ${iconColor} me-2"></i>
                ${activity.title}
            </h6>
            <small class="text-muted">${activity.time}</small>
        </div>
        <p class="mb-1">${activity.description}</p>
    `;
    
    return listGroupItem;
}

/* Tạm thời vô hiệu hóa việc thêm CSS động để gỡ lỗi
// Add CSS for animations
const style = document.createElement('style');
style.textContent = `
    .fade-in {
        animation: fadeInUp 0.5s ease-out;
    }
    
    @keyframes fadeInUp {
        from {
            opacity: 0;
            transform: translateY(20px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }
    
    .card {
        transition: all 0.3s ease;
    }
    
    .card:hover {
        transform: translateY(-5px);
        box-shadow: 0 10px 25px rgba(0,0,0,0.1);
    }
    
    .btn {
        transition: all 0.3s ease;
    }
    
    .btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(0,0,0,0.2);
    }
`;
document.head.appendChild(style);
*/

// Export functions for global access
window.loadDashboardStatistics = loadDashboardStatistics;
window.loadRecentActivities = loadRecentActivities; 