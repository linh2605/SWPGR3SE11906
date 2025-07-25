<%@ page import="java.util.List" %>
<%@ page import="models.ConsultationSession" %>
<%@ page import="models.ConsultationMessage" %>
<%@ page import="models.User" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Chat tư vấn - Fauguet Medical</title>
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
            <div class="container-fluid">
                <%
                    ConsultationSession consultationSession = (ConsultationSession) request.getAttribute("session");
                    List<ConsultationMessage> messages = (List<ConsultationMessage>) request.getAttribute("messages");
                    User currentUser = (User) request.getAttribute("currentUser");
                    boolean isPatient = currentUser.getRole().getRoleId() == 1;
                    boolean isDoctor = currentUser.getRole().getRoleId() == 2;
                %>
                
                <!-- Header -->
                <div class="row mb-4">
                    <div class="col-12">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <a href="${pageContext.request.contextPath}/consultation-chat" class="btn btn-outline-secondary">
                                    <i class="bi bi-arrow-left"></i> Quay lại
                                </a>
                            </div>
                            <div class="text-center">
                                <h4 class="mb-1">
                                    <% if (isPatient) { %>
                                        <i class="bi bi-person-badge text-primary"></i> 
                                        Bác sĩ <%= consultationSession.getDoctor().getUser().getFullName() %>
                                    <% } else if (isDoctor) { %>
                                        <i class="bi bi-person text-info"></i> 
                                        Bệnh nhân <%= consultationSession.getPatient().getUser().getFullName() %>
                                    <% } %>
                                </h4>
                                <span class="badge <%= getStatusBadgeClass(consultationSession.getStatus()) %>">
                                    <%= consultationSession.getStatusDisplay() %>
                                </span>
                            </div>
                            <div>
                                <button class="btn btn-outline-primary" onclick="refreshMessages()">
                                    <i class="bi bi-arrow-clockwise"></i> Làm mới
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <!-- Chat area -->
                    <div class="col-lg-9">
                        <div class="card chat-card shadow-lg">
                            <div class="card-header bg-primary text-white py-3">
                                <h5 class="mb-0">
                                    <i class="bi bi-chat-dots me-2"></i> Tin nhắn tư vấn
                                </h5>
                            </div>
                            <div class="card-body chat-body" id="chatMessages">
                                <% if (messages != null && !messages.isEmpty()) { %>
                                    <% for (ConsultationMessage message : messages) { %>
                                        <div class="message <%= message.isFromPatient() ? "message-patient" : "message-doctor" %>">
                                            <div class="message-content">
                                                <div class="message-header">
                                                    <strong>
                                                        <% if (message.isFromPatient()) { %>
                                                            <%= consultationSession.getPatient().getUser().getFullName() %>
                                                        <% } else { %>
                                                            Bác sĩ <%= consultationSession.getDoctor().getUser().getFullName() %>
                                                        <% } %>
                                                    </strong>
                                                    <small class="text-muted">
                                                        <%= message.getCreated_at() != null ? message.getCreated_at().toString().substring(11, 16) : "" %>
                                                    </small>
                                                </div>
                                                <div class="message-text">
                                                    <%= message.getMessage_content() %>
                                                </div>
                                            </div>
                                        </div>
                                    <% } %>
                                <% } else { %>
                                    <div class="text-center text-muted py-5">
                                        <i class="bi bi-chat-dots" style="font-size: 4rem; opacity: 0.5;"></i>
                                        <h4 class="mt-3">Chưa có tin nhắn nào</h4>
                                        <p class="fs-5">Hãy bắt đầu cuộc trò chuyện!</p>
                                    </div>
                                <% } %>
                            </div>
                            
                            <!-- Message input -->
                            <div class="card-footer bg-light py-3">
                                <form id="messageForm" class="d-flex">
                                    <input type="hidden" name="session_id" value="<%= consultationSession.getSession_id() %>">
                                    <input type="text" name="message_content" class="form-control me-3" 
                                           placeholder="Nhập tin nhắn..." required>
                                    <button type="submit" class="btn btn-primary px-4">
                                        <i class="bi bi-send me-2"></i> Gửi
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- Sidebar info -->
                    <div class="col-lg-3">
                        <div class="card shadow-lg">
                            <div class="card-header bg-info text-white py-3">
                                <h6 class="mb-0">
                                    <i class="bi bi-info-circle me-2"></i> Thông tin phiên tư vấn
                                </h6>
                            </div>
                            <div class="card-body p-4">
                                <div class="mb-4">
                                    <strong><i class="bi bi-thermometer-half text-warning me-2"></i> Triệu chứng:</strong>
                                    <p class="text-muted mt-2 fs-6"><%= consultationSession.getPatient_symptoms() != null ? consultationSession.getPatient_symptoms() : "Không có" %></p>
                                </div>
                                <div class="mb-4">
                                    <strong><i class="bi bi-chat-quote text-primary me-2"></i> Tin nhắn đầu tiên:</strong>
                                    <p class="text-muted mt-2 fs-6"><%= consultationSession.getPatient_message() != null ? consultationSession.getPatient_message() : "Không có" %></p>
                                </div>
                                <div class="mb-4">
                                    <strong><i class="bi bi-calendar-plus text-success me-2"></i> Ngày tạo:</strong>
                                    <p class="text-muted mt-2 fs-6"><%= consultationSession.getCreated_at() != null ? consultationSession.getCreated_at().toString().substring(0, 16) : "N/A" %></p>
                                </div>
                                <div class="mb-4">
                                    <strong><i class="bi bi-clock-history text-secondary me-2"></i> Cập nhật lần cuối:</strong>
                                    <p class="text-muted mt-2 fs-6"><%= consultationSession.getUpdated_at() != null ? consultationSession.getUpdated_at().toString().substring(0, 16) : "N/A" %></p>
                                </div>
                                
                                <% if (isDoctor && !consultationSession.isCompleted()) { %>
                                <div class="d-grid gap-2">
                                    <button class="btn btn-success py-2" onclick="completeSession()">
                                        <i class="bi bi-check-circle me-2"></i> Hoàn thành phiên tư vấn
                                    </button>
                                </div>
                                <% } %>
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

