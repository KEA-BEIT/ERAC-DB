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


-- Dumping structure for procedure erac-db.BudgetGen
DROP PROCEDURE IF EXISTS `BudgetGen`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `BudgetGen`(IN GetGenServiceID MEDIUMINT)
BEGIN
	declare GenPrice INT DEFAULT NULL;
	SET GenPrice = (SELECT GenServicePrice FROM generelservice WHERE GenServiceID = GetGenServiceID);
	SELECT 'Service price', GenPrice;
END//
DELIMITER ;


-- Dumping structure for procedure erac-db.BudgetSpec
DROP PROCEDURE IF EXISTS `BudgetSpec`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `budgetspec`(IN `GetSpecServiceID` MEDIUMINT, IN `GetModelID` MEDIUMINT)
BEGIN
	DROP TABLE IF EXISTS partid_tempt;
	CREATE temporary table partid_tempt (ID MEDIUMINT NOT NULL auto_increment, PartID MEDIUMINT, primary key(id)) engine = innodb;
	SET @SpecSerCheck = (SELECT SScbpoMID FROM specificservicescanbepreformedonmodel WHERE SpecServiceID = GetSpecServiceID AND ModelID = GetModelID);
	if @SpecSerCheck IS NOT NULL then
		SET @Part_name = (SELECT PartName FROM specificservice_amount WHERE SpecServiceID = GetSpecServiceID);
		INSERT INTO partid_tempt (PartID)
		SELECT PartID FROM part WHERE PartName = @Part_name;
		SET @v_counter = 1;
		SET @v_max = (SELECT COUNT(ID) FROM partid_tempt) + 1;
		start transaction;
		while @v_counter < @v_max do
			SET @PM_ID = (SELECT PcwMID FROM partcombatiablewithmodel WHERE ModelID = GetModelID AND PartID IN (SELECT PartID FROM partid_tempt WHERE ID = @v_counter));
			if @PM_ID IS NOT NULL then
				SET @v_counter = @v_max;
			end if;
			SET @v_counter = @v_counter + 1;
		end while;
		commit;
		if @PM_ID IS NOT NULL then
			SET @Part_price_n = (SELECT Part_ValuePrice FROM part_value WHERE PartID = @PM_ID AND ConditionID = 1);
			SET @Part_price_u = (SELECT Part_ValuePrice FROM part_value WHERE PartID = @PM_ID AND ConditionID = 2);
			SET @SS_price = (SELECT SpecService_ValuePrice FROM specificservice_value WHERE SpecServiceID = GetSpecServiceID limit 0,1);
			SET @SS_amount = (SELECT SpecService_Amount FROM specificservice_amount WHERE SpecServiceID = GetSpecServiceID);
			SELECT @Part_price_n;
			SELECT @Part_price_u;
			SELECT @SS_price;
			SELECT @SS_amount;
			SET @S_sum_n = @SS_price + @Part_price_n * @SS_amount;
			SET @S_sum_u = @SS_price + @Part_price_u * @SS_amount;
			SELECT 'Service price with new part:', @S_sum_n;
			SELECT 'Service price with used part:', @S_sum_u;
		end if;
	end if;
END//
DELIMITER ;


-- Dumping structure for procedure erac-db.CarCompatiablePart
DROP PROCEDURE IF EXISTS `CarCompatiablePart`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `CarCompatiablePart`(IN GetClientCarID MEDIUMINT)
BEGIN
	DROP TABLE IF EXISTS ccpid_tempt;
	CREATE temporary table ccpid_tempt (ID MEDIUMINT NOT NULL auto_increment, PartID MEDIUMINT, primary key(id)) engine = innodb;
	SET @clientcar_model = (SELECT ClientcarModel FROM clientcar WHERE ClientcarID = GetClientCarID);
	SET @clientcar_make = (SELECT ClientcarMake FROM clientcar WHERE ClientcarID = GetClientCarID);
	SET @clientcar_fuel = (SELECT ClientcarFuel FROM clientcar WHERE ClientcarID = GetClientCarID);

	SET @model_id = (SELECT ModelID FROM model WHERE ModelName = @clientcar_model AND ModelMake = @clientcar_make AND ModelFuel = @clientcar_fuel);

	INSERT INTO ccpid_tempt (PartID)
	SELECT PartID FROM partcombatiablewithmodel WHERE ModelID = @model_id;

	SELECT ccpid_tempt.PartID, part_amount.ConditionID, part_amount.Part_AmountQuantity
	FROM ccpid_tempt
	INNER JOIN part_amount ON ccpid_tempt.PartID = part_amount.PartID WHERE part_amount.Part_AmountQuantity > 0;
	
