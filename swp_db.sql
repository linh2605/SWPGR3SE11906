-- MySQL dump 10.13  Distrib 8.4.3, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: swp_db
-- ------------------------------------------------------
-- Server version	8.4.3

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


DROP DATABASE IF EXISTS swp_db;
CREATE DATABASE swp_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE swp_db;

--
-- Table structure for table `appointments`
--

DROP TABLE IF EXISTS `appointments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `appointments` (
  `appointment_id` int NOT NULL AUTO_INCREMENT,
  `patient_id` int NOT NULL,
  `doctor_id` int NOT NULL,
  `appointment_date` datetime NOT NULL,
  `status` enum('pending','completed','canceled') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
  `note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `service_id` int DEFAULT NULL,
  `payment_status` enum('PENDING','PAID') COLLATE utf8mb4_unicode_ci DEFAULT 'PENDING',
  PRIMARY KEY (`appointment_id`),
  KEY `fk_appointment_patient` (`patient_id`),
  KEY `fk_appointment_doctor` (`doctor_id`),
  KEY `appointments_services_service_id_fk` (`service_id`),
  CONSTRAINT `appointments_services_service_id_fk` FOREIGN KEY (`service_id`) REFERENCES `services` (`service_id`),
  CONSTRAINT `fk_appointment_doctor` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`doctor_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_appointment_patient` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appointments`
--

INSERT INTO `appointments` VALUES (1,1,1,'2025-06-01 10:00:00','pending','Đau khớp gối, cần khám','2025-05-31 12:00:00','2025-06-25 08:19:06',2,'PENDING'),(2,2,2,'2025-06-01 11:00:00','pending','Đau bụng, nghi viêm ruột','2025-05-31 12:00:00','2025-06-25 08:19:06',3,'PENDING'),(3,1,2,'2025-06-04 10:00:00','completed','Đau khớp gối, cần khám','2025-05-31 12:00:00','2025-05-31 12:00:00',12,'PENDING'),(4,1,1,'2025-06-06 10:00:00','completed','Đau khớp gối, cần khám','2025-05-31 12:00:00','2025-06-25 08:19:11',4,'PENDING');

--
-- Table structure for table `contact_messages`
--

DROP TABLE IF EXISTS `contact_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contact_messages` (
  `message_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject` enum('service_feedback','incident_report','improvement_suggestion','cooperation','other') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('pending','in_progress','resolved') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
  `priority` enum('low','medium','high') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'medium',
  `assigned_to` int DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`message_id`),
  KEY `idx_email` (`email`),
  KEY `idx_phone` (`phone`),
  KEY `idx_status` (`status`),
  KEY `idx_subject` (`subject`),
  KEY `idx_priority` (`priority`),
  KEY `idx_created_at` (`created_at`),
  KEY `fk_contact_assigned_to` (`assigned_to`),
  CONSTRAINT `fk_contact_assigned_to` FOREIGN KEY (`assigned_to`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `check_contact_email` CHECK (regexp_like(`email`,_utf8mb3'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+.[A-Za-z]{2,}$')),
  CONSTRAINT `check_contact_phone` CHECK (regexp_like(`phone`,_utf8mb3'^[0-9]{10,15}$'))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contact_messages`
--

INSERT INTO `contact_messages` VALUES (1,'Nguyễn Văn A','nguyenvana@email.com','0987654321','service_feedback','Dịch vụ khám bệnh rất tốt, nhưng thời gian chờ hơi lâu','pending','medium',NULL,'2025-05-31 14:00:00','2025-05-31 14:00:00'),(2,'Trần Thị B','tranthib@email.com','0987654322','incident_report','Máy ATM trong bệnh viện bị hỏng','pending','high',NULL,'2025-05-31 15:00:00','2025-05-31 16:00:00'),(3,'Lê Văn C','levanc@email.com','0987654323','improvement_suggestion','Nên thêm dịch vụ gửi xe miễn phí cho bệnh nhân','pending','low',NULL,'2025-05-31 16:00:00','2025-05-31 16:00:00'),(4,'Phạm Thị D','phamthid@email.com','0987654324','cooperation','Công ty chúng tôi muốn hợp tác về dịch vụ bảo hiểm y tế','pending','high',NULL,'2025-05-31 17:00:00','2025-05-31 17:00:00');