<script>
var contextPath = '<%= request.getContextPath() %>';
const isPatient = <%= isPatient %>;
const senderName = isPatient ? '<%= consultationSession.getPatient().getUser().getFullName() %>' : 'Bác sĩ <%= consultationSession.getDoctor().getUser().getFullName() %>';
let websocket;
const sessionId = '<%= consultationSession.getSession_id() %>';

function initWebSocket() {
    if (!sessionId) {
        console.error('sessionId is empty!');
        return;
    }
    // window.location.origin includes protocol, host, and port
    const wsProtocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
    const wsUrl = wsProtocol + '//' + window.location.host + contextPath + '/websocket/chat/' + sessionId;
    console.log('Connecting WebSocket to:', wsUrl);
    websocket = new WebSocket(wsUrl);
    websocket.onopen = function(event) {
        console.log('WebSocket connected');
    };
    websocket.onmessage = function(event) {
        try {
            const data = JSON.parse(event.data);
            console.log('WebSocket received:', data);
            if (data.type === 'new_message') {
                addMessageToChat(data.message);
            }
        } catch (e) {
            console.error('WebSocket message parse error:', e, event.data);
        }
    };
    websocket.onclose = function(event) {
        console.log('WebSocket disconnected');
        setTimeout(initWebSocket, 3000);
    };
    websocket.onerror = function(error) {
        console.error('WebSocket error:', error);
    };
}

// Auto scroll to bottom
function scrollToBottom() {
    const chatMessages = document.getElementById('chatMessages');
    chatMessages.scrollTop = chatMessages.scrollHeight;
}

// Add new message to chat
function addMessageToChat(message) {
    console.log('addMessageToChat:', message);
    if (!message || !message.message_content || !message.senderName) {
        console.warn('Message object thiếu trường hoặc rỗng:', message);
        return; // Không render nếu thiếu nội dung
    }
    const chatMessages = document.getElementById('chatMessages');
    const messageDiv = document.createElement('div');
    messageDiv.className = `message ${message.isFromPatient ? 'message-patient' : 'message-doctor'}`;

    const time = new Date(message.created_at).toLocaleTimeString('vi-VN', {hour: '2-digit', minute: '2-digit'});

    const contentDiv = document.createElement('div');
    contentDiv.className = 'message-content';

    const headerDiv = document.createElement('div');
    headerDiv.className = 'message-header';

    const strong = document.createElement('strong');
    strong.textContent = message.senderName;

    const small = document.createElement('small');
    small.className = 'text-muted';
    small.textContent = time;

    headerDiv.appendChild(strong);
    headerDiv.appendChild(small);

    const textDiv = document.createElement('div');
    textDiv.className = 'message-text';
    textDiv.textContent = message.message_content;

    contentDiv.appendChild(headerDiv);
    contentDiv.appendChild(textDiv);
    messageDiv.appendChild(contentDiv);
    chatMessages.appendChild(messageDiv);
    scrollToBottom();
}

// Load messages (fallback)
function refreshMessages() {
    location.reload();
}

