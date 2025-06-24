<%-- 
    Document   : list
    Created on : May 26, 2025, 8:29:00 AM
    Author     : tuan
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<html lang="vi">
    <head>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
        <!-- Bootstrap Icons -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <!-- Custom CSS (đã bao gồm Leaflet CSS) -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">

        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/favicon.svg" />
        <link href="${pageContext.request.contextPath}/assets/css/doctor-list.css" media="screen" rel="stylesheet" type="text/css" />

        <title>Danh sách bác sĩ</title>
        <style>
            .page-btn.active {
                background-color: #004D99;
                color: white;
            }
        </style>
    </head>

    <body>
        <!-- Nhúng header và navbar -->
        <%@ include file="../layouts/header.jsp" %>

        <!--<main class="container my-5">-->
        <main>
            <div id="doctor">
                <div class="Banner">
                    <div class="-img">
                        <img
                            src="../../assets/pexels-photo-5327590.png"
                            alt=""
                            title=""
                            class="ls-is-cached lazyloaded"/>
                    </div>

                    <div class="-txt">
                        <div class="container-fluid">
                            <h1 class="-title">Danh sách bác sĩ</h1>

                            <nav aria-label="breadcrumb">
                                <ol class="breadcrumb">
                                    <li class="breadcrumb-item">
                                        <a class="-link" href="${pageContext.request.contextPath}">
                                            Trang chủ
                                        </a>
                                    </li>

                                    <li class="breadcrumb-item active" aria-current="page"> <!--chưa ăn icon bootstrap-->
                                        Danh sách bác sĩ
                                    </li>
                                </ol>
                            </nav>
                        </div>
                    </div>
                </div>

                <div class="doctorFilter">
                    <div class="container-fluid" id="doctoFilterAjax">

                        <div class="row">
                            <div class="col-md-3">
                                <div class="-top">
                                    <form class="-search" id="doctor-search-form">
                                        <input
                                            type="text"
                                            name="doctor-search"
                                            id="doctor-search"
                                            placeholder="Tìm kiếm" />
                                        <input
                                            type="text"
                                            name="app-locale"
                                            id="app-locale"
                                            value="vi"
                                            hidden="" />
                                        <div class="-icon">
                                            <img src="../../assets/icon-search.svg" alt="" />
                                        </div>
                                    </form>
                                </div>

                                <div class="tabAll" id="tabDoctor" role="tablist">
                                    <div
                                        class="-itemTab active"

                                        type="button"
                                        role="tab"
                                        aria-selected="true"
                                        data-specialist-id="all">
                                        Tất cả
                                        <div class="-number">${countAllSpecialties}</div>
                                    </div>
                                    <c:forEach var="s" items="${specialties}">
                                        <button
                                            class="-itemTab nav-link"

                                            type="button"
                                            role="tab"
                                            aria-selected="false"
                                            data-specialist-id="${s.key.specialty_id}">
                                            ${s.key.name}
                                            <div class="-number">${s.value}</div>
                                        </button>
                                    </c:forEach>
                                    <!--                                    <button
                                                                            class="-itemTab nav-link"
                                                                            id="nav-1128-tab"
                                                                            data-bs-toggle="tab"
                                                                            data-bs-target="#nav-1128"
                                                                            type="button"
                                                                            role="tab"
                                                                            aria-controls="nav-1128"
                                                                            aria-selected="false"
                                                                            data-specialist="1128"
                                                                            tabindex="-1">
                                                                            Đơn nguyên Nam Khoa &amp; PT Tiết Niệu
                                                                            <div class="-number">6</div>
                                                                        </button>
                                    
                                                                        <button
                                                                            class="-itemTab nav-link"
                                                                            id="nav-1119-tab"
                                                                            data-bs-toggle="tab"
                                                                            data-bs-target="#nav-1119"
                                                                            type="button"
                                                                            role="tab"
                                                                            aria-controls="nav-1119"
                                                                            aria-selected="false"
                                                                            data-specialist="1119"
                                                                            tabindex="-1">
                                                                            Khoa Cấp Cứu - Hồi Sức Tích Cực ICU
                                                                            <div class="-number">12</div>
                                                                        </button>
                                    
                                                                        <button
                                                                            class="-itemTab nav-link"
                                                                            id="nav-1120-tab"
                                                                            data-bs-toggle="tab"
                                                                            data-bs-target="#nav-1120"
                                                                            type="button"
                                                                            role="tab"
                                                                            aria-controls="nav-1120"
                                                                            aria-selected="false"
                                                                            data-specialist="1120"
                                                                            tabindex="-1">
                                                                            Khoa Chẩn đoán hình ảnh và Điện quang can thiệp
                                                                            <div class="-number">11</div>
                                                                        </button>
                                    
                                                                        <button
                                                                            class="-itemTab nav-link"
                                                                            id="nav-1121-tab"
                                                                            data-bs-toggle="tab"
                                                                            data-bs-target="#nav-1121"
                                                                            type="button"
                                                                            role="tab"
                                                                            aria-controls="nav-1121"
                                                                            aria-selected="false"
                                                                            data-specialist="1121"
                                                                            tabindex="-1">
                                                                            Khoa Cơ - Xương - Khớp
                                                                            <div class="-number">10</div>
                                                                        </button>
                                    
                                                                        <button
                                                                            class="-itemTab nav-link"
                                                                            id="nav-1122-tab"
                                                                            data-bs-toggle="tab"
                                                                            data-bs-target="#nav-1122"
                                                                            type="button"
                                                                            role="tab"
                                                                            aria-controls="nav-1122"
                                                                            aria-selected="false"
                                                                            data-specialist="1122"
                                                                            tabindex="-1">
                                                                            Khoa Da Liễu
                                                                            <div class="-number">4</div>
                                                                        </button>
                                    
                                                                        <button
                                                                            class="-itemTab nav-link"
                                                                            id="nav-1124-tab"
                                                                            data-bs-toggle="tab"
                                                                            data-bs-target="#nav-1124"
                                                                            type="button"
                                                                            role="tab"
                                                                            aria-controls="nav-1124"
                                                                            aria-selected="false"
                                                                            data-specialist="1124"
                                                                            tabindex="-1">
                                                                            Khoa Hô Hấp
                                                                            <div class="-number">6</div>
                                                                        </button>
                                    
                                                                        <button
                                                                            class="-itemTab nav-link"
                                                                            id="nav-1127-tab"
                                                                            data-bs-toggle="tab"
                                                                            data-bs-target="#nav-1127"
                                                                            type="button"
                                                                            role="tab"
                                                                            aria-controls="nav-1127"
                                                                            aria-selected="false"
                                                                            data-specialist="1127"
                                                                            tabindex="-1">
                                                                            Khoa Mắt
                                                                            <div class="-number">12</div>
                                                                        </button>
                                    
                                                                        <button
                                                                            class="-itemTab nav-link"
                                                                            id="nav-27775-tab"
                                                                            data-bs-toggle="tab"
                                                                            data-bs-target="#nav-27775"
                                                                            type="button"
                                                                            role="tab"
                                                                            aria-controls="nav-27775"
                                                                            aria-selected="false"
                                                                            data-specialist="27775"
                                                                            tabindex="-1">
                                                                            Khoa Ngoại Chấn Thương Chỉnh Hình - Thần Kinh Sọ Não
                                                                            <div class="-number">19</div>
                                                                        </button>
                                    
                                                                        <button
                                                                            class="-itemTab nav-link"
                                                                            id="nav-1129-tab"
                                                                            data-bs-toggle="tab"
                                                                            data-bs-target="#nav-1129"
                                                                            type="button"
                                                                            role="tab"
                                                                            aria-controls="nav-1129"
                                                                            aria-selected="false"
                                                                            data-specialist="1129"
                                                                            tabindex="-1">
                                                                            Khoa Ngoại Tổng Hợp
                                                                            <div class="-number">15</div>
                                                                        </button>
                                    
                                                                        <button
                                                                            class="-itemTab nav-link"
                                                                            id="nav-1130-tab"
                                                                            data-bs-toggle="tab"
                                                                            data-bs-target="#nav-1130"
                                                                            type="button"
                                                                            role="tab"
                                                                            aria-controls="nav-1130"
                                                                            aria-selected="false"
                                                                            data-specialist="1130"
                                                                            tabindex="-1">
                                                                            Khoa Nhi
                                                                            <div class="-number">102</div>
                                                                        </button>
                                    
                                                                        <button
                                                                            class="-itemTab nav-link"
                                                                            id="nav-1132-tab"
                                                                            data-bs-toggle="tab"
                                                                            data-bs-target="#nav-1132"
                                                                            type="button"
                                                                            role="tab"
                                                                            aria-controls="nav-1132"
                                                                            aria-selected="false"
                                                                            data-specialist="1132"
                                                                            tabindex="-1">
                                                                            Khoa Nội Tiết
                                                                            <div class="-number">8</div>
                                                                        </button>
                                    
                                                                        <button
                                                                            class="-itemTab nav-link"
                                                                            id="nav-1131-tab"
                                                                            data-bs-toggle="tab"
                                                                            data-bs-target="#nav-1131"
                                                                            type="button"
                                                                            role="tab"
                                                                            aria-controls="nav-1131"
                                                                            aria-selected="false"
                                                                            data-specialist="1131"
                                                                            tabindex="-1">
                                                                            Khoa Nội Tổng Hợp
                                                                            <div class="-number">13</div>
                                                                        </button>
                                    
                                                                        <button
                                                                            class="-itemTab nav-link"
                                                                            id="nav-1133-tab"
                                                                            data-bs-toggle="tab"
                                                                            data-bs-target="#nav-1133"
                                                                            type="button"
                                                                            role="tab"
                                                                            aria-controls="nav-1133"
                                                                            aria-selected="false"
                                                                            data-specialist="1133"
                                                                            tabindex="-1">
                                                                            Khoa Răng Hàm Mặt
                                                                            <div class="-number">17</div>
                                                                        </button>
                                    
                                                                        <button
                                                                            class="-itemTab nav-link"
                                                                            id="nav-1134-tab"
                                                                            data-bs-toggle="tab"
                                                                            data-bs-target="#nav-1134"
                                                                            type="button"
                                                                            role="tab"
                                                                            aria-controls="nav-1134"
                                                                            aria-selected="false"
                                                                            data-specialist="1134"
                                                                            tabindex="-1">
                                                                            Khoa Sản - Phụ Khoa
                                                                            <div class="-number">16</div>
                                                                        </button>-->
                                </div>
                            </div>

                            <div class="col-md-9 tab-content" id="tabDoctorContent">
                                <div
                                    class="-listdoctor tab-pane fade show active"
                                    id="nav-all"
                                    role="tabpanel"
                                    aria-labelledby="nav-all-tab">
                                    <div class="row">
                                        <c:forEach var="d" items="${doctors}">
                                            <div class="col-md-6 doctor-item" data-specialist-id="${d.specialty.specialty_id}">
                                                <div class="itemDoctor" >
                                                    <div class="-img">
                                                        <img
                                                            src="${d.image_url}"
                                                            alt=""
                                                            title=""
                                                            class="ls-is-cached lazyloaded" />
                                                    </div>

                                                    <div class="-txt">
                                                        <a
                                                            href="${pageContext.request.contextPath}/doctors/${d.doctor_id}"
                                                            class="-link">
                                                            <h6 class="-name">${d.user.fullName}</h6>
                                                        </a>

                                                        <div class="-des"></div>

                                                        <a
                                                            href="${pageContext.request.contextPath}/doctors/${d.doctor_id}"
                                                            class="-viewdetail">
                                                            Xem chi tiết
                                                        </a>

                                                        <ul>
                                                            <li>
                                                                <img
                                                                    src="../../assets/icon-graduation.svg"
                                                                    alt=""
                                                                    class="ls-is-cached lazyloaded" />
                                                                <span> ${d.degree} </span>
                                                            </li>

                                                            <li>
                                                                <img
                                                                    src="../../assets/icon-hospital.svg"
                                                                    alt=""
                                                                    class="ls-is-cached lazyloaded" />
                                                                <span> ${d.experience} </span>
                                                            </li>
                                                        </ul>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                        <!--                                        <div class="col-md-6">
                                                                                    <div class="itemDoctor">
                                                                                        <div class="-img">
                                                                                            <img
                                                                                                src="../../assets/doctor-image.png"
                                                                                                alt=""
                                                                                                title=""
                                                                                                class="ls-is-cached lazyloaded" />
                                                                                        </div>
                                        
                                                                                        <div class="-txt">
                                                                                            <a
                                                                                                href="#"
                                                                                                class="-link">
                                                                                                <h6 class="-name">PGS.TS - Nguyễn Văn A</h6>
                                                                                            </a>
                                        
                                                                                            <div class="-des"></div>
                                        
                                                                                            <a
                                                                                                href="#"
                                                                                                class="-viewdetail">
                                                                                                Xem chi tiết
                                                                                            </a>
                                        
                                                                                            <ul>
                                                                                                <li>
                                                                                                    <img
                                                                                                        src="../../assets/icon-graduation.svg"
                                                                                                        alt=""
                                                                                                        class="ls-is-cached lazyloaded" />
                                                                                                    <span> Phó Giáo sư, Tiến sĩ </span>
                                                                                                </li>
                                        
                                                                                                <li>
                                                                                                    <img
                                                                                                        src="../../assets/icon-hospital.svg"
                                                                                                        alt=""
                                                                                                        class="ls-is-cached lazyloaded" />
                                                                                                    <span> Bệnh viện Đa khoa A </span>
                                                                                                </li>
                                                                                            </ul>
                                                                                        </div>
                                                                                    </div>
                                                                                </div>
                                                                                <div class="col-md-6">
                                                                                    <div class="itemDoctor">
                                                                                        <div class="-img">
                                                                                            <img
                                                                                                src="../../assets/doctor-image.png"
                                                                                                alt=""
                                                                                                title=""
                                                                                                class="ls-is-cached lazyloaded" />
                                                                                        </div>
                                        
                                                                                        <div class="-txt">
                                                                                            <a
                                                                                                href="#"
                                                                                                class="-link">
                                                                                                <h6 class="-name">ThS.BSCKII - Nguyễn Văn A</h6>
                                                                                            </a>
                                        
                                                                                            <div class="-des"></div>
                                        
                                                                                            <a
                                                                                                href="#"
                                                                                                class="-viewdetail">
                                                                                                Xem chi tiết
                                                                                            </a>
                                        
                                                                                            <ul>
                                                                                                <li>
                                                                                                    <img
                                                                                                        src="../../assets/icon-graduation.svg"
                                                                                                        alt=""
                                                                                                        class="ls-is-cached lazyloaded" />
                                                                                                    <span> Thạc sĩ, Bác sĩ Chuyên khoa II </span>
                                                                                                </li>
                                        
                                                                                                <li>
                                                                                                    <img
                                                                                                        src="../../assets/icon-hospital.svg"
                                                                                                        alt=""
                                                                                                        class="ls-is-cached lazyloaded" />
                                                                                                    <span> Bệnh viện Đa khoa A </span>
                                                                                                </li>
                                                                                            </ul>
                                                                                        </div>
                                                                                    </div>
                                                                                </div>
                                                                                <div class="col-md-6">
                                                                                    <div class="itemDoctor">
                                                                                        <div class="-img">
                                                                                            <img
                                                                                                src="../../assets/doctor-image.png"
                                                                                                alt=""
                                                                                                title=""
                                                                                                class="ls-is-cached lazyloaded" />
                                                                                        </div>
                                        
                                                                                        <div class="-txt">
                                                                                            <a
                                                                                                href="#"
                                                                                                class="-link">
                                                                                                <h6 class="-name">PGS.TS - Nguyễn Văn A</h6>
                                                                                            </a>
                                        
                                                                                            <div class="-des"></div>
                                        
                                                                                            <a
                                                                                                href="#"
                                                                                                class="-viewdetail">
                                                                                                Xem chi tiết
                                                                                            </a>
                                        
                                                                                            <ul>
                                                                                                <li>
                                                                                                    <img
                                                                                                        src="../../assets/icon-graduation.svg"
                                                                                                        alt=""
                                                                                                        class="ls-is-cached lazyloaded" />
                                                                                                    <span> Phó Giáo sư, Tiến sĩ </span>
                                                                                                </li>
                                        
                                                                                                <li>
                                                                                                    <img
                                                                                                        src="../../assets/icon-hospital.svg"
                                                                                                        alt=""
                                                                                                        class="ls-is-cached lazyloaded" />
                                                                                                    <span> Bệnh viện Đa khoa A </span>
                                                                                                </li>
                                                                                            </ul>
                                                                                        </div>
                                                                                    </div>
                                                                                </div>
                                                                                <div class="col-md-6">
                                                                                    <div class="itemDoctor">
                                                                                        <div class="-img">
                                                                                            <img
                                                                                                src="../../assets/doctor-image.png"
                                                                                                alt=""
                                                                                                title=""
                                                                                                class="ls-is-cached lazyloaded" />
                                                                                        </div>
                                        
                                                                                        <div class="-txt">
                                                                                            <a
                                                                                                href="#"
                                                                                                class="-link">
                                                                                                <h6 class="-name">
                                                                                                    TTƯT.ThS.BSCKI - Nguyễn Văn A
                                                                                                </h6>
                                                                                            </a>
                                        
                                                                                            <div class="-des"></div>
                                        
                                                                                            <a
                                                                                                href="#"
                                                                                                class="-viewdetail">
                                                                                                Xem chi tiết
                                                                                            </a>
                                        
                                                                                            <ul>
                                                                                                <li>
                                                                                                    <img
                                                                                                        src="../../assets/icon-graduation.svg"
                                                                                                        alt=""
                                                                                                        class="ls-is-cached lazyloaded" />
                                                                                                    <span>
                                                                                                        Thầy thuốc ưu tú, Thạc sĩ, Bác sĩ Chuyên khoa I
                                                                                                    </span>
                                                                                                </li>
                                        
                                                                                                <li>
                                                                                                    <img
                                                                                                        src="../../assets/icon-hospital.svg"
                                                                                                        alt=""
                                                                                                        class="ls-is-cached lazyloaded" />
                                                                                                    <span> Bệnh viện Đa khoa A </span>
                                                                                                </li>
                                                                                            </ul>
                                                                                        </div>
                                                                                    </div>
                                                                                </div>
                                                                                <div class="col-md-6">
                                                                                    <div class="itemDoctor">
                                                                                        <div class="-img">
                                                                                            <img
                                                                                                src="../../assets/doctor-image.png"
                                                                                                alt=""
                                                                                                title=""
                                                                                                class="ls-is-cached lazyloaded" />
                                                                                        </div>
                                        
                                                                                        <div class="-txt">
                                                                                            <a
                                                                                                href="#"
                                                                                                class="-link">
                                                                                                <h6 class="-name">Ths. Bs - Nguyễn Văn A</h6>
                                                                                            </a>
                                        
                                                                                            <div class="-des"></div>
                                        
                                                                                            <a
                                                                                                href="#"
                                                                                                class="-viewdetail">
                                                                                                Xem chi tiết
                                                                                            </a>
                                        
                                                                                            <ul>
                                                                                                <li>
                                                                                                    <img
                                                                                                        src="../../assets/icon-graduation.svg"
                                                                                                        alt=""
                                                                                                        class="ls-is-cached lazyloaded" />
                                                                                                    <span> Bác sĩ, Thạc sĩ </span>
                                                                                                </li>
                                        
                                                                                                <li>
                                                                                                    <img
                                                                                                        src="../../assets/icon-hospital.svg"
                                                                                                        alt=""
                                                                                                        class="ls-is-cached lazyloaded" />
                                                                                                    <span>
                                                                                                        Bệnh viện Đa khoa A
                                                                                                    </span>
                                                                                                </li>
                                                                                            </ul>
                                                                                        </div>
                                                                                    </div>
                                                                                </div>
                                                                                <div class="col-md-6">
                                                                                    <div class="itemDoctor">
                                                                                        <div class="-img">
                                                                                            <img
                                                                                                src="../../assets/doctor-image.png"
                                                                                                alt=""
                                                                                                title=""
                                                                                                class="ls-is-cached lazyloaded" />
                                                                                        </div>
                                        
                                                                                        <div class="-txt">
                                                                                            <a
                                                                                                href="#"
                                                                                                class="-link">
                                                                                                <h6 class="-name">TS.BS. - Nguyễn Văn A</h6>
                                                                                            </a>
                                        
                                                                                            <div class="-des"></div>
                                        
                                                                                            <a
                                                                                                href="#"
                                                                                                class="-viewdetail">
                                                                                                Xem chi tiết
                                                                                            </a>
                                        
                                                                                            <ul>
                                                                                                <li>
                                                                                                    <img
                                                                                                        src="../../assets/icon-graduation.svg"
                                                                                                        alt=""
                                                                                                        class="ls-is-cached lazyloaded" />
                                                                                                    <span> Tiến sĩ, Bác sĩ </span>
                                                                                                </li>
                                        
                                                                                                <li>
                                                                                                    <img
                                                                                                        src="../../assets/icon-hospital.svg"
                                                                                                        alt=""
                                                                                                        class="ls-is-cached lazyloaded" />
                                                                                                    <span> Bệnh viện Đa khoa A </span>
                                                                                                </li>
                                                                                            </ul>
                                                                                        </div>
                                                                                    </div>
                                                                                </div>
                                                                                <div class="col-md-6">
                                                                                    <div class="itemDoctor">
                                                                                        <div class="-img">
                                                                                            <img
                                                                                                src="../../assets/doctor-image.png"
                                                                                                alt=""
                                                                                                title=""
                                                                                                class="ls-is-cached lazyloaded" />
                                                                                        </div>
                                        
                                                                                        <div class="-txt">
                                                                                            <a
                                                                                                href="#"
                                                                                                class="-link">
                                                                                                <h6 class="-name">TS. BS - Nguyễn Văn A</h6>
                                                                                            </a>
                                        
                                                                                            <a
                                                                                                href="#"
                                                                                                class="-viewdetail">
                                                                                                Xem chi tiết
                                                                                            </a>
                                        
                                                                                            <ul>
                                                                                                <li>
                                                                                                    <img
                                                                                                        src="../../assets/icon-graduation.svg"
                                                                                                        alt=""
                                                                                                        class="ls-is-cached lazyloaded" />
                                                                                                    <span> Tiến sĩ, Bác sĩ </span>
                                                                                                </li>
                                        
                                                                                                <li>
                                                                                                    <img
                                                                                                        src="../../assets/icon-hospital.svg"
                                                                                                        alt=""
                                                                                                        class="ls-is-cached lazyloaded" />
                                                                                                    <span>
                                                                                                        Bệnh viện Đa khoa A
                                                                                                    </span>
                                                                                                </li>
                                                                                            </ul>
                                                                                        </div>
                                        
                                        
                                                                                    </div>
                                                                                </div>
                                                                                <div class="col-md-6">
                                                                                    <div class="itemDoctor">
                                                                                        <div class="-img">
                                                                                            <img
                                                                                                src="../../assets/doctor-image.png"
                                                                                                alt=""
                                                                                                title=""
                                                                                                class="ls-is-cached lazyloaded" />
                                                                                        </div>
                                        
                                                                                        <div class="-txt">
                                                                                            <a
                                                                                                href="#"
                                                                                                class="-link">
                                                                                                <h6 class="-name">Nguyễn Văn A</h6>
                                                                                            </a>
                                        
                                                                                            <div class="-des"></div>
                                        
                                                                                            <a
                                                                                                href="#"
                                                                                                class="-viewdetail">
                                                                                                Xem chi tiết
                                                                                            </a>
                                        
                                                                                            <ul>
                                                                                                <li>
                                                                                                    <img
                                                                                                        src="../../assets/icon-graduation.svg"
                                                                                                        alt=""
                                                                                                        class="ls-is-cached lazyloaded" />
                                                                                                    <span> Phó Giáo sư, Tiến sĩ, Bác sĩ </span>
                                                                                                </li>
                                        
                                                                                                <li>
                                                                                                    <img
                                                                                                        src="../../assets/icon-hospital.svg"
                                                                                                        alt=""
                                                                                                        class="ls-is-cached lazyloaded" />
                                                                                                    <span> Bệnh viện Đa khoa A </span>
                                                                                                </li>
                                                                                            </ul>
                                                                                        </div>
                                                                                    </div>
                                                                                </div>
                                                                                <div class="col-md-6">
                                                                                    <div class="itemDoctor">
                                                                                        <div class="-img">
                                                                                            <img
                                                                                                src="../../assets/doctor-image.png"
                                                                                                alt=""
                                                                                                title=""
                                                                                                class="ls-is-cached lazyloaded" />
                                                                                        </div>
                                        
                                                                                        <div class="-txt">
                                                                                            <a
                                                                                                href="#"
                                                                                                class="-link">
                                                                                                <h6 class="-name">PGS.TS - Nguyễn Văn A</h6>
                                                                                            </a>
                                        
                                                                                            <div class="-des"></div>
                                        
                                                                                            <a
                                                                                                href="#"
                                                                                                class="-viewdetail">
                                                                                                Xem chi tiết
                                                                                            </a>
                                        
                                                                                            <ul>
                                                                                                <li>
                                                                                                    <img
                                                                                                        src="../../assets/icon-graduation.svg"
                                                                                                        alt=""
                                                                                                        class="ls-is-cached lazyloaded" />
                                                                                                    <span> Phó giáo sư, Tiến sĩ </span>
                                                                                                </li>
                                        
                                                                                                <li>
                                                                                                    <img
                                                                                                        src="../../assets/icon-hospital.svg"
                                                                                                        alt=""
                                                                                                        class="ls-is-cached lazyloaded" />
                                                                                                    <span>
                                                                                                        Bệnh viện Đa khoa A
                                                                                                    </span>
                                                                                                </li>
                                                                                            </ul>
                                                                                        </div>
                                                                                    </div>
                                                                                </div>
                                                                                <div class="col-md-6">
                                                                                    <div class="itemDoctor">
                                                                                        <div class="-img">
                                                                                            <img
                                                                                                src="../../assets/doctor-image.png"
                                                                                                alt=""
                                                                                                title=""
                                                                                                class="ls-is-cached lazyloaded" />
                                                                                        </div>
                                        
                                                                                        <div class="-txt">
                                                                                            <a
                                                                                                href="#"
                                                                                                class="-link">
                                                                                                <h6 class="-name">BSCKII - Nguyễn Văn A</h6>
                                                                                            </a>
                                        
                                                                                            <div class="-des"></div>
                                        
                                                                                            <a
                                                                                                href="#"
                                                                                                class="-viewdetail">
                                                                                                Xem chi tiết
                                                                                            </a>
                                        
                                                                                            <ul>
                                                                                                <li>
                                                                                                    <img
                                                                                                        src="../../assets/icon-graduation.svg"
                                                                                                        alt=""
                                                                                                        class="ls-is-cached lazyloaded" />
                                                                                                    <span> Bác sĩ Chuyên khoa II </span>
                                                                                                </li>
                                        
                                                                                                <li>
                                                                                                    <img
                                                                                                        src="../../assets/icon-hospital.svg"
                                                                                                        alt=""
                                                                                                        class="ls-is-cached lazyloaded" />
                                                                                                    <span>
                                                                                                        Bệnh viện Đa khoa A
                                                                                                    </span>
                                                                                                </li>
                                                                                            </ul>
                                                                                        </div>
                                                                                    </div>
                                                                                </div>-->
                                    </div>

                                    <div id="pagination-container" class="mt-4 text-center pagination"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <!-- Bản đồ OpenStreetMap với Leaflet -->
        <section class="map-section mb-4">
            <div id="map" style="height: 300px; width: 100%;"></div>
        </section>

        <!-- Nhúng footer -->
        <%@ include file="../layouts/footer.jsp" %>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
        <!-- Leaflet JS cho OpenStreetMap -->
        <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
        <!-- Custom JS (đã bao gồm script khởi tạo bản đồ) -->
        <script src="${pageContext.request.contextPath}/assets/js/scripts.js"></script>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const specialistButtons = document.querySelectorAll('[data-specialist-id]');
                const allDoctors = Array.from(document.querySelectorAll('.doctor-item'));
                const paginationContainer = document.getElementById('pagination-container');
                const searchInput = document.getElementById('doctor-search');

                const doctorsPerPage = 2; // config so bac si tren 1 trang
                let currentSpecialistId = 'all';
                let currentPage = 1;
                let currentKeyword = '';

                function normalize(str) {
                    return str.toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, "");
                }

                function getFilteredDoctors() {
                    return allDoctors.filter(doc => {
                        const docSpecId = doc.getAttribute('data-specialist-id');
                        const name = doc.querySelector('.-name')?.textContent || '';
                        const matchSpec = currentSpecialistId === 'all' || docSpecId === currentSpecialistId;
                        const matchKeyword = normalize(name).includes(normalize(currentKeyword));
                        return matchSpec && matchKeyword;
                    });
                }

                function renderDoctors() {
                    const filteredDoctors = getFilteredDoctors();
                    const totalPages = Math.ceil(filteredDoctors.length / doctorsPerPage);
                    if (currentPage > totalPages)
                        currentPage = 1;

                    const start = (currentPage - 1) * doctorsPerPage;
                    const end = start + doctorsPerPage;

                    allDoctors.forEach(doc => doc.style.display = 'none');
                    filteredDoctors.slice(start, end).forEach(doc => doc.style.display = 'block');

                    renderPagination(totalPages);
                }

                function renderPagination(totalPages) {
                    paginationContainer.innerHTML = '';
                    for (let i = 1; i <= totalPages; i++) {
                        const btn = document.createElement('button');
                        btn.className = 'btn btn-outline-primary m-1 page-btn';
                        btn.textContent = i;
                        if (i === currentPage)
                            btn.classList.add('active');

                        btn.addEventListener('click', () => {
                            currentPage = i;
                            renderDoctors();
                        });

                        paginationContainer.appendChild(btn);
                    }
                }

                specialistButtons.forEach(btn => {
                    btn.addEventListener('click', function () {
                        currentSpecialistId = btn.getAttribute('data-specialist-id');
                        currentPage = 1;

                        specialistButtons.forEach(b => b.classList.remove('active'));
                        btn.classList.add('active');

                        renderDoctors();
                    });
                });

                searchInput.addEventListener('input', function () {
                    currentKeyword = this.value;
                    currentPage = 1;
                    renderDoctors();
                });

                renderDoctors();
            });
        </script>

    </body>
</html>