END//
DELIMITER ;


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
	declare last_id_in_ordergen INT;
	INSERT INTO orders (ClientID, ClientcarID) VALUES (GetClientID, GetClientcarID);
	SET last_id_in_ordergen = LAST_INSERT_ID();
	INSERT INTO orderrequiresgenerelservice (OrderID, GenserviceID) VALUES (last_id_in_ordergen, GetGenServiceID);
END//
DELIMITER ;


-- Dumping structure for procedure erac-db.NewOrderSpec
DROP PROCEDURE IF EXISTS `NewOrderSpec`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `NewOrderSpec`(IN GetClientID MEDIUMINT, IN GetClientcarID MEDIUMINT, IN GetSpecServiceID MEDIUMINT, IN GetOrSSQuantity INT)
BEGIN
	declare last_id_in_orderspec INT;
	INSERT INTO  orders (ClientID, ClientcarID) VALUES (GetClientID, GetClientcarID);
	SET last_id_in_orderspec = LAST_INSERT_ID();
	INSERT INTO orderrequriesspecificservice (OrderID, SpecServiceID, OrSSQuantity) VALUES (last_id_in_orderspec, GetSpecServiceID, GetOrSSQuantity);
END//
DELIMITER ;


-- Dumping structure for procedure erac-db.NewPart
DROP PROCEDURE IF EXISTS `NewPart`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `NewPart`(IN GetPartName Varchar(50), IN GetPartSN INT, IN GetPart_ConditionID MEDIUMINT, IN GetPart_AmountQuantity INT, IN GetPart_ValuePrice INT)
BEGIN
	declare last_id_in_part INT;
	declare part_id INT DEFAULT NULL;
	SET part_id = (SELECT PartID FROM part WHERE PartName = GetPartName AND PartSN = GetPartSN);
	if part_id IS NULL then
		INSERT INTO part(PartName, PartSN) VALUES (GetPartName, GetPartSN);
		SET last_id_in_part = LAST_INSERT_ID();
		INSERT INTO part_amount(PartID, ConditionID, Part_AmountQuantity) VALUES (last_id_in_part, GetPart_ConditionID, GetPart_AmountQuantity);
		INSERT INTO part_value(PartID, ConditionID, Part_ValuePrice) VALUES (last_id_in_part, GetPart_ConditionID, GetPart_ValuePrice);
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
  `PcwMID` mediumint(9) NOT NULL AUTO_INCREMENT,
  `PartID` mediumint(9) NOT NULL,
  `ModelID` mediumint(9) NOT NULL,
  PRIMARY KEY (`PcwMID`),
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
  `PufSSiOQuantity` int(11) NOT NULL,
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
  `SScbpoMID` mediumint(9) NOT NULL AUTO_INCREMENT,
  `SpecServiceID` mediumint(9) NOT NULL,
  `ModelID` mediumint(9) NOT NULL,
  PRIMARY KEY (`SScbpoMID`),
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
  KEY `SpecServiceID` (`SpecServiceID`),
  CONSTRAINT `FK_specificservice_amount_specificservice` FOREIGN KEY (`SpecServiceID`) REFERENCES `specificservice` (`SpecServiceID`)
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
  CONSTRAINT `FK_specificservice_value_model` FOREIGN KEY (`ModelID`) REFERENCES `model` (`ModelID`),
  CONSTRAINT `FK_specificservice_value_specificservice` FOREIGN KEY (`SpecServiceID`) REFERENCES `specificservice` (`SpecServiceID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Data exporting was unselected.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
