<%@ page import="java.util.List" %>
<%@ page import="models.HealthConsultation" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>TÆ° váº¥n sá»©c khá»e - Fauguet Medical</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
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
            <div class="hero-section bg-primary text-white py-5">
                <div class="container">
                    <div class="row align-items-center">
                        <div class="col-lg-6">
                            <h1 class="display-4 fw-bold mb-4">TÆ° váº¥n sá»©c khá»e</h1>
                            <p class="lead mb-4">Nháº­n tÆ° váº¥n tá»« cÃ¡c bÃ¡c sÄ© chuyÃªn mÃ´n cao vá» cÃ¡c váº¥n Äá» sá»©c khá»e cá»§a báº¡n</p>
                            <p class="mb-0">ChÃºng tÃ´i cung cáº¥p dá»ch vá»¥ tÆ° váº¥n sá»©c khá»e cháº¥t lÆ°á»£ng cao vá»i Äá»i ngÅ© bÃ¡c sÄ© giÃ u kinh nghiá»m</p>
                        </div>
                        <div class="col-lg-6 text-center">
                            <i class="bi bi-heart-pulse" style="font-size: 8rem; opacity: 0.8;"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Consultation List -->
            <div class="container my-5">
                <div class="row">
                    <div class="col-12">
                        <h2 class="section-title text-center mb-5">Danh sÃ¡ch tÆ° váº¥n sá»©c khá»e đã được thực hiện</h2>
                        
                        <%
                            List<HealthConsultation> consultations = (List<HealthConsultation>) request.getAttribute("consultations");
                            if (consultations != null && !consultations.isEmpty()) {
                        %>
                        
                        <div class="row">
                            <% for (HealthConsultation hc : consultations) { %>
                            <div class="col-lg-6 col-md-12 mb-4">
                                <div class="card h-100 shadow-sm">
                                    <div class="card-body">
                                        <div class="d-flex align-items-center mb-3">
                                            <div class="flex-shrink-0">
                                                <i class="bi bi-person-circle text-primary" style="font-size: 2rem;"></i>
                                            </div>
                                            <div class="flex-grow-1 ms-3">
                                                <h5 class="card-title mb-1">BÃ¡c sÄ© <%= hc.getDoctor().getUser().getFullName() %></h5>
                                                <p class="text-muted mb-0">
                                                    <i class="bi bi-calendar3"></i>
                                                    <%= hc.getCreated_at() != null ? hc.getCreated_at().toString().substring(0, 16) : "N/A" %>
                                                </p>
                                            </div>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <span class="badge bg-info me-2">
                                                <i class="bi bi-person"></i> Bá»nh nhÃ¢n: <%= hc.getPatient().getUser().getFullName() %>
                                            </span>
                                            <% if (hc.getDoctor().getSpecialty() != null) { %>
                                            <span class="badge bg-secondary">
                                                <i class="bi bi-stethoscope"></i> <%= hc.getDoctor().getSpecialty().getName() %>
                                            </span>
                                            <% } %>
                                        </div>
                                        
                                        <p class="card-text">
                                            <%= hc.getDetail() %>
                                        </p>
                                        
                                        <div class="d-flex justify-content-between align-items-center">
                                            <small class="text-muted">
                                                <i class="bi bi-clock"></i> TÆ° váº¥n chuyÃªn mÃ´n
                                            </small>
                                            <button class="btn btn-outline-primary btn-sm" data-bs-toggle="modal" data-bs-target="#consultationModal<%= hc.getConsultation_id() %>">
                                                <i class="bi bi-eye"></i> Xem chi tiáº¿t
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <% } %>
                        </div>
                        
                        <!-- Modals for consultation details -->
                        <% for (HealthConsultation hc : consultations) { %>
                        <div class="modal fade" id="consultationModal<%= hc.getConsultation_id() %>" tabindex="-1" aria-labelledby="consultationModalLabel<%= hc.getConsultation_id() %>" aria-hidden="true">
                            <div class="modal-dialog modal-lg">
                                <div class="modal-content">
                                    <div class="modal-header bg-primary text-white">
                                        <h5 class="modal-title" id="consultationModalLabel<%= hc.getConsultation_id() %>">
                                            <i class="bi bi-heart-pulse"></i> Chi tiáº¿t tÆ° váº¥n sá»©c khá»e
                                        </h5>
                                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <div class="row">
                                            <!-- ThÃ´ng tin bÃ¡c sÄ© -->
                                            <div class="col-md-6 mb-4">
                                                <div class="card border-primary">
                                                    <div class="card-header bg-light">
                                                        <h6 class="mb-0"><i class="bi bi-person-badge text-primary"></i> ThÃ´ng tin bÃ¡c sÄ©</h6>
                                                    </div>
                                                    <div class="card-body">
                                                        <div class="d-flex align-items-center mb-3">
                                                            <i class="bi bi-person-circle text-primary me-3" style="font-size: 2rem;"></i>
                                                            <div>
                                                                <h6 class="mb-1"><%= hc.getDoctor().getUser().getFullName() %></h6>
                                                                <p class="text-muted mb-0">
                                                                    <i class="bi bi-award"></i> <%= hc.getDoctor().getDegree() != null ? hc.getDoctor().getDegree() : "BÃ¡c sÄ©" %>
                                                                </p>
                                                            </div>
                                                        </div>
                                                        <% if (hc.getDoctor().getSpecialty() != null) { %>
                                                        <p class="mb-2">
                                                            <strong>ChuyÃªn khoa:</strong> 
                                                            <span class="badge bg-primary"><%= hc.getDoctor().getSpecialty().getName() %></span>
                                                        </p>
                                                        <% } %>
                                                        <% if (hc.getDoctor().getExperience() != null) { %>
                                                        <p class="mb-0">
                                                            <strong>Kinh nghiá»m:</strong> <%= hc.getDoctor().getExperience() %>
                                                        </p>
                                                        <% } %>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <!-- ThÃ´ng tin bá»nh nhÃ¢n -->
                                            <div class="col-md-6 mb-4">
                                                <div class="card border-info">
                                                    <div class="card-header bg-light">
                                                        <h6 class="mb-0"><i class="bi bi-person text-info"></i> ThÃ´ng tin bá»nh nhÃ¢n</h6>
                                                    </div>
                                                    <div class="card-body">
                                                        <div class="d-flex align-items-center mb-3">
                                                            <i class="bi bi-person-circle text-info me-3" style="font-size: 2rem;"></i>
                                                            <div>
                                                                <h6 class="mb-1"><%= hc.getPatient().getUser().getFullName() %></h6>
                                                                <p class="text-muted mb-0">
                                                                    <i class="bi bi-envelope"></i> <%= hc.getPatient().getUser().getEmail() != null ? hc.getPatient().getUser().getEmail() : "N/A" %>
                                                                </p>
                                                            </div>
                                                        </div>
                                                        <% if (hc.getPatient().getGender() != null) { %>
                                                        <p class="mb-2">
                                                            <strong>Giá»i tÃ­nh:</strong> 
                                                            <span class="badge bg-info">
                                                                <%= hc.getPatient().getGender().toString().equals("MALE") ? "Nam" : 
                                                                   hc.getPatient().getGender().toString().equals("FEMALE") ? "Ná»¯" : "KhÃ¡c" %>
                                                            </span>
                                                        </p>
                                                        <% } %>
                                                        <% if (hc.getPatient().getDate_of_birth() != null) { %>
                                                        <p class="mb-0">
                                                            <strong>NgÃ y sinh:</strong> <%= hc.getPatient().getDate_of_birth() %>
                                                        </p>
                                                        <% } %>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <!-- Ná»i dung tÆ° váº¥n -->
                                        <div class="card border-success">
                                            <div class="card-header bg-light">
                                                <h6 class="mb-0"><i class="bi bi-chat-text text-success"></i> Ná»i dung tÆ° váº¥n</h6>
                                            </div>
                                            <div class="card-body">
                                                <div class="consultation-content">
                                                    <%= hc.getDetail() %>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <!-- ThÃ´ng tin bá» sung -->
                                        <div class="row mt-3">
                                            <div class="col-md-6">
                                                <div class="d-flex align-items-center text-muted">
                                                    <i class="bi bi-calendar3 me-2"></i>
                                                    <span>NgÃ y tÆ° váº¥n: <%= hc.getCreated_at() != null ? hc.getCreated_at().toString().substring(0, 16) : "N/A" %></span>
                                                </div>
                                            </div>
                                            <div class="col-md-6 text-end">
                                                <span class="badge bg-success">
                                                    <i class="bi bi-check-circle"></i> ÄÃ£ hoÃ n thÃ nh
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">ÄÃ³ng</button>
                                        <a href="${pageContext.request.contextPath}/doctors" class="btn btn-primary">
                                            <i class="bi bi-person-badge"></i> Xem danh sÃ¡ch bÃ¡c sÄ©
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <% } %>
                        
                        <% } else { %>
                        
                        <div class="text-center py-5">
                            <i class="bi bi-inbox text-muted" style="font-size: 4rem;"></i>
                            <h4 class="text-muted mt-3">ChÆ°a cÃ³ tÆ° váº¥n sá»©c khá»e nÃ o</h4>
                            <p class="text-muted">HÃ£y quay láº¡i sau Äá» xem cÃ¡c tÆ° váº¥n sá»©c khá»e má»i nháº¥t tá»« cÃ¡c bÃ¡c sÄ© chuyÃªn mÃ´n.</p>
                        </div>
                        
                        <% } %>
                    </div>
                </div>
            </div>

            <!-- Contact Section -->
            <div class="bg-light py-5">
                <div class="container">
                    <div class="row">
                        <div class="col-lg-8 mx-auto text-center">
                            <h3 class="mb-4">Cáº§n tÆ° váº¥n sá»©c khá»e?</h3>
                            <p class="lead mb-4">LiÃªn há» vá»i chÃºng tÃ´i Äá» ÄÆ°á»£c tÆ° váº¥n trá»±c tiáº¿p tá»« cÃ¡c bÃ¡c sÄ© chuyÃªn mÃ´n</p>
                            <div class="d-flex justify-content-center gap-3">
                                <a href="${pageContext.request.contextPath}/contact" class="btn btn-primary">
                                    <i class="bi bi-telephone"></i> LiÃªn há» ngay
                                </a>
                                <a href="${pageContext.request.contextPath}/doctors" class="btn btn-outline-primary">
                                    <i class="bi bi-person-badge"></i> Xem danh sÃ¡ch bÃ¡c sÄ©
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <%@ include file="../layouts/footer.jsp" %>
</div>

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/jwt-manager.js"></script>

<style>
.consultation-content {
    line-height: 1.6;
    font-size: 1rem;
}

.modal-lg {
    max-width: 800px;
}

.card.border-primary {
    border-color: #0d6efd !important;
}

.card.border-info {
    border-color: #0dcaf0 !important;
}

.card.border-success {
    border-color: #198754 !important;
}

.modal-header.bg-primary {
    background-color: #0d6efd !important;
}
</style>

<script>
// Thiáº¿t láº­p active menu
document.addEventListener('DOMContentLoaded', function() {
    const navLinks = document.querySelectorAll('.nav-link');
    navLinks.forEach(link => {
        if (link.textContent.trim() === 'TÆ° váº¥n sá»©c khá»e') {
            link.classList.add('active');
        }
    });
    
    // ThÃªm hiá»u á»©ng cho modal
    const modals = document.querySelectorAll('.modal');
    modals.forEach(modal => {
        modal.addEventListener('shown.bs.modal', function() {
            // ThÃªm hiá»u á»©ng fade in cho ná»i dung
            const modalBody = this.querySelector('.modal-body');
            modalBody.style.opacity = '0';
            modalBody.style.transform = 'translateY(20px)';
            
            setTimeout(() => {
                modalBody.style.transition = 'all 0.3s ease';
                modalBody.style.opacity = '1';
                modalBody.style.transform = 'translateY(0)';
            }, 100);
        });
    });
});
</script>
</body>
</html> 