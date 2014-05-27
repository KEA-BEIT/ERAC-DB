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

when 'newclient'

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

when 'newmodel'

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

when 'newoldcar'

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

when 'newpart'
	C_cond_input = false
	C_quan_input = false
	Arrpart_id = Array.new
	Arrcondition_id = Array.new

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
			puts "\nPleae input a number which is not negative."
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

	

	sth = dbh.execute("SELECT PartID FROM part WHERE PartName = '#{Part_name}'")
	sth.fetch_array do |row|
		Arrpart_id = row[0]
	end

	sth.finish

	if Arrpart_id[0] == nil
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

	else
		puts "not null"
	end


	dbh.disconnect
	puts "\nDisconnected from server"

when 'close'
	
	status = false

end
end
	