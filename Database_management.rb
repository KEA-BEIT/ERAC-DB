require "dbi"
=begin
def connect(db_name)
	begin
		dbh = DBI.connect("DBI:Mysql:#{db_name}:localhost", "root","")
	rescue DBI::DatabaseError => e
		puts "An error occurred"
		puts "Error code: #{e.err}"
		puts "Error message: #{e.errstr}"
	ensure
		dbh.disconnect if dbh
	end	
end
=end

puts "\nERAC database management"
status = true

while(status == true)
puts "\nPlease select one of the following options:"
puts "-- Type 'NewClient' to add a new client"
puts "-- Type 'NewPart' if you want to add a part to the database"
puts "-- Type 'Connect' to connect to the database"
puts "-- Type 'Close' if you want to terminate the program"

choice = gets.chomp.downcase

case choice

when 'newclient'
begin
	dbh = DBI.connect("DBI:Mysql:erac-db:localhost", "root","")
	row = dbh.select_one("SELECT VERSION()")
	puts "Server version: "+ row[0]
rescue DBI::DatabaseError => e
	puts "An error occurred"
	puts "Error code: #{e.err}"
	puts "Error message: #{e.errstr}"
end

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
	puts "Phone:"
	Client_phone = gets.chomp.to_i
	puts "E-mail:"
	Client_email = gets.chomp.downcase

	rows = dbh.do(
		"INSERT INTO client (ClientName, ClientAddress, ClientCity, ClientState, ClientZip_code, ClientCountry, ClientPhone, ClientEmail)
		VALUES ('#{Client_name}', '#{Client_address}', '#{Client_city}', '#{Client_state}', #{Client_zip_code}, '#{Client_country}', #{Client_phone}, '#{Client_email}')"
		)

	dbh.disconnect
	puts "\nDisconnected form server"



when 'newpart'

puts "What is the parts name?"
part = gets.chomp.downcase
puts "Is the part new(N) or used(U)? "
condition = gets.chomp.downcase
puts "How many?"
quantity = gets.chomp.to_i

if quantity <1
	puts "\nPlease input an amount that is higher then 0."
	break
elsif quantity >1		
	puts "\n#{quantity.to_s} #{part}s has been added to the database"
else
	puts "\n#{quantity.to_s} #{part} has been added to the database"
end

when 'connect'
begin
	dbh = DBI.connect("DBI:Mysql:erac-db:localhost", "root","")
	row = dbh.select_one("SELECT VERSION()")
	puts "Server version: "+ row[0]	
end


when 'close'
	
	status = false
end
end
	