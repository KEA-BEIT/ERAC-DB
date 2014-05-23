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
  `ClientName` varchar(50) NOT NULL,
  `ClientAddress` varchar(50) NOT NULL,
  `ClientContact` varchar(50) NOT NULL,
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


-- Dumping structure for table erac-db.model
DROP TABLE IF EXISTS `model`;
CREATE TABLE IF NOT EXISTS `model` (
  `ModelID` int(9) NOT NULL AUTO_INCREMENT,
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
  `ModelID` int(11) NOT NULL,
  KEY `FK_ModelcompatiblewithComponent_component` (`ComponentID`),
  KEY `FK_ModelcompatiblewithComponent_model` (`ModelID`),
  CONSTRAINT `FK_ModelcompatiblewithComponent_component` FOREIGN KEY (`ComponentID`) REFERENCES `component` (`ComponentID`),
  CONSTRAINT `FK_ModelcompatiblewithComponent_model` FOREIGN KEY (`ModelID`) REFERENCES `model` (`ModelID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for table erac-db.modelcompatiblewithpart
DROP TABLE IF EXISTS `modelcompatiblewithpart`;
CREATE TABLE IF NOT EXISTS `modelcompatiblewithpart` (
  `ModelID` int(11) NOT NULL,
  `PartID` mediumint(9) NOT NULL,
  KEY `FK__model` (`ModelID`),
  KEY `FK__part` (`PartID`),
  CONSTRAINT `FK__model` FOREIGN KEY (`ModelID`) REFERENCES `model` (`ModelID`),
  CONSTRAINT `FK__part` FOREIGN KEY (`PartID`) REFERENCES `part` (`PartID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


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


-- Dumping structure for table erac-db.order
DROP TABLE IF EXISTS `order`;
CREATE TABLE IF NOT EXISTS `order` (
  `OrderID` mediumint(9) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`OrderID`)
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
  `ModelID` int(11) NOT NULL,
  KEY `FK_ServicecanbeperformedonModel_service` (`ServiceID`),
  KEY `FK_ServicecanbeperformedonModel_model` (`ModelID`),
  CONSTRAINT `FK_ServicecanbeperformedonModel_service` FOREIGN KEY (`ServiceID`) REFERENCES `service` (`ServiceID`),
  CONSTRAINT `FK_ServicecanbeperformedonModel_model` FOREIGN KEY (`ModelID`) REFERENCES `model` (`ModelID`)
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
