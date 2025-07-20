-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: swp_db
-- ------------------------------------------------------
-- Server version	8.0.40

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

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
                                `service_id` int DEFAULT NULL,
                                `appointment_date` datetime NOT NULL,
                                `shift_id` int NOT NULL,
                                `queue_number` int NOT NULL,
                                `status` enum('pending','completed','canceled') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
                                `note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
                                `payment_status` enum('PENDING','RESERVED','PAID') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'PENDING',
                                `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
                                `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                PRIMARY KEY (`appointment_id`),
                                KEY `fk_appointment_patient` (`patient_id`),
                                KEY `fk_appointment_doctor` (`doctor_id`),
                                KEY `fk_appointment_service` (`service_id`),
                                KEY `fk_appointment_shift` (`shift_id`),
                                KEY `idx_appointment_shift_queue` (`doctor_id`,`appointment_date`,`shift_id`,`queue_number`),
                                CONSTRAINT `fk_appointment_doctor` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`doctor_id`) ON DELETE CASCADE ON UPDATE CASCADE,
                                CONSTRAINT `fk_appointment_patient` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`) ON DELETE CASCADE ON UPDATE CASCADE,
                                CONSTRAINT `fk_appointment_service` FOREIGN KEY (`service_id`) REFERENCES `services` (`service_id`) ON DELETE SET NULL ON UPDATE CASCADE,
                                CONSTRAINT `fk_appointment_shift` FOREIGN KEY (`shift_id`) REFERENCES `shifts` (`shift_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appointments`
--

LOCK TABLES `appointments` WRITE;
/*!40000 ALTER TABLE `appointments` DISABLE KEYS */;
INSERT INTO `appointments` VALUES (1,1,1,2,'2025-06-01 10:00:00',1,1,'pending','Đau khớp gối, cần khám','PENDING','2025-05-31 12:00:00','2025-06-29 15:46:22'),(2,2,2,13,'2025-06-01 11:00:00',1,1,'pending','Đau bụng, nghi viêm ruột','PENDING','2025-05-31 12:00:00','2025-06-29 15:46:22'),(3,25,4,2,'2025-06-30 08:00:00',1,1,'pending','Khám cho con, bị đau họng, sốt','PENDING','2025-06-29 13:08:14','2025-06-29 15:46:22'),(4,15,4,2,'2025-06-30 08:00:00',1,2,'pending','khám cho cháu gái, đau họng, ho, sốt','PENDING','2025-06-29 13:51:57','2025-06-29 15:46:22'),(5,15,4,2,'2025-07-01 08:00:00',1,1,'pending','Khám tiếp lần nữa','PENDING','2025-06-29 15:55:36','2025-06-29 15:55:36');
/*!40000 ALTER TABLE `appointments` ENABLE KEYS */;
UNLOCK TABLES;

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

LOCK TABLES `contact_messages` WRITE;
/*!40000 ALTER TABLE `contact_messages` DISABLE KEYS */;
INSERT INTO `contact_messages` VALUES (1,'Nguyễn Văn A','nguyenvana@email.com','0987654321','service_feedback','Dịch vụ khám bệnh rất tốt, nhưng thời gian chờ hơi lâu','pending','medium',NULL,'2025-05-31 14:00:00','2025-05-31 14:00:00'),(2,'Trần Thị B','tranthib@email.com','0987654322','incident_report','Máy ATM trong bệnh viện bị hỏng','pending','high',NULL,'2025-05-31 15:00:00','2025-05-31 16:00:00'),(3,'Lê Văn C','levanc@email.com','0987654323','improvement_suggestion','Nên thêm dịch vụ gửi xe miễn phí cho bệnh nhân','pending','low',NULL,'2025-05-31 16:00:00','2025-05-31 16:00:00'),(4,'Phạm Thị D','phamthid@email.com','0987654324','cooperation','Công ty chúng tôi muốn hợp tác về dịch vụ bảo hiểm y tế','pending','high',NULL,'2025-05-31 17:00:00','2025-05-31 17:00:00');
/*!40000 ALTER TABLE `contact_messages` ENABLE KEYS */;
UNLOCK TABLES;

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
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doctor_services`
--

LOCK TABLES `doctor_services` WRITE;
/*!40000 ALTER TABLE `doctor_services` DISABLE KEYS */;
INSERT INTO `doctor_services` VALUES (1,1,2),(2,2,4),(3,2,13),(5,4,2),(6,4,3),(7,5,4),(8,5,5),(9,5,6),(10,6,7),(11,6,8),(12,6,9),(13,7,10),(14,7,11),(15,7,12);
/*!40000 ALTER TABLE `doctor_services` ENABLE KEYS */;
UNLOCK TABLES;

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
                           `contract_status` enum('ACTIVE', 'EXPIRED', 'SUSPENDED'),
                           `contract_start_date` DATE,
                           `contract_end_date` DATE,
                           `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
                           PRIMARY KEY (`doctor_id`),
                           KEY `fk_doctor_user` (`user_id`),
                           KEY `fk_doctor_specialty` (`specialty_id`),
                           CONSTRAINT `fk_doctor_specialty` FOREIGN KEY (`specialty_id`) REFERENCES `specialties` (`specialty_id`) ON DELETE SET NULL ON UPDATE CASCADE,
                           CONSTRAINT `fk_doctor_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doctors`
--

LOCK TABLES `doctors` WRITE;
/*!40000 ALTER TABLE `doctors` DISABLE KEYS */;
INSERT INTO `doctors` VALUES (1,3,'Male','1980-03-15','/ClinicManagementSystem/assets/uploads/avatars/Doctor.png',1,'ThS.BSCKI','10 năm kinh nghiệm tại BV Chợ Rẫy','inactive','ACTIVE', '2020-06-11', '2030-06-11', '2025-06-11 03:49:52'),
                             (2,4,'Male','1985-07-20','/ClinicManagementSystem/assets/uploads/avatars/Doctor (2).png',2,'BS','7 năm kinh nghiệm tại BV 115','active','ACTIVE', '2020-06-11', '2030-06-11', '2025-06-11 03:49:52'),
                             (4,54,'Male','1985-07-20','/ClinicManagementSystem/assets/uploads/avatars/Doctor (3).png',3,'BS','7 năm kinh nghiệm tại BV 115','active','ACTIVE', '2020-06-11', '2030-06-11', '2025-06-11 03:49:52'),
                             (5,55,'Male','1985-07-20','https://picsum.photos/600/400',1,'BS','7 năm kinh nghiệm tại BV 115','active','ACTIVE', '2020-06-11', '2030-06-11', '2025-06-11 03:49:52'),
                             (6,56,'Male','1985-07-20','https://picsum.photos/600/400',2,'BS','7 năm kinh nghiệm tại BV 115','active','ACTIVE', '2020-06-11', '2030-06-11', '2025-06-11 03:49:52'),
                             (7,57,'Male','1985-07-20','https://picsum.photos/600/400',2,'BS','7 năm kinh nghiệm tại BV 115','active','ACTIVE', '2020-06-11', '2030-06-11', '2025-06-11 03:49:52');
/*!40000 ALTER TABLE `doctors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `examination_package_specialities`
--

DROP TABLE IF EXISTS `examination_package_specialities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `examination_package_specialities` (
                                                    `package_id` int NOT NULL,
                                                    `speciality_id` int NOT NULL,
                                                    PRIMARY KEY (`package_id`,`speciality_id`),
                                                    KEY `speciality_id` (`speciality_id`),
                                                    CONSTRAINT `examination_package_specialities_ibfk_1` FOREIGN KEY (`package_id`) REFERENCES `examination_packages` (`package_id`) ON DELETE CASCADE,
                                                    CONSTRAINT `examination_package_specialities_ibfk_2` FOREIGN KEY (`speciality_id`) REFERENCES `specialties` (`specialty_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `examination_package_specialities`
--

LOCK TABLES `examination_package_specialities` WRITE;
/*!40000 ALTER TABLE `examination_package_specialities` DISABLE KEYS */;
/*!40000 ALTER TABLE `examination_package_specialities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `examination_packages`
--

DROP TABLE IF EXISTS `examination_packages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `examination_packages` (
                                        `package_id` int NOT NULL AUTO_INCREMENT,
                                        `name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
                                        `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
                                        `price` decimal(10,2) NOT NULL,
                                        `duration` int NOT NULL,
                                        PRIMARY KEY (`package_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `examination_packages`
--

LOCK TABLES `examination_packages` WRITE;
/*!40000 ALTER TABLE `examination_packages` DISABLE KEYS */;
/*!40000 ALTER TABLE `examination_packages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feedback`
--

DROP TABLE IF EXISTS `feedback`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `feedback` (
                            `feedback_id` int NOT NULL AUTO_INCREMENT,
                            `rate` int NOT NULL,
                            `doctor_feedback` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
                            `service_feedback` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
                            `price_feedback` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
                            `offer_feedback` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
                            `patient_id` int NOT NULL,
                            PRIMARY KEY (`feedback_id`),
                            KEY `patient_id` (`patient_id`),
                            CONSTRAINT `feedback_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`),
                            CONSTRAINT `feedback_chk_1` CHECK ((`rate` in (1,2,3,4,5)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feedback`
--

LOCK TABLES `feedback` WRITE;
/*!40000 ALTER TABLE `feedback` DISABLE KEYS */;
/*!40000 ALTER TABLE `feedback` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medical_records`
--

DROP TABLE IF EXISTS `medical_records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medical_records` (
                                   `record_id` int NOT NULL AUTO_INCREMENT,
                                   `appointment_id` int NOT NULL,
                                   `patient_id` int NOT NULL,
                                   `doctor_id` int NOT NULL,
                                   `diagnosis` text COLLATE utf8mb4_unicode_ci,
                                   `treatment` text COLLATE utf8mb4_unicode_ci,
                                   `prescription` text COLLATE utf8mb4_unicode_ci,
                                   `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                   `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                   PRIMARY KEY (`record_id`),
                                   KEY `appointment_id` (`appointment_id`),
                                   KEY `patient_id` (`patient_id`),
                                   KEY `doctor_id` (`doctor_id`),
                                   CONSTRAINT `medical_records_ibfk_1` FOREIGN KEY (`appointment_id`) REFERENCES `appointments` (`appointment_id`),
                                   CONSTRAINT `medical_records_ibfk_2` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`),
                                   CONSTRAINT `medical_records_ibfk_3` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`doctor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medical_records`
--

LOCK TABLES `medical_records` WRITE;
/*!40000 ALTER TABLE `medical_records` DISABLE KEYS */;
/*!40000 ALTER TABLE `medical_records` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `otp_verification`
--

DROP TABLE IF EXISTS `otp_verification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `otp_verification` (
                                    `id` int NOT NULL AUTO_INCREMENT,
                                    `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
                                    `otp` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
                                    `expiry` datetime NOT NULL,
                                    `is_verified` tinyint(1) DEFAULT '0',
                                    PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=79 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `otp_verification`
--

LOCK TABLES `otp_verification` WRITE;
/*!40000 ALTER TABLE `otp_verification` DISABLE KEYS */;
INSERT INTO `otp_verification` VALUES (1,'vuquanglinhfuhn@gmail.com','833160','2025-06-11 03:49:52',1),(2,'vuquanglinhfuhn@gmail.com','139847','2025-06-11 03:52:38',1),(3,'vuquanglinhfuhn@gmail.com','051402','2025-06-11 03:57:56',1),(4,'vuquanglinhfuhn@gmail.com','206031','2025-06-11 03:58:04',1),(5,'vuquanglinhfuhn@gmail.com','979037','2025-06-11 03:59:18',1),(6,'vuquanglinhfuhn@gmail.com','633002','2025-06-11 04:08:13',1),(7,'vuquanglinhfuhn@gmail.com','373273','2025-06-11 04:10:07',1),(8,'vuquanglinhfuhn@gmail.com','318970','2025-06-11 04:17:05',1),(9,'vuquanglinhfuhn@gmail.com','765318','2025-06-11 04:17:38',1),(10,'vuquanglinhfuhn@gmail.com','712693','2025-06-11 04:27:37',1),(11,'vuquanglinhfuhn@gmail.com','079758','2025-06-11 04:31:04',1),(12,'vuquanglinhfuhn@gmail.com','524602','2025-06-11 04:33:44',1),(13,'vuquanglinhfuhn@gmail.com','314991','2025-06-11 04:44:02',1),(14,'vuquanglinhfuhn@gmail.com','496441','2025-06-11 05:04:51',1),(15,'vuquanglinhfuhn@gmail.com','903143','2025-06-11 05:07:28',1),(16,'vuquanglinhfuhn@gmail.com','291678','2025-06-11 05:10:23',1),(17,'vuquanglinhfuhn@gmail.com','300368','2025-06-11 05:12:53',1),(18,'vuquanglinhfuhn@gmail.com','262486','2025-06-11 05:24:12',1),(19,'vuquanglinhfuhn@gmail.com','365048','2025-06-11 05:31:05',1),(20,'vuquanglinhfuhn@gmail.com','834136','2025-06-11 05:41:07',1),(21,'vuquanglinhfuhn@gmail.com','555659','2025-06-11 05:45:47',1),(22,'vuquanglinhfuhn@gmail.com','290541','2025-06-11 05:45:56',1),(23,'vuquanglinhfuhn@gmail.com','819740','2025-06-11 05:51:58',1),(24,'vuquanglinhfuhn@gmail.com','591674','2025-06-11 06:34:30',1),(25,'vuquanglinhfuhn@gmail.com','270307','2025-06-11 06:43:45',1),(26,'vuquanglinhfuhn@gmail.com','837513','2025-06-11 07:05:23',1),(27,'vuquanglinhfuhn@gmail.com','877323','2025-06-11 07:06:23',1),(28,'vuquanglinhfuhn@gmail.com','640031','2025-06-11 07:08:20',1),(29,'vuquanglinhfuhn@gmail.com','259852','2025-06-11 07:08:59',1),(30,'vuquanglinhfuhn@gmail.com','793641','2025-06-11 07:10:46',1),(31,'vuquanglinhfuhn@gmail.com','111216','2025-06-11 07:18:29',1),(32,'linhvqhe176018@fpt.edu.vn','897398','2025-06-11 07:20:44',1),(33,'vuquanglinhfuhn@gmail.com','362767','2025-06-11 08:23:33',1),(34,'linhvqhe176018@fpt.edu.vn','019312','2025-06-11 08:24:39',1),(35,'linhvqhe176018@fpt.edu.vn','214288','2025-06-11 08:34:36',1),(36,'linhvqhe176018@fpt.edu.vn','431157','2025-06-11 08:38:00',1),(37,'linhvqhe176018@fpt.edu.vn','182222','2025-06-11 08:41:57',1),(38,'linhvqhe176018@fpt.edu.vn','175341','2025-06-11 09:04:37',1),(39,'linhvqhe176018@fpt.edu.vn','757382','2025-06-11 09:05:01',1),(40,'linhvqhe176018@fpt.edu.vn','903089','2025-06-11 09:08:13',1),(41,'linhvqhe176018@fpt.edu.vn','260159','2025-06-11 09:09:28',1),(42,'linhvqhe176018@fpt.edu.vn','727063','2025-06-11 09:13:02',1),(43,'linhvqhe176018@fpt.edu.vn','438708','2025-06-11 09:15:11',1),(44,'linhvqhe176018@fpt.edu.vn','211429','2025-06-11 09:16:38',1),(45,'linhvqhe176018@fpt.edu.vn','021942','2025-06-11 09:18:45',1),(46,'linhvqhe176018@fpt.edu.vn','207346','2025-06-11 09:20:37',1),(47,'linhvqhe176018@fpt.edu.vn','028438','2025-06-11 09:21:57',1),(48,'linhvqhe176018@fpt.edu.vn','110622','2025-06-11 09:22:22',1),(49,'linhvqhe176018@fpt.edu.vn','229379','2025-06-11 09:25:35',1),(50,'linhvqhe176018@fpt.edu.vn','800171','2025-06-11 09:33:40',1),(51,'linhvqhe176018@fpt.edu.vn','852085','2025-06-11 09:34:57',1),(52,'vuquanglinhfuhn@gmail.com','929670','2025-06-11 09:35:21',1),(53,'vuquanglinhfuhn@gmail.com','526685','2025-06-11 10:53:44',1),(54,'linhvqhe176018@fpt.edu.vn','276846','2025-06-11 10:55:03',1),(55,'linhvqhe176018@fpt.edu.vn','290176','2025-06-11 11:16:07',1),(56,'linhvqhe176018@fpt.edu.vn','636847','2025-06-11 11:20:53',1),(57,'linhvqhe176018@fpt.edu.vn','454986','2025-06-11 11:27:23',1),(58,'vuquanglinhfuhn@gmail.com','168712','2025-06-23 23:18:32',1),(59,'vuquanglinhfuhn@gmail.com','388877','2025-06-23 23:25:34',1),(60,'vuquanglinhfuhn@gmail.com','257484','2025-06-23 23:27:48',1),(61,'vuquanglinhfuhn@gmail.com','633682','2025-06-23 23:34:28',1),(62,'vuquanglinhfuhn@gmail.com','779105','2025-06-23 23:47:59',1),(63,'vuquanglinhfuhn@gmail.com','240943','2025-06-23 23:53:54',1),(64,'vuquanglinhfuhn@gmail.com','494591','2025-06-23 23:56:00',1),(65,'vuquanglinhfuhn@gmail.com','513233','2025-06-23 23:57:57',1),(66,'linhvqhe176018@fpt.edu.vn','805941','2025-06-24 10:19:40',1),(67,'linhvqhe176018@fpt.edu.vn','216657','2025-06-24 10:23:54',1),(68,'linhvqhe176018@fpt.edu.vn','943710','2025-06-24 10:26:46',1),(69,'linhvqhe176018@fpt.edu.vn','098591','2025-06-24 10:33:06',1),(70,'linhvqhe176018@fpt.edu.vn','962103','2025-06-24 22:27:10',1),(71,'linhvqhe176018@fpt.edu.vn','553815','2025-06-24 22:28:34',1),(72,'linhvqhe176018@fpt.edu.vn','765905','2025-06-24 22:29:01',1),(73,'linhvqhe176018@fpt.edu.vn','946846','2025-06-24 22:31:35',1),(74,'linhvqhe176018@fpt.edu.vn','237083','2025-06-24 23:13:31',1),(75,'vu073483@gmail.com','775918','2025-06-25 03:59:14',0),(76,'vu0731483@gmail.com','455499','2025-06-25 03:59:36',0),(77,'minzz8128@gmail.com','723286','2025-06-25 11:21:04',1),(78,'vul407261@gmail.com','391964','2025-06-25 11:23:54',0);
/*!40000 ALTER TABLE `otp_verification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patient_status_logs`
--

DROP TABLE IF EXISTS `patient_status_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patient_status_logs` (
                                       `log_id` int NOT NULL AUTO_INCREMENT,
                                       `patient_id` int DEFAULT NULL,
                                       `status_code` int DEFAULT NULL,
                                       `changed_by` int DEFAULT NULL,
                                       `changed_at` datetime DEFAULT CURRENT_TIMESTAMP,
                                       PRIMARY KEY (`log_id`),
                                       KEY `patient_id` (`patient_id`),
                                       KEY `status_code` (`status_code`),
                                       KEY `changed_by` (`changed_by`),
                                       CONSTRAINT `patient_status_logs_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`),
                                       CONSTRAINT `patient_status_logs_ibfk_2` FOREIGN KEY (`status_code`) REFERENCES `status_definitions` (`code`),
                                       CONSTRAINT `patient_status_logs_ibfk_3` FOREIGN KEY (`changed_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=126 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patient_status_logs`
--

LOCK TABLES `patient_status_logs` WRITE;
/*!40000 ALTER TABLE `patient_status_logs` DISABLE KEYS */;
INSERT INTO `patient_status_logs` VALUES (1,1,5,3,'2025-06-23 08:55:43'),(2,1,5,3,'2025-06-23 08:55:46'),(3,1,5,3,'2025-06-23 08:55:49'),(4,1,9,3,'2025-06-23 08:56:06'),(5,1,4,3,'2025-06-23 08:57:09'),(6,1,5,3,'2025-06-23 09:00:26'),(7,1,9,3,'2025-06-23 09:00:28'),(8,1,5,3,'2025-06-23 09:00:30'),(9,1,5,3,'2025-06-23 09:05:42'),(10,1,5,3,'2025-06-23 09:05:44'),(11,1,9,3,'2025-06-23 09:05:46'),(12,1,5,3,'2025-06-23 09:05:48'),(13,2,2,5,'2025-06-24 21:43:36'),(14,2,2,5,'2025-06-24 21:43:39'),(15,2,1,5,'2025-06-24 22:00:23'),(16,1,9,3,'2025-06-25 01:58:02'),(17,2,3,5,'2025-06-25 01:59:57'),(18,3,2,5,'2025-06-25 02:31:16'),(19,4,1,5,'2025-06-25 02:31:21'),(20,4,3,5,'2025-06-25 02:31:24'),(21,1,3,5,'2025-06-25 02:36:32'),(22,3,1,5,'2025-06-25 02:39:32'),(23,3,3,5,'2025-06-25 02:39:35'),(24,1,5,3,'2025-06-25 02:41:30'),(25,1,8,40,'2025-06-25 02:41:42'),(26,1,5,3,'2025-06-25 02:41:45'),(27,1,5,3,'2025-06-25 02:42:16'),(28,1,8,40,'2025-06-25 02:43:17'),(29,1,9,3,'2025-06-25 02:44:15'),(30,2,5,3,'2025-06-25 02:44:36'),(31,2,8,40,'2025-06-25 02:44:41'),(32,2,5,3,'2025-06-25 02:44:49'),(33,2,5,3,'2025-06-25 02:47:40'),(34,3,5,3,'2025-06-25 02:47:49'),(35,2,8,40,'2025-06-25 02:47:52'),(36,3,7,40,'2025-06-25 02:47:56'),(37,3,8,40,'2025-06-25 02:47:58'),(38,3,5,3,'2025-06-25 02:48:02'),(39,1,10,5,'2025-06-25 02:48:47'),(40,1,3,5,'2025-06-25 02:48:58'),(41,3,5,3,'2025-06-25 02:49:02'),(42,3,5,3,'2025-06-25 02:53:08'),(43,3,5,3,'2025-06-25 02:53:33'),(44,3,5,3,'2025-06-25 02:53:48'),(45,3,5,3,'2025-06-25 02:58:51'),(46,1,5,3,'2025-06-25 10:11:09'),(47,4,5,3,'2025-06-25 10:11:50'),(48,15,5,3,'2025-06-25 10:12:15'),(49,18,9,3,'2025-06-25 11:13:43'),(50,16,9,3,'2025-06-25 11:13:48'),(51,17,9,3,'2025-06-25 11:13:50'),(52,19,4,3,'2025-06-25 11:29:56'),(53,20,5,3,'2025-06-25 11:31:47'),(54,21,5,3,'2025-06-25 11:41:49'),(55,22,5,3,'2025-06-25 11:42:12'),(56,2,4,3,'2025-06-30 08:21:27'),(57,1,6,40,'2025-06-30 08:23:27'),(58,1,7,40,'2025-06-30 08:23:29'),(59,1,8,40,'2025-06-30 08:23:30'),(60,3,6,40,'2025-06-30 08:23:31'),(61,3,7,40,'2025-06-30 08:23:32'),(62,3,8,40,'2025-06-30 08:23:32'),(63,4,6,40,'2025-06-30 08:23:54'),(64,4,7,40,'2025-06-30 08:23:56'),(65,4,8,40,'2025-06-30 08:23:59'),(66,15,6,40,'2025-07-01 16:00:42'),(67,20,6,40,'2025-07-01 16:00:46'),(68,21,6,40,'2025-07-01 16:00:57'),(69,15,7,40,'2025-07-01 16:01:10'),(70,15,7,40,'2025-07-01 16:01:23'),(71,20,7,40,'2025-07-01 16:01:41'),(72,21,7,40,'2025-07-01 16:01:55'),(73,15,8,40,'2025-07-01 16:01:56'),(74,20,8,40,'2025-07-01 16:01:57'),(75,21,8,40,'2025-07-01 16:02:01'),(76,21,4,3,'2025-07-01 16:09:18'),(77,21,9,3,'2025-07-01 16:09:41'),(78,21,3,5,'2025-07-01 16:10:31'),(79,2,9,3,'2025-07-01 16:11:10'),(80,18,2,5,'2025-07-01 16:21:08'),(81,4,2,5,'2025-07-01 16:21:13'),(82,3,2,5,'2025-07-01 16:22:10'),(83,3,2,5,'2025-07-01 16:22:23'),(84,3,3,5,'2025-07-01 16:22:27'),(85,4,3,5,'2025-07-01 16:22:29'),(86,3,4,3,'2025-07-01 16:25:21'),(87,3,5,3,'2025-07-01 16:25:28'),(88,3,6,40,'2025-07-01 16:25:40'),(89,3,7,40,'2025-07-01 16:25:41'),(90,3,8,40,'2025-07-01 16:25:43'),(91,16,2,5,'2025-07-01 16:30:40'),(92,21,2,5,'2025-07-01 16:30:43'),(93,18,3,5,'2025-07-01 16:30:54'),(94,16,3,5,'2025-07-01 16:30:55'),(95,21,3,5,'2025-07-01 16:30:56'),(96,4,4,3,'2025-07-01 16:38:50'),(97,21,4,3,'2025-07-01 16:39:15'),(98,16,4,3,'2025-07-01 16:39:20'),(99,16,4,3,'2025-07-01 16:39:41'),(100,16,5,3,'2025-07-01 16:39:54'),(101,21,5,3,'2025-07-01 16:39:54'),(102,18,4,3,'2025-07-01 16:40:13'),(103,18,5,3,'2025-07-01 16:40:16'),(104,16,6,40,'2025-07-01 16:40:28'),(105,16,7,40,'2025-07-01 16:40:31'),(106,16,8,40,'2025-07-01 16:40:33'),(107,21,6,40,'2025-07-01 16:40:37'),(108,21,7,40,'2025-07-01 16:40:41'),(109,21,8,40,'2025-07-01 16:40:42'),(110,18,6,40,'2025-07-01 16:40:47'),(111,17,2,5,'2025-07-02 00:29:45'),(112,19,2,5,'2025-07-02 00:29:49'),(113,22,2,5,'2025-07-02 00:29:53'),(114,1,2,5,'2025-07-02 00:30:01'),(115,22,3,5,'2025-07-02 00:30:03'),(116,1,3,5,'2025-07-02 00:30:07'),(117,4,9,54,'2025-07-02 00:30:28'),(118,22,4,54,'2025-07-02 00:30:56'),(119,16,4,54,'2025-07-02 00:31:04'),(120,21,4,54,'2025-07-02 00:31:07'),(121,3,4,54,'2025-07-02 00:31:15'),(122,3,9,54,'2025-07-02 00:31:38'),(123,21,9,54,'2025-07-02 00:31:39'),(124,16,9,54,'2025-07-02 00:31:39'),(125,22,9,54,'2025-07-02 00:31:40');
/*!40000 ALTER TABLE `patient_status_logs` ENABLE KEYS */;
UNLOCK TABLES;

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
                            `status_code` int DEFAULT '1',
                            `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT 'active',
                            PRIMARY KEY (`patient_id`),
                            KEY `fk_patient_user` (`user_id`),
                            KEY `status_code` (`status_code`),
                            CONSTRAINT `fk_patient_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
                            CONSTRAINT `patients_ibfk_1` FOREIGN KEY (`status_code`) REFERENCES `status_definitions` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patients`
--

LOCK TABLES `patients` WRITE;
/*!40000 ALTER TABLE `patients` DISABLE KEYS */;
INSERT INTO `patients` VALUES (1,1,'Female','1990-05-10','123 Đường Láng, Đống Đa, Hà Nội','https://example.com/patient1.jpg','2025-05-31 12:00:00',3,'active'),(2,2,'Female','1995-08-25','456 Nguyễn Huệ, TP Huế','https://example.com/patient2.jpg','2025-05-31 12:00:00',1,'active'),(3,34,'Male','2003-05-26','123 Đường ABC, Quận XYZ, Hà Nội','/ClinicManagementSystem/assets/uploads/avatars/6c1f02a170bbc7e59eaa.jpg','2025-06-24 05:40:41',9,'active'),(4,39,'Male','2025-06-04','123 Đường Láng, Đống Đa, Hà Nội',NULL,'2025-06-24 23:10:11',9,'active'),(15,43,'Female','1995-06-10','456 Nguyễn Thị Minh Khai, Hà Nội','/ClinicManagementSystem/assets/uploads/avatars/Screenshot 2025-06-06 101210.png','2025-06-26 12:00:00',1,'active'),(16,44,'Male','1989-07-15','789 Nguyễn Trãi, Hà Nội','https://example.com/patient41.jpg','2025-06-26 12:00:00',9,'active'),(17,45,'Female','2000-08-20','234 Hòa Bình, Hà Nội','https://example.com/patient42.jpg','2025-06-26 12:00:00',2,'active'),(18,46,'Male','1998-05-22','567 Thái Hà, Hà Nội','https://example.com/patient43.jpg','2025-06-26 12:00:00',6,'active'),(19,47,'Female','1997-10-10','345 Kim Mã, Hà Nội','https://example.com/patient44.jpg','2025-06-26 12:00:00',2,'active'),(20,48,'Male','2001-11-30','678 Phan Đình Phùng, Hà Nội','https://example.com/patient45.jpg','2025-06-26 12:00:00',1,'active'),(21,49,'Female','1994-04-18','123 Lê Duẩn, Hà Nội','https://example.com/patient46.jpg','2025-06-26 12:00:00',9,'active'),(22,50,'Male','1999-02-25','456 Bạch Mai, Hà Nội','https://example.com/patient47.jpg','2025-06-26 12:00:00',9,'active'),(23,51,'Female','2002-03-12','789 Đội Cấn, Hà Nội','https://example.com/patient48.jpg','2025-06-26 12:00:00',1,'active'),(24,52,'Male','1996-09-01','234 Nguyễn Lương Bằng, Hà Nội','https://example.com/patient49.jpg','2025-06-26 12:00:00',1,'active'),(25,53,NULL,NULL,NULL,NULL,'2025-06-25 11:16:44',1,'active'),(26,43,'Female','1995-06-10','456 Nguyễn Thị Minh Khai, Hà Nội','https://example.com/patient40.jpg','2025-06-26 12:00:00',1,'active'),(27,44,'Male','1989-07-15','789 Nguyễn Trãi, Hà Nội','https://example.com/patient41.jpg','2025-06-26 12:00:00',1,'active'),(28,45,'Female','2000-08-20','234 Hòa Bình, Hà Nội','https://example.com/patient42.jpg','2025-06-26 12:00:00',1,'active'),(29,46,'Male','1998-05-22','567 Thái Hà, Hà Nội','https://example.com/patient43.jpg','2025-06-26 12:00:00',1,'active'),(30,47,'Female','1997-10-10','345 Kim Mã, Hà Nội','https://example.com/patient44.jpg','2025-06-26 12:00:00',1,'active'),(31,48,'Male','2001-11-30','678 Phan Đình Phùng, Hà Nội','https://example.com/patient45.jpg','2025-06-26 12:00:00',1,'active'),(32,49,'Female','1994-04-18','123 Lê Duẩn, Hà Nội','https://example.com/patient46.jpg','2025-06-26 12:00:00',1,'active'),(33,50,'Male','1999-02-25','456 Bạch Mai, Hà Nội','https://example.com/patient47.jpg','2025-06-26 12:00:00',1,'active'),(34,51,'Female','2002-03-12','789 Đội Cấn, Hà Nội','https://example.com/patient48.jpg','2025-06-26 12:00:00',1,'active'),(35,52,'Male','1996-09-01','234 Nguyễn Lương Bằng, Hà Nội','https://example.com/patient49.jpg','2025-06-26 12:00:00',1,'active');
/*!40000 ALTER TABLE `patients` ENABLE KEYS */;
UNLOCK TABLES;

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

LOCK TABLES `receptionists` WRITE;
/*!40000 ALTER TABLE `receptionists` DISABLE KEYS */;
INSERT INTO `receptionists` VALUES (1,5,'Female','1992-11-30','https://example.com/receptionist1.jpg','Sáng','active','2025-05-31 12:00:00');
/*!40000 ALTER TABLE `receptionists` ENABLE KEYS */;
UNLOCK TABLES;

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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'patient','Bệnh nhân đặt lịch hẹn'),(2,'doctor','Bác sĩ khám bệnh'),(3,'receptionist','Lễ tân quản lý lịch hẹn'),(4,'admin','Quản trị viên hệ thống'),(5,'technician','Kỹ thuật viên thực hiện xét nghiệm và chụp chiếu');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schedule_changes`
--

DROP TABLE IF EXISTS `schedule_changes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `schedule_changes` (
                                    `change_id` int NOT NULL AUTO_INCREMENT,
                                    `doctor_id` int NOT NULL,
                                    `old_shift_id` int NOT NULL,
                                    `new_shift_id` int NOT NULL,
                                    `change_reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
                                    `effective_date` date NOT NULL,
                                    `end_date` date DEFAULT NULL,
                                    `status` enum('pending','approved','rejected','active','completed') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
                                    `type` enum('change','cancel') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'change',
                                    `approved_by` int DEFAULT NULL,
                                    `approved_at` datetime DEFAULT NULL,
                                    `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
                                    `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                    PRIMARY KEY (`change_id`),
                                    KEY `fk_change_doctor` (`doctor_id`),
                                    KEY `fk_change_old_shift` (`old_shift_id`),
                                    KEY `fk_change_new_shift` (`new_shift_id`),
                                    KEY `fk_change_approved_by` (`approved_by`),
                                    KEY `idx_status` (`status`),
                                    KEY `idx_effective_date` (`effective_date`),
                                    CONSTRAINT `fk_change_approved_by` FOREIGN KEY (`approved_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE,
                                    CONSTRAINT `fk_change_doctor` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`doctor_id`) ON DELETE CASCADE ON UPDATE CASCADE,
                                    CONSTRAINT `fk_change_new_shift` FOREIGN KEY (`new_shift_id`) REFERENCES `shifts` (`shift_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
                                    CONSTRAINT `fk_change_old_shift` FOREIGN KEY (`old_shift_id`) REFERENCES `shifts` (`shift_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedule_changes`
--

LOCK TABLES `schedule_changes` WRITE;
/*!40000 ALTER TABLE `schedule_changes` DISABLE KEYS */;
INSERT INTO `schedule_changes` VALUES (2,2,2,1,'Muốn làm ca sáng để có thời gian cho gia đình','2025-06-15','2025-12-31','approved','change',6,'2025-05-31 14:00:00','2025-05-31 13:00:00','2025-05-31 14:00:00'),(3,1,1,3,'vì lý do gia đình','2025-02-28',NULL,'approved','change',0,NULL,'2025-06-28 15:13:11','2025-06-28 15:57:29');
/*!40000 ALTER TABLE `schedule_changes` ENABLE KEYS */;
UNLOCK TABLES;

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

LOCK TABLES `schedule_exceptions` WRITE;
/*!40000 ALTER TABLE `schedule_exceptions` DISABLE KEYS */;
INSERT INTO `schedule_exceptions` VALUES (1,1,'2025-06-02','Nghỉ phép',NULL,'Nghỉ lễ','Chờ duyệt','2025-05-31 12:00:00'),(2,2,'2025-06-03','Thay đổi giờ làm',3,'Họp khoa','Chờ duyệt','2025-05-31 12:00:00');
/*!40000 ALTER TABLE `schedule_exceptions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `services`
--

DROP TABLE IF EXISTS `services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `services` (
                            `service_id` int NOT NULL AUTO_INCREMENT,
                            `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
                            `detail` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
                            `price` bigint NOT NULL,
                            `image` text,
                            `type` enum('COMBO','SPECIALIST','DEPARTMENT') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'SPECIALIST',
                            PRIMARY KEY (`service_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `services`
--

LOCK TABLES `services` WRITE;
/*!40000 ALTER TABLE `services` DISABLE KEYS */;
INSERT INTO `services` VALUES (2,'Nhi khoa','Khám Nhi khoa',300000,'/images/kham-nhi-khoa.webp','SPECIALIST'),
                              (3,'Tim mạch','Tim mạch',250000,'/images/kham-nhi-khoa.webp','SPECIALIST'),
                              (4,'Tiêu hóa','Tiêu hóa',250000,'/images/kham-nhi-khoa.webp','SPECIALIST'),
                              (5,'Thần kinh','Thần kinh',250000,'/images/kham-nhi-khoa.webp','SPECIALIST'),
                              (6,'Hô hấp','Hô hấp',250000,'/images/kham-nhi-khoa.webp','SPECIALIST'),
                              (7,'Da liễu','Da liễu',200000,'/images/kham-nhi-khoa.webp','SPECIALIST'),
                              (8,'Mắt','Mắt',200000,'/images/kham-nhi-khoa.webp','SPECIALIST'),
                              (9,'Tai mũi họng','Tai mũi họng',150000,'/images/kham-nhi-khoa.webp','SPECIALIST'),
                              (10,'Răng hàm mặt','Răng hàm mặt',150000,'/images/kham-nhi-khoa.webp','SPECIALIST'),
                              (11,'Chụp X-quang','Chụp X-quang',150000,'/images/kham-nhi-khoa.webp','DEPARTMENT'),
                              (12,'Xét nghiệm','Xét nghiệm',150000,'/images/kham-nhi-khoa.webp','DEPARTMENT'),
                              (13,'Khám sức khỏe cơ bản','Tiêu hóa - Tim mạch – Hô hấp - Tai mũi họng - Răng hàm mặt',1000000,'/images/kham-nhi-khoa.webp','COMBO'),
                              (14,'Khám sức khỏe nâng cao','Tim mạch - Tiêu hóa - Thần kinh- Hô hấp - Da liễu - Mắt - Tai mũi họng - Răng hàm mặt',2000000,'/images/kham-nhi-khoa.webp','COMBO'),
                              (15,'Gói khám Nhi khoa','Khám nhi - Khám mắt - Răng hàm mặt - Tai mũi họng - Da liễu',900000,'/images/kham-nhi-khoa.webp','COMBO');
/*!40000 ALTER TABLE `services` ENABLE KEYS */;
UNLOCK TABLES;

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

LOCK TABLES `shifts` WRITE;
/*!40000 ALTER TABLE `shifts` DISABLE KEYS */;
INSERT INTO `shifts` VALUES (1,'Sáng','08:00:00','12:00:00','Ca làm việc buổi sáng'),(2,'Chiều','13:00:00','17:00:00','Ca làm việc buổi chiều'),(3,'Tối','17:30:00','21:30:00','Ca làm việc buổi tối');
/*!40000 ALTER TABLE `shifts` ENABLE KEYS */;
UNLOCK TABLES;

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

LOCK TABLES `specialties` WRITE;
/*!40000 ALTER TABLE `specialties` DISABLE KEYS */;
INSERT INTO `specialties` VALUES (1,'Cơ Xương Khớp','Chuyên khoa điều trị các bệnh về xương khớp'),(2,'Ngoại Tổng Hợp','Chuyên khoa phẫu thuật tổng quát'),(3,'Nội Tiêu Hóa','Chuyên khoa điều trị bệnh tiêu hóa');
/*!40000 ALTER TABLE `specialties` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `status`
--

DROP TABLE IF EXISTS `status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `status` (
                          `status_id` int NOT NULL AUTO_INCREMENT,
                          `status_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
                          `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
                          PRIMARY KEY (`status_id`),
                          UNIQUE KEY `status_name` (`status_name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `status`
--

LOCK TABLES `status` WRITE;
/*!40000 ALTER TABLE `status` DISABLE KEYS */;
INSERT INTO `status` VALUES (1,'pending','Chờ xử lý'),(2,'approved','Đã duyệt'),(3,'rejected','Đã từ chối');
/*!40000 ALTER TABLE `status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `status_definitions`
--

DROP TABLE IF EXISTS `status_definitions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `status_definitions` (
                                      `code` int NOT NULL,
                                      `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
                                      `handled_by` int DEFAULT NULL,
                                      `next_handled_by` int DEFAULT NULL,
                                      PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `status_definitions`
--

LOCK TABLES `status_definitions` WRITE;
/*!40000 ALTER TABLE `status_definitions` DISABLE KEYS */;
INSERT INTO `status_definitions` VALUES (1,'New',3,3),(2,'Check in',3,3),(3,'Đang đợi khám',3,2),(4,'Đang khám',2,2),(5,'Đang chờ bệnh nhân xét nghiệm',2,5),(6,'Đang xét nghiệm',5,5),(7,'Chờ kết quả xét nghiệm hoặc chụp quang',5,5),(8,'Đã lấy kết quả xét nghiệm',5,2),(9,'Đã khám xong. Đợi thanh toán',2,3),(10,'Thanh toán xong',3,3);
/*!40000 ALTER TABLE `status_definitions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `technicians`
--

DROP TABLE IF EXISTS `technicians`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `technicians` (
                               `technician_id` int NOT NULL AUTO_INCREMENT,
                               `user_id` int DEFAULT NULL,
                               `gender` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
                               `dob` date DEFAULT NULL,
                               `image_url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
                               `department` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
                               `shift` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
                               `status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
                               PRIMARY KEY (`technician_id`),
                               UNIQUE KEY `user_id` (`user_id`),
                               CONSTRAINT `technicians_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `technicians`
--

LOCK TABLES `technicians` WRITE;
/*!40000 ALTER TABLE `technicians` DISABLE KEYS */;
INSERT INTO `technicians` VALUES (7,40,'Male','1990-01-01',NULL,NULL,'Ca sáng','active'),(8,41,'Female','1992-02-02','',NULL,'Ca chiều','Active'),(9,42,'Male','1988-03-03','',NULL,'Ca tối','Inactive');
/*!40000 ALTER TABLE `technicians` ENABLE KEYS */;
UNLOCK TABLES;

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
                         `is_deleted` tinyint(1) DEFAULT '0',
                         PRIMARY KEY (`user_id`),
                         UNIQUE KEY `username` (`username`),
                         UNIQUE KEY `email` (`email`),
                         KEY `fk_user_role` (`role_id`),
                         CONSTRAINT `fk_user_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
                         CONSTRAINT `check_email` CHECK (regexp_like(`email`,_utf8mb4'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+.[A-Za-z]{2,}$')),
                         CONSTRAINT `check_phone` CHECK (regexp_like(`phone`,_utf8mb4'^[0-9]{10,15}$'))
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'patient1','adminpass','Nguyễn Văn An','an.nguyen@email.com','0901234567',1,'2025-05-31 12:00:00',0),(2,'patient2','pass123','Trần Thị Bình','binh.tran@email.com','0912345678',1,'2025-05-31 12:00:00',0),(3,'doctor1','aafdc23870ecbcd3d557b6423a8982134e17927e','ThS.BSCKI Trịnh Minh Thanh','thanh.trinh@email.com','0923456789',2,'2025-05-31 12:00:00',0),(4,'doctor2','aafdc23870ecbcd3d557b6423a8982134e17927e','BS. Lê Văn Hùng','hung.le@email.com','0934567890',2,'2025-05-31 12:00:00',0),(5,'receptionist1','aafdc23870ecbcd3d557b6423a8982134e17927e','Phạm Thị Mai','mai.pham@email.com','0945678901',3,'2025-05-31 12:00:00',0),(6,'admin1','74913f5cd5f61ec0bcfdb775414c2fb3d161b620','Nguyễn Văn Quản Trị','admin@email.com','0956789012',4,'2025-05-31 12:00:00',0),(8,'starpacusa','password123','quanglinh','admin1@example.com','1234567890',1,'2025-06-11 03:24:44',0),(13,'john_doe','password123','John Doe','john.doe@example.com','1234567890',1,'2025-06-11 05:58:00',0),(21,'john_doe1','password123','John1 Doe','john.dose@example.com','1234567890',1,'2025-06-11 06:39:14',0),(27,'johndoe','password123','John Doe','johndoe@example.com','1234567890',1,'2025-06-11 11:16:20',0),(34,'Vuquanglinh','241798fad97209ab8197b031da00c24909da2e7a','Vũ Quang Linh','vuquanglinhfuhn@gmail.com','0344768409',1,'2025-06-23 23:53:11',0),(39,'Vuquanglinh265','241798fad97209ab8197b031da00c24909da2e7a','Vũ Quang Linhh','linhvqhe176018@fpt.edu.vn','0344768409',1,'2025-06-24 23:10:11',0),(40,'tech01','aafdc23870ecbcd3d557b6423a8982134e17927e','KTV Nguyễn Văn A','tech01@example.com','0912345678',5,'2025-06-25 01:06:27',0),(41,'tech02','aafdc23870ecbcd3d557b6423a8982134e17927e','KTV Trần Thị B','tech02@example.com','0987654321',5,'2025-06-25 01:06:27',0),(42,'tech03','aafdc23870ecbcd3d557b6423a8982134e17927e','KTV Lê Văn C','tech03@example.com','0901122334',5,'2025-06-25 01:06:27',0),(43,'patient40','aafdc23870ecbcd3d557b6423a8982134e17927e','Nguyễn Thị Mai','mai.thi.mai@example.com','0901234567',1,'2025-06-26 12:00:00',0),(44,'patient41','aafdc23870ecbcd3d557b6423a8982134e17927e','Trần Thi Bích','tran.thi.bich@example.com','0901234568',1,'2025-06-26 12:00:00',0),(45,'patient42','aafdc23870ecbcd3d557b6423a8982134e17927e','Phan Minh Tuấn','phan.minh.tuan@example.com','0901234569',1,'2025-06-26 12:00:00',0),(46,'patient43','aafdc23870ecbcd3d557b6423a8982134e17927e','Lê Thị Lan','le.thi.lan@example.com','0901234570',1,'2025-06-26 12:00:00',0),(47,'patient44','aafdc23870ecbcd3d557b6423a8982134e17927e','Nguyễn Minh Phương','nguyen.minh.phuong@example.com','0901234571',1,'2025-06-26 12:00:00',0),(48,'patient45','aafdc23870ecbcd3d557b6423a8982134e17927e','Hoàng Thu Trang','hoang.thu.trang@example.com','0901234572',1,'2025-06-26 12:00:00',0),(49,'patient46','aafdc23870ecbcd3d557b6423a8982134e17927e','Đỗ Văn Toàn','do.van.toan@example.com','0901234573',1,'2025-06-26 12:00:00',0),(50,'patient47','aafdc23870ecbcd3d557b6423a8982134e17927e','Phạm Lan Anh','pham.lan.anh@example.com','0901234574',1,'2025-06-26 12:00:00',0),(51,'patient48','aafdc23870ecbcd3d557b6423a8982134e17927e','Bùi Quang Hải','bui.quang.hai@example.com','0901234575',1,'2025-06-26 12:00:00',0),(52,'patient49','aafdc23870ecbcd3d557b6423a8982134e17927e','Nguyễn Quang Linh','nguyen.quang.linh@example.com','0901234576',1,'2025-06-26 12:00:00',0),(53,'hoanganh123','789b49606c321c8cf228d17942608eff0ccc4171','Nguyễn Đình Hoàng Anh','minzz8128@gmail.com','0976054728',1,'2025-06-25 11:16:43',0),(54,'doctor3','aafdc23870ecbcd3d557b6423a8982134e17927e','BS. Lê Văn A','hung.le1@email.com','0934567890',2,'2025-06-26 16:31:13',0),(55,'doctor4','aafdc23870ecbcd3d557b6423a8982134e17927e','BS. Lê Văn B','hung.le2@email.com','0934567890',2,'2025-06-26 16:31:13',0),(56,'doctor5','aafdc23870ecbcd3d557b6423a8982134e17927e','BS. Lê Văn C','hung.le3@email.com','0934567890',2,'2025-06-26 16:31:13',0),(57,'doctor6','aafdc23870ecbcd3d557b6423a8982134e17927e','BS. Lê Văn D','hung.le4@email.com','0934567890',2,'2025-06-26 16:31:13',0);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

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
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `working_schedules`
--

LOCK TABLES `working_schedules` WRITE;
/*!40000 ALTER TABLE `working_schedules` DISABLE KEYS */;
INSERT INTO `working_schedules` VALUES (1,1,'Thứ 2',3,15,1,'2025-05-31 12:00:00','2025-06-28 15:57:29'),(2,1,'Thứ 2',2,15,1,'2025-05-31 12:00:00','2025-05-31 12:00:00'),(3,1,'Thứ 3',3,15,1,'2025-05-31 12:00:00','2025-06-28 15:57:29'),(4,1,'Thứ 3',2,15,1,'2025-05-31 12:00:00','2025-05-31 12:00:00'),(5,1,'Thứ 4',3,15,1,'2025-05-31 12:00:00','2025-06-28 15:57:29'),(6,1,'Thứ 4',2,15,1,'2025-05-31 12:00:00','2025-05-31 12:00:00'),(7,1,'Thứ 5',3,15,1,'2025-05-31 12:00:00','2025-06-28 15:57:29'),(8,1,'Thứ 5',2,15,1,'2025-05-31 12:00:00','2025-05-31 12:00:00'),(9,1,'Thứ 6',3,15,1,'2025-05-31 12:00:00','2025-06-28 15:57:29'),(10,1,'Thứ 6',2,15,1,'2025-05-31 12:00:00','2025-05-31 12:00:00'),(11,2,'Thứ 2',1,12,1,'2025-05-31 12:00:00','2025-05-31 12:00:00'),(13,2,'Thứ 3',1,12,1,'2025-05-31 12:00:00','2025-05-31 12:00:00'),(14,2,'Thứ 3',2,12,1,'2025-05-31 12:00:00','2025-05-31 12:00:00'),(15,2,'Thứ 4',1,12,1,'2025-05-31 12:00:00','2025-05-31 12:00:00'),(16,2,'Thứ 4',2,12,1,'2025-05-31 12:00:00','2025-05-31 12:00:00'),(17,2,'Thứ 5',1,12,1,'2025-05-31 12:00:00','2025-05-31 12:00:00'),(18,2,'Thứ 5',2,12,1,'2025-05-31 12:00:00','2025-05-31 12:00:00'),(19,2,'Thứ 6',1,12,1,'2025-05-31 12:00:00','2025-05-31 12:00:00'),(20,2,'Thứ 6',2,12,1,'2025-05-31 12:00:00','2025-05-31 12:00:00'),(21,2,'Thứ 2',2,10,1,'2025-06-27 09:43:35','2025-06-27 09:43:35'),(22,4,'Thứ 2',1,10,1,'2025-06-26 16:31:33','2025-06-26 16:31:33'),(23,4,'Thứ 2',2,10,1,'2025-06-26 16:31:33','2025-06-26 16:31:33'),(24,4,'Thứ 3',1,10,1,'2025-06-26 16:31:33','2025-06-26 16:31:33'),(25,4,'Thứ 3',2,10,1,'2025-06-26 16:31:33','2025-06-26 16:31:33'),(26,5,'Thứ 4',1,10,1,'2025-06-26 16:31:33','2025-06-26 16:31:33'),(27,5,'Thứ 4',2,10,1,'2025-06-26 16:31:33','2025-06-26 16:31:33'),(28,5,'Thứ 5',1,10,1,'2025-06-26 16:31:33','2025-06-26 16:31:33'),(29,5,'Thứ 5',2,10,1,'2025-06-26 16:31:33','2025-06-26 16:31:33'),(30,6,'Thứ 6',1,10,1,'2025-06-26 16:31:33','2025-06-26 16:31:33'),(31,6,'Thứ 6',2,10,1,'2025-06-26 16:31:33','2025-06-26 16:31:33'),(32,7,'Thứ 7',1,10,1,'2025-06-26 16:31:33','2025-06-26 16:31:33'),(33,7,'Thứ 7',2,10,1,'2025-06-26 16:31:33','2025-06-26 16:31:33');
/*!40000 ALTER TABLE `working_schedules` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-07-02  3:09:37