--
-- Table structure for table `doctor_services`
--

DROP TABLE IF EXISTS `doctor_services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `doctor_services` (
  `id` int NOT NULL AUTO_INCREMENT,
  `doctor_id` int NOT NULL,
  `service_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `doctor_services_doctors_doctor_id_fk` (`doctor_id`),
  KEY `doctor_services_services_service_id_fk` (`service_id`),
  CONSTRAINT `doctor_services_doctors_doctor_id_fk` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`doctor_id`),
  CONSTRAINT `doctor_services_services_service_id_fk` FOREIGN KEY (`service_id`) REFERENCES `services` (`service_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doctor_services`
--


--
-- Table structure for table `doctors`
--

DROP TABLE IF EXISTS `doctors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `doctors` (
  `doctor_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `gender` enum('Male','Female','Other') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `image_url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `specialty_id` int DEFAULT NULL,
  `degree` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `experience` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `status` enum('active','inactive') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'active',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`doctor_id`),
  KEY `fk_doctor_user` (`user_id`),
  KEY `fk_doctor_specialty` (`specialty_id`),
  CONSTRAINT `fk_doctor_specialty` FOREIGN KEY (`specialty_id`) REFERENCES `specialties` (`specialty_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_doctor_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doctors`
--

INSERT INTO `doctors` VALUES (1,3,'Male','1980-03-15','https://example.com/doctor1.jpg',1,'ThS.BSCKI','10 năm kinh nghiệm tại BV Chợ Rẫy','active','2025-05-31 12:00:00'),(2,4,'Male','1985-07-20','https://example.com/doctor2.jpg',2,'BS','7 năm kinh nghiệm tại BV 115','active','2025-05-31 12:00:00'),(3,7,'Male','1985-07-20','https://example.com/doctor2.jpg',2,'BS','7 năm kinh nghiệm tại BV 115','active','2025-06-25 04:52:59');

--
-- Table structure for table `patients`
--

DROP TABLE IF EXISTS `patients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patients` (
  `patient_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `gender` enum('Male','Female','Other') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `address` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `image_url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`patient_id`),
  KEY `fk_patient_user` (`user_id`),
  CONSTRAINT `fk_patient_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patients`
--

INSERT INTO `patients` VALUES (1,1,'Male','1990-05-10','123 Đường Láng, Đống Đa, Hà Nội','https://example.com/patient1.jpg','2025-05-31 12:00:00'),(2,2,'Female','1995-08-25','456 Nguyễn Huệ, TP Huế','https://example.com/patient2.jpg','2025-05-31 12:00:00');

--
-- Table structure for table `receptionists`
--

DROP TABLE IF EXISTS `receptionists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `receptionists` (
  `receptionist_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `gender` enum('Male','Female','Other') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `image_url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `shift` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('active','inactive') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'active',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`receptionist_id`),
  KEY `fk_receptionist_user` (`user_id`),
  CONSTRAINT `fk_receptionist_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `receptionists`
--

INSERT INTO `receptionists` VALUES (1,5,'Female','1992-11-30','https://example.com/receptionist1.jpg','Sáng','active','2025-05-31 12:00:00');

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `role_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` VALUES (1,'patient','Bệnh nhân đặt lịch hẹn'),(2,'doctor','Bác sĩ khám bệnh'),(3,'receptionist','Lễ tân quản lý lịch hẹn'),(4,'admin','Quản trị viên hệ thống');

--
-- Table structure for table `schedule_exceptions`
--

DROP TABLE IF EXISTS `schedule_exceptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `schedule_exceptions` (
  `exception_id` int NOT NULL AUTO_INCREMENT,
  `doctor_id` int NOT NULL,
  `exception_date` date NOT NULL,
  `exception_type` enum('Nghỉ phép','Thay đổi giờ làm','Khẩn cấp') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `new_shift_id` int DEFAULT NULL,
  `reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `status` enum('Chờ duyệt','Đã duyệt','Đã từ chối') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'Chờ duyệt',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`exception_id`),
  UNIQUE KEY `unique_doctor_date` (`doctor_id`,`exception_date`),
  KEY `fk_exception_doctor` (`doctor_id`),
  KEY `fk_exception_new_shift` (`new_shift_id`),
  CONSTRAINT `fk_exception_doctor` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`doctor_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_exception_new_shift` FOREIGN KEY (`new_shift_id`) REFERENCES `shifts` (`shift_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedule_exceptions`
--

INSERT INTO `schedule_exceptions` VALUES (1,1,'2025-06-02','Nghỉ phép',NULL,'Nghỉ lễ','Chờ duyệt','2025-05-31 12:00:00'),(2,2,'2025-06-03','Thay đổi giờ làm',3,'Họp khoa','Chờ duyệt','2025-05-31 12:00:00');

--
-- Table structure for table `services`
--

DROP TABLE IF EXISTS `services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `services` (
  `service_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `detail` text COLLATE utf8mb4_unicode_ci,
  `price` bigint NOT NULL,
  `type` enum('COMBO','SPECIALIST','DEPARTMENT') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'SPECIALIST',
  PRIMARY KEY (`service_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `services`
--

INSERT INTO `services` VALUES (2,'Nhi khoa','Khám Nhi khoa',300000,'SPECIALIST'),(3,'Tim mạch','Tim mạch',250000,'SPECIALIST'),(4,'Tiêu hóa','Tiêu hóa',250000,'SPECIALIST'),(5,'Thần kinh','Thần kinh',250000,'SPECIALIST'),(6,'Hô hấp','Hô hấp',250000,'SPECIALIST'),(7,'Da liễu','Da liễu',200000,'SPECIALIST'),(8,'Mắt','Mắt',200000,'SPECIALIST'),(9,'Tai mũi họng','Tai mũi họng',150000,'SPECIALIST'),(10,'Răng hàm mặt','Răng hàm mặt',150000,'SPECIALIST'),(11,'Chụp X-quang','Chụp X-quang',150000,'DEPARTMENT'),(12,'Xét nghiệm','Xét nghiệm',150000,'DEPARTMENT'),(13,'Khám sức khỏe cơ bản','Tiêu hóa - Tim mạch – Hô hấp - Tai mũi họng - Răng hàm mặt',1000000,'COMBO'),(14,'Khám sức khỏe nâng cao','Tim mạch - Tiêu hóa - Thần kinh- Hô hấp - Da liễu - Mắt - Tai mũi họng - Răng hàm mặt',2000000,'COMBO'),(15,'Gói khám Nhi khoa','Khám nhi - Khám mắt - Răng hàm mặt - Tai mũi họng - Da liễu',900000,'COMBO');

--
-- Table structure for table `shifts`
--

DROP TABLE IF EXISTS `shifts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shifts` (
  `shift_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`shift_id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shifts`
--

INSERT INTO `shifts` VALUES (1,'Sáng','08:00:00','12:00:00','Ca làm việc buổi sáng'),(2,'Chiều','13:00:00','17:00:00','Ca làm việc buổi chiều'),(3,'Tối','17:30:00','21:30:00','Ca làm việc buổi tối');

--
-- Table structure for table `specialties`
--

DROP TABLE IF EXISTS `specialties`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `specialties` (
  `specialty_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`specialty_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `specialties`
--

INSERT INTO `specialties` VALUES (1,'Cơ Xương Khớp','Chuyên khoa điều trị các bệnh về xương khớp'),(2,'Ngoại Tổng Hợp','Chuyên khoa phẫu thuật tổng quát'),(3,'Nội Tiêu Hóa','Chuyên khoa điều trị bệnh tiêu hóa');

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `full_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `role_id` int NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`),
  KEY `fk_user_role` (`role_id`),
  CONSTRAINT `fk_user_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `check_email` CHECK (regexp_like(`email`,_utf8mb3'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+.[A-Za-z]{2,}$')),
  CONSTRAINT `check_phone` CHECK (regexp_like(`phone`,_utf8mb3'^[0-9]{10,15}$'))
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

INSERT INTO `users` VALUES (1,'patient1','aafdc23870ecbcd3d557b6423a8982134e17927e','Nguyễn Văn An','an.nguyen@email.com','0901234567',1,'2025-05-31 12:00:00'),(2,'patient2','aafdc23870ecbcd3d557b6423a8982134e17927e','Trần Thị Bình','binh.tran@email.com','0912345678',1,'2025-05-31 12:00:00'),(3,'doctor1','aafdc23870ecbcd3d557b6423a8982134e17927e','ThS.BSCKI Trịnh Minh Thanh','thanh.trinh@email.com','0923456789',2,'2025-05-31 12:00:00'),(4,'doctor2','aafdc23870ecbcd3d557b6423a8982134e17927e','BS. Lê Văn Hùng','hung.le@email.com','0934567890',2,'2025-05-31 12:00:00'),(5,'receptionist1','aafdc23870ecbcd3d557b6423a8982134e17927e','Phạm Thị Mai','mai.pham@email.com','0945678901',3,'2025-05-31 12:00:00'),(6,'admin1','74913f5cd5f61ec0bcfdb775414c2fb3d161b620','Nguyễn Văn Quản Trị','admin@email.com','0956789012',4,'2025-05-31 12:00:00'),(7,'doctor3','aafdc23870ecbcd3d557b6423a8982134e17927e','BS. Lê Văn X','hung.leee@email.com','0934567891',2,'2025-05-31 12:00:00');

--
-- Table structure for table `working_schedules`
--

DROP TABLE IF EXISTS `working_schedules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `working_schedules` (
  `schedule_id` int NOT NULL AUTO_INCREMENT,
  `doctor_id` int NOT NULL,
  `week_day` enum('Thứ 2','Thứ 3','Thứ 4','Thứ 5','Thứ 6','Thứ 7','Chủ nhật') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `shift_id` int NOT NULL,
  `max_patients` int DEFAULT '10',
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`schedule_id`),
  UNIQUE KEY `unique_doctor_shift` (`doctor_id`,`week_day`,`shift_id`),
  KEY `fk_schedule_doctor` (`doctor_id`),
  KEY `fk_schedule_shift` (`shift_id`),
  CONSTRAINT `fk_schedule_doctor` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`doctor_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_schedule_shift` FOREIGN KEY (`shift_id`) REFERENCES `shifts` (`shift_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `working_schedules`
--

INSERT INTO `working_schedules` VALUES (1,1,'Thứ 2',1,15,1,'2025-05-31 12:00:00','2025-05-31 12:00:00'),(2,1,'Thứ 2',2,15,1,'2025-05-31 12:00:00','2025-05-31 12:00:00'),(3,1,'Thứ 3',1,15,1,'2025-05-31 12:00:00','2025-05-31 12:00:00'),(4,1,'Thứ 3',2,15,1,'2025-05-31 12:00:00','2025-05-31 12:00:00'),(5,1,'Thứ 4',1,15,1,'2025-05-31 12:00:00','2025-05-31 12:00:00'),(6,1,'Thứ 4',2,15,1,'2025-05-31 12:00:00','2025-05-31 12:00:00'),(7,1,'Thứ 5',1,15,1,'2025-05-31 12:00:00','2025-05-31 12:00:00'),(8,1,'Thứ 5',2,15,1,'2025-05-31 12:00:00','2025-05-31 12:00:00'),(9,1,'Thứ 6',1,15,1,'2025-05-31 12:00:00','2025-05-31 12:00:00'),(10,1,'Thứ 6',2,15,1,'2025-05-31 12:00:00','2025-05-31 12:00:00'),(11,2,'Thứ 2',1,12,1,'2025-05-31 12:00:00','2025-05-31 12:00:00'),(12,2,'Thứ 2',2,12,1,'2025-05-31 12:00:00','2025-05-31 12:00:00'),(13,2,'Thứ 3',1,12,1,'2025-05-31 12:00:00','2025-05-31 12:00:00'),(14,2,'Thứ 3',2,12,1,'2025-05-31 12:00:00','2025-05-31 12:00:00'),(15,2,'Thứ 4',1,12,1,'2025-05-31 12:00:00','2025-05-31 12:00:00'),(16,2,'Thứ 4',2,12,1,'2025-05-31 12:00:00','2025-05-31 12:00:00'),(17,2,'Thứ 5',1,12,1,'2025-05-31 12:00:00','2025-05-31 12:00:00'),(18,2,'Thứ 5',2,12,1,'2025-05-31 12:00:00','2025-05-31 12:00:00'),(19,2,'Thứ 6',1,12,1,'2025-05-31 12:00:00','2025-05-31 12:00:00'),(20,2,'Thứ 6',2,12,1,'2025-05-31 12:00:00','2025-05-31 12:00:00');
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-06-25  9:19:24
