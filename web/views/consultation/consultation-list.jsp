<%@ page import="java.util.List" %>
<%@ page import="models.ConsultationSession" %>
<%@ page import="models.User" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Tư vấn sức khỏe - Fauguet Medical</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
</head>
<body>
<div class="wrapper">
    <%@ include file="../layouts/header.jsp" %>
    
    <div class="main">
        <div class="content">
            <!-- Hero Section -->
            <div class="hero-section bg-gradient-primary text-white py-5">
                <div class="container">
                    <div class="row align-items-center">
                        <div class="col-lg-8">
                            <h1 class="display-5 fw-bold mb-3">Tư vấn sức khỏe trực tuyến</h1>
                            <p class="lead mb-0">Kết nối với bác sĩ chuyên môn để được tư vấn sức khỏe 24/7</p>
                        </div>
                        <div class="col-lg-4 text-center">
                            <i class="bi bi-chat-dots hero-icon"></i>
                        </div>
                    </div>
                </div>
            </div>

            <div class="container-fluid my-5">
                <%
                    User currentUser = (User) request.getAttribute("currentUser");
                    List<ConsultationSession> sessions = (List<ConsultationSession>) request.getAttribute("sessions");
                    boolean isPatient = currentUser.getRole().getRoleId() == 1;
                    boolean isDoctor = currentUser.getRole().getRoleId() == 2;
                %>

                <!-- Nút tạo phiên tư vấn mới (chỉ cho bệnh nhân) -->
                <% if (isPatient) { %>
                <div class="row mb-5">
                    <div class="col-12">
                        <button class="btn btn-primary btn-lg shadow-sm px-4 py-3" data-bs-toggle="modal" data-bs-target="#newConsultationModal">
                            <i class="bi bi-plus-circle me-3"></i> Tạo phiên tư vấn mới
                        </button>
                    </div>
                </div>
                <% } %>

                <!-- Danh sách phiên tư vấn -->
                <div class="row">
                    <div class="col-12">
                        <div class="d-flex align-items-center mb-5">
                            <h2 class="mb-0">
                                <% if (isPatient) { %>
                                    <i class="bi bi-list-ul text-primary me-3"></i> Phiên tư vấn của tôi
                                <% } else if (isDoctor) { %>
                                    <i class="bi bi-list-ul text-info me-3"></i> Phiên tư vấn cần xử lý
                                <% } %>
                            </h2>
                            <span class="badge bg-secondary ms-3 px-3 py-2"><%= sessions != null ? sessions.size() : 0 %> phiên</span>
                        </div>
                        
                        <% if (sessions != null && !sessions.isEmpty()) { %>
                        <div class="row">
                            <% for (ConsultationSession consultationSession : sessions) { %>
                            <div class="col-xl-4 col-lg-6 col-md-12 mb-5">
                                <div class="card h-100 consultation-card shadow-lg">
                                    <div class="card-header d-flex justify-content-between align-items-center py-3">
                                        <h5 class="mb-0">
                                            <% if (isPatient) { %>
                                                <i class="bi bi-person-badge text-primary me-2"></i> 
                                                Bác sĩ <%= consultationSession.getDoctor().getUser().getFullName() %>
                                            <% } else if (isDoctor) { %>
                                                <i class="bi bi-person text-info me-2"></i> 
                                                Bệnh nhân <%= consultationSession.getPatient().getUser().getFullName() %>
                                            <% } %>
                                        </h5>
                                        <span class="badge <%= getStatusBadgeClass(consultationSession.getStatus()) %> px-3 py-2">
                                            <%= consultationSession.getStatusDisplay() %>
                                        </span>
                                    </div>
                                    <div class="card-body p-4">
                                        <div class="mb-4">
                                            <strong><i class="bi bi-thermometer-half text-warning me-2"></i> Triệu chứng:</strong>
                                            <p class="text-muted mb-2 mt-2 fs-6"><%= consultationSession.getPatient_symptoms() != null ? consultationSession.getPatient_symptoms() : "Không có" %></p>
                                        </div>
                                        <div class="mb-4">
                                            <strong><i class="bi bi-chat-quote text-primary me-2"></i> Tin nhắn đầu tiên:</strong>
                                            <p class="text-muted mb-2 mt-2 fs-6"><%= consultationSession.getPatient_message() != null ? consultationSession.getPatient_message() : "Không có" %></p>
                                        </div>
                                        <div class="d-flex justify-content-between align-items-center">
                                            <small class="text-muted fs-6">
                                                <i class="bi bi-calendar3 me-2"></i> 
                                                <%= consultationSession.getCreated_at() != null ? consultationSession.getCreated_at().toString().substring(0, 16) : "N/A" %>
                                            </small>
                                            <a href="${pageContext.request.contextPath}/consultation-chat?action=view-session&session_id=<%= consultationSession.getSession_id() %>" 
                                               class="btn btn-outline-primary">
                                                <i class="bi bi-chat me-2"></i> Xem chi tiết
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <% } %>
                        </div>
                        <% } else { %>
                        <div class="text-center py-5">
                            <div class="empty-state">
                                <i class="bi bi-inbox text-muted empty-icon"></i>
                                <h3 class="text-muted mt-4">
                                    <% if (isPatient) { %>
                                        Bạn chưa có phiên tư vấn nào
                                    <% } else if (isDoctor) { %>
                                        Chưa có phiên tư vấn nào cần xử lý
                                    <% } %>
                                </h3>
                                <p class="text-muted fs-5">
                                    <% if (isPatient) { %>
                                        Hãy tạo phiên tư vấn mới để được bác sĩ tư vấn
                                    <% } else if (isDoctor) { %>
                                        Hãy chờ bệnh nhân tạo phiên tư vấn mới
                                    <% } %>
                                </p>
                            </div>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <%@ include file="../layouts/footer.jsp" %>
</div>

<!-- Modal tạo phiên tư vấn mới -->
<% if (isPatient) { %>
<div class="modal fade" id="newConsultationModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title">
                    <i class="bi bi-plus-circle me-2"></i> Tạo phiên tư vấn mới
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form id="newConsultationForm">
                <input type="hidden" name="action" value="create-session">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label"><i class="bi bi-person-badge me-1"></i> Chọn bác sĩ</label>
                        <select name="doctor_id" class="form-select" required>
                            <option value="">Chọn bác sĩ tư vấn</option>
                            <!-- Sẽ được load bằng AJAX -->
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label"><i class="bi bi-thermometer-half me-1"></i> Triệu chứng chính</label>
                        <textarea name="patient_symptoms" class="form-control" rows="2" 
                                  placeholder="Mô tả các triệu chứng bạn đang gặp phải..." required></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label"><i class="bi bi-chat-quote me-1"></i> Tin nhắn đầu tiên</label>
                        <textarea name="patient_message" class="form-control" rows="3" 
                                  placeholder="Mô tả chi tiết vấn đề sức khỏe của bạn..." required></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-send me-1"></i> Tạo phiên tư vấn
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
<% } %>

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/jwt-manager.js"></script>

<% if (isPatient) { %>
<script>
function loadDoctors() {
    fetch('${pageContext.request.contextPath}/api/doctors')
        .then(response => response.json())
        .then(data => {
            const select = document.querySelector('select[name="doctor_id"]');
            data.forEach(doctor => {
                const option = document.createElement('option');
                option.value = doctor.doctorId;
                option.textContent = doctor.fullname + ' - ' + (doctor.speciality_name ? doctor.speciality_name : 'Chuyên khoa');
                select.appendChild(option);
            });
        })
        .catch(error => {
            console.error('Error loading doctors:', error);
        });
}

document.addEventListener('DOMContentLoaded', function() {
    const navLinks = document.querySelectorAll('.nav-link');
    navLinks.forEach(link => {
        if (link.textContent.trim() === 'Tư vấn sức khỏe') {
            link.classList.add('active');
        }
    });
    loadDoctors();
});

document.getElementById('newConsultationForm').addEventListener('submit', function(e) {
    e.preventDefault();
    const formData = new FormData(this);
    formData.append('action', 'create-session');
    console.log('Creating consultation session...');
    console.log('Form data:', Object.fromEntries(formData));
    const params = new URLSearchParams();
    for (let [key, value] of formData.entries()) {
        params.append(key, value);
    }
    console.log('URLSearchParams:', params.toString());
    fetch('${pageContext.request.contextPath}/consultation-chat', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: params
    })
    .then(response => {
        console.log('Create session response status:', response.status);
        console.log('Create session response headers:', response.headers);
        return response.text().then(text => {
            console.log('Create session raw response:', text);
            try {
                return JSON.parse(text);
            } catch (e) {
                console.error('JSON parse error:', e);
                console.error('Response text:', text);
                throw new Error('Invalid JSON response: ' + text);
            }
        });
    })
    .then(data => {
        console.log('Parsed response data:', data);
        if (data.success) {
            alert('Tạo phiên tư vấn thành công!');
            location.reload();
        } else {
            alert('Lỗi: ' + data.message);
        }
    })
    .catch(error => {
        console.error('Error creating consultation session:', error);
        alert('Có lỗi xảy ra khi tạo phiên tư vấn: ' + error.message);
    });
});
</script>
<% } %>
</script>