// Send message
document.getElementById('messageForm').addEventListener('submit', function(e) {
    e.preventDefault();
    
    const formData = new FormData(this);
    formData.append('action', 'send-message');
    
    // Convert FormData to URLSearchParams for better compatibility
    const params = new URLSearchParams();
    for (let [key, value] of formData.entries()) {
        params.append(key, value);
    }
    
    console.log('Sending message with params:', params.toString());
    
    fetch('${pageContext.request.contextPath}/consultation-chat', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: params
    })
    .then(response => response.text())
    .then(text => {
        try {
            const data = JSON.parse(text);
            if (data.success) {
                this.querySelector('input[name="message_content"]').value = '';
                // Gửi message qua WebSocket, chỉ render khi nhận lại qua WebSocket
                const messageContent = formData.get('message_content');
                const currentTime = new Date().toISOString();
                const newMessage = {
                    message_content: messageContent,
                    created_at: currentTime,
                    isFromPatient: isPatient,
                    senderName: senderName
                };
                console.log('Sending WebSocket message:', {
                    type: 'new_message',
                    message: newMessage
                });
                if (websocket && websocket.readyState === WebSocket.OPEN) {
                    websocket.send(JSON.stringify({
                        type: 'new_message',
                        message: newMessage
                    }));
                } else {
                    // Nếu WebSocket chưa sẵn sàng, fallback reload sau 1s
                    setTimeout(() => location.reload(), 1000);
                }
            } else {
                alert('Lỗi: ' + data.message);
            }
        } catch (e) {
            console.error('JSON parse error:', e);
            console.error('Response text:', text);
            alert('Có lỗi xảy ra khi gửi tin nhắn.');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('Có lỗi xảy ra khi gửi tin nhắn: ' + error.message);
    });
});

// Complete session (for doctors)
function completeSession() {
    if (confirm('Bạn có chắc muốn hoàn thành phiên tư vấn này?')) {
        fetch('${pageContext.request.contextPath}/consultation-chat', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'action=complete-session&session_id=<%= consultationSession.getSession_id() %>'
        })
        .then(response => {
            console.log('Complete session response status:', response.status);
            return response.text().then(text => {
                console.log('Complete session raw response:', text);
                try {
                    return JSON.parse(text);
                } catch (e) {
                    console.error('JSON parse error:', e);
                    throw new Error('Invalid JSON response: ' + text);
                }
            });
        })
        .then(data => {
            if (data.success) {
                alert('Đã hoàn thành phiên tư vấn!');
                location.reload();
            } else {
                alert('Lỗi: ' + data.message);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Có lỗi xảy ra: ' + error.message);
        });
    }
}

// Initialize WebSocket when page loads
document.addEventListener('DOMContentLoaded', function() {
    scrollToBottom();
    initWebSocket();
});

// Fallback: Auto refresh every 30 seconds if WebSocket fails
setInterval(function() {
    if (!websocket || websocket.readyState !== WebSocket.OPEN) {
        console.log('WebSocket not available, using fallback refresh');
        refreshMessages();
    }
}, 30000);
</script>

<style>
.chat-card {
    height: 75vh;
    display: flex;
    flex-direction: column;
    border: none;
    border-radius: 15px;
    overflow: hidden;
}

.chat-body {
    flex: 1;
    overflow-y: auto;
    padding: 1.5rem;
    background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
}

.message {
    margin-bottom: 1.5rem;
    display: flex;
    animation: fadeIn 0.3s ease-in;
}

.message-patient {
    justify-content: flex-end;
}

.message-doctor {
    justify-content: flex-start;
}

.message-content {
    max-width: 70%;
    padding: 1rem;
    border-radius: 1.5rem;
    position: relative;
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}

.message-patient .message-content {
    background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
    color: white;
    border-bottom-right-radius: 0.5rem;
}

.message-doctor .message-content {
    background: white;
    border: 1px solid #dee2e6;
    border-bottom-left-radius: 0.5rem;
}

.message-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 0.5rem;
    font-size: 0.875rem;
}

.message-text {
    line-height: 1.5;
    font-size: 0.95rem;
}

.message-patient .message-header small {
    color: rgba(255, 255, 255, 0.8);
}

.message-doctor .message-header small {
    color: #6c757d;
}

@keyframes fadeIn {
    from { opacity: 0; transform: translateY(10px); }
    to { opacity: 1; transform: translateY(0); }
}

.card {
    border: none;
    border-radius: 15px;
    box-shadow: 0 4px 15px rgba(0,0,0,0.1);
}

.card-header {
    border-radius: 15px 15px 0 0 !important;
    border: none;
}

.btn {
    border-radius: 10px;
    font-weight: 500;
}

.form-control {
    border-radius: 10px;
    border: 1px solid #dee2e6;
}

.form-control:focus {
    border-color: #007bff;
    box-shadow: 0 0 0 0.2rem rgba(0,123,255,0.25);
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