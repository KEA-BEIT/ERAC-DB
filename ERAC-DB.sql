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
  `ClientID` mediumint(9) NOT NULL AUTO_INCREMENT,
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


-- Dumping structure for table erac-db.clientcar
DROP TABLE IF EXISTS `clientcar`;
CREATE TABLE IF NOT EXISTS `clientcar` (
  `ClientcarID` mediumint(9) NOT NULL AUTO_INCREMENT,
  `ClientcarModel` varchar(50) NOT NULL,
  `ClientcarMake` varchar(50) NOT NULL,
  PRIMARY KEY (`ClientcarID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for table erac-db.clienthasclientcar
DROP TABLE IF EXISTS `clienthasclientcar`;
CREATE TABLE IF NOT EXISTS `clienthasclientcar` (
  `ClientID` mediumint(9) NOT NULL,
  `ClientcarID` mediumint(9) NOT NULL,
  KEY `ClientID` (`ClientID`),
  KEY `ClientcarID` (`ClientcarID`),
  CONSTRAINT `FK_clienthasclientcar_clientcar` FOREIGN KEY (`ClientcarID`) REFERENCES `clientcar` (`ClientcarID`),
  CONSTRAINT `FK_clienthasclientcar_client` FOREIGN KEY (`ClientID`) REFERENCES `client` (`ClientID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for table erac-db.clienthasorderforclientcar
DROP TABLE IF EXISTS `clienthasorderforclientcar`;
CREATE TABLE IF NOT EXISTS `clienthasorderforclientcar` (
  `ClientID` mediumint(9) NOT NULL,
  `OrderID` mediumint(9) NOT NULL,
  `ClientcarID` mediumint(9) NOT NULL,
  `Timestamp` timestamp NULL DEFAULT NULL,
  KEY `ClientID` (`ClientID`),
  KEY `OrderID` (`OrderID`),
  KEY `ClientcarID` (`ClientcarID`),
  CONSTRAINT `FK_clienthasorderforclientcar_client` FOREIGN KEY (`ClientID`) REFERENCES `client` (`ClientID`),
  CONSTRAINT `FK_clienthasorderforclientcar_order` FOREIGN KEY (`OrderID`) REFERENCES `order` (`OrderID`),
  CONSTRAINT `FK_clienthasorderforclientcar_clientcar` FOREIGN KEY (`ClientcarID`) REFERENCES `clientcar` (`ClientcarID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for table erac-db.component
DROP TABLE IF EXISTS `component`;
CREATE TABLE IF NOT EXISTS `component` (
  `ComponentID` mediumint(9) NOT NULL AUTO_INCREMENT,
  `ComponenetName` varchar(50) NOT NULL,
  PRIMARY KEY (`ComponentID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for table erac-db.componentneededformodelinspecificservice
DROP TABLE IF EXISTS `componentneededformodelinspecificservice`;
CREATE TABLE IF NOT EXISTS `componentneededformodelinspecificservice` (
  `ComponentID` mediumint(9) NOT NULL,
  `ModelID` mediumint(9) NOT NULL,
  `SpecServiceID` mediumint(9) NOT NULL,
  `CnfMiSSQuantity` int(11) NOT NULL,
  KEY `ModelID` (`ModelID`),
  KEY `ComponentID` (`ComponentID`),
  KEY `SpecServiceID` (`SpecServiceID`),
  CONSTRAINT `FK_componentneededformodelinspecificservice_component` FOREIGN KEY (`ComponentID`) REFERENCES `component` (`ComponentID`),
  CONSTRAINT `FK_componentneededformodelinspecificservice_specificservice` FOREIGN KEY (`SpecServiceID`) REFERENCES `specificservice` (`SpecServiceID`),
  CONSTRAINT `FK_componentneededformodelinspecificservice_model` FOREIGN KEY (`ModelID`) REFERENCES `model` (`ModelID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for table erac-db.componentusedformodelinorder
DROP TABLE IF EXISTS `componentusedformodelinorder`;
CREATE TABLE IF NOT EXISTS `componentusedformodelinorder` (
  `SpecSerivceID` mediumint(9) NOT NULL,
  `OrderID` mediumint(9) NOT NULL,
  `ComponetID` mediumint(9) NOT NULL,
  `ModelID` mediumint(9) NOT NULL,
  `CufMiO` int(11) DEFAULT NULL,
  KEY `SpecSerivceID` (`SpecSerivceID`),
  KEY `OrderID` (`OrderID`),
  KEY `ComponetID` (`ComponetID`),
  KEY `ModelID` (`ModelID`),
  CONSTRAINT `FK_componentusedformodelinorder_component` FOREIGN KEY (`ComponetID`) REFERENCES `component` (`ComponentID`),
  CONSTRAINT `FK_componentusedformodelinorder_model` FOREIGN KEY (`ModelID`) REFERENCES `model` (`ModelID`),
  CONSTRAINT `FK_componentusedformodelinorder_order` FOREIGN KEY (`OrderID`) REFERENCES `order` (`OrderID`),
  CONSTRAINT `FK_componentusedformodelinorder_specificservice` FOREIGN KEY (`SpecSerivceID`) REFERENCES `specificservice` (`SpecServiceID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for table erac-db.condition
DROP TABLE IF EXISTS `condition`;
CREATE TABLE IF NOT EXISTS `condition` (
  `ConditionID` mediumint(9) NOT NULL AUTO_INCREMENT,
  `ConditionName` char(1) NOT NULL,
  PRIMARY KEY (`ConditionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for table erac-db.generelservice
DROP TABLE IF EXISTS `generelservice`;
CREATE TABLE IF NOT EXISTS `generelservice` (
  `GenServiceID` mediumint(9) NOT NULL AUTO_INCREMENT,
  `GenServiceName` varchar(50) NOT NULL,
  `GenServicePrice` int(11) DEFAULT NULL,
  PRIMARY KEY (`GenServiceID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for table erac-db.model
DROP TABLE IF EXISTS `model`;
CREATE TABLE IF NOT EXISTS `model` (
  `ModelID` mediumint(9) NOT NULL AUTO_INCREMENT,
  `ModelName` varchar(50) NOT NULL,
  `ModelMake` varchar(50) NOT NULL,
  `ModelFuel` varchar(50) NOT NULL,
  PRIMARY KEY (`ModelID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for table erac-db.oldcar
DROP TABLE IF EXISTS `oldcar`;
CREATE TABLE IF NOT EXISTS `oldcar` (
  `OldcarID` mediumint(9) NOT NULL AUTO_INCREMENT,
  `OldcarLO_Name` varchar(50) NOT NULL,
  `OldcarLO_Address` varchar(50) NOT NULL,
  `OldcarLO_Phone` int(11) NOT NULL,
  `OldcarLO_Email` varchar(50) NOT NULL,
  PRIMARY KEY (`OldcarID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for table erac-db.oldcargivescomponent
DROP TABLE IF EXISTS `oldcargivescomponent`;
CREATE TABLE IF NOT EXISTS `oldcargivescomponent` (
  `OldcarID` mediumint(9) NOT NULL,
  `ComponentID` mediumint(9) NOT NULL,
  `OcgCQuantity` int(2) DEFAULT NULL,
  KEY `OldcarID` (`OldcarID`),
  KEY `ComponentID` (`ComponentID`),
  CONSTRAINT `FK_oldcargivescomponent_oldcar` FOREIGN KEY (`OldcarID`) REFERENCES `oldcar` (`OldcarID`),
  CONSTRAINT `FK_oldcargivescomponent_component` FOREIGN KEY (`ComponentID`) REFERENCES `component` (`ComponentID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for table erac-db.oldcargivespart
DROP TABLE IF EXISTS `oldcargivespart`;
CREATE TABLE IF NOT EXISTS `oldcargivespart` (
  `OldcarID` mediumint(9) NOT NULL,
  `PartID` mediumint(9) NOT NULL,
  `OcgPQuantity` int(4) DEFAULT NULL,
  KEY `OldcarID` (`OldcarID`),
  KEY `PartID` (`PartID`),
  CONSTRAINT `FK_oldcargivespart_oldcar` FOREIGN KEY (`OldcarID`) REFERENCES `oldcar` (`OldcarID`),
  CONSTRAINT `FK_oldcargivespart_part` FOREIGN KEY (`PartID`) REFERENCES `part` (`PartID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for table erac-db.order
DROP TABLE IF EXISTS `order`;
CREATE TABLE IF NOT EXISTS `order` (
  `OrderID` mediumint(9) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`OrderID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for table erac-db.orderrequiresgenerelservice
DROP TABLE IF EXISTS `orderrequiresgenerelservice`;
CREATE TABLE IF NOT EXISTS `orderrequiresgenerelservice` (
  `OrderID` mediumint(9) NOT NULL,
  `GenServiceID` mediumint(9) NOT NULL,
  `OrGSQuantity` int(11) DEFAULT NULL,
  KEY `OrderID` (`OrderID`),
  KEY `GenServiceID` (`GenServiceID`),
  CONSTRAINT `FK_orderrequiresgenerelservice_generelservice` FOREIGN KEY (`GenServiceID`) REFERENCES `generelservice` (`GenServiceID`),
  CONSTRAINT `FK_orderrequiresgenerelservice_order` FOREIGN KEY (`OrderID`) REFERENCES `order` (`OrderID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for table erac-db.orderrequriesspecificservice
DROP TABLE IF EXISTS `orderrequriesspecificservice`;
CREATE TABLE IF NOT EXISTS `orderrequriesspecificservice` (
  `OrderID` mediumint(9) NOT NULL,
  `SpecServiceID` mediumint(9) NOT NULL,
  `OrSSQuantity` int(11) DEFAULT NULL,
  KEY `SpecServiceID` (`SpecServiceID`),
  KEY `OrderID` (`OrderID`),
  CONSTRAINT `FK_orderrequriesspecificservice_order` FOREIGN KEY (`OrderID`) REFERENCES `order` (`OrderID`),
  CONSTRAINT `FK_orderrequriesspecificservice_specificservice` FOREIGN KEY (`SpecServiceID`) REFERENCES `specificservice` (`SpecServiceID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for table erac-db.part
DROP TABLE IF EXISTS `part`;
CREATE TABLE IF NOT EXISTS `part` (
  `PartID` mediumint(9) NOT NULL AUTO_INCREMENT,
  `PartName` varchar(50) NOT NULL,
  PRIMARY KEY (`PartID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for table erac-db.partneededformodelinspecificservice
DROP TABLE IF EXISTS `partneededformodelinspecificservice`;
CREATE TABLE IF NOT EXISTS `partneededformodelinspecificservice` (
  `PartID` mediumint(9) NOT NULL,
  `ModelID` mediumint(9) NOT NULL,
  `SpecService` mediumint(9) NOT NULL,
  `PnfMiSSQuantity` int(11) NOT NULL,
  KEY `PartID` (`PartID`),
  KEY `ModelID` (`ModelID`),
  KEY `SpecService` (`SpecService`),
  CONSTRAINT `FK_partneededformodelinspecificservice_part` FOREIGN KEY (`PartID`) REFERENCES `part` (`PartID`),
  CONSTRAINT `FK_partneededformodelinspecificservice_model` FOREIGN KEY (`ModelID`) REFERENCES `model` (`ModelID`),
  CONSTRAINT `FK_partneededformodelinspecificservice_specificservice` FOREIGN KEY (`SpecService`) REFERENCES `specificservice` (`SpecServiceID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for table erac-db.partusedformodelinorder
DROP TABLE IF EXISTS `partusedformodelinorder`;
CREATE TABLE IF NOT EXISTS `partusedformodelinorder` (
  `SpecServiceID` mediumint(9) NOT NULL,
  `OrderID` mediumint(9) NOT NULL,
  `PartID` mediumint(9) NOT NULL,
  `ModelID` mediumint(9) NOT NULL,
  `PufMiOQuantity` int(11) DEFAULT NULL,
  KEY `SpecServiceID` (`SpecServiceID`),
  KEY `OrderID` (`OrderID`),
  KEY `ModelID` (`ModelID`),
  KEY `PartID` (`PartID`),
  CONSTRAINT `FK_partusedformodelinorder_order` FOREIGN KEY (`OrderID`) REFERENCES `order` (`OrderID`),
  CONSTRAINT `FK_partusedformodelinorder_part` FOREIGN KEY (`PartID`) REFERENCES `part` (`PartID`),
  CONSTRAINT `FK_partusedformodelinorder_model` FOREIGN KEY (`ModelID`) REFERENCES `model` (`ModelID`),
  CONSTRAINT `FK_partusedformodelinorder_specificservice` FOREIGN KEY (`SpecServiceID`) REFERENCES `specificservice` (`SpecServiceID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for table erac-db.partusedinorder
DROP TABLE IF EXISTS `partusedinorder`;
CREATE TABLE IF NOT EXISTS `partusedinorder` (
  `GenServiceID` mediumint(9) NOT NULL,
  `PartID` mediumint(9) NOT NULL,
  `OrderID` mediumint(9) NOT NULL,
  `PuiOQuantity` int(11) DEFAULT NULL,
  KEY `ServiceID` (`GenServiceID`),
  KEY `PartID` (`PartID`),
  KEY `OrderID` (`OrderID`),
  CONSTRAINT `FK_partusedinorder_generelservice` FOREIGN KEY (`GenServiceID`) REFERENCES `generelservice` (`GenServiceID`),
  CONSTRAINT `FK_partusedinorder_part` FOREIGN KEY (`PartID`) REFERENCES `part` (`PartID`),
  CONSTRAINT `FK_partusedinorder_order` FOREIGN KEY (`OrderID`) REFERENCES `order` (`OrderID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for table erac-db.part_amount
DROP TABLE IF EXISTS `part_amount`;
CREATE TABLE IF NOT EXISTS `part_amount` (
  `Part_AmountID` mediumint(9) NOT NULL AUTO_INCREMENT,
  `PartID` mediumint(9) NOT NULL,
  `ConditionID` mediumint(9) NOT NULL,
  `Part_AmountQuantity` int(11) DEFAULT NULL,
  PRIMARY KEY (`Part_AmountID`),
  KEY `PartID` (`PartID`),
  KEY `Part_ConditionID` (`ConditionID`),
  CONSTRAINT `FK_part_amount_condition` FOREIGN KEY (`ConditionID`) REFERENCES `condition` (`ConditionID`),
  CONSTRAINT `FK_part_amount_part` FOREIGN KEY (`PartID`) REFERENCES `part` (`PartID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for table erac-db.part_value
DROP TABLE IF EXISTS `part_value`;
CREATE TABLE IF NOT EXISTS `part_value` (
  `Part_ValueD` mediumint(9) NOT NULL AUTO_INCREMENT,
  `PartID` mediumint(9) NOT NULL,
  `ConditionID` mediumint(9) NOT NULL,
  `Part_ValuePrice` int(11) DEFAULT NULL,
  PRIMARY KEY (`Part_ValueD`),
  KEY `PartID` (`PartID`),
  KEY `Part_ConditionID` (`ConditionID`),
  CONSTRAINT `FK_part_price_part` FOREIGN KEY (`PartID`) REFERENCES `part` (`PartID`),
  CONSTRAINT `FK_part_value_condition` FOREIGN KEY (`ConditionID`) REFERENCES `condition` (`ConditionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for table erac-db.specificservice
DROP TABLE IF EXISTS `specificservice`;
CREATE TABLE IF NOT EXISTS `specificservice` (
  `SpecServiceID` mediumint(9) NOT NULL AUTO_INCREMENT,
  `SpecServiceName` varchar(50) NOT NULL,
  `SpecServicePrice` int(11) DEFAULT NULL,
  PRIMARY KEY (`SpecServiceID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
