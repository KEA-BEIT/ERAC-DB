require "dbi"

puts "\nERAC database management"
status = true

while(status == true)
puts "\nPlease select one of the following options:"
puts "-- Type 'NewClient' to add a new client"
puts "-- Type 'NewPart' if you want to add a part to the database"
puts "-- Type 'NewModel' to add a new car model to the database"
puts "-- Type 'Oldcar' to add a new old car to the database with the lastowners information"
puts "-- Type 'Close' if you want to terminate the program"

choice = gets.chomp.downcase

case choice

when 'newclient' #Need to make some methods. This code is discusting

	puts "Name:"
	Client_name = gets.chomp.downcase
	puts "Address:"
	Client_address = gets.chomp.downcase
	puts "City:"
	Client_city = gets.chomp.downcase
	puts "State:"
	Client_state = gets.chomp.downcase
	puts "Zip code:"
	Client_zip_code = gets.chomp.to_i
	puts "Country:"
	Client_country = gets.chomp.downcase
	puts "Phone number:"
	Client_phone = gets.chomp.to_i
	puts "E-mail:"
	Client_email = gets.chomp.downcase

	begin
		dbh = DBI.connect("DBI:Mysql:erac-db:localhost", "root","")
		row = dbh.select_one("SELECT VERSION()")
		puts "Server version: "+ row[0]
	rescue DBI::DatabaseError => e
		puts "An error occurred"
		puts "Error code: #{e.err}"
		puts "Error message: #{e.errstr}"
	end

	dbh.do (
		"INSERT INTO client (ClientName, ClientAddress, ClientCity, ClientState, ClientZip_code, ClientCountry, ClientPhone, ClientEmail)
		VALUES ('#{Client_name}', '#{Client_address}', '#{Client_city}', '#{Client_state}', #{Client_zip_code}, '#{Client_country}', #{Client_phone}, '#{Client_email}')"
		)
	Clientcar_owner = dbh.func(:insert_id)

	puts "Cars model:"
	Clientcar_model = gets.chomp.downcase
	puts "Cars make:"
	Clientcar_make = gets.chomp.downcase
	puts "Cars fuelsource:"
	Clientcar_fuel = gets.chomp.downcase

	dbh.do (
	"INSERT INTO clientcar (ClientcarModel, ClientcarMake, ClientcarFuel)		
	VALUES ('#{Clientcar_model}', '#{Clientcar_make}', '#{Clientcar_fuel}')"
	)
	Clientcar_car = dbh.func(:insert_id)

	dbh.do (
		"INSERT INTO clienthasclientcar (ClientID, ClientcarID)
		VALUES (#{Clientcar_owner}, #{Clientcar_car})"
		)	


	dbh.disconnect
	puts "\nDisconnected from server" 

when 'newclientcar' #Add a new car to a client(done). This code is discusting

	puts "To which client does this car belong? (id)"
	Clientcar_owner = gets.chomp.to_i
	puts "Cars model:"
	Clientcar_model = gets.chomp.downcase
	puts "Cars make:"
	Clientcar_make = gets.chomp.downcase
	puts "Cars fuelsource:"
	Clientcar_fuel = gets.chomp.downcase

	begin
		dbh = DBI.connect("DBI:Mysql:erac-db:localhost", "root","")
		row = dbh.select_one("SELECT VERSION()")
		puts "Server version: "+ row[0]
	rescue DBI::DatabaseError => e
		puts "An error occurred"
		puts "Error code: #{e.err}"
		puts "Error message: #{e.errstr}"
	end

	dbh.do (
		"INSERT INTO clientcar (ClientcarModel, ClientcarMake, ClientcarFuel)
		VALUES ('#{Clientcar_model}', '#{Clientcar_make}', '#{Clientcar_fuel}')"
		)
	Clientcar_car = dbh.func(:insert_id)
	# Need failsafe here
	dbh.do (
		"INSERT INTO clienthasclientcar (ClientID, ClientcarID)
		VALUES (#{Clientcar_owner}, #{Clientcar_car})"
		)

	dbh.disconnect
	puts "\nDisconnected from server" 

when 'neworder' #Create a new order of anykind related to a specific client
	
	dbh.disconnect
	puts "\nDisconnected from server" 

when 'newgenservice' #Create a new generel service
	ArrGenservice_id = Array.new

	begin
		dbh = DBI.connect("DBI:Mysql:erac-db:localhost", "root","")
		row = dbh.select_one("SELECT VERSION()")
		puts "Server version: "+ row[0]
	rescue DBI::DatabaseError => e
		puts "An error occurred"
		puts "Error code: #{e.err}"
		puts "Error message: #{e.errstr}"
	end

	puts "Service name:"
	Genservice_name = gets.chomp.downcase
	puts "Type: (if none wirte null)"
	Genservice_type = gets.chomp.downcase
	puts "Service price:"
	Genservice_price = gets.chomp.to_i

	Gs_sth = dbh.execute("SELECT GenServiceID FROM generelservice WHERE GenServiceName = '#{Genservice_name}' AND GenServiceType = '#{Genservice_type}'")
	Gs_sth.fetch_array do |row|
		ArrGenservice_id = row
	end
	Gs_sth.finish

	if ArrGenservice_id[0] == nil
		dbh.do (
		"INSERT INTO generelservice (GenServiceName, GenServiceType, GenServicePrice)		
		VALUES ('#{Genservice_name}', '#{Genservice_type}' #{Genservice_price})"
		)
	else
		puts "A service of the same name and type already exsits under GenServiceID: #{ArrGenservice_id[0]}"
	end

	dbh.disconnect
	puts "\nDisconnected from server" 

when 'newspecservice' #Create a new model specific service


	dbh.disconnect
	puts "\nDisconnected from server" 

when 'budget' #Pull the estimated price of an order


	dbh.disconnect
	puts "\nDisconnected from server" 

when 'compatiable' #Pull all compatiable parts in stock
	ArrClientcarID = Array.new
	ArrClientcars = Array.new
	ArrClientcar = Array.new
	ArrModelID = Array.new

	puts "Client id:"
	Client_id = gets.chomp.to_i

	begin
		dbh = DBI.connect("DBI:Mysql:erac-db:localhost", "root","")
		row = dbh.select_one("SELECT VERSION()")
		puts "Server version: "+ row[0]
	rescue DBI::DatabaseError => e
		puts "An error occurred"
		puts "Error code: #{e.err}"
		puts "Error message: #{e.errstr}"
	end	
	
	x_sth = dbh.execute("SELECT ClientcarID FROM clienthasclientcar WHERE ClientID = #{Client_id}")
	x_sth.fetch_array do |row|
		ArrClientcarID += row
	end
	x_sth.finish

	ArrClientcarID.each do |f|
		y_sth = dbh.execute("SELECT * FROM clientcar WHERE ClientcarID = #{f}")
		y_sth.fetch_array do |row|
			ArrClientcars += row
		end
	end


	puts "\n\nWhich of your cars do you want to check agianst compatiable parts: (ID)"
	count = 0
	ArrClientcars.each do |g|
		print "#{g} "
		if count == 3
			print "\n"
			count = 0
		else
			count += 1
		end
	end

	Clientcar_id = gets.chomp.to_i #Need failsafe

	if ArrClientcars.index("#{Clientcar_id}") != nil
		z_sth = dbh.execute("SELECT ClientcarModel, ClientcarMake, ClientcarFuel FROM clientcar WHERE ClientcarID = #{Clientcar_id}")
		z_sth.fetch_array do |row|
			ArrClientcar += row
		end
		z_sth.finish
		Clientcar_model = ArrClientcar[0].to_s
		Clientcar_make = ArrClientcar[1].to_s
		Clientcar_fuel = ArrClientcar[2].to_s

		t_sth = dbh.execute("SELECT ModelID FROM model WHERE ModelName = '#{ClientcarModel}' AND ModelMake = '#{ClientcarMake}' AND ModelFuel = '#{ClientcarFuel}'")
		t_sth.fetch_array do |row|
			ArrModelID = row
		end






	dbh.disconnect
	puts "\nDisconnected from server" 

when 'newmodel' #Isn't part of the requriement but need som features to be functionel

	puts "Model:"
	Model_name = gets.chomp.downcase
	puts "Make:"
	Model_make = gets.chomp.downcase
	puts "Fuel:"
	Model_fuel = gets.chomp.downcase

	begin
		dbh = DBI.connect("DBI:Mysql:erac-db:localhost", "root","")
		version_check = dbh.select_one("SELECT VERSION()")
		puts "Server version: "+ version_check[0]
	rescue DBI::DatabaseError => e
		puts "An error occurred"
		puts "Error code: #{e.err}"
		puts "Error message: #{e.errstr}"
	end		

	dbh.do (
		"INSERT INTO model (ModelName, ModelMake, ModelFuel)
		VALUES ('#{Model_name}', '#{Model_make}', '#{Model_fuel}') "
		)
	dbh.disconnect
	puts "\nDisconnected from server" 

when 'newoldcar' #Finished

	puts "Lastowner name:"
	Oldcar_lo_name = gets.chomp.downcase
	puts "Lastowner address:"
	Oldcar_lo_address = gets.chomp.downcase
	puts "Lastowner phone number:"
	Oldcar_lo_phone = gets.chomp.to_i
	puts "Lastowner E-mail:"
	Oldcar_lo_email = gets.chomp.downcase

	begin
		dbh = DBI.connect("DBI:Mysql:erac-db:localhost", "root","")
		version_check = dbh.select_one("SELECT VERSION()")
		puts "Server version: "+ version_check[0]
	rescue DBI::DatabaseError => e
		puts "An error occurred"
		puts "Error code: #{e.err}"
		puts "Error message: #{e.errstr}"
	end	

	dbh.do (
		"INSERT INTO oldcar (OldcarLO_Name, OldcarLO_Address, OldcarLO_Phone, OldcarLO_Email)
		VALUES ('#{Oldcar_lo_name}', '#{Oldcar_lo_address}', #{Oldcar_lo_phone}, '#{Oldcar_lo_email}')"	
		)

	dbh.disconnect
	puts "\nDisconnected from server"

when 'newpart' #Missing: adding compatability with models
	C_cond_input = false
	C_quan_input = false
	P_value_input = false
	Arrpart_id = Array.new
	Arrcondition_id = Array.new
	Arrpart_amount_quan = Array.new
	Arrpart_value_price = Array.new

	puts "What is the parts name?"
	Part_name = gets.chomp.downcase

	puts "Is the part new(N) or used(U)?"
	while C_cond_input == false
	Condition_name = gets.chomp.downcase

		if Condition_name == "n"
			Arrcondition_id[0] = 1
			C_cond_input = true

		elsif Condition_name == "u"
			Arrcondition_id[0] = 2
			C_cond_input = true

		else
			puts "Either 'n' for new or 'u' for used!"
		end

	end

	puts "How many?"
	while C_quan_input == false
	Part_Amount_quantity = gets.chomp.to_i

		if Part_Amount_quantity < 0
			puts "\nPleae input a number which is not negative:"
		else
			C_quan_input = true
		end
	end

	begin
		dbh = DBI.connect("DBI:Mysql:erac-db:localhost", "root","")
		version_check = dbh.select_one("SELECT VERSION()")
		puts "Server version: "+ version_check[0]
	rescue DBI::DatabaseError => e
		puts "An error occurred"
		puts "Error code: #{e.err}"
		puts "Error message: #{e.errstr}"
	end	

	

	Pn_sth = dbh.execute("SELECT PartID FROM part WHERE PartName = '#{Part_name}'")
	Pn_sth.fetch_array do |row|
		Arrpart_id = row
	end

	Pn_sth.finish

	if Arrpart_id[0] == nil #Have to add compatability with model
		#PartID.New
		puts "null"
		dbh.do (
			"INSERT INTO part (PartName)
			VALUES ('#{Part_name}')"
			)
		id = dbh.func(:insert_id)
		puts "added new part at #{id}"

		dbh.do (
			"INSERT INTO part_amount (PartID, ConditionID, Part_AmountQuantity)
			VALUES (#{id}, #{Arrcondition_id[0]}, #{Part_Amount_quantity})"
			)
		puts "\n\nPartID: #{id} with condition: #{Arrcondition_id[0]} and amount of #{Part_Amount_quantity}"

		#Pricetag
		puts "\nSince this is a new part what is it basic pricetag? (DKK)"
		while P_value_input == false
			Part_Value_price = gets.chomp.to_i
			if Part_Value_price < 0
				puts "\nPleae input a number which is not negative:"
			else
				P_value_input = true
			end
		end
		dbh.do (
			"INSERT INTO part_value (PartID, ConditionID, Part_ValuePrice)
			VALUES (#{id}, #{Arrcondition_id[0]}, #{Part_Value_price})"
			)
		puts "\nPartID: #{id} with condition #{Arrcondition_id[0]} and the value of #{Part_Value_price}"

		#Compatiable with model - will return to that 

	else #Updating part amount
		puts "not null"

		Pa_sth = dbh.execute("SELECT Part_AmountQuantity FROM part_amount WHERE PartID = #{Arrpart_id[0]} AND ConditionID = #{Arrcondition_id[0]}")
		Pa_sth.fetch_array do |row|
			 Arrpart_amount_quan = row
		end

		Pa_sth.finish

		if Arrpart_amount_quan[0] == nil
			puts "need new row"
			dbh.do (
				"INSERT INTO part_amount (PartID, ConditionID, Part_AmountQuantity)
				VALUES (#{Arrpart_id[0]}, #{Arrcondition_id[0]}, #{Part_Amount_quantity})"
				)
			puts "\nPartID: #{Arrpart_id[0]} with condition #{Arrcondition_id[0]} and amount of #{Part_Amount_quantity}"

			Pv_sth = dbh.execute("SELECT Part_ValuePrice FROM part_value WHERE PartID = #{Arrpart_id[0]} AND ConditionID = #{Arrcondition_id[0]}")
			Pv_sth.fetch_array do |row|
				Arrpart_value_price = row
			end

			Pv_sth.finish

			if Arrpart_value_price[0] == nil
				puts "There is no pricetag for the part #{Arrpart_id[0]} with this condition #{Arrcondition_id[0]}. Please input the pricetag:"
				while P_value_input == false
					Part_Value_price = gets.chomp.to_i
					if Part_Value_price < 0
					puts "\nPleae input a number which is not negative:"
					else
					P_value_input = true
					end
				end
				dbh.do (
					"INSERT INTO part_value (PartID, ConditionID, Part_ValuePrice)
					VALUES (#{Arrpart_id[0]}, #{Arrcondition_id[0]}, #{Part_Value_price})"
					)
				puts "\nPartID: #{Arrpart_id[0]} with condition #{Arrcondition_id[0]} and the value of #{Part_Value_price}"

			else
				puts "\nThere already is price!"
			end

		else

			U_Part_amount = Arrpart_amount_quan[0].to_i + Part_Amount_quantity
			dbh.do ("UPDATE part_amount SET Part_AmountQuantity = #{U_Part_amount} WHERE PartID = #{Arrpart_id[0]} AND ConditionID = #{Arrcondition_id[0]}")
			puts "\nUpdated quantity at PartID: #{Arrpart_id[0]} and ConditionID: #{Arrcondition_id[0]} to #{U_Part_amount}"

		end

	end

	dbh.disconnect
	puts "\nDisconnected from server"

when 'close'
	
	status = false

end
end
	