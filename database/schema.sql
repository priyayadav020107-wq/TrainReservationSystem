CREATE DATABASE  IF NOT EXISTS `train_reservation_system` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `train_reservation_system`;
-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: localhost    Database: train_reservation_system
-- ------------------------------------------------------
-- Server version	8.0.37

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
-- Table structure for table `admins`
--

DROP TABLE IF EXISTS `admins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admins` (
  `admin_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `admin_password` varchar(255) NOT NULL,
  PRIMARY KEY (`admin_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admins`
--

LOCK TABLES `admins` WRITE;
/*!40000 ALTER TABLE `admins` DISABLE KEYS */;
INSERT INTO `admins` VALUES (1,'Train Admin1','admin@railway.com','240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9');
/*!40000 ALTER TABLE `admins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `booking_audit`
--

DROP TABLE IF EXISTS `booking_audit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `booking_audit` (
  `audit_id` int NOT NULL AUTO_INCREMENT,
  `booking_id` int NOT NULL,
  `action_type` enum('BOOKED','CANCELLED','PAYMENT_SUCCESS','PAYMENT_FAILED') NOT NULL,
  `action_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`audit_id`),
  KEY `fk_audit_booking` (`booking_id`),
  CONSTRAINT `fk_audit_booking` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking_audit`
--

LOCK TABLES `booking_audit` WRITE;
/*!40000 ALTER TABLE `booking_audit` DISABLE KEYS */;
INSERT INTO `booking_audit` VALUES (1,1,'BOOKED','2026-06-27 08:16:03'),(2,1,'PAYMENT_SUCCESS','2026-06-27 08:16:03'),(3,2,'BOOKED','2026-06-27 08:17:56'),(4,2,'PAYMENT_SUCCESS','2026-06-27 08:17:56'),(5,3,'BOOKED','2026-06-27 08:24:42'),(6,3,'PAYMENT_SUCCESS','2026-06-27 08:24:42'),(7,3,'CANCELLED','2026-06-27 08:25:16'),(8,4,'BOOKED','2026-06-27 09:24:38'),(9,4,'PAYMENT_SUCCESS','2026-06-27 09:24:38'),(10,5,'BOOKED','2026-06-28 17:30:05'),(11,5,'PAYMENT_SUCCESS','2026-06-28 17:30:05'),(12,6,'BOOKED','2026-07-17 16:35:04'),(13,6,'PAYMENT_SUCCESS','2026-07-17 16:35:04'),(14,7,'BOOKED','2026-07-19 09:20:57'),(15,7,'PAYMENT_SUCCESS','2026-07-19 09:20:57'),(16,8,'BOOKED','2026-07-19 10:06:01'),(17,8,'PAYMENT_SUCCESS','2026-07-19 10:06:01'),(18,9,'BOOKED','2026-07-19 10:18:35'),(19,9,'PAYMENT_SUCCESS','2026-07-19 10:18:35'),(20,10,'BOOKED','2026-07-19 10:36:22'),(21,10,'PAYMENT_SUCCESS','2026-07-19 10:36:22'),(22,11,'BOOKED','2026-07-19 10:36:52'),(23,11,'PAYMENT_SUCCESS','2026-07-19 10:36:52'),(24,12,'BOOKED','2026-07-19 10:48:04'),(25,12,'PAYMENT_SUCCESS','2026-07-19 10:48:04'),(26,13,'BOOKED','2026-07-19 10:48:34'),(27,13,'PAYMENT_SUCCESS','2026-07-19 10:48:34'),(28,14,'BOOKED','2026-08-01 15:19:44'),(29,14,'PAYMENT_SUCCESS','2026-08-01 15:19:44'),(30,15,'BOOKED','2026-08-01 15:19:47'),(31,15,'PAYMENT_SUCCESS','2026-08-01 15:19:47'),(32,16,'BOOKED','2026-08-01 15:32:01'),(33,16,'PAYMENT_SUCCESS','2026-08-01 15:32:01'),(34,17,'BOOKED','2026-08-01 15:58:26'),(35,17,'PAYMENT_SUCCESS','2026-08-01 15:58:26'),(36,18,'BOOKED','2026-08-01 15:59:37'),(37,18,'PAYMENT_SUCCESS','2026-08-01 15:59:37'),(38,19,'BOOKED','2026-08-01 16:00:10'),(39,18,'CANCELLED','2026-08-01 16:04:29'),(40,17,'CANCELLED','2026-08-01 16:49:52'),(41,19,'PAYMENT_SUCCESS','2026-08-01 16:49:52'),(42,20,'BOOKED','2026-08-01 17:29:31'),(43,20,'PAYMENT_SUCCESS','2026-08-01 17:29:31'),(44,21,'BOOKED','2026-08-01 17:30:25'),(45,21,'PAYMENT_SUCCESS','2026-08-01 17:30:25'),(46,22,'BOOKED','2026-08-01 17:31:08'),(47,21,'CANCELLED','2026-08-01 17:32:14'),(48,22,'PAYMENT_SUCCESS','2026-08-01 17:32:14');
/*!40000 ALTER TABLE `booking_audit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bookings`
--

DROP TABLE IF EXISTS `bookings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bookings` (
  `booking_id` int NOT NULL AUTO_INCREMENT,
  `pnr` varchar(20) NOT NULL,
  `user_id` int NOT NULL,
  `train_id` int NOT NULL,
  `journey_date` date NOT NULL,
  `booking_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `total_passengers` int NOT NULL,
  `total_fare` decimal(10,2) NOT NULL,
  `booking_status` enum('CONFIRMED','WAITING','CANCELLED','EXPIRED') DEFAULT 'CONFIRMED',
  PRIMARY KEY (`booking_id`),
  UNIQUE KEY `pnr` (`pnr`),
  KEY `idx_booking_user` (`user_id`),
  KEY `idx_booking_train` (`train_id`),
  KEY `idx_booking_pnr` (`pnr`),
  KEY `idx_journey_date` (`journey_date`),
  CONSTRAINT `fk_booking_train` FOREIGN KEY (`train_id`) REFERENCES `trains` (`train_id`),
  CONSTRAINT `fk_booking_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `chk_passenger_count` CHECK ((`total_passengers` between 1 and 6))
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bookings`
--

LOCK TABLES `bookings` WRITE;
/*!40000 ALTER TABLE `bookings` DISABLE KEYS */;
INSERT INTO `bookings` VALUES (1,'PNR100001',1,4,'2026-06-29','2026-06-27 08:16:03',1,1000.00,'EXPIRED'),(2,'PNR100002',4,4,'2026-06-29','2026-06-27 08:17:56',1,1000.00,'EXPIRED'),(3,'PNR100003',1,1,'2026-06-30','2026-06-27 08:24:42',1,1500.00,'CANCELLED'),(4,'PNR100004',3,2,'2026-06-29','2026-06-27 09:24:38',1,900.00,'EXPIRED'),(5,'PNR100005',1,5,'2026-07-02','2026-06-28 17:30:05',1,1200.00,'EXPIRED'),(6,'PNR100006',1,2,'2026-07-19','2026-07-17 16:35:04',1,900.00,'EXPIRED'),(7,'PNR100007',1,1,'2026-07-21','2026-07-19 09:20:57',1,1500.00,'EXPIRED'),(8,'PNR100008',1,3,'2026-07-24','2026-07-19 10:06:01',1,1100.00,'EXPIRED'),(9,'PNR100009',3,1,'2026-07-21','2026-07-19 10:18:35',1,1500.00,'EXPIRED'),(10,'PNR100010',5,3,'2026-07-25','2026-07-19 10:36:22',1,1100.00,'EXPIRED'),(11,'PNR100011',1,3,'2026-07-25','2026-07-19 10:36:52',1,1100.00,'EXPIRED'),(12,'PNR100012',5,2,'2026-07-25','2026-07-19 10:48:04',1,900.00,'EXPIRED'),(13,'PNR100013',3,2,'2026-07-25','2026-07-19 10:48:34',1,900.00,'EXPIRED'),(14,'PNR100014',4,1,'2026-08-02','2026-08-01 15:19:44',1,1500.00,'CONFIRMED'),(15,'PNR100015',3,1,'2026-08-02','2026-08-01 15:19:47',1,1500.00,'CONFIRMED'),(16,'PNR100016',1,2,'2026-08-05','2026-08-01 15:32:01',1,900.00,'CONFIRMED'),(17,'PNR100017',4,6,'2026-08-03','2026-08-01 15:58:26',1,500.00,'CANCELLED'),(18,'PNR100018',4,6,'2026-08-03','2026-08-01 15:59:37',1,500.00,'CANCELLED'),(19,'PNR100019',4,6,'2026-08-03','2026-08-01 16:00:10',1,500.00,'CONFIRMED'),(20,'PNR100020',4,2,'2026-08-04','2026-08-01 17:29:31',1,900.00,'CONFIRMED'),(21,'PNR100021',4,6,'2026-08-03','2026-08-01 17:30:25',1,500.00,'CANCELLED'),(22,'PNR100022',4,6,'2026-08-03','2026-08-01 17:31:08',1,500.00,'CONFIRMED');
/*!40000 ALTER TABLE `bookings` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `booking_insert_audit` AFTER INSERT ON `bookings` FOR EACH ROW BEGIN
    INSERT INTO booking_audit (booking_id, action_type)
    VALUES (NEW.booking_id, 'BOOKED');
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `booking_cancel_audit` AFTER UPDATE ON `bookings` FOR EACH ROW BEGIN
    IF NEW.booking_status = 'CANCELLED' AND OLD.booking_status != 'CANCELLED' THEN
        INSERT INTO booking_audit (booking_id, action_type)
        VALUES (NEW.booking_id, 'CANCELLED');
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `passengers`
--

DROP TABLE IF EXISTS `passengers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `passengers` (
  `passenger_id` int NOT NULL AUTO_INCREMENT,
  `booking_id` int NOT NULL,
  `passenger_name` varchar(100) NOT NULL,
  `age` int NOT NULL,
  `gender` enum('MALE','FEMALE','OTHER') NOT NULL,
  `passenger_status` enum('CONFIRMED','WAITING','CANCELLED') DEFAULT 'CONFIRMED',
  PRIMARY KEY (`passenger_id`),
  KEY `fk_passenger_booking` (`booking_id`),
  CONSTRAINT `fk_passenger_booking` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `passengers`
--

LOCK TABLES `passengers` WRITE;
/*!40000 ALTER TABLE `passengers` DISABLE KEYS */;
INSERT INTO `passengers` VALUES (1,1,'priyaayaaaayaayyayay',19,'FEMALE','CONFIRMED'),(2,2,'sweta yadav',26,'FEMALE','CONFIRMED'),(3,3,'srishti',19,'FEMALE','CANCELLED'),(4,4,'sushila yadav',45,'FEMALE','CONFIRMED'),(5,5,'anjali',19,'FEMALE','CONFIRMED'),(6,6,'ladoo',6,'MALE','CONFIRMED'),(7,7,'priyaaa',19,'FEMALE','CONFIRMED'),(8,8,'jnkjok',67,'MALE','CONFIRMED'),(9,9,'opaojdaknx z',56,'MALE','CONFIRMED'),(10,10,'sweta',26,'FEMALE','CONFIRMED'),(11,11,'kasojkbanm',78,'MALE','CONFIRMED'),(12,12,'aospdijklzscm',34,'FEMALE','CONFIRMED'),(13,13,';lzskcpokm,.z',67,'MALE','CONFIRMED'),(14,14,'aspookksc',34,'MALE','CONFIRMED'),(15,15,'powpw',28,'FEMALE','CONFIRMED'),(16,16,'kdsaopks',78,'MALE','CONFIRMED'),(17,17,'opwajijdf',45,'MALE','CANCELLED'),(18,18,'poakdc',23,'FEMALE','CANCELLED'),(19,19,'waiting passenger',67,'MALE','CONFIRMED'),(20,20,'waiting passenger1',43,'FEMALE','CONFIRMED'),(21,21,'wiojrij',54,'MALE','CANCELLED'),(22,22,'waiting state passenger',76,'FEMALE','CONFIRMED');
/*!40000 ALTER TABLE `passengers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payments` (
  `payment_id` int NOT NULL AUTO_INCREMENT,
  `booking_id` int NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_method` enum('UPI','CARD','NETBANKING') NOT NULL,
  `payment_status` enum('SUCCESS','FAILED','REFUNDED') NOT NULL,
  `payment_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`payment_id`),
  KEY `idx_payment_booking` (`booking_id`),
  CONSTRAINT `fk_payment_booking` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
INSERT INTO `payments` VALUES (1,1,1000.00,'UPI','SUCCESS','2026-06-27 08:16:03'),(2,2,1000.00,'UPI','SUCCESS','2026-06-27 08:17:56'),(3,3,1500.00,'UPI','REFUNDED','2026-06-27 08:24:42'),(4,4,900.00,'UPI','SUCCESS','2026-06-27 09:24:38'),(5,5,1200.00,'UPI','SUCCESS','2026-06-28 17:30:05'),(6,6,900.00,'UPI','SUCCESS','2026-07-17 16:35:04'),(7,7,1500.00,'UPI','SUCCESS','2026-07-19 09:20:57'),(8,8,1100.00,'UPI','SUCCESS','2026-07-19 10:06:01'),(9,9,1500.00,'UPI','SUCCESS','2026-07-19 10:18:35'),(10,10,1100.00,'CARD','SUCCESS','2026-07-19 10:36:22'),(11,11,1100.00,'NETBANKING','SUCCESS','2026-07-19 10:36:52'),(12,12,900.00,'CARD','SUCCESS','2026-07-19 10:48:04'),(13,13,900.00,'UPI','SUCCESS','2026-07-19 10:48:34'),(14,14,1500.00,'UPI','SUCCESS','2026-08-01 15:19:44'),(15,15,1500.00,'UPI','SUCCESS','2026-08-01 15:19:47'),(16,16,900.00,'UPI','SUCCESS','2026-08-01 15:32:01'),(17,17,500.00,'UPI','REFUNDED','2026-08-01 15:58:26'),(18,18,500.00,'UPI','REFUNDED','2026-08-01 15:59:37'),(19,19,500.00,'UPI','SUCCESS','2026-08-01 16:49:52'),(20,20,900.00,'UPI','SUCCESS','2026-08-01 17:29:31'),(21,21,500.00,'UPI','REFUNDED','2026-08-01 17:30:25'),(22,22,500.00,'UPI','SUCCESS','2026-08-01 17:32:14');
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `payment_audit` AFTER INSERT ON `payments` FOR EACH ROW BEGIN
    INSERT INTO booking_audit (booking_id, action_type)
    VALUES (NEW.booking_id, CASE WHEN NEW.payment_status = 'SUCCESS' THEN 'PAYMENT_SUCCESS' ELSE 'PAYMENT_FAILED' END);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `seat_reservation`
--

DROP TABLE IF EXISTS `seat_reservation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `seat_reservation` (
  `reservation_id` int NOT NULL AUTO_INCREMENT,
  `booking_id` int NOT NULL,
  `passenger_id` int NOT NULL,
  `seat_id` int NOT NULL,
  `journey_date` date NOT NULL,
  `reservation_status` enum('BOOKED','CANCELLED') DEFAULT 'BOOKED',
  `active_seat_id` int GENERATED ALWAYS AS (if((`reservation_status` = _utf8mb4'BOOKED'),`seat_id`,NULL)) VIRTUAL,
  PRIMARY KEY (`reservation_id`),
  UNIQUE KEY `uq_active_seat_per_day` (`active_seat_id`,`journey_date`),
  KEY `fk_reservation_booking` (`booking_id`),
  KEY `fk_reservation_passenger` (`passenger_id`),
  KEY `idx_reservation_seat` (`seat_id`),
  KEY `idx_reservation_date` (`journey_date`),
  CONSTRAINT `fk_reservation_booking` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_reservation_passenger` FOREIGN KEY (`passenger_id`) REFERENCES `passengers` (`passenger_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_reservation_seat` FOREIGN KEY (`seat_id`) REFERENCES `seats` (`seat_id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `seat_reservation`
--

LOCK TABLES `seat_reservation` WRITE;
/*!40000 ALTER TABLE `seat_reservation` DISABLE KEYS */;
INSERT INTO `seat_reservation` (`reservation_id`, `booking_id`, `passenger_id`, `seat_id`, `journey_date`, `reservation_status`) VALUES (1,1,1,13,'2026-06-29','CANCELLED'),(2,2,2,22,'2026-06-29','CANCELLED'),(3,3,3,1,'2026-06-30','CANCELLED'),(4,4,4,6,'2026-06-29','CANCELLED'),(5,5,5,213,'2026-07-02','CANCELLED'),(6,6,6,6,'2026-07-19','CANCELLED'),(7,7,7,1,'2026-07-21','CANCELLED'),(8,8,8,10,'2026-07-24','CANCELLED'),(9,9,9,2,'2026-07-21','CANCELLED'),(10,10,10,10,'2026-07-25','CANCELLED'),(11,11,11,11,'2026-07-25','CANCELLED'),(12,12,12,6,'2026-07-25','CANCELLED'),(13,13,13,7,'2026-07-25','CANCELLED'),(14,14,14,1,'2026-08-02','BOOKED'),(15,15,15,2,'2026-08-02','BOOKED'),(16,16,16,6,'2026-08-05','BOOKED'),(17,17,17,293,'2026-08-03','CANCELLED'),(18,18,18,294,'2026-08-03','CANCELLED'),(20,19,19,293,'2026-08-03','BOOKED'),(21,20,20,6,'2026-08-04','BOOKED'),(22,21,21,294,'2026-08-03','CANCELLED'),(23,22,22,294,'2026-08-03','BOOKED');
/*!40000 ALTER TABLE `seat_reservation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `seats`
--

DROP TABLE IF EXISTS `seats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `seats` (
  `seat_id` int NOT NULL AUTO_INCREMENT,
  `train_id` int NOT NULL,
  `seat_number` varchar(20) NOT NULL,
  `coach_no` varchar(20) NOT NULL,
  `seat_type` enum('WINDOW','MIDDLE','AISLE') NOT NULL,
  PRIMARY KEY (`seat_id`),
  UNIQUE KEY `uq_train_seat` (`train_id`,`seat_number`),
  CONSTRAINT `fk_seat_train` FOREIGN KEY (`train_id`) REFERENCES `trains` (`train_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=295 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `seats`
--

LOCK TABLES `seats` WRITE;
/*!40000 ALTER TABLE `seats` DISABLE KEYS */;
INSERT INTO `seats` VALUES (1,1,'A1','A','WINDOW'),(2,1,'A2','A','AISLE'),(3,1,'A3','A','MIDDLE'),(4,1,'A4','A','WINDOW'),(5,1,'A5','A','AISLE'),(6,2,'B1','B','WINDOW'),(7,2,'B2','B','AISLE'),(8,2,'B3','B','MIDDLE'),(9,2,'B4','B','WINDOW'),(10,3,'C1','C','WINDOW'),(11,3,'C2','C','AISLE'),(12,3,'C3','C','MIDDLE'),(13,4,'A1','A','WINDOW'),(14,4,'A2','A','WINDOW'),(15,4,'A3','A','WINDOW'),(16,4,'A4','A','WINDOW'),(17,4,'A5','A','WINDOW'),(18,4,'A6','A','WINDOW'),(19,4,'A7','A','WINDOW'),(20,4,'A8','A','WINDOW'),(21,4,'A9','A','WINDOW'),(22,4,'A10','A','WINDOW'),(23,4,'A11','A','WINDOW'),(24,4,'A12','A','WINDOW'),(25,4,'A13','A','WINDOW'),(26,4,'A14','A','WINDOW'),(27,4,'A15','A','WINDOW'),(28,4,'A16','A','WINDOW'),(29,4,'A17','A','WINDOW'),(30,4,'A18','A','WINDOW'),(31,4,'A19','A','WINDOW'),(32,4,'A20','A','WINDOW'),(33,4,'A21','A','WINDOW'),(34,4,'A22','A','WINDOW'),(35,4,'A23','A','WINDOW'),(36,4,'A24','A','WINDOW'),(37,4,'A25','A','WINDOW'),(38,4,'A26','A','WINDOW'),(39,4,'A27','A','WINDOW'),(40,4,'A28','A','WINDOW'),(41,4,'A29','A','WINDOW'),(42,4,'A30','A','WINDOW'),(43,4,'A31','A','WINDOW'),(44,4,'A32','A','WINDOW'),(45,4,'A33','A','WINDOW'),(46,4,'A34','A','WINDOW'),(47,4,'A35','A','WINDOW'),(48,4,'A36','A','WINDOW'),(49,4,'A37','A','WINDOW'),(50,4,'A38','A','WINDOW'),(51,4,'A39','A','WINDOW'),(52,4,'A40','A','WINDOW'),(53,4,'A41','A','WINDOW'),(54,4,'A42','A','WINDOW'),(55,4,'A43','A','WINDOW'),(56,4,'A44','A','WINDOW'),(57,4,'A45','A','WINDOW'),(58,4,'A46','A','WINDOW'),(59,4,'A47','A','WINDOW'),(60,4,'A48','A','WINDOW'),(61,4,'A49','A','WINDOW'),(62,4,'A50','A','WINDOW'),(63,4,'A51','A','WINDOW'),(64,4,'A52','A','WINDOW'),(65,4,'A53','A','WINDOW'),(66,4,'A54','A','WINDOW'),(67,4,'A55','A','WINDOW'),(68,4,'A56','A','WINDOW'),(69,4,'A57','A','WINDOW'),(70,4,'A58','A','WINDOW'),(71,4,'A59','A','WINDOW'),(72,4,'A60','A','WINDOW'),(73,4,'A61','A','WINDOW'),(74,4,'A62','A','WINDOW'),(75,4,'A63','A','WINDOW'),(76,4,'A64','A','WINDOW'),(77,4,'A65','A','WINDOW'),(78,4,'A66','A','WINDOW'),(79,4,'A67','A','WINDOW'),(80,4,'A68','A','WINDOW'),(81,4,'A69','A','WINDOW'),(82,4,'A70','A','WINDOW'),(83,4,'A71','A','WINDOW'),(84,4,'A72','A','WINDOW'),(85,4,'A73','A','WINDOW'),(86,4,'A74','A','WINDOW'),(87,4,'A75','A','WINDOW'),(88,4,'A76','A','WINDOW'),(89,4,'A77','A','WINDOW'),(90,4,'A78','A','WINDOW'),(91,4,'A79','A','WINDOW'),(92,4,'A80','A','WINDOW'),(93,4,'A81','A','WINDOW'),(94,4,'A82','A','WINDOW'),(95,4,'A83','A','WINDOW'),(96,4,'A84','A','WINDOW'),(97,4,'A85','A','WINDOW'),(98,4,'A86','A','WINDOW'),(99,4,'A87','A','WINDOW'),(100,4,'A88','A','WINDOW'),(101,4,'A89','A','WINDOW'),(102,4,'A90','A','WINDOW'),(103,4,'A91','A','WINDOW'),(104,4,'A92','A','WINDOW'),(105,4,'A93','A','WINDOW'),(106,4,'A94','A','WINDOW'),(107,4,'A95','A','WINDOW'),(108,4,'A96','A','WINDOW'),(109,4,'A97','A','WINDOW'),(110,4,'A98','A','WINDOW'),(111,4,'A99','A','WINDOW'),(112,4,'A100','A','WINDOW'),(113,4,'A101','A','WINDOW'),(114,4,'A102','A','WINDOW'),(115,4,'A103','A','WINDOW'),(116,4,'A104','A','WINDOW'),(117,4,'A105','A','WINDOW'),(118,4,'A106','A','WINDOW'),(119,4,'A107','A','WINDOW'),(120,4,'A108','A','WINDOW'),(121,4,'A109','A','WINDOW'),(122,4,'A110','A','WINDOW'),(123,4,'A111','A','WINDOW'),(124,4,'A112','A','WINDOW'),(125,4,'A113','A','WINDOW'),(126,4,'A114','A','WINDOW'),(127,4,'A115','A','WINDOW'),(128,4,'A116','A','WINDOW'),(129,4,'A117','A','WINDOW'),(130,4,'A118','A','WINDOW'),(131,4,'A119','A','WINDOW'),(132,4,'A120','A','WINDOW'),(133,4,'A121','A','WINDOW'),(134,4,'A122','A','WINDOW'),(135,4,'A123','A','WINDOW'),(136,4,'A124','A','WINDOW'),(137,4,'A125','A','WINDOW'),(138,4,'A126','A','WINDOW'),(139,4,'A127','A','WINDOW'),(140,4,'A128','A','WINDOW'),(141,4,'A129','A','WINDOW'),(142,4,'A130','A','WINDOW'),(143,4,'A131','A','WINDOW'),(144,4,'A132','A','WINDOW'),(145,4,'A133','A','WINDOW'),(146,4,'A134','A','WINDOW'),(147,4,'A135','A','WINDOW'),(148,4,'A136','A','WINDOW'),(149,4,'A137','A','WINDOW'),(150,4,'A138','A','WINDOW'),(151,4,'A139','A','WINDOW'),(152,4,'A140','A','WINDOW'),(153,4,'A141','A','WINDOW'),(154,4,'A142','A','WINDOW'),(155,4,'A143','A','WINDOW'),(156,4,'A144','A','WINDOW'),(157,4,'A145','A','WINDOW'),(158,4,'A146','A','WINDOW'),(159,4,'A147','A','WINDOW'),(160,4,'A148','A','WINDOW'),(161,4,'A149','A','WINDOW'),(162,4,'A150','A','WINDOW'),(163,4,'A151','A','WINDOW'),(164,4,'A152','A','WINDOW'),(165,4,'A153','A','WINDOW'),(166,4,'A154','A','WINDOW'),(167,4,'A155','A','WINDOW'),(168,4,'A156','A','WINDOW'),(169,4,'A157','A','WINDOW'),(170,4,'A158','A','WINDOW'),(171,4,'A159','A','WINDOW'),(172,4,'A160','A','WINDOW'),(173,4,'A161','A','WINDOW'),(174,4,'A162','A','WINDOW'),(175,4,'A163','A','WINDOW'),(176,4,'A164','A','WINDOW'),(177,4,'A165','A','WINDOW'),(178,4,'A166','A','WINDOW'),(179,4,'A167','A','WINDOW'),(180,4,'A168','A','WINDOW'),(181,4,'A169','A','WINDOW'),(182,4,'A170','A','WINDOW'),(183,4,'A171','A','WINDOW'),(184,4,'A172','A','WINDOW'),(185,4,'A173','A','WINDOW'),(186,4,'A174','A','WINDOW'),(187,4,'A175','A','WINDOW'),(188,4,'A176','A','WINDOW'),(189,4,'A177','A','WINDOW'),(190,4,'A178','A','WINDOW'),(191,4,'A179','A','WINDOW'),(192,4,'A180','A','WINDOW'),(193,4,'A181','A','WINDOW'),(194,4,'A182','A','WINDOW'),(195,4,'A183','A','WINDOW'),(196,4,'A184','A','WINDOW'),(197,4,'A185','A','WINDOW'),(198,4,'A186','A','WINDOW'),(199,4,'A187','A','WINDOW'),(200,4,'A188','A','WINDOW'),(201,4,'A189','A','WINDOW'),(202,4,'A190','A','WINDOW'),(203,4,'A191','A','WINDOW'),(204,4,'A192','A','WINDOW'),(205,4,'A193','A','WINDOW'),(206,4,'A194','A','WINDOW'),(207,4,'A195','A','WINDOW'),(208,4,'A196','A','WINDOW'),(209,4,'A197','A','WINDOW'),(210,4,'A198','A','WINDOW'),(211,4,'A199','A','WINDOW'),(212,4,'A200','A','WINDOW'),(213,5,'A1','A','WINDOW'),(214,5,'A2','A','WINDOW'),(215,5,'A3','A','WINDOW'),(216,5,'A4','A','WINDOW'),(217,5,'A5','A','WINDOW'),(218,5,'A6','A','WINDOW'),(219,5,'A7','A','WINDOW'),(220,5,'A8','A','WINDOW'),(221,5,'A9','A','WINDOW'),(222,5,'A10','A','WINDOW'),(223,5,'A11','A','WINDOW'),(224,5,'A12','A','WINDOW'),(225,5,'A13','A','WINDOW'),(226,5,'A14','A','WINDOW'),(227,5,'A15','A','WINDOW'),(228,5,'A16','A','WINDOW'),(229,5,'A17','A','WINDOW'),(230,5,'A18','A','WINDOW'),(231,5,'A19','A','WINDOW'),(232,5,'A20','A','WINDOW'),(233,5,'A21','A','WINDOW'),(234,5,'A22','A','WINDOW'),(235,5,'A23','A','WINDOW'),(236,5,'A24','A','WINDOW'),(237,5,'A25','A','WINDOW'),(238,5,'A26','A','WINDOW'),(239,5,'A27','A','WINDOW'),(240,5,'A28','A','WINDOW'),(241,5,'A29','A','WINDOW'),(242,5,'A30','A','WINDOW'),(243,5,'A31','A','WINDOW'),(244,5,'A32','A','WINDOW'),(245,5,'A33','A','WINDOW'),(246,5,'A34','A','WINDOW'),(247,5,'A35','A','WINDOW'),(248,5,'A36','A','WINDOW'),(249,5,'A37','A','WINDOW'),(250,5,'A38','A','WINDOW'),(251,5,'A39','A','WINDOW'),(252,5,'A40','A','WINDOW'),(253,5,'A41','A','WINDOW'),(254,5,'A42','A','WINDOW'),(255,5,'A43','A','WINDOW'),(256,5,'A44','A','WINDOW'),(257,5,'A45','A','WINDOW'),(258,5,'A46','A','WINDOW'),(259,5,'A47','A','WINDOW'),(260,5,'A48','A','WINDOW'),(261,5,'A49','A','WINDOW'),(262,5,'A50','A','WINDOW'),(263,5,'A51','A','WINDOW'),(264,5,'A52','A','WINDOW'),(265,5,'A53','A','WINDOW'),(266,5,'A54','A','WINDOW'),(267,5,'A55','A','WINDOW'),(268,5,'A56','A','WINDOW'),(269,5,'A57','A','WINDOW'),(270,5,'A58','A','WINDOW'),(271,5,'A59','A','WINDOW'),(272,5,'A60','A','WINDOW'),(273,5,'A61','A','WINDOW'),(274,5,'A62','A','WINDOW'),(275,5,'A63','A','WINDOW'),(276,5,'A64','A','WINDOW'),(277,5,'A65','A','WINDOW'),(278,5,'A66','A','WINDOW'),(279,5,'A67','A','WINDOW'),(280,5,'A68','A','WINDOW'),(281,5,'A69','A','WINDOW'),(282,5,'A70','A','WINDOW'),(283,5,'A71','A','WINDOW'),(284,5,'A72','A','WINDOW'),(285,5,'A73','A','WINDOW'),(286,5,'A74','A','WINDOW'),(287,5,'A75','A','WINDOW'),(288,5,'A76','A','WINDOW'),(289,5,'A77','A','WINDOW'),(290,5,'A78','A','WINDOW'),(291,5,'A79','A','WINDOW'),(292,5,'A80','A','WINDOW'),(293,6,'A1','A','WINDOW'),(294,6,'A2','A','WINDOW');
/*!40000 ALTER TABLE `seats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `security_log`
--

DROP TABLE IF EXISTS `security_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `security_log` (
  `log_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `login_time` datetime DEFAULT NULL,
  `logout_time` datetime DEFAULT NULL,
  PRIMARY KEY (`log_id`),
  KEY `idx_security_user` (`user_id`),
  CONSTRAINT `fk_security_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `security_log`
--

LOCK TABLES `security_log` WRITE;
/*!40000 ALTER TABLE `security_log` DISABLE KEYS */;
INSERT INTO `security_log` VALUES (1,1,'2026-06-27 13:45:01','2026-06-27 13:46:32'),(2,4,'2026-06-27 13:47:23','2026-06-27 13:48:06'),(3,1,'2026-06-27 13:52:45',NULL),(4,3,'2026-06-27 14:53:34','2026-06-27 14:55:28'),(5,1,'2026-06-27 16:31:40',NULL),(6,1,'2026-06-27 16:45:34','2026-06-27 16:45:40'),(7,1,'2026-06-27 16:51:34','2026-06-27 16:53:45'),(8,1,'2026-06-27 17:03:27','2026-06-27 17:03:30'),(9,1,'2026-06-28 22:59:23','2026-06-28 23:13:40'),(10,1,'2026-06-30 20:33:11','2026-06-30 20:33:49'),(11,1,'2026-07-17 22:04:06','2026-07-17 22:06:43'),(12,1,'2026-07-18 21:57:29',NULL),(13,1,'2026-07-18 22:03:14',NULL),(14,1,'2026-07-18 22:10:02',NULL),(15,1,'2026-07-18 22:13:41',NULL),(16,1,'2026-07-19 14:50:04','2026-07-19 14:51:11'),(17,1,'2026-07-19 14:52:29','2026-07-19 14:53:52'),(18,1,'2026-07-19 15:35:36',NULL),(19,3,'2026-07-19 15:47:49','2026-07-19 15:52:24'),(20,5,'2026-07-19 16:04:57',NULL),(21,1,'2026-07-19 16:05:22',NULL),(22,3,'2026-07-19 16:17:13',NULL),(23,5,'2026-07-19 16:17:37',NULL),(24,1,'2026-08-01 20:16:36','2026-08-01 20:20:16'),(25,4,'2026-08-01 20:47:46',NULL),(26,3,'2026-08-01 20:48:43',NULL),(27,1,'2026-08-01 21:01:08','2026-08-01 21:25:21'),(28,4,'2026-08-01 21:27:53','2026-08-01 21:30:26'),(29,4,'2026-08-01 21:34:05',NULL),(30,4,'2026-08-01 22:19:30','2026-08-01 22:54:03'),(31,4,'2026-08-01 22:56:39','2026-08-01 23:09:33');
/*!40000 ALTER TABLE `security_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stations`
--

DROP TABLE IF EXISTS `stations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stations` (
  `station_id` int NOT NULL AUTO_INCREMENT,
  `station_code` varchar(10) NOT NULL,
  `station_name` varchar(100) NOT NULL,
  `city` varchar(100) NOT NULL,
  PRIMARY KEY (`station_id`),
  UNIQUE KEY `station_code` (`station_code`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stations`
--

LOCK TABLES `stations` WRITE;
/*!40000 ALTER TABLE `stations` DISABLE KEYS */;
INSERT INTO `stations` VALUES (1,'NDLS','New Delhi','Delhi'),(2,'ADI','Ahmedabad Junction','Ahmedabad'),(3,'MMCT','Mumbai Central','Mumbai'),(4,'BCT','Mumbai Local Terminal','Mumbai'),(5,'CNB','Kanpur Central','Kanpur'),(6,'LKO','Lucknow Junction','Lucknow');
/*!40000 ALTER TABLE `stations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `train_audit`
--

DROP TABLE IF EXISTS `train_audit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `train_audit` (
  `audit_id` int NOT NULL AUTO_INCREMENT,
  `train_id` int NOT NULL,
  `train_no` varchar(20) DEFAULT NULL,
  `train_name` varchar(100) DEFAULT NULL,
  `old_fare` decimal(10,2) DEFAULT NULL,
  `new_fare` decimal(10,2) DEFAULT NULL,
  `old_status` varchar(20) DEFAULT NULL,
  `new_status` varchar(20) DEFAULT NULL,
  `action_type` enum('UPDATE','DEACTIVATE','ACTIVATE') NOT NULL,
  `changed_by` varchar(100) DEFAULT NULL,
  `changed_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`audit_id`),
  KEY `idx_train_audit` (`train_id`),
  KEY `idx_audit_date` (`changed_at`),
  CONSTRAINT `train_audit_ibfk_1` FOREIGN KEY (`train_id`) REFERENCES `trains` (`train_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `train_audit`
--

LOCK TABLES `train_audit` WRITE;
/*!40000 ALTER TABLE `train_audit` DISABLE KEYS */;
INSERT INTO `train_audit` VALUES (1,4,'2406143','ujjan Special',1000.00,1000.00,'ACTIVE','INACTIVE','UPDATE','SYSTEM','2026-06-27 08:21:27'),(2,6,'TEST01','WaitlistTestTrain',500.00,500.00,'ACTIVE','INACTIVE','DEACTIVATE','Train Admin1','2026-08-01 17:42:34'),(3,6,'TEST01','WaitlistTestTrain',500.00,250.00,'INACTIVE','INACTIVE','UPDATE','Train Admin1','2026-08-01 17:42:48');
/*!40000 ALTER TABLE `train_audit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trains`
--

DROP TABLE IF EXISTS `trains`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trains` (
  `train_id` int NOT NULL AUTO_INCREMENT,
  `train_no` varchar(20) NOT NULL,
  `train_name` varchar(100) NOT NULL,
  `source_station_id` int NOT NULL,
  `destination_station_id` int NOT NULL,
  `departure_time` time NOT NULL,
  `arrival_time` time NOT NULL,
  `total_seats` int NOT NULL,
  `available_seats` int NOT NULL,
  `fare` decimal(10,2) NOT NULL,
  `status` enum('ACTIVE','INACTIVE','CANCELLED') DEFAULT 'ACTIVE',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`train_id`),
  UNIQUE KEY `train_no` (`train_no`),
  KEY `fk_train_source_station` (`source_station_id`),
  KEY `fk_train_destination_station` (`destination_station_id`),
  KEY `idx_train_number` (`train_no`),
  CONSTRAINT `fk_train_destination_station` FOREIGN KEY (`destination_station_id`) REFERENCES `stations` (`station_id`),
  CONSTRAINT `fk_train_source_station` FOREIGN KEY (`source_station_id`) REFERENCES `stations` (`station_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trains`
--

LOCK TABLES `trains` WRITE;
/*!40000 ALTER TABLE `trains` DISABLE KEYS */;
INSERT INTO `trains` VALUES (1,'12951','Mumbai Rajdhani',1,3,'16:55:00','08:35:00',100,96,1500.00,'ACTIVE','2026-06-27 07:59:40'),(2,'12009','Shatabdi Express',1,6,'06:00:00','12:30:00',80,75,900.00,'ACTIVE','2026-06-27 07:59:40'),(3,'22953','Gujarat Superfast',2,3,'21:00:00','07:15:00',120,117,1100.00,'ACTIVE','2026-06-27 07:59:40'),(4,'2406143','ujjan Special',3,1,'15:34:00','05:20:00',200,200,1000.00,'INACTIVE','2026-06-27 08:02:40'),(5,'8888','Varanasi Express',3,2,'15:43:00','12:00:00',80,80,1200.00,'ACTIVE','2026-06-27 09:11:59'),(6,'TEST01','WaitlistTestTrain',6,1,'02:30:00','10:15:00',2,0,250.00,'INACTIVE','2026-08-01 15:57:33');
/*!40000 ALTER TABLE `trains` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `train_audit_trigger` AFTER UPDATE ON `trains` FOR EACH ROW BEGIN
    IF (OLD.fare != NEW.fare) OR (OLD.status != NEW.status) THEN
        INSERT INTO train_audit (train_id, train_no, train_name, old_fare, new_fare, old_status, new_status, action_type, changed_by)
        VALUES (
            NEW.train_id, NEW.train_no, NEW.train_name, OLD.fare, NEW.fare, OLD.status, NEW.status,
            -- ✅ CHANGED: was a hardcoded 'UPDATE' string; now derives the correct
            -- action label so TrainHistory.jsp's badge-activate / badge-deactivate
            -- CSS classes (already built, previously unreachable) will render.
            CASE
                WHEN OLD.status = 'ACTIVE' AND NEW.status = 'INACTIVE' THEN 'DEACTIVATE'
                WHEN OLD.status = 'INACTIVE' AND NEW.status = 'ACTIVE' THEN 'ACTIVATE'
                ELSE 'UPDATE'
            END,
            IF(@current_admin IS NOT NULL, @current_admin, 'SYSTEM')
        );
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `user_password` varchar(255) NOT NULL,
  `is_active` enum('Active','Inactive','Deactivated') DEFAULT 'Active',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `phone` (`phone`),
  KEY `idx_user_email` (`email`),
  KEY `idx_user_phone` (`phone`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Priya Yadav','priya@gmail.com','9876543210','0a8b8dfad3f637d7d30fed7b108c5c5986c4775d14cab26ec9279866eba99116','Active','2026-06-27 07:59:40'),(2,'Rahul Sharma','rahul@gmail.com','9876543211','687f6da20de59091e67f594827cdee268125feb3aed1c3bad77d0f6761eb198a','Active','2026-06-27 07:59:40'),(3,'Amit Patel','amit@gmail.com','9876543212','1fec7401b302e76333629c9f68415b7718769e072f0613e54726143cda06d789','Active','2026-06-27 07:59:40'),(4,'Riya','riya@gmail.com','9999999999','bc97aaa7b5bde4bae9d3b658e6d4bf711b2d8bb5d7a27f17e95815efc6e0618d','Active','2026-06-27 07:59:41'),(5,'Sushila yadav','sushi@gmail.com','0989787630','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92','Active','2026-07-19 10:25:28'),(6,'srishti','sri@gmail.com','7867478789','99b73be742a560f9b1bbc47e575c7f4ae50ba82a6528e1534c101fbf49f2a06e','Active','2026-07-19 10:52:17');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'train_reservation_system'
--
/*!50106 SET @save_time_zone= @@TIME_ZONE */ ;
/*!50106 DROP EVENT IF EXISTS `daily_expire_journeys` */;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8mb4 */ ;;
/*!50003 SET character_set_results = utf8mb4 */ ;;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 DEFINER=`root`@`localhost`*/ /*!50106 EVENT `daily_expire_journeys` ON SCHEDULE EVERY 1 DAY STARTS '2026-06-27 00:00:01' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN
    CALL expire_past_journeys();
END */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
DELIMITER ;
/*!50106 SET TIME_ZONE= @save_time_zone */ ;

--
-- Dumping routines for database 'train_reservation_system'
--
/*!50003 DROP FUNCTION IF EXISTS `login_user_func` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `login_user_func`(p_email VARCHAR(100), p_password VARCHAR(255)) RETURNS tinyint(1)
    DETERMINISTIC
BEGIN
    DECLARE v_user_id INT;
    
    SELECT user_id INTO v_user_id
    FROM users
    WHERE email = p_email AND user_password = SHA2(p_password, 256) AND is_active = 'Active'
    LIMIT 1;
    
    IF v_user_id IS NOT NULL THEN
        INSERT INTO security_log (user_id, login_time) VALUES (v_user_id, NOW());
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `logout_user_func` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `logout_user_func`(p_user_id INT) RETURNS tinyint(1)
    DETERMINISTIC
BEGIN
    DECLARE v_log_id INT;
    
    SELECT log_id INTO v_log_id
    FROM security_log
    WHERE user_id = p_user_id AND logout_time IS NULL
    ORDER BY login_time DESC LIMIT 1;
    
    IF v_log_id IS NOT NULL THEN
        UPDATE security_log SET logout_time = NOW() WHERE log_id = v_log_id;
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `activate_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `activate_user`(IN p_user_id INT)
BEGIN
    UPDATE users SET is_active = 'Active' WHERE user_id = p_user_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `add_to_waitlist` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_to_waitlist`(
    IN p_user_id INT,
    IN p_train_id INT,
    IN p_journey_date DATE,
    IN p_passenger_name VARCHAR(100),
    IN p_age INT,
    IN p_gender VARCHAR(10)
)
BEGIN
    DECLARE v_pnr VARCHAR(20);
    DECLARE v_total_fare DECIMAL(10,2);
    DECLARE v_booking_id INT;

    SELECT fare INTO v_total_fare FROM trains WHERE train_id = p_train_id;

    START TRANSACTION;

    INSERT INTO bookings (pnr, user_id, train_id, journey_date, total_passengers, total_fare, booking_status)
    VALUES ('', p_user_id, p_train_id, p_journey_date, 1, v_total_fare, 'WAITING');

    SET v_booking_id = LAST_INSERT_ID();
    SET v_pnr = CONCAT('PNR', 100000 + v_booking_id);
    UPDATE bookings SET pnr = v_pnr WHERE booking_id = v_booking_id;

    INSERT INTO passengers (booking_id, passenger_name, age, gender, passenger_status)
    VALUES (v_booking_id, p_passenger_name, p_age, p_gender, 'WAITING');

    COMMIT;

    SELECT v_booking_id AS booking_id, v_pnr AS pnr;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `add_train` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_train`(
    IN p_train_no VARCHAR(20),
    IN p_train_name VARCHAR(100),
    IN p_source_station INT,
    IN p_destination_station INT,
    IN p_departure TIME,
    IN p_arrival TIME,
    IN p_total_seats INT,
    IN p_fare DECIMAL(10,2)
)
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE v_train_id INT;
    
    INSERT INTO trains (train_no, train_name, source_station_id, destination_station_id, departure_time, arrival_time, total_seats, available_seats, fare)
    VALUES (p_train_no, p_train_name, p_source_station, p_destination_station, p_departure, p_arrival, p_total_seats, p_total_seats, p_fare);
    
    SET v_train_id = LAST_INSERT_ID();
    
    WHILE i <= p_total_seats DO
        INSERT INTO seats (train_id, seat_number, coach_no, seat_type)
        VALUES (v_train_id, CONCAT('A', i), 'A', 'WINDOW');
        SET i = i + 1;
    END WHILE;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `book_ticket` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `book_ticket`(
    IN p_user_id INT,
    IN p_train_id INT,
    IN p_journey_date DATE,
    IN p_passenger_name VARCHAR(100),
    IN p_age INT,
    IN p_gender VARCHAR(10),
    IN p_seat_id INT,
    IN p_payment_method VARCHAR(20)
)
BEGIN
    DECLARE v_pnr VARCHAR(20);
    DECLARE v_total_fare DECIMAL(10,2);
    DECLARE v_booking_id INT;
    DECLARE v_passenger_id INT;
    
    SELECT fare INTO v_total_fare FROM trains WHERE train_id = p_train_id;
    
    START TRANSACTION;
    
    INSERT INTO bookings (pnr, user_id, train_id, journey_date, total_passengers, total_fare, booking_status)
    VALUES ('', p_user_id, p_train_id, p_journey_date, 1, v_total_fare, 'CONFIRMED');
    
    SET v_booking_id = LAST_INSERT_ID();
    SET v_pnr = CONCAT('PNR', 100000 + v_booking_id);
    UPDATE bookings SET pnr = v_pnr WHERE booking_id = v_booking_id;
    
    INSERT INTO passengers (booking_id, passenger_name, age, gender, passenger_status)
    VALUES (v_booking_id, p_passenger_name, p_age, p_gender, 'CONFIRMED');
    SET v_passenger_id = LAST_INSERT_ID();
    
    INSERT INTO seat_reservation (booking_id, passenger_id, seat_id, journey_date, reservation_status)
    VALUES (v_booking_id, v_passenger_id, p_seat_id, p_journey_date, 'BOOKED');
    
    INSERT INTO payments (booking_id, amount, payment_method, payment_status, payment_date)
    VALUES (v_booking_id, v_total_fare, p_payment_method, 'SUCCESS', NOW());
    
    -- ✅ NEW LINE: decrement available_seats so ManageTrains.jsp / SearchTrain.jsp
    -- finally reflect real bookings instead of always showing full availability.
    UPDATE trains SET available_seats = available_seats - 1 WHERE train_id = p_train_id;
    
    COMMIT;
    
    SELECT v_booking_id AS booking_id, v_pnr AS pnr;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cancel_ticket` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cancel_ticket`(IN p_booking_id INT)
BEGIN
    DECLARE v_train_id INT DEFAULT NULL;
    DECLARE v_journey_date DATE DEFAULT NULL;
    DECLARE v_seat_id INT DEFAULT NULL;

    -- ✅ NEW: capture what's being freed BEFORE any cancellation happens
    SELECT b.train_id, b.journey_date, sr.seat_id
    INTO v_train_id, v_journey_date, v_seat_id
    FROM bookings b
    LEFT JOIN seat_reservation sr ON sr.booking_id = b.booking_id AND sr.reservation_status = 'BOOKED'
    WHERE b.booking_id = p_booking_id AND b.booking_status = 'CONFIRMED'
    LIMIT 1;

    UPDATE trains t
    JOIN bookings b ON b.train_id = t.train_id
    SET t.available_seats = t.available_seats + 1
    WHERE b.booking_id = p_booking_id AND b.booking_status = 'CONFIRMED';

    UPDATE bookings SET booking_status = 'CANCELLED' WHERE booking_id = p_booking_id;
    UPDATE passengers SET passenger_status = 'CANCELLED' WHERE booking_id = p_booking_id;
    UPDATE seat_reservation SET reservation_status = 'CANCELLED' WHERE booking_id = p_booking_id;
    UPDATE payments SET payment_status = 'REFUNDED' WHERE booking_id = p_booking_id AND payment_status = 'SUCCESS';

    -- ✅ NEW: return the freed info (all NULL if this wasn't a CONFIRMED booking)
    SELECT v_train_id AS freed_train_id, v_journey_date AS freed_journey_date, v_seat_id AS freed_seat_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `change_admin_password` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `change_admin_password`(
    IN p_admin_id INT,
    IN p_current_password VARCHAR(255),
    IN p_new_password VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;
    
    SELECT COUNT(*) INTO v_count
    FROM admins WHERE admin_id = p_admin_id AND admin_password = SHA2(p_current_password, 256);
    
    IF v_count = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Current password is incorrect';
    END IF;
    
    IF LENGTH(p_new_password) < 6 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Password must be at least 6 characters';
    END IF;
    
    UPDATE admins SET admin_password = SHA2(p_new_password, 256) WHERE admin_id = p_admin_id;
    SELECT 'Password Changed Successfully' AS message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `change_password` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `change_password`(
    IN p_user_id INT,
    IN p_old_password VARCHAR(255),
    IN p_new_password VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;
    
    SELECT COUNT(*) INTO v_count
    FROM users
    WHERE user_id = p_user_id AND user_password = SHA2(p_old_password, 256);
    
    IF v_count = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Current password is incorrect';
    END IF;
    
    IF LENGTH(p_new_password) < 6 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Password must be at least 6 characters';
    END IF;
    
    UPDATE users SET user_password = SHA2(p_new_password, 256) WHERE user_id = p_user_id;
    SELECT 'Password Changed Successfully' AS message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `deactivate_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `deactivate_user`(IN p_user_id INT)
BEGIN
    UPDATE users SET is_active = 'Inactive' WHERE user_id = p_user_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `download_ticket` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `download_ticket`(IN p_pnr VARCHAR(20))
BEGIN
    SELECT b.pnr, t.train_no, t.train_name, b.journey_date, p.passenger_name, p.age, p.gender, s.seat_number, s.coach_no, b.total_fare
    FROM bookings b
    JOIN passengers p ON b.booking_id = p.booking_id
    JOIN seat_reservation sr ON p.passenger_id = sr.passenger_id
    JOIN seats s ON sr.seat_id = s.seat_id
    JOIN trains t ON b.train_id = t.train_id
    WHERE b.pnr = p_pnr;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `expire_past_journeys` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `expire_past_journeys`()
BEGIN
    UPDATE bookings SET booking_status = 'EXPIRED'
    WHERE booking_status = 'CONFIRMED' AND journey_date < CURDATE();
    
    UPDATE seat_reservation sr
    JOIN bookings b ON sr.booking_id = b.booking_id
    SET sr.reservation_status = 'CANCELLED'
    WHERE b.booking_status = 'EXPIRED' AND sr.reservation_status = 'BOOKED';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_admin_profile` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_admin_profile`(IN p_admin_id INT)
BEGIN
    SELECT admin_id, name, email FROM admins WHERE admin_id = p_admin_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_all_bookings` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_bookings`()
BEGIN
    SELECT 
        b.*,
        u.name AS user_name,
        t.train_name
    FROM bookings b
    LEFT JOIN users u ON b.user_id = u.user_id
    LEFT JOIN trains t ON b.train_id = t.train_id
    ORDER BY b.booking_date DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_all_bookings_count` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_bookings_count`()
BEGIN
    SELECT COUNT(*) AS total FROM bookings;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_all_bookings_paged` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_bookings_paged`(IN p_limit INT, IN p_offset INT)
BEGIN
    SET @lim = p_limit;
    SET @off = p_offset;
    PREPARE stmt FROM
        'SELECT b.*, u.name AS user_name, t.train_name
         FROM bookings b
         LEFT JOIN users u ON b.user_id = u.user_id
         LEFT JOIN trains t ON b.train_id = t.train_id
         ORDER BY b.booking_date DESC
         LIMIT ? OFFSET ?';
    EXECUTE stmt USING @lim, @off;
    DEALLOCATE PREPARE stmt;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_all_trains` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_trains`()
BEGIN
    SELECT * FROM trains ORDER BY train_id DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_all_train_audit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_train_audit`()
BEGIN
    SELECT audit_id, train_id, train_no, train_name, old_fare, new_fare, old_status, new_status, action_type, changed_by, changed_at
    FROM train_audit
    ORDER BY changed_at DESC
    LIMIT 50;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_all_users` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_users`()
BEGIN
    SELECT * FROM users;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_all_users_count` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_users_count`()
BEGIN
    SELECT COUNT(*) AS total FROM users;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_all_users_paged` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_users_paged`(IN p_limit INT, IN p_offset INT)
BEGIN
    SET @lim = p_limit;
    SET @off = p_offset;
    -- Note: added ORDER BY user_id DESC (the original get_all_users had no
    -- explicit order) since stable pagination requires a deterministic
    -- order - without it, rows could repeat or be skipped across pages.
    PREPARE stmt FROM
        'SELECT * FROM users ORDER BY user_id DESC LIMIT ? OFFSET ?';
    EXECUTE stmt USING @lim, @off;
    DEALLOCATE PREPARE stmt;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_booking_count_for_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_booking_count_for_user`(IN p_user_id INT)
BEGIN
    SELECT COUNT(*) AS total FROM bookings WHERE user_id = p_user_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_booking_history` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_booking_history`(IN p_user_id INT)
BEGIN
    UPDATE bookings SET booking_status = 'EXPIRED'
    WHERE user_id = p_user_id AND booking_status = 'CONFIRMED' AND journey_date < CURDATE();
    
    SELECT booking_id, pnr, train_id, journey_date, booking_date, total_passengers, total_fare, booking_status
    FROM bookings
    WHERE user_id = p_user_id
    ORDER BY booking_date DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_booking_history_paged` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_booking_history_paged`(IN p_user_id INT, IN p_limit INT, IN p_offset INT)
BEGIN
    UPDATE bookings SET booking_status = 'EXPIRED'
    WHERE user_id = p_user_id AND booking_status = 'CONFIRMED' AND journey_date < CURDATE();

    SET @uid = p_user_id;
    SET @lim = p_limit;
    SET @off = p_offset;

    PREPARE stmt FROM
        'SELECT booking_id, pnr, train_id, journey_date, booking_date, total_passengers, total_fare, booking_status
         FROM bookings
         WHERE user_id = ?
         ORDER BY booking_date DESC
         LIMIT ? OFFSET ?';
    EXECUTE stmt USING @uid, @lim, @off;
    DEALLOCATE PREPARE stmt;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_booking_status_distribution` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_booking_status_distribution`()
BEGIN
    SELECT booking_status, COUNT(*) AS count
    FROM bookings
    GROUP BY booking_status;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_complete_booking_details` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_complete_booking_details`(IN p_pnr VARCHAR(20))
BEGIN
    SELECT 
        b.pnr,
        t.train_name,
        b.journey_date,
        b.booking_status,
        p.passenger_name,
        p.age,
        p.gender,
        COALESCE(s.seat_number, 'N/A') AS seat_number,
        COALESCE(s.coach_no, 'N/A') AS coach_no,
        b.total_fare
    FROM bookings b
    JOIN trains t ON b.train_id = t.train_id
    LEFT JOIN passengers p ON b.booking_id = p.booking_id
    LEFT JOIN seat_reservation sr ON p.passenger_id = sr.passenger_id
    LEFT JOIN seats s ON sr.seat_id = s.seat_id
    WHERE b.pnr = p_pnr
    LIMIT 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_dashboard_stats` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_dashboard_stats`()
BEGIN
    SELECT
        (SELECT COUNT(*) FROM users) AS total_users,
        (SELECT COUNT(*) FROM trains) AS total_trains,
        (SELECT COUNT(*) FROM bookings) AS total_bookings,
        (SELECT IFNULL(SUM(amount), 0) FROM payments WHERE payment_status = 'SUCCESS') AS total_revenue,
        (SELECT COUNT(*) FROM bookings WHERE DATE(booking_date) = CURDATE()) AS todays_bookings,
        (SELECT IFNULL(SUM(amount), 0) FROM payments WHERE payment_status = 'SUCCESS' AND DATE(payment_date) = CURDATE()) AS todays_revenue;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_monthly_bookings` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_monthly_bookings`()
BEGIN
    SELECT MONTH(journey_date) AS month_num, MONTHNAME(journey_date) AS month_name, COUNT(*) AS booking_count
    FROM bookings
    GROUP BY MONTH(journey_date), MONTHNAME(journey_date)
    ORDER BY MONTH(journey_date);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_next_waitlist_booking` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_next_waitlist_booking`(IN p_train_id INT, IN p_journey_date DATE)
BEGIN
    SELECT booking_id, pnr, user_id, total_fare
    FROM bookings
    WHERE train_id = p_train_id AND journey_date = p_journey_date AND booking_status = 'WAITING'
    ORDER BY booking_date ASC
    LIMIT 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_passengers_by_booking` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_passengers_by_booking`(IN p_booking_id INT)
BEGIN
    SELECT 
        p.passenger_id,
        p.passenger_name,
        p.age,
        p.gender,
        COALESCE(s.seat_number, 'N/A') AS seat_number,
        COALESCE(s.coach_no, 'N/A') AS coach_no
    FROM passengers p
    LEFT JOIN seat_reservation sr ON p.passenger_id = sr.passenger_id
    LEFT JOIN seats s ON sr.seat_id = s.seat_id
    WHERE p.booking_id = p_booking_id
    LIMIT 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_passengers_with_seats` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_passengers_with_seats`(IN p_booking_id INT)
BEGIN
    SELECT 
        p.passenger_id,
        p.passenger_name,
        p.age,
        p.gender,
        COALESCE(s.seat_number, 'N/A') AS seat_number,
        COALESCE(s.coach_no, 'N/A') AS coach_no
    FROM passengers p
    LEFT JOIN seat_reservation sr ON p.passenger_id = sr.passenger_id
    LEFT JOIN seats s ON sr.seat_id = s.seat_id
    WHERE p.booking_id = p_booking_id
    LIMIT 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_recent_activities` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_recent_activities`()
BEGIN
    (SELECT 'BOOKING' AS activity_type, ba.action_type AS action, CONCAT('Booking ', b.pnr, ' ', ba.action_type) AS description, ba.action_time AS activity_time
     FROM booking_audit ba JOIN bookings b ON ba.booking_id = b.booking_id
     ORDER BY ba.action_time DESC LIMIT 5)
    UNION ALL
    (SELECT 'LOGIN' AS activity_type, 'LOGIN' AS action, CONCAT('User ', u.name, ' logged in') AS description, sl.login_time AS activity_time
     FROM security_log sl JOIN users u ON sl.user_id = u.user_id
     ORDER BY sl.login_time DESC LIMIT 5)
    ORDER BY activity_time DESC LIMIT 10;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_recent_bookings` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_recent_bookings`(IN p_user_id INT)
BEGIN
    SELECT b.pnr, t.train_name, b.journey_date, b.booking_status, b.booking_id
    FROM bookings b JOIN trains t ON b.train_id = t.train_id
    WHERE b.user_id = p_user_id
    ORDER BY b.booking_date DESC LIMIT 5;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_recent_booking_date_for_train` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_recent_booking_date_for_train`(IN p_train_id INT)
BEGIN
    SELECT journey_date
    FROM bookings
    WHERE train_id = p_train_id AND booking_status = 'CONFIRMED'
    ORDER BY booking_date DESC
    LIMIT 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_report_summary` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_report_summary`()
BEGIN
    SELECT
        (SELECT IFNULL(SUM(total_fare), 0) FROM bookings WHERE booking_status = 'CONFIRMED') AS total_revenue,
        (SELECT COUNT(*) FROM bookings) AS total_bookings,
        (SELECT COUNT(*) FROM bookings WHERE booking_status = 'CANCELLED') AS cancelled_bookings,
        (SELECT COUNT(*) FROM trains WHERE status = 'ACTIVE') AS active_trains;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_train_seats_status` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_train_seats_status`(IN p_train_id INT, IN p_journey_date DATE)
BEGIN
    SELECT 
        s.seat_id,
        s.seat_number,
        s.coach_no,
        s.seat_type,
        CASE WHEN sr.reservation_status = 'BOOKED' THEN 'BOOKED' ELSE 'AVAILABLE' END AS seat_status
    FROM seats s
    LEFT JOIN seat_reservation sr ON s.seat_id = sr.seat_id AND sr.journey_date = p_journey_date AND sr.reservation_status = 'BOOKED'
    WHERE s.train_id = p_train_id
    ORDER BY s.seat_number;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_user_dashboard` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_user_dashboard`(IN p_user_id INT)
BEGIN
    UPDATE bookings SET booking_status = 'EXPIRED'
    WHERE user_id = p_user_id AND booking_status = 'CONFIRMED' AND journey_date < CURDATE();
    
    SELECT
        (SELECT COUNT(*) FROM bookings WHERE user_id = p_user_id) AS total_bookings,
        (SELECT COUNT(*) FROM bookings WHERE user_id = p_user_id AND booking_status = 'CONFIRMED' AND journey_date >= CURDATE()) AS active_tickets,
        (SELECT COUNT(*) FROM bookings WHERE user_id = p_user_id AND booking_status = 'CANCELLED') AS cancelled_tickets,
        (SELECT COUNT(*) FROM bookings WHERE user_id = p_user_id AND booking_status = 'EXPIRED') AS expired_tickets,
        (SELECT CONCAT(t.train_name, ' on ', b.journey_date) FROM bookings b JOIN trains t ON b.train_id = t.train_id
         WHERE b.user_id = p_user_id AND b.booking_status = 'CONFIRMED' AND b.journey_date >= CURDATE()
         ORDER BY b.journey_date ASC LIMIT 1) AS upcoming_journey;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_user_details` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_user_details`(IN p_user_id INT)
BEGIN
    SELECT user_id, name, email, phone, is_active, created_at
    FROM users WHERE user_id = p_user_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_user_login_history` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_user_login_history`(IN p_user_id INT)
BEGIN
    SELECT login_time, logout_time FROM security_log
    WHERE user_id = p_user_id ORDER BY login_time DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `promote_waitlist_booking` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `promote_waitlist_booking`(IN p_booking_id INT, IN p_seat_id INT)
BEGIN
    DECLARE v_passenger_id INT;
    DECLARE v_journey_date DATE;
    DECLARE v_train_id INT;
    DECLARE v_total_fare DECIMAL(10,2);

    SELECT passenger_id INTO v_passenger_id FROM passengers WHERE booking_id = p_booking_id LIMIT 1;
    SELECT journey_date, train_id, total_fare INTO v_journey_date, v_train_id, v_total_fare
        FROM bookings WHERE booking_id = p_booking_id;

    START TRANSACTION;

    INSERT INTO seat_reservation (booking_id, passenger_id, seat_id, journey_date, reservation_status)
    VALUES (p_booking_id, v_passenger_id, p_seat_id, v_journey_date, 'BOOKED');

    UPDATE bookings SET booking_status = 'CONFIRMED' WHERE booking_id = p_booking_id;
    UPDATE passengers SET passenger_status = 'CONFIRMED' WHERE booking_id = p_booking_id;

    -- Note: auto-promoted bookings default payment method to 'UPI' since no
    -- payment method was collected at waitlist-join time (no charge happens
    -- until a seat is actually available).
    INSERT INTO payments (booking_id, amount, payment_method, payment_status, payment_date)
    VALUES (p_booking_id, v_total_fare, 'UPI', 'SUCCESS', NOW());

    UPDATE trains SET available_seats = available_seats - 1 WHERE train_id = v_train_id;

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `register_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `register_user`(
    IN p_name VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_phone VARCHAR(15),
    IN p_password VARCHAR(255)
)
BEGIN
    IF EXISTS (SELECT 1 FROM users WHERE email = p_email) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Email already exists';
    END IF;
    
    IF EXISTS (SELECT 1 FROM users WHERE phone = p_phone) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Phone number already exists';
    END IF;
    
    IF LENGTH(p_password) < 6 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Password must be minimum 6 characters';
    END IF;
    
    INSERT INTO users (name, email, phone, user_password)
    VALUES (p_name, p_email, p_phone, SHA2(p_password, 256));
    
    SELECT 'User Registered Successfully' AS message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `remove_train` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `remove_train`(IN p_train_id INT)
BEGIN
    UPDATE trains SET status = 'INACTIVE' WHERE train_id = p_train_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `search_booking_by_pnr` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `search_booking_by_pnr`(IN p_pnr VARCHAR(20))
BEGIN
    SELECT b.*, t.train_no, t.train_name, u.name
    FROM bookings b
    JOIN trains t ON b.train_id = t.train_id
    JOIN users u ON b.user_id = u.user_id
    WHERE b.pnr = p_pnr;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `search_train` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `search_train`(IN p_source_station INT, IN p_destination_station INT)
BEGIN
    SELECT * FROM trains
    WHERE source_station_id = p_source_station
    AND destination_station_id = p_destination_station
    AND status = 'ACTIVE';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_admin_email` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_admin_email`(IN p_admin_id INT, IN p_email VARCHAR(100))
BEGIN
    IF EXISTS (SELECT 1 FROM admins WHERE email = p_email AND admin_id != p_admin_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Email already exists for another admin';
    END IF;
    
    UPDATE admins SET email = p_email WHERE admin_id = p_admin_id;
    SELECT 'Email Updated Successfully' AS message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_admin_name` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_admin_name`(IN p_admin_id INT, IN p_name VARCHAR(100))
BEGIN
    UPDATE admins SET name = p_name WHERE admin_id = p_admin_id;
    SELECT 'Name Updated Successfully' AS message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_booking_details` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_booking_details`(
    IN p_booking_id INT,
    IN p_total_passengers INT,
    IN p_total_fare DECIMAL(10,2)
)
BEGIN
    UPDATE bookings SET total_passengers = p_total_passengers, total_fare = p_total_fare
    WHERE booking_id = p_booking_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_train` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_train`(IN p_train_id INT, IN p_fare DECIMAL(10,2), IN p_status VARCHAR(20))
BEGIN
    UPDATE trains SET fare = p_fare, status = p_status WHERE train_id = p_train_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_user_email` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_user_email`(IN p_user_id INT, IN p_email VARCHAR(100))
BEGIN
    IF EXISTS (SELECT 1 FROM users WHERE email = p_email AND user_id != p_user_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Email already exists';
    END IF;
    
    UPDATE users SET email = p_email WHERE user_id = p_user_id;
    SELECT 'Email Updated Successfully' AS message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_user_name` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_user_name`(IN p_user_id INT, IN p_name VARCHAR(100))
BEGIN
    UPDATE users SET name = p_name WHERE user_id = p_user_id;
    SELECT 'Name Updated Successfully' AS message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_user_password` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_user_password`(
    IN p_user_id INT,
    IN p_current_password VARCHAR(255),
    IN p_new_password VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;
    
    SELECT COUNT(*) INTO v_count
    FROM users
    WHERE user_id = p_user_id AND user_password = SHA2(p_current_password, 256);
    
    IF v_count = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Current Password Incorrect';
    END IF;
    
    IF LENGTH(p_new_password) < 6 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Password must be minimum 6 characters';
    END IF;
    
    UPDATE users SET user_password = SHA2(p_new_password, 256) WHERE user_id = p_user_id;
    SELECT 'Password Updated Successfully' AS message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_user_phone` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_user_phone`(IN p_user_id INT, IN p_phone VARCHAR(15))
BEGIN
    IF EXISTS (SELECT 1 FROM users WHERE phone = p_phone AND user_id != p_user_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Phone already exists';
    END IF;
    
    UPDATE users SET phone = p_phone WHERE user_id = p_user_id;
    SELECT 'Phone Updated Successfully' AS message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-08-02 20:36:43