<style>
.hero-section {
    background: linear-gradient(135deg, #0d6efd 0%, #0b5ed7 50%, #0a58ca 100%);
    position: relative;
    overflow: hidden;
}

.hero-section::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="25" cy="25" r="1" fill="white" opacity="0.1"/><circle cx="75" cy="75" r="1" fill="white" opacity="0.1"/><circle cx="50" cy="10" r="0.5" fill="white" opacity="0.1"/><circle cx="10" cy="60" r="0.5" fill="white" opacity="0.1"/><circle cx="90" cy="40" r="0.5" fill="white" opacity="0.1"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
    opacity: 0.3;
}

.hero-icon {
    font-size: 5rem;
    opacity: 0.8;
    animation: float 3s ease-in-out infinite;
}

@keyframes float {
    0%, 100% { transform: translateY(0px); }
    50% { transform: translateY(-10px); }
}

.consultation-card {
    transition: all 0.3s ease;
    border: none;
    border-radius: 15px;
    overflow: hidden;
}

.consultation-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 8px 25px rgba(0,0,0,0.15) !important;
}

.card {
    border: none;
    border-radius: 15px;
    box-shadow: 0 4px 15px rgba(0,0,0,0.1);
}

.card-header {
    border-radius: 15px 15px 0 0 !important;
    border: none;
    background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
}

.empty-state {
    padding: 3rem 0;
}

.empty-icon {
    font-size: 4rem;
    opacity: 0.5;
}

.btn {
    border-radius: 10px;
    font-weight: 500;
    transition: all 0.3s ease;
}

.btn:hover {
    transform: translateY(-1px);
}

.form-control, .form-select {
    border-radius: 10px;
    border: 1px solid #dee2e6;
    transition: all 0.3s ease;
}

.form-control:focus, .form-select:focus {
    border-color: #007bff;
    box-shadow: 0 0 0 0.2rem rgba(0,123,255,0.25);
    transform: translateY(-1px);
}

.modal-content {
    border: none;
    border-radius: 15px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.2);
}

.modal-header {
    border-radius: 15px 15px 0 0 !important;
    border: none;
}

.badge {
    font-weight: 500;
    padding: 0.5em 0.75em;
}
</style>

<%!
private String getStatusBadgeClass(String status) {
    switch (status) {
        case "pending": return "bg-warning";
        case "active": return "bg-success";
        case "completed": return "bg-info";
        case "cancelled": return "bg-danger";
        default: return "bg-secondary";
    }
}
%>
</body>
</html> 