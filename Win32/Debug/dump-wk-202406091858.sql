-- MySQL dump 10.13  Distrib 5.7.29, for Win32 (AMD64)
--
-- Host: localhost    Database: wk
-- ------------------------------------------------------
-- Server version	5.7.29-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cliente`
--

DROP TABLE IF EXISTS `cliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cliente` (
  `codigo` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `cidade` varchar(100) NOT NULL,
  `UF` char(2) NOT NULL,
  PRIMARY KEY (`codigo`),
  KEY `codigo` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cliente`
--

LOCK TABLES `cliente` WRITE;
/*!40000 ALTER TABLE `cliente` DISABLE KEYS */;
INSERT INTO `cliente` VALUES (1,'Ana Silva','São Paulo','SP'),(2,'Bruno Santos','Rio de Janeiro','RJ'),(3,'Carlos Pereira','Belo Horizonte','MG'),(4,'Daniela Oliveira','Porto Alegre','RS'),(5,'Eduardo Costa','Curitiba','PR'),(6,'Fernanda Souza','Florianópolis','SC'),(7,'Gabriel Lima','Salvador','BA'),(8,'Helena Rocha','Recife','PE'),(9,'Igor Almeida','Fortaleza','CE'),(10,'Juliana Martins','Goiânia','GO'),(11,'Kleber Fonseca','Brasília','DF'),(12,'Larissa Mendes','São Luís','MA'),(13,'Marcos Ribeiro','Belém','PA'),(14,'Natália Araújo','Manaus','AM'),(15,'Otávio Melo','Boa Vista','RR'),(16,'Patrícia Nunes','Rio Branco','AC'),(17,'Quintino Moreira','Porto Velho','RO'),(18,'Rafael Costa','Macapá','AP'),(19,'Sabrina Lima','Palmas','TO'),(20,'Thiago Santos','Cuiabá','MT'),(21,'Ursula Farias','Campo Grande','MS'),(22,'Vinícius Oliveira','Vitória','ES'),(23,'Wellington Silva','Aracaju','SE'),(24,'Xênia Albuquerque','Maceió','AL'),(25,'Yuri Matos','João Pessoa','PB'),(26,'Zuleica Farias','Natal','RN'),(27,'Alex Teixeira','Teresina','PI'),(28,'Bárbara Costa','Sobral','CE'),(29,'Célia Ferreira','Feira de Santana','BA'),(30,'Diego Moreira','Niterói','RJ');
/*!40000 ALTER TABLE `cliente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedido`
--

DROP TABLE IF EXISTS `pedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pedido` (
  `numero_pedido` int(11) NOT NULL AUTO_INCREMENT,
  `data_emissao` date NOT NULL,
  `cod_cliente` int(11) DEFAULT NULL,
  `Valor_Total` decimal(10,2) NOT NULL,
  PRIMARY KEY (`numero_pedido`),
  KEY `cod_cliente` (`cod_cliente`),
  KEY `idx_numero_pedido` (`numero_pedido`),
  CONSTRAINT `pedido_ibfk_1` FOREIGN KEY (`cod_cliente`) REFERENCES `cliente` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedido`
--

LOCK TABLES `pedido` WRITE;
/*!40000 ALTER TABLE `pedido` DISABLE KEYS */;
INSERT INTO `pedido` VALUES (1,'2024-06-09',9,299.80),(4,'2024-06-09',6,29.90),(8,'2024-06-09',5,10485.50),(9,'2024-06-09',23,569.10);
/*!40000 ALTER TABLE `pedido` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedido_item`
--

DROP TABLE IF EXISTS `pedido_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pedido_item` (
  `autoIncrem` int(11) NOT NULL AUTO_INCREMENT,
  `numero_pedido` int(11) NOT NULL,
  `codigo_produto` int(11) NOT NULL,
  `quantidade` int(11) NOT NULL,
  `vl_unitario` decimal(10,2) NOT NULL,
  `vl_total` decimal(10,2) NOT NULL,
  PRIMARY KEY (`autoIncrem`),
  KEY `codigo_produto` (`codigo_produto`),
  KEY `idx_numero_pedido` (`numero_pedido`),
  CONSTRAINT `pedido_item_ibfk_1` FOREIGN KEY (`numero_pedido`) REFERENCES `pedido` (`numero_pedido`) ON DELETE CASCADE,
  CONSTRAINT `pedido_item_ibfk_2` FOREIGN KEY (`codigo_produto`) REFERENCES `produto` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedido_item`
--

LOCK TABLES `pedido_item` WRITE;
/*!40000 ALTER TABLE `pedido_item` DISABLE KEYS */;
INSERT INTO `pedido_item` VALUES (23,8,5,26,99.90,2597.40),(24,8,6,65,79.90,5193.50),(25,8,25,54,49.90,2694.60),(26,9,2,2,89.90,179.80),(27,9,1,1,29.90,29.90),(28,9,15,6,59.90,359.40);
/*!40000 ALTER TABLE `pedido_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `produto`
--

DROP TABLE IF EXISTS `produto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `produto` (
  `codigo` int(11) NOT NULL AUTO_INCREMENT,
  `descricao` varchar(255) NOT NULL,
  `preco_venda` decimal(10,2) NOT NULL,
  PRIMARY KEY (`codigo`),
  KEY `codigo` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produto`
--

LOCK TABLES `produto` WRITE;
/*!40000 ALTER TABLE `produto` DISABLE KEYS */;
INSERT INTO `produto` VALUES (1,'Camiseta Básica',29.90),(2,'Calça Jeans',89.90),(3,'Tênis Esportivo',149.90),(4,'Jaqueta de Couro',199.90),(5,'Relógio Digital',99.90),(6,'Óculos de Sol',79.90),(7,'Boné Estiloso',39.90),(8,'Mochila Escolar',89.90),(9,'Carteira de Couro',49.90),(10,'Cinto de Couro',59.90),(11,'Blusa de Frio',89.90),(12,'Meia Social',19.90),(13,'Gravata de Seda',49.90),(14,'Chinelo de Borracha',29.90),(15,'Sandália de Couro',59.90),(16,'Calça de Moletom',69.90),(17,'Camiseta Polo',79.90),(18,'Vestido Casual',99.90),(19,'Saia Jeans',59.90),(20,'Bermuda de Tactel',49.90),(21,'Camisa Social',89.90),(22,'Suéter de Lã',99.90),(23,'Blusa de Tricô',79.90),(24,'Cachecol de Lã',39.90),(25,'Luvas de Couro',49.90),(26,'Gorro de Lã',29.90),(27,'Casaco de Lã',199.90),(28,'Jaqueta Jeans',149.90),(29,'Sapato Social',199.90),(30,'Bota de Couro',299.90);
/*!40000 ALTER TABLE `produto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'wk'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-06-09 18:58:32
