-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               5.6.16 - MySQL Community Server (GPL)
-- Server OS:                    Win32
-- HeidiSQL Version:             8.3.0.4694
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping database structure for erac-db
DROP DATABASE IF EXISTS `erac-db`;
CREATE DATABASE IF NOT EXISTS `erac-db` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `erac-db`;


-- Dumping structure for table erac-db.client
DROP TABLE IF EXISTS `client`;
CREATE TABLE IF NOT EXISTS `client` (
  `ClientID` int(11) NOT NULL AUTO_INCREMENT,
  `ClientName` varchar(50) DEFAULT NULL,
  `ClientAddress` varchar(50) DEFAULT NULL,
  `ClientCity` varchar(50) DEFAULT NULL,
  `ClientState` varchar(50) DEFAULT NULL,
  `ClientZip_code` mediumint(9) DEFAULT NULL,
  `ClientCountry` varchar(50) DEFAULT NULL,
  `ClientPhone` int(11) DEFAULT NULL,
  `ClientEmail` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ClientID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for table erac-db.clienthasorder
DROP TABLE IF EXISTS `clienthasorder`;
CREATE TABLE IF NOT EXISTS `clienthasorder` (
  `ClientID` int(11) NOT NULL,
  `OrderID` mediumint(9) NOT NULL,
  `Timestamp` timestamp NULL DEFAULT NULL,
  KEY `FK_ClienthasOrder_client` (`ClientID`),
  KEY `FK_ClienthasOrder_order` (`OrderID`),
  CONSTRAINT `FK_ClienthasOrder_client` FOREIGN KEY (`ClientID`) REFERENCES `client` (`ClientID`),
  CONSTRAINT `FK_ClienthasOrder_order` FOREIGN KEY (`OrderID`) REFERENCES `order` (`OrderID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for table erac-db.component
DROP TABLE IF EXISTS `component`;
CREATE TABLE IF NOT EXISTS `component` (
  `ComponentID` mediumint(9) NOT NULL AUTO_INCREMENT,
  `ComponenetName` char(30) NOT NULL,
  `ComponentCondition` varchar(1) NOT NULL,
  `ComponentQuantity` int(11) DEFAULT NULL,
  `ComponentPrice` int(10) NOT NULL,
  PRIMARY KEY (`ComponentID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for table erac-db.componenthaspart
DROP TABLE IF EXISTS `componenthaspart`;
CREATE TABLE IF NOT EXISTS `componenthaspart` (
  `ComponentID` mediumint(9),
  `PartID` mediumint(9),
  `RequiredQuantity` int(2) NOT NULL,
  KEY `FK_ComponenthasPart_component` (`ComponentID`),
  KEY `FK_ComponenthasPart_part` (`PartID`),
  CONSTRAINT `FK_ComponenthasPart_component` FOREIGN KEY (`ComponentID`) REFERENCES `component` (`ComponentID`),
  CONSTRAINT `FK_ComponenthasPart_part` FOREIGN KEY (`PartID`) REFERENCES `part` (`PartID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for table erac-db.model
DROP TABLE IF EXISTS `model`;
CREATE TABLE IF NOT EXISTS `model` (
  `ModelID` mediumint(9) NOT NULL AUTO_INCREMENT,
  `Modelname` varchar(30) NOT NULL,
  `Make` varchar(60) NOT NULL,
  `Fuel` varchar(60) NOT NULL,
  PRIMARY KEY (`ModelID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for table erac-db.modelcompatiblewithcomponent
DROP TABLE IF EXISTS `modelcompatiblewithcomponent`;
CREATE TABLE IF NOT EXISTS `modelcompatiblewithcomponent` (
  `ComponentID` mediumint(9) NOT NULL,
  `ModelID` mediumint(9) NOT NULL,
  KEY `FK_ModelcompatiblewithComponent_component` (`ComponentID`),
  KEY `FK_ModelcompatiblewithComponent_model` (`ModelID`),
  CONSTRAINT `FK_modelcompatiblewithcomponent_model` FOREIGN KEY (`ModelID`) REFERENCES `model` (`ModelID`),
  CONSTRAINT `FK_ModelcompatiblewithComponent_component` FOREIGN KEY (`ComponentID`) REFERENCES `component` (`ComponentID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for table erac-db.modelcompatiblewithpart
DROP TABLE IF EXISTS `modelcompatiblewithpart`;
CREATE TABLE IF NOT EXISTS `modelcompatiblewithpart` (
  `ModelID` mediumint(9) NOT NULL,
  `PartID` mediumint(9) NOT NULL,
  KEY `FK__model` (`ModelID`),
  KEY `FK__part` (`PartID`),
  CONSTRAINT `FK_modelcompatiblewithpart_part` FOREIGN KEY (`PartID`) REFERENCES `part` (`PartID`),
  CONSTRAINT `FK_modelcompatiblewithpart_model` FOREIGN KEY (`ModelID`) REFERENCES `model` (`ModelID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for procedure erac-db.NewClient
DROP PROCEDURE IF EXISTS `NewClient`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `NewClient`(IN Getname Varchar(50), IN Getadresse Varchar(50), IN Getcity Varchar(50), IN Getstate Varchar(50), IN GetZIP_code INT, IN Getcountry Varchar(50), IN Getphone_num INT, IN Getemail Varchar(50))
BEGIN
	INSERT INTO client (name, adresse, city, state, ZIP_code, country, phone_num, email)
	VALUES (Getname, Getadresse, Getcity, Getstate, GetZIP_code, Getcountry, Getphone_num, Getemail);
END//
DELIMITER ;


-- Dumping structure for table erac-db.oldcar
DROP TABLE IF EXISTS `oldcar`;
CREATE TABLE IF NOT EXISTS `oldcar` (
  `oldcarid` mediumint(9) NOT NULL AUTO_INCREMENT,
  `LOname` varchar(30) NOT NULL,
  `PartID` mediumint(9) NOT NULL,
  `LOaddress` varchar(60) NOT NULL,
  `LOcontact` varchar(60) NOT NULL,
  PRIMARY KEY (`oldcarid`),
  KEY `FK_oldcar_part` (`PartID`),
  CONSTRAINT `FK_oldcar_part` FOREIGN KEY (`PartID`) REFERENCES `part` (`PartID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for table erac-db.oldcargivescomponent
DROP TABLE IF EXISTS `oldcargivescomponent`;
CREATE TABLE IF NOT EXISTS `oldcargivescomponent` (
  `OldcarID` mediumint(9) DEFAULT NULL,
  `ComponentID` mediumint(9) DEFAULT NULL,
  `OCgCQuantity` int(1) DEFAULT NULL,
  KEY `FK_OldcargivesComponent_oldcar` (`OldcarID`),
  KEY `FK_OldcargivesComponent_component` (`ComponentID`),
  CONSTRAINT `FK_OldcargivesComponent_oldcar` FOREIGN KEY (`OldcarID`) REFERENCES `oldcar` (`oldcarid`),
  CONSTRAINT `FK_OldcargivesComponent_component` FOREIGN KEY (`ComponentID`) REFERENCES `component` (`ComponentID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for table erac-db.oldcargivespart
DROP TABLE IF EXISTS `oldcargivespart`;
CREATE TABLE IF NOT EXISTS `oldcargivespart` (
  `OldcarID` mediumint(9) DEFAULT NULL,
  `PartID` mediumint(9) DEFAULT NULL,
  `OCgPQuantity` int(4) DEFAULT NULL,
  KEY `FK_OldcargivesPart_oldcar` (`OldcarID`),
  KEY `FK_OldcargivesPart_part` (`PartID`),
  CONSTRAINT `FK_OldcargivesPart_oldcar` FOREIGN KEY (`OldcarID`) REFERENCES `oldcar` (`oldcarid`),
  CONSTRAINT `FK_OldcargivesPart_part` FOREIGN KEY (`PartID`) REFERENCES `part` (`PartID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for table erac-db.order
DROP TABLE IF EXISTS `order`;
CREATE TABLE IF NOT EXISTS `order` (
  `OrderID` mediumint(9) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`OrderID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for table erac-db.orderrequiresservice
DROP TABLE IF EXISTS `orderrequiresservice`;
CREATE TABLE IF NOT EXISTS `orderrequiresservice` (
  `OrderID` mediumint(9) NOT NULL,
  `ServiceID` mediumint(9) NOT NULL,
  `OrSQuantity` int(11) NOT NULL,
  KEY `FK_OrderrequiresService_order` (`OrderID`),
  KEY `FK_OrderrequiresService_service` (`ServiceID`),
  CONSTRAINT `FK_OrderrequiresService_order` FOREIGN KEY (`OrderID`) REFERENCES `order` (`OrderID`),
  CONSTRAINT `FK_OrderrequiresService_service` FOREIGN KEY (`ServiceID`) REFERENCES `service` (`ServiceID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for table erac-db.part
DROP TABLE IF EXISTS `part`;
CREATE TABLE IF NOT EXISTS `part` (
  `PartID` mediumint(9) NOT NULL AUTO_INCREMENT,
  `Partname` char(30) NOT NULL,
  `PartCondition` varchar(1) NOT NULL,
  `PartQuantity` int(11) DEFAULT NULL,
  `PartPrice` int(11) DEFAULT NULL,
  PRIMARY KEY (`PartID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for table erac-db.service
DROP TABLE IF EXISTS `service`;
CREATE TABLE IF NOT EXISTS `service` (
  `ServiceID` mediumint(9) NOT NULL AUTO_INCREMENT,
  `ServiceName` varchar(60) NOT NULL,
  `ServicePrice` int(60) NOT NULL,
  `Estimatedtime` int(60) NOT NULL,
  `All` int(1) DEFAULT NULL,
  PRIMARY KEY (`ServiceID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for table erac-db.servicecanbeperformedonmodel
DROP TABLE IF EXISTS `servicecanbeperformedonmodel`;
CREATE TABLE IF NOT EXISTS `servicecanbeperformedonmodel` (
  `ServiceID` mediumint(9) NOT NULL,
  `ModelID` mediumint(9) NOT NULL,
  KEY `FK_ServicecanbeperformedonModel_service` (`ServiceID`),
  KEY `FK_ServicecanbeperformedonModel_model` (`ModelID`),
  CONSTRAINT `FK_servicecanbeperformedonmodel_model` FOREIGN KEY (`ModelID`) REFERENCES `model` (`ModelID`),
  CONSTRAINT `FK_ServicecanbeperformedonModel_service` FOREIGN KEY (`ServiceID`) REFERENCES `service` (`ServiceID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for table erac-db.servicepartorder
DROP TABLE IF EXISTS `servicepartorder`;
CREATE TABLE IF NOT EXISTS `servicepartorder` (
  `ServiceID` mediumint(9) NOT NULL,
  `PartID` mediumint(9) NOT NULL,
  `OrderID` mediumint(9) NOT NULL,
  KEY `FK_ServicePartOrder_service` (`ServiceID`),
  KEY `FK_ServicePartOrder_part` (`PartID`),
  KEY `FK_ServicePartOrder_order` (`OrderID`),
  CONSTRAINT `FK_ServicePartOrder_service` FOREIGN KEY (`ServiceID`) REFERENCES `service` (`ServiceID`),
  CONSTRAINT `FK_ServicePartOrder_part` FOREIGN KEY (`PartID`) REFERENCES `part` (`PartID`),
  CONSTRAINT `FK_ServicePartOrder_order` FOREIGN KEY (`OrderID`) REFERENCES `order` (`OrderID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
