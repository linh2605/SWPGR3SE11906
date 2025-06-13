<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="vi">
    <head>
        <title>Đặt lịch khám - G3 Hospital</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4Q6Gf2aSP4eDXB8Miphtr37CMZZQ5oXLH2yaXMJ2w8e2ZtHTl7GptT4jmndRuHDT" crossorigin="anonymous">
        <!-- Bootstrap Icons -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <!-- FullCalendar CSS -->
        <link href="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.css" rel="stylesheet">
        <!-- Custom CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
    </head>
    <body id="appointments">
        <!-- Header -->
        <%@ include file="../layouts/header.jsp" %>
        <!-- Main Content -->
        <main class="container my-5">
            <h2 class="section-title text-center mb-4">ĐẶT LỊCH KHÁM</h2>
            <c:if test="${errorMsg != null}">
                <div class="alert alert-danger fs-5 row mb-3" role="alert">
                    ${errorMsg}
                </div>
            </c:if>
            <div class="">
                <form id="bookingForm" 
                      action="${pageContext.request.contextPath}/appointment" 
                      method="POST">
                    <div class="row mb-3">
                        <div class="col-md-3">
                            <label for="fullName" class="form-label">Họ và tên</label>
                        </div>
                        <div class="col-md-9">
                            <input type="text" 
                                   class="form-control" 
                                   id="fullName" 
                                   name="fullName"
                                   value="${patient.fullName}"
                                   required>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-3">
                            <label for="phone" class="form-label">Số điện thoại</label>
                        </div>
                        <div class="col-md-9">
                            <input type="tel" 
                                   class="form-control" 
                                   id="phone" 
                                   name="phone"
                                   value="${patient.user.phone}"
                                   required>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-3">
                            <label for="email" class="form-label">Email</label>
                        </div>
                        <div class="col-md-9">
                            <input type="email" 
                                   class="form-control" 
                                   id="email" 
                                   name="email" 
                                   value="${patient.user.email}"
                                   required>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-3">
                            <label for="doctor" class="form-label">Bác sĩ</label>
                        </div>
                        <div class="col-md-9">
                            <select class="form-select" id="doctor" name="doctor" required>
                                <option value="" disabled selected>Chọn bác sĩ</option>
                                <c:forEach var="d" items="${doctors}">
                                    <option value="${d.doctor_id}" 
                                            ${doctorId == d.doctor_id ? 'selected' : ''}
                                            >
                                        ${d.specialty.name} - ${d.degree} ${d.user.fullName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-3">
                            <label for="appointmentDate" class="form-label">Ngày giờ hẹn</label>
                        </div>
                        <div class="col-md-9">
                            <input type="datetime-local" 
                                   class="form-control" 
                                   id="appointmentDate" 
                                   name="appointmentDate" 
                                   value="${appointmentDate}"
                                   required>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-3">
                            <label for="note" class="form-label">Ghi chú</label>
                        </div>
                        <div class="col-md-9">
                            <textarea class="form-control" id="note" name="note" rows="3" required>${note}</textarea>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-3"></div>
                        <div class="col-md-9">
                            <button type="submit" class="btn btn-primary w-100">Đặt lịch</button>
                        </div>
                    </div>
                    <input type="hidden" name="patientId" value ="${patient.patient_id}"/>
                </form>
            </div>
        </main>

        <!-- Footer -->
        <%@ include file="../layouts/footer.jsp" %>

        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js" integrity="sha384-j1CDi7MgGQ12Z7Qab0qlWQ/Qqz24Gc6BM0thvEMVjHnfYGF0rmFCozFSxQBxwHKO" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.js"></script>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/scripts.js"></script>
    </body>
</html>