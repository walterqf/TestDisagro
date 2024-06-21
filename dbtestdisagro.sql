-- MySQL dump 10.13  Distrib 8.0.32, for macos13 (arm64)
--
-- Host: 127.0.0.1    Database: PlataformaPromociones
-- ------------------------------------------------------
-- Server version	8.0.32

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

--
-- Table structure for table `Clientes`
--
DROP DATABASE IF EXISTS PlataformaPromociones;
CREATE DATABASE PlataformaPromociones;
USE PlataformaPromociones;
DROP TABLE IF EXISTS `Clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Clientes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombres` varchar(100) NOT NULL,
  `apellidos` varchar(100) NOT NULL,
  `correo_electronico` varchar(100) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `fecha_registro` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Clientes`
--

LOCK TABLES `Clientes` WRITE;
/*!40000 ALTER TABLE `Clientes` DISABLE KEYS */;
INSERT INTO `Clientes` (`id`, `nombres`, `apellidos`, `correo_electronico`, `telefono`, `fecha_registro`) VALUES (1,'Walter','Quijada','walterqfolgar@hotmail.com',NULL,'2024-06-19 17:26:53'),(2,'Walto','Q','walter@aol.com',NULL,'2024-06-19 22:56:58');
/*!40000 ALTER TABLE `Clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Confirmaciones`
--

DROP TABLE IF EXISTS `Confirmaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Confirmaciones` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cliente_id` int NOT NULL,
  `evento_id` int NOT NULL,
  `fecha_confirmacion` datetime DEFAULT CURRENT_TIMESTAMP,
  `descuento_servicio` decimal(5,2) DEFAULT NULL,
  `descuento_producto` decimal(5,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cliente_id` (`cliente_id`),
  KEY `evento_id` (`evento_id`),
  CONSTRAINT `confirmaciones_ibfk_1` FOREIGN KEY (`cliente_id`) REFERENCES `Clientes` (`id`),
  CONSTRAINT `confirmaciones_ibfk_2` FOREIGN KEY (`evento_id`) REFERENCES `Eventos` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Confirmaciones`
--

LOCK TABLES `Confirmaciones` WRITE;
/*!40000 ALTER TABLE `Confirmaciones` DISABLE KEYS */;
INSERT INTO `Confirmaciones` (`id`, `cliente_id`, `evento_id`, `fecha_confirmacion`, `descuento_servicio`, `descuento_producto`) VALUES (1,1,1,'2024-06-19 17:26:53',5.00,3.00),(2,2,2,'2024-06-19 22:56:58',5.00,0.00);
/*!40000 ALTER TABLE `Confirmaciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Confirmaciones_Productos`
--

DROP TABLE IF EXISTS `Confirmaciones_Productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Confirmaciones_Productos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `confirmacion_id` int NOT NULL,
  `producto_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `confirmacion_id` (`confirmacion_id`),
  KEY `producto_id` (`producto_id`),
  CONSTRAINT `confirmaciones_productos_ibfk_1` FOREIGN KEY (`confirmacion_id`) REFERENCES `Confirmaciones` (`id`),
  CONSTRAINT `confirmaciones_productos_ibfk_2` FOREIGN KEY (`producto_id`) REFERENCES `Productos` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Confirmaciones_Productos`
--

LOCK TABLES `Confirmaciones_Productos` WRITE;
/*!40000 ALTER TABLE `Confirmaciones_Productos` DISABLE KEYS */;
INSERT INTO `Confirmaciones_Productos` (`id`, `confirmacion_id`, `producto_id`) VALUES (1,1,2),(2,1,7),(3,1,3),(4,2,3),(5,2,5);
/*!40000 ALTER TABLE `Confirmaciones_Productos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Confirmaciones_Servicios`
--

DROP TABLE IF EXISTS `Confirmaciones_Servicios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Confirmaciones_Servicios` (
  `id` int NOT NULL AUTO_INCREMENT,
  `confirmacion_id` int NOT NULL,
  `servicio_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `confirmacion_id` (`confirmacion_id`),
  KEY `servicio_id` (`servicio_id`),
  CONSTRAINT `confirmaciones_servicios_ibfk_1` FOREIGN KEY (`confirmacion_id`) REFERENCES `Confirmaciones` (`id`),
  CONSTRAINT `confirmaciones_servicios_ibfk_2` FOREIGN KEY (`servicio_id`) REFERENCES `Servicios` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Confirmaciones_Servicios`
--

LOCK TABLES `Confirmaciones_Servicios` WRITE;
/*!40000 ALTER TABLE `Confirmaciones_Servicios` DISABLE KEYS */;
INSERT INTO `Confirmaciones_Servicios` (`id`, `confirmacion_id`, `servicio_id`) VALUES (1,1,1),(2,1,5),(3,2,6),(4,2,8);
/*!40000 ALTER TABLE `Confirmaciones_Servicios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Eventos`
--

DROP TABLE IF EXISTS `Eventos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Eventos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `fecha` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Eventos`
--

LOCK TABLES `Eventos` WRITE;
/*!40000 ALTER TABLE `Eventos` DISABLE KEYS */;
INSERT INTO `Eventos` (`id`, `nombre`, `fecha`) VALUES (1,'Evento 1','2021-12-01 10:00:00'),(2,'Evento 2','2021-12-02 10:00:00'),(3,'Evento 3','2021-12-03 10:00:00'),(4,'Evento 4','2023-12-01 12:00:00');
/*!40000 ALTER TABLE `Eventos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Productos`
--

DROP TABLE IF EXISTS `Productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Productos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text,
  `precio` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Productos`
--

LOCK TABLES `Productos` WRITE;
/*!40000 ALTER TABLE `Productos` DISABLE KEYS */;
INSERT INTO `Productos` (`id`, `nombre`, `descripcion`, `precio`) VALUES (1,'Disawett35','Es un coadyuvante adherente y humectante sintético a base de Nonilfenol',150.00),(2,'DISAWETT® MAX','Es un coadyuvante surfactante, humectante y penetrante no iónico a base de Organosilicona.',250.00),(3,'Disawett®90','Es un coadyuvante adherente y humectante sintético a base de Nonilfenol y ácido fosforico.',300.00),(4,'Disawett® pH','Es un coadyuvante regulador de pH del agua a base de ácido fosforico.',150.00),(5,'Disawett x','Es un coadyuvante regulador de pH del agua a base de ácido fosforico.',200.00),(6,'Disawett y','Es un coadyuvante regulador de pH del agua a base de ácido fosforico.',250.00),(7,'Disawett z','Es un coadyuvante regulador de pH del agua a base de ácido fosforico.',300.00);
/*!40000 ALTER TABLE `Productos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Servicios`
--

DROP TABLE IF EXISTS `Servicios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Servicios` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text,
  `precio` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Servicios`
--

LOCK TABLES `Servicios` WRITE;
/*!40000 ALTER TABLE `Servicios` DISABLE KEYS */;
INSERT INTO `Servicios` (`id`, `nombre`, `descripcion`, `precio`) VALUES (1,'Mantenimiento de maquinaria','Mantenimiento preventivo y correctivo de maquinaria',500.00),(2,'Instalación de maquinaria','Instalación de maquinaria en la empresa',1000.00),(3,'Capacitación de personal','Capacitación de personal en el uso de maquinaria',1500.00),(4,'Servicio de transporte','Servicio de transporte de maquinaria',2000.00),(5,'Análisis de residuos de plaguicidas','Análisis de residuos de plaguicidas en frutas y hortalizas',2500.00),(6,'Análisis de agua','Análisis de agua para riego',3000.00),(7,'Análisis de suelo','Análisis de suelo para cultivos',3500.00),(8,'Análisis de residuos de plaguicidas','Análisis de residuos de plaguicidas en frutas y hortalizas',4000.00),(9,'Análisis de cafeína','Análisis de cafeína en café',4500.00),(10,'Mano de obra','Mano de obra para la instalación de maquinaria',500.00),(11,'Servicio x','Servicio x',550.00),(12,'Servicio y','Servicio y',600.00),(13,'Servicio z','Servicio z',650.00),(14,'Servicio xyz','Servicio xyz',100.00),(15,'Servicio 123','Servicio 123',150.00);
/*!40000 ALTER TABLE `Servicios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Usuarios`
--

DROP TABLE IF EXISTS `Usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Usuarios` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre_usuario` varchar(255) NOT NULL,
  `correo_electronico` varchar(255) NOT NULL,
  `contrasena` varchar(255) NOT NULL,
  `fecha_registro` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `rol` enum('admin','usuario') NOT NULL DEFAULT 'usuario',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Usuarios`
--

LOCK TABLES `Usuarios` WRITE;
/*!40000 ALTER TABLE `Usuarios` DISABLE KEYS */;
INSERT INTO `Usuarios` (`id`, `nombre_usuario`, `correo_electronico`, `contrasena`, `fecha_registro`, `rol`) VALUES (8,'walterqf','walterqfolgar@hotmail.com','123456','2024-06-19 23:26:50','usuario'),(9,'usuario1','walter@hotmail.com','123456','2024-06-19 23:26:50','usuario'),(10,'usuario2','usuario2@hotmail.com','123456','2024-06-19 23:26:50','usuario');
/*!40000 ALTER TABLE `Usuarios` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-06-19 23:46:30
