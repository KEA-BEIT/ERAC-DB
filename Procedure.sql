DROP PROCEDURE IF EXISTS `NewOldcar`;
DELIMITER //
CREATE PROCEDURE NewOldcar(IN GetOldcarLO_Name Varchar(50), IN GetOldcarLO_Address Varchar(50), IN GetOldcarLO_Phone INT, IN GetOldcarLO_Email Varchar(50))
BEGIN
	INSERT INTO oldcar (OldcarLO_Name, OldcarLO_Address, OldcarLO_Phone, OldcarLO_Email)
	VALUES (GetOldcarLO_Name, GetOldcarLO_Address, GetOldcarLO_Phone, GetOldcarLO_Email);
END //
DELIMITER;

CALL NewOldcar("Mathias Tønning Faarbæk", "Banefløjen 14, 3th", 28704869, "mtf92@outlook.com")


DROP PROCEDURE IF EXISTS `NewPart`;
DELIMITER //
CREATE PROCEDURE NewPart (IN GetPartName Varchar(50), IN GetPartSN INT, IN GetPart_ConditionID MEDIUMINT, IN GetPart_AmountQuantity INT, IN GetPart_ValuePrice INT)
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
end //
DELIMITER;

CALL NewPart ("Brake", 111111, 1, 5, 923571)


DROP PROCEDURE IF EXISTS `NewOrderGen`;
DELIMITER //
CREATE PROCEDURE NewOrderGen (IN GetClientID MEDIUMINT, IN GetClientcarID MEDIUMINT, IN GetGenServiceID MEDIUMINT)
BEGIN
	declare last_id_in_ordergen INT;
	INSERT INTO orders (ClientID, ClientcarID) VALUES (GetClientID, GetClientcarID);
	SET last_id_in_ordergen = LAST_INSERT_ID();
	INSERT INTO orderrequiresgenerelservice (OrderID, GenserviceID) VALUES (last_id_in_ordergen, GetGenServiceID);
END //
DELIMITER;

CALL NewOrderGen (1,2,5)


DROP PROCEDURE IF EXISTS `NewOrderSpec`;
DELIMITER //
CREATE PROCEDURE NewOrderSpec (IN GetClientID MEDIUMINT, IN GetClientcarID MEDIUMINT, IN GetSpecServiceID MEDIUMINT, IN GetOrSSQuantity INT)
BEGIN
	declare last_id_in_orderspec INT;
	INSERT INTO  orders (ClientID, ClientcarID) VALUES (GetClientID, GetClientcarID);
	SET last_id_in_orderspec = LAST_INSERT_ID();
	INSERT INTO orderrequriesspecificservice (OrderID, SpecServiceID, OrSSQuantity) VALUES (last_id_in_orderspec, GetSpecServiceID, GetOrSSQuantity);
END //
DELIMITER;	

CALL NewOrderSpec (1,2,4,2)


DROP PROCEDURE IF EXISTS `BudgetGen`;
DELIMITER //
CREATE PROCEDURE BudgetGen (IN GetGenServiceID MEDIUMINT)
BEGIN
	declare GenPrice INT DEFAULT NULL;
	SET GenPrice = (SELECT GenServicePrice FROM generelservice WHERE GenServiceID = GetGenServiceID);
	SELECT 'Service price', GenPrice;
END //
DELIMITER;

CALL BudgetGen(1)


DROP PROCEDURE IF EXISTS `CarCompatiablePart`;
DELIMITER //
CREATE PROCEDURE CarCompatiablePart (IN GetClientCarID MEDIUMINT)
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
END //
DELIMITER;

CALL CarCompatiablePart (1)


#Doesn't work at the moment
DROP PROCEDURE IF EXISTS `BudgetSpec`;
DELIMITER //
CREATE PROCEDURE BudgetSpec (IN GetSpecServiceID MEDIUMINT, IN GetModelID MEDIUMINT)
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
		if @PM_ID IS NOT NULL then
			SET @Part_price_n = (SELECT Part_ValuePrice FROM part_value WHERE PartID = @id AND ConditionID = 1);
			SET @Part_price_u = (SELECT Part_ValuePrice FROM part_value WHERE PartID = @id AND ConditionID = 2);
			SET @SS_price = (SELECT SpecService_ValuePrice FROM specificservice_value WHERE SpecServiceID = GetSpecServiceID);
			SET @SS_amount = (SELECT SpecService_Amount FROM specificservice_amount WHERE SpecServiceID = GetSpecServiceID);
			SET @S_sum_n = @SS_price + @Part_price_n * @SS_amount;
			SET @S_sum_u = @SS_price + @Part_price_u * @SS_amount;
			SELECT 'Service price with new part:', @S_sum_n;
			SELECT 'Service price with used part:', @S_sum_u;
		end if;
	end if;
END //
DELIMITER;