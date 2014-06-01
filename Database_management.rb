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

when 'newclient' #Need client car otherwice finished

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

	rows = dbh.do(
		"INSERT INTO client (ClientName, ClientAddress, ClientCity, ClientState, ClientZip_code, ClientCountry, ClientPhone, ClientEmail)
		VALUES ('#{Client_name}', '#{Client_address}', '#{Client_city}', '#{Client_state}', #{Client_zip_code}, '#{Client_country}', #{Client_phone}, '#{Client_email}')"
		)

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

	rows = dbh.do(
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

	rows = dbh.do(
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

		Pa_sth = dbh.execute("SELECT Part_AmountQuantity FROM part_amount WHERE PartID = #{Arrpart_id[0]} and ConditionID = #{Arrcondition_id[0]}")
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

			Pv_sth = dbh.execute("SELECT Part_ValuePrice FROM part_value WHERE PartID = #{Arrpart_id[0]} and ConditionID = #{Arrcondition_id[0]}")
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
			dbh.do ("UPDATE part_amount SET Part_AmountQuantity = #{U_Part_amount} WHERE PartID = #{Arrpart_id[0]} and ConditionID = #{Arrcondition_id[0]}")
			puts "\nUpdated quantity at PartID: #{Arrpart_id[0]} and ConditionID: #{Arrcondition_id[0]} to #{U_Part_amount}"

		end

	end

	dbh.disconnect
	puts "\nDisconnected from server"

when 'close'
	
	status = false

end
end
	