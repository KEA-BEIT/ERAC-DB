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
  `ClientcarFuel` varchar(50) NOT NULL,
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
  CONSTRAINT `FK_clienthasclientcar_client` FOREIGN KEY (`ClientID`) REFERENCES `client` (`ClientID`),
  CONSTRAINT `FK_clienthasclientcar_clientcar` FOREIGN KEY (`ClientcarID`) REFERENCES `clientcar` (`ClientcarID`)
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
  `GenServiceType` varchar(50) DEFAULT NULL,
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


-- Dumping structure for procedure erac-db.NewOldcar
DROP PROCEDURE IF EXISTS `NewOldcar`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `NewOldcar`(IN GetOldcarLO_Name Varchar(50), IN GetOldcarLO_Address Varchar(50), IN GetOldcarLO_Phone INT, IN GetOldcarLO_Email Varchar(50))
BEGIN
	INSERT INTO oldcar (OldcarLO_Name, OldcarLO_Address, OldcarLO_Phone, OldcarLO_Email)
	VALUES (GetOldcarLO_Name, GetOldcarLO_Address, GetOldcarLO_Phone, GetOldcarLO_Email);
END//
DELIMITER ;


-- Dumping structure for procedure erac-db.NewOrderGen
DROP PROCEDURE IF EXISTS `NewOrderGen`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `NewOrderGen`(IN GetClientID MEDIUMINT, IN GetClientcarID MEDIUMINT, IN GetGenServiceID MEDIUMINT)
BEGIN
	INSERT INTO orders (ClientID, ClientcarID) VALUES (GetClientID, GetClientcarID);
	SET @last_id_in_ordersgen = LAST_INSERT_ID();
	INSERT INTO orderrequiresgenerelservice (OrderID, GenserviceID) VALUES (@last_id_in_ordergen, GetGenServiceID);
END//
DELIMITER ;


-- Dumping structure for procedure erac-db.NewOrderSpec
DROP PROCEDURE IF EXISTS `NewOrderSpec`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `NewOrderSpec`(IN GetClientID MEDIUMINT, IN GetClientcarID MEDIUMINT, IN GetSpecServiceID MEDIUMINT, IN GetOrSSQuantity INT)
BEGIN
	INSERT INTO  orders (ClientID, ClientcarID) VALUES (GetClientID, GetClientcarID);
	SET @last_id_in_orderspec = LAST_INSERT_ID();
	INSERT INTO orderrequriesspecificservice (OrderID, SpecServiceID, OrSSQuantity) VALUES (@last_id_in_orderspec, GetSpecServiceID, GetOrSSQuantity);
END//
DELIMITER ;


-- Dumping structure for procedure erac-db.NewPart
DROP PROCEDURE IF EXISTS `NewPart`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `NewPart`(IN GetPartName Varchar(50), IN GetPartSN INT, IN GetPart_ConditionID MEDIUMINT, IN GetPart_AmountQuantity INT, IN GetPart_ValuePrice INT)
BEGIN
	declare part_id INT DEFAULT NULL;
	SET part_id = (SELECT PartID FROM part WHERE PartName = GetPartName AND PartSN = GetPartSN);
	if part_id IS NULL then
		INSERT INTO part(PartName, PartSN) VALUES (GetPartName, GetPartSN);
		SET @last_id_in_part = LAST_INSERT_ID();
		INSERT INTO part_amount(PartID, ConditionID, Part_AmountQuantity) VALUES (@last_id_in_part, GetPart_ConditionID, GetPart_AmountQuantity);
		INSERT INTO part_value(PartID, ConditionID, Part_ValuePrice) VALUES (@last_id_in_part, GetPart_ConditionID, GetPart_ValuePrice);
	end if;
end//
DELIMITER ;


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


-- Dumping structure for table erac-db.orderrequiresgenerelservice
DROP TABLE IF EXISTS `orderrequiresgenerelservice`;
CREATE TABLE IF NOT EXISTS `orderrequiresgenerelservice` (
  `OrderID` mediumint(9) NOT NULL,
  `GenServiceID` mediumint(9) NOT NULL,
  KEY `OrderID` (`OrderID`),
  KEY `GenServiceID` (`GenServiceID`),
  CONSTRAINT `FK_orderrequiresgenerelservice_generelservice` FOREIGN KEY (`GenServiceID`) REFERENCES `generelservice` (`GenServiceID`),
  CONSTRAINT `FK_orderrequiresgenerelservice_order` FOREIGN KEY (`OrderID`) REFERENCES `orders` (`OrderID`)
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
  CONSTRAINT `FK_orderrequriesspecificservice_order` FOREIGN KEY (`OrderID`) REFERENCES `orders` (`OrderID`),
  CONSTRAINT `FK_orderrequriesspecificservice_specificservice` FOREIGN KEY (`SpecServiceID`) REFERENCES `specificservice` (`SpecServiceID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for table erac-db.orders
DROP TABLE IF EXISTS `orders`;
CREATE TABLE IF NOT EXISTS `orders` (
  `OrderID` mediumint(9) NOT NULL AUTO_INCREMENT,
  `ClientID` mediumint(9) NOT NULL,
  `ClientcarID` mediumint(9) NOT NULL,
  PRIMARY KEY (`OrderID`),
  KEY `ClientcarID` (`ClientcarID`),
  KEY `ClientID` (`ClientID`),
  CONSTRAINT `FK_order_client` FOREIGN KEY (`ClientID`) REFERENCES `client` (`ClientID`),
  CONSTRAINT `FK_order_clientcar` FOREIGN KEY (`ClientcarID`) REFERENCES `clientcar` (`ClientcarID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for table erac-db.part
DROP TABLE IF EXISTS `part`;
CREATE TABLE IF NOT EXISTS `part` (
  `PartID` mediumint(9) NOT NULL AUTO_INCREMENT,
  `PartName` varchar(50) NOT NULL,
  `PartSN` int(11) DEFAULT NULL,
  PRIMARY KEY (`PartID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for table erac-db.partcombatiablewithmodel
DROP TABLE IF EXISTS `partcombatiablewithmodel`;
CREATE TABLE IF NOT EXISTS `partcombatiablewithmodel` (
  `PartID` mediumint(9) NOT NULL,
  `ModelID` mediumint(9) NOT NULL,
  KEY `PartID` (`PartID`),
  KEY `ModelID` (`ModelID`),
  CONSTRAINT `FK_partcombatiablewithmodel_model` FOREIGN KEY (`ModelID`) REFERENCES `model` (`ModelID`),
  CONSTRAINT `FK_partcombatiablewithmodel_part` FOREIGN KEY (`PartID`) REFERENCES `part` (`PartID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for table erac-db.partusedforspecificserviceinorder
DROP TABLE IF EXISTS `partusedforspecificserviceinorder`;
CREATE TABLE IF NOT EXISTS `partusedforspecificserviceinorder` (
  `SpecServiceID` mediumint(9) NOT NULL,
  `OrderID` mediumint(9) NOT NULL,
  `PartID` mediumint(9) NOT NULL,
  `PufSSiOQuantity` int(11) DEFAULT NULL,
  KEY `SpecServiceID` (`SpecServiceID`),
  KEY `OrderID` (`OrderID`),
  KEY `PartID` (`PartID`),
  CONSTRAINT `FK_partusedformodelinorder_order` FOREIGN KEY (`OrderID`) REFERENCES `orders` (`OrderID`),
  CONSTRAINT `FK_partusedformodelinorder_part` FOREIGN KEY (`PartID`) REFERENCES `part` (`PartID`),
  CONSTRAINT `FK_partusedformodelinorder_specificservice` FOREIGN KEY (`SpecServiceID`) REFERENCES `specificservice` (`SpecServiceID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for table erac-db.part_amount
DROP TABLE IF EXISTS `part_amount`;
CREATE TABLE IF NOT EXISTS `part_amount` (
  `PartID` mediumint(9) NOT NULL,
  `ConditionID` mediumint(9) NOT NULL,
  `Part_AmountQuantity` int(11) DEFAULT NULL,
  KEY `PartID` (`PartID`),
  KEY `Part_ConditionID` (`ConditionID`),
  CONSTRAINT `FK_part_amount_condition` FOREIGN KEY (`ConditionID`) REFERENCES `condition` (`ConditionID`),
  CONSTRAINT `FK_part_amount_part` FOREIGN KEY (`PartID`) REFERENCES `part` (`PartID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for table erac-db.part_value
DROP TABLE IF EXISTS `part_value`;
CREATE TABLE IF NOT EXISTS `part_value` (
  `PartID` mediumint(9) NOT NULL,
  `ConditionID` mediumint(9) NOT NULL,
  `Part_ValuePrice` int(11) DEFAULT NULL,
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
  PRIMARY KEY (`SpecServiceID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for table erac-db.specificservicescanbepreformedonmodel
DROP TABLE IF EXISTS `specificservicescanbepreformedonmodel`;
CREATE TABLE IF NOT EXISTS `specificservicescanbepreformedonmodel` (
  `SpecServiceID` mediumint(9) NOT NULL,
  `ModelID` mediumint(9) NOT NULL,
  KEY `SpecServiceID` (`SpecServiceID`),
  KEY `ModelID` (`ModelID`),
  CONSTRAINT `FK_specificservicescanbepreformedonmodel_model` FOREIGN KEY (`ModelID`) REFERENCES `model` (`ModelID`),
  CONSTRAINT `FK_specificservicescanbepreformedonmodel_specificservice` FOREIGN KEY (`SpecServiceID`) REFERENCES `specificservice` (`SpecServiceID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for table erac-db.specificservice_amount
DROP TABLE IF EXISTS `specificservice_amount`;
CREATE TABLE IF NOT EXISTS `specificservice_amount` (
  `SpecServiceID` mediumint(9) NOT NULL,
  `PartName` varchar(50) NOT NULL,
  `SpecService_Amount` int(11) NOT NULL,
  KEY `SpecServiceID` (`SpecServiceID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.


-- Dumping structure for table erac-db.specificservice_value
DROP TABLE IF EXISTS `specificservice_value`;
CREATE TABLE IF NOT EXISTS `specificservice_value` (
  `SpecServiceID` mediumint(9) NOT NULL,
  `ModelID` mediumint(9) NOT NULL,
  `SpecService_ValuePrice` int(11) DEFAULT NULL,
  KEY `SpecServiceID` (`SpecServiceID`),
  KEY `ModelID` (`ModelID`),
  CONSTRAINT `FK_specificservice_value_specificservice` FOREIGN KEY (`SpecServiceID`) REFERENCES `specificservice` (`SpecServiceID`),
  CONSTRAINT `FK_specificservice_value_model` FOREIGN KEY (`ModelID`) REFERENCES `model` (`ModelID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
