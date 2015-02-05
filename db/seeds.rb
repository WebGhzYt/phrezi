# if Rails.env.production?
#   puts '[ERROR] Cannot run in production env'
#   exit 1
# end

puts 'SEEDING..'

#cleanup all the tables
puts 'CLEANUP.. all except oauth'
(ActiveRecord::Base.connection.tables - ['schema_migrations', 'opro_client_apps']).each do |table|
  ActiveRecord::Base.connection.execute("DELETE FROM #{table};")
end

puts 'USERS..'
ActiveRecord::Base.connection.execute("TRUNCATE users")
ActiveRecord::Base.connection.reset_pk_sequence!('users')
@user1 = User.create_with(name: 'Ryan',
                          last_name: 'Spears',
                          password: 'password',
                          password_confirmation: 'password',
                          confirmed_at: DateTime.now,
                          establishment_access: true).find_or_create_by(email: 'ryan@phrenzi.com')
@user2 = User.create_with(name: 'Matt',
                          last_name: 'McGuire',
                          password: 'password',
                          password_confirmation: 'password',
                          confirmed_at: DateTime.now,
                          establishment_access: true).find_or_create_by(email: 'matt@phrenzi.com')
@user3 = User.create_with(name: 'David',
                          last_name: 'Strohm',
                          password: 'password',
                          password_confirmation: 'password',
                          confirmed_at: DateTime.now,
                          establishment_access: true).find_or_create_by(email: 'david@phrenzi.com')
@user4 = User.create_with(name: 'Rohit',
                          last_name: 'Jain',
                          password: 'password',
                          password_confirmation: 'password',
                          confirmed_at: DateTime.now,
                          establishment_access: true).find_or_create_by(email: 'engrohitjain5@gmail.com')
#@user4 = FactoryGirl.create(:user, name: 'Admin User', email: 'admin@mailinator.com', password: 'dismantle', password_confirmation: 'dismantle')
#@user5 = User.create_with(name: 'Fat Joe',
#                          password: 'password',
#                          password_confirmation: 'password',
#                          confirmed_at: DateTime.now).find_or_create_by(email: 'joe@mailinator.com')

# employees = 10.times.map { FactoryGirl.create(:employee) }
# challenges = employees.map {|e| FactoryGirl.create(:challenge, establishment: e.establishment) }
# patrons = 10.times.map { FactoryGirl.create(:user) }
# 5.times.map { FactoryGirl.create(:enrolled_challenge, patron: patrons.sample, challenge: challenges.sample) }

# employees.each do |e|
#   [@user1, @user2].each do |u|
#     FactoryGirl.create(:employee, role: 'administrator', user: u, establishment: e.establishment)
#   end
# end

=begin
puts 'ADDRESS & ESTABLISHMENTS..'
@add1 = FactoryGirl.create(:address, street1: '1/F, Beach Commercial Complex', street2: 'Park Island', city: 'Hong Kong', country: 'Hong Kong')
@est1 = FactoryGirl.create(:establishment, name: "Cafe Roma", address: @add1, phone: "1231231234", gps_lat: 22.3500339, gps_long: 114.0614559, point_dollar: 1)
@add2 = FactoryGirl.create(:address, street1: 'G/F & Basement, 21 D\'Aguilar Street', street2: 'Lan Kwai Fong', city: 'Hong Kong', country: 'Hong Kong')
@est2 = FactoryGirl.create(:establishment, name: "Hong Kong Brewhouse", address: @add2, phone: "1231231234", gps_lat: 22.2810955, gps_long: 114.1556762, point_dollar: 1)
@add3 = FactoryGirl.create(:address, street1: 'Lot No. K4, Pier 4, New Reclamation', street2: 'Central', city: 'Hong Kong', country: 'Hong Kong')
@est3 = FactoryGirl.create(:establishment, name: "Beer Bay", address: @add3, phone: "1231231234", gps_lat: 22.2879732, gps_long: 114.157123, point_dollar: 1)
@add4 = FactoryGirl.create(:address, street1: 'LG/F 83-85 Hollywood Road', street2: 'Central', city: 'Hong Kong', country: 'Hong Kong')
@est4 = FactoryGirl.create(:establishment, name: "Voume Heat", address: @add4, phone: "1231231234", gps_lat: 22.2835824, gps_long: 114.1525765, point_dollar: 1)
@add5 = FactoryGirl.create(:address, street1: '52 D\'Aguilar Street', street2: 'Lan Kwai Fong', city: 'Hong Kong', country: 'Hong Kong')
@est5 = FactoryGirl.create(:establishment, name: "The Keg", address: @add5, phone: "1231231234", gps_lat: 22.2806322, gps_long: 114.155311, point_dollar: 1)
@add6 = FactoryGirl.create(:address, street1: '1/F The Luxe Manor', street2: '39 Kimberley Road', city: 'Kowloon', country: 'Hong Kong')
@est6 = FactoryGirl.create(:establishment, name: "FINDS", address: @add5, phone: "1231231234", gps_lat: 22.300953, gps_long: 114.17388, point_dollar: 1)
@add7 = FactoryGirl.create(:address, street1: 'G/F and 1/F, 55 Wyndham Street', street2: 'Central', city: 'Hong Kong', country: 'Hong Kong')
@est7 = FactoryGirl.create(:establishment, name: "6 Degrees", address: @add5, phone: "1231231234", gps_lat: 22.280903, gps_long: 114.154949, point_dollar: 1)
@add8 = FactoryGirl.create(:address, street1: 'Shop R005, Civic Square, Elements', street2: 'Kowloon Station', city: 'Kowloon', country: 'Hong Kong')
@est8 = FactoryGirl.create(:establishment, name: "Stormies", address: @add5, phone: "1231231234", gps_lat: 22.304919, gps_long: 114.161552, point_dollar: 1)
@add9 = FactoryGirl.create(:address, street1: '43 Wyndham Street', street2: 'Central', city: 'Hong Kong', country: 'Hong Kong')
@est9 = FactoryGirl.create(:establishment, name: "Tonic", address: @add5, phone: "1231231234", gps_lat: 22.280903, gps_long: 114.154949, point_dollar: 1)
@add10 = FactoryGirl.create(:address, street1: 'Shop M, Roof Viewing Deck, Central Pier 7', street2: 'Central Piers', city: 'Hong Kong', country: 'Hong Kong')
@est10 = FactoryGirl.create(:establishment, name: "Pier 7 Cafe", address: @add5, phone: "1231231234", gps_lat: 22.2862664, gps_long: 114.158865, point_dollar: 1)
@add11 = FactoryGirl.create(:address, street1: '90 Stanley Main Street', street2: 'Stanley', city: 'Hong Kong', country: 'Hong Kong')
@est11 = FactoryGirl.create(:establishment, name: "Pickled Pelican", address: @add5, phone: "1231231234", gps_lat: 22.2187116, gps_long: 114.2114324, point_dollar: 1)
@add12 = FactoryGirl.create(:address, street1: '38 Wong Nai Chung Road', street2: 'Happy Valley', city: 'Hong Kong', country: 'Hong Kong')
@est12 = FactoryGirl.create(:establishment, name: "Happy Valley Bar and Grill", address: @add5, phone: "1231231234", gps_lat: 22.2696487, gps_long: 114.1833198, point_dollar: 1)
@add13 = FactoryGirl.create(:address, street1: '2nd floor,88 Caroline Hill Rd', street2: 'Causeway Bay', city: 'Hong Kong', country: 'Hong Kong')
@est13 = FactoryGirl.create(:establishment, name: "Inn Side Out", address: @add5, phone: "1231231234", gps_lat: 22.275296, gps_long: 114.186892, point_dollar: 1)
@add14 = FactoryGirl.create(:address, street1: '33-35 Chatham Road South', street2: 'Tsim Sha Chui', city: 'Kowloon', country: 'Hong Kong')
@est14 = FactoryGirl.create(:establishment, name: "Tequila Jack's", address: @add5, phone: "1231231234", gps_lat: 22.298171, gps_long: 114.175316, point_dollar: 1)
@add15 = FactoryGirl.create(:address, street1: 'Shop 14 1/F, Causeway Center, 28 Harbour Road', street2: 'Wan Chai', city: 'Hong Kong', country: 'Hong Kong')
@est15 = FactoryGirl.create(:establishment, name: "The Hop House Pub & Grub", address: @add5, phone: "1231231234", gps_lat: 22.280489, gps_long: 114.176297, point_dollar: 1)
@add16 = FactoryGirl.create(:address, street1: '90A Stanley Main Street', street2: 'Stanley', city: 'Hong Kong', country: 'Hong Kong')
@est16 = FactoryGirl.create(:establishment, name: "Vern's Beach Bar", address: @add5, phone: "1231231234", gps_lat: 22.2187575, gps_long: 114.2113149, point_dollar: 1)
@add17 = FactoryGirl.create(:address, street1: '46 Cochrane Street', street2: 'Central', city: 'Hong Kong', country: 'Hong Kong')
@est17 = FactoryGirl.create(:establishment, name: "Cochrane's", address: @add5, phone: "1231231234", gps_lat: 22.2822468, gps_long: 114.1540074, point_dollar: 1)
@add18 = FactoryGirl.create(:address, street1: '114-120 Lockhart Road', street2: 'Wan Chai', city: 'Hong Kong', country: 'Hong Kong')
@est18 = FactoryGirl.create(:establishment, name: "Coyote Bar & Grill", address: @add5, phone: "1231231234", gps_lat: 22.2779126, gps_long: 114.1725651, point_dollar: 1)
@add19 = FactoryGirl.create(:address, street1: '21 D\'Aguilar Street', street2: 'Lan Kwai Fong', city: 'Hong Kong', country: 'Hong Kong')
@est19 = FactoryGirl.create(:establishment, name: "Havana Bar", address: @add5, phone: "1231231234", gps_lat: 22.28121, gps_long: 114.155473, point_dollar: 1)
@add20 = FactoryGirl.create(:address, street1: '26-30 Elgin Street', street2: 'Soho', city: 'Hong Kong', country: 'Hong Kong')
@est20 = FactoryGirl.create(:establishment, name: "i Caramba", address: @add5, phone: "1231231234", gps_lat: 22.2818315, gps_long: 114.1525616, point_dollar: 1)
@add21 = FactoryGirl.create(:address, street1: '55 Elgin Street', street2: 'Soho', city: 'Hong Kong', country: 'Hong Kong')
@est21 = FactoryGirl.create(:establishment, name: "McSorley's Ale House 1", address: @add5, phone: "1231231234", gps_lat: 22.2811137, gps_long: 114.1526759, point_dollar: 1)
@add22 = FactoryGirl.create(:address, street1: 'Block B, Discovery Bay Plaza', street2: 'Discovery Bay', city: 'New Territories', country: 'Hong Kong')
@est22 = FactoryGirl.create(:establishment, name: "McSorley's Ale House 2", address: @add5, phone: "1231231234", gps_lat: 22.2956333, gps_long: 114.01704, point_dollar: 1)
@est23 = FactoryGirl.create(:establishment, name: "Liberty Exchange", address: @add5, phone: "1231231234", gps_lat: 22.2822479, gps_long: 114.1585018, point_dollar: 1)
@add23 = FactoryGirl.create(:address, street1: '2 Exchange Square, 8 Connaught Road', street2: 'Central', city: 'Hong Kong', country: 'Hong Kong')
@est24 = FactoryGirl.create(:establishment, name: "Deck n Beer", address: @add5, phone: "1231231234", gps_lat: 22.2957722, gps_long: 114.176765, point_dollar: 1)
@add24 = FactoryGirl.create(:address, street1: 'G/F East Promenade, Salisbury Road', street2: 'Tsim Sha Chui', city: 'Kowloon', country: 'Hong Kong')
@est25 = FactoryGirl.create(:establishment, name: "Simply Life", address: @add5, phone: "1231231234", gps_lat: 22.2792565, gps_long: 114.16422, point_dollar: 1)
@add25 = FactoryGirl.create(:address, street1: 'B05-06, 1F Queensway Plaza', street2: 'Admiralty', city: 'Hong Kong', country: 'Hong Kong')
@est26 = FactoryGirl.create(:establishment, name: "Carnegie's Bar & Grill", address: @add5, phone: "1231231234", gps_lat: 22.278421, gps_long: 114.170814, point_dollar: 1)
@add26 = FactoryGirl.create(:address, street1: 'GF, 53-55 Lockhart Road', street2: 'Wan Chai', city: 'Hong Kong', country: 'Hong Kong')
@est27 = FactoryGirl.create(:establishment, name: "Delaney's Pokfulam", address: @add5, phone: "1231231234", gps_lat: 22.2612427, gps_long: 114.1303162, point_dollar: 1)
@add27 = FactoryGirl.create(:address, street1: 'The Spire at the Arcade', street2: 'Cyberport', city: 'Hong Kong', country: 'Hong Kong')
@est28 = FactoryGirl.create(:establishment, name: "Delaney's Wan Chai", address: @add5, phone: "1231231234", gps_lat: 22.278461, gps_long: 114.1719559, point_dollar: 1)
@add28 = FactoryGirl.create(:address, street1: 'One Capital Place - 18 Luard Road', street2: 'Wan Chai', city: 'Hong Kong', country: 'Hong Kong')
@est29 = FactoryGirl.create(:establishment, name: "Staunton's", address: @add5, phone: "1231231234", gps_lat: 22.281779, gps_long: 114.152843, point_dollar: 1)
@add29 = FactoryGirl.create(:address, street1: 'GF, 10 – 12 Staunton Street', street2: 'Soho', city: 'Hong Kong', country: 'Hong Kong')
@est30 = FactoryGirl.create(:establishment, name: "Peak Bar", address: @add5, phone: "1231231234", gps_lat: 22.281779, gps_long: 114.152843, point_dollar: 1)
@add30 = FactoryGirl.create(:address, street1: '9-13 Shelley Street', street2: 'Soho', city: 'Hong Kong', country: 'Hong Kong')

puts 'EMPLOYEE ROLES..'
FactoryGirl.create(:employee, role: 'owner', user: @user2, establishment: @est1, enabled: true)
FactoryGirl.create(:employee, role: 'owner', user: @user2, establishment: @est2, enabled: true)
FactoryGirl.create(:employee, role: 'owner', user: @user2, establishment: @est3, enabled: true)
FactoryGirl.create(:employee, role: 'owner', user: @user2, establishment: @est4, enabled: true)
FactoryGirl.create(:employee, role: 'owner', user: @user2, establishment: @est5, enabled: true)
FactoryGirl.create(:employee, role: 'owner', user: @user2, establishment: @est6, enabled: true)
FactoryGirl.create(:employee, role: 'owner', user: @user2, establishment: @est7, enabled: true)
FactoryGirl.create(:employee, role: 'owner', user: @user2, establishment: @est8, enabled: true)
FactoryGirl.create(:employee, role: 'owner', user: @user2, establishment: @est9, enabled: true)
FactoryGirl.create(:employee, role: 'owner', user: @user2, establishment: @est10, enabled: true)
FactoryGirl.create(:employee, role: 'owner', user: @user2, establishment: @est11, enabled: true)
FactoryGirl.create(:employee, role: 'owner', user: @user2, establishment: @est12, enabled: true)
FactoryGirl.create(:employee, role: 'owner', user: @user2, establishment: @est13, enabled: true)
FactoryGirl.create(:employee, role: 'owner', user: @user2, establishment: @est14, enabled: true)
FactoryGirl.create(:employee, role: 'owner', user: @user2, establishment: @est15, enabled: true)
FactoryGirl.create(:employee, role: 'owner', user: @user2, establishment: @est16, enabled: true)
FactoryGirl.create(:employee, role: 'owner', user: @user2, establishment: @est17, enabled: true)
FactoryGirl.create(:employee, role: 'owner', user: @user2, establishment: @est18, enabled: true)
FactoryGirl.create(:employee, role: 'owner', user: @user2, establishment: @est19, enabled: true)
FactoryGirl.create(:employee, role: 'owner', user: @user2, establishment: @est20, enabled: true)
FactoryGirl.create(:employee, role: 'owner', user: @user2, establishment: @est21, enabled: true)
FactoryGirl.create(:employee, role: 'owner', user: @user2, establishment: @est22, enabled: true)
FactoryGirl.create(:employee, role: 'owner', user: @user2, establishment: @est23, enabled: true)
FactoryGirl.create(:employee, role: 'owner', user: @user2, establishment: @est24, enabled: true)
FactoryGirl.create(:employee, role: 'owner', user: @user2, establishment: @est25, enabled: true)
FactoryGirl.create(:employee, role: 'owner', user: @user2, establishment: @est26, enabled: true)
FactoryGirl.create(:employee, role: 'owner', user: @user2, establishment: @est27, enabled: true)
FactoryGirl.create(:employee, role: 'owner', user: @user2, establishment: @est28, enabled: true)
FactoryGirl.create(:employee, role: 'owner', user: @user2, establishment: @est29, enabled: true)
FactoryGirl.create(:employee, role: 'owner', user: @user2, establishment: @est30, enabled: true)

puts 'CHALLENGES..'
@challenge1 = FactoryGirl.create(:challenge, name: 'Challenge 1', start_date: Time.now - 5.day, end_date: Time.now + 1.day, payout: 30, finish_points: 200, establishment: @est1)
@challenge2 = FactoryGirl.create(:challenge, name: 'Challenge 1', start_date: Time.now - 6.day, end_date: Time.now, payout: 30, finish_points: 200, establishment: @est2)
@challenge3 = FactoryGirl.create(:challenge, name: 'Challenge 1', start_date: Time.now, end_date: Time.now + 6.day, payout: 30, finish_points: 200, establishment: @est3)
@challenge4 = FactoryGirl.create(:challenge, name: 'Challenge 1', start_date: Time.now, end_date: Time.now + 6.day, payout: 30, finish_points: 200, establishment: @est4)
@challenge5 = FactoryGirl.create(:challenge, name: 'Challenge 1', start_date: Time.now, end_date: Time.now + 6.day, payout: 30, finish_points: 200, establishment: @est5)
@challenge6 = FactoryGirl.create(:challenge, name: 'Challenge 1', start_date: Time.now, end_date: Time.now + 6.day, payout: 30, finish_points: 200, establishment: @est6)
@challenge7 = FactoryGirl.create(:challenge, name: 'Challenge 1', start_date: Time.now, end_date: Time.now + 6.day, payout: 30, finish_points: 200, establishment: @est7)
@challenge8 = FactoryGirl.create(:challenge, name: 'Challenge 1', start_date: Time.now, end_date: Time.now + 6.day, payout: 30, finish_points: 200, establishment: @est8)
@challenge9 = FactoryGirl.create(:challenge, name: 'Challenge 1', start_date: Time.now, end_date: Time.now + 6.day, payout: 30, finish_points: 200, establishment: @est9)
@challenge10 = FactoryGirl.create(:challenge, name: 'Challenge 1', start_date: Time.now, end_date: Time.now + 6.day, payout: 30, finish_points: 200, establishment: @est10)
@challenge11 = FactoryGirl.create(:challenge, name: 'Challenge 1', start_date: Time.now, end_date: Time.now + 6.day, payout: 30, finish_points: 200, establishment: @est11)
@challenge12 = FactoryGirl.create(:challenge, name: 'Challenge 1', start_date: Time.now, end_date: Time.now + 6.day, payout: 30, finish_points: 200, establishment: @est12)
@challenge13 = FactoryGirl.create(:challenge, name: 'Challenge 1', start_date: Time.now, end_date: Time.now + 6.day, payout: 30, finish_points: 200, establishment: @est13)
@challenge14 = FactoryGirl.create(:challenge, name: 'Challenge 2', start_date: Time.now + 1.week, end_date: Time.now + 1.week + 6.day, payout: 30, finish_points: 200, establishment: @est13)
@challenge15 = FactoryGirl.create(:challenge, name: 'Challenge 3', start_date: Time.now + 2.week, end_date: Time.now + 2.week + 6.day, payout: 30, finish_points: 200, establishment: @est13)
@challenge16 = FactoryGirl.create(:challenge, name: 'Challenge 1', start_date: Time.now, end_date: Time.now + 6.day, payout: 30, finish_points: 200, establishment: @est14)
@challenge17 = FactoryGirl.create(:challenge, name: 'Challenge 2', start_date: Time.now + 1.week, end_date: Time.now + 1.week + 6.day, payout: 30, finish_points: 200, establishment: @est14)
@challenge18 = FactoryGirl.create(:challenge, name: 'Challenge 1', start_date: Time.now, end_date: Time.now + 6.day, payout: 30, finish_points: 200, establishment: @est15)
@challenge19 = FactoryGirl.create(:challenge, name: 'Challenge 1', start_date: Time.now, end_date: Time.now + 6.day, payout: 30, finish_points: 200, establishment: @est16)
@challenge20 = FactoryGirl.create(:challenge, name: 'Challenge 1', start_date: Time.now, end_date: Time.now + 6.day, payout: 30, finish_points: 200, establishment: @est17)
@challenge21 = FactoryGirl.create(:challenge, name: 'Challenge 1', start_date: Time.now, end_date: Time.now + 6.day, payout: 30, finish_points: 200, establishment: @est18)
@challenge22 = FactoryGirl.create(:challenge, name: 'Challenge 1', start_date: Time.now, end_date: Time.now + 6.day, payout: 30, finish_points: 200, establishment: @est19)
@challenge23 = FactoryGirl.create(:challenge, name: 'Challenge 1', start_date: Time.now, end_date: Time.now + 6.day, payout: 30, finish_points: 200, establishment: @est20)
@challenge24 = FactoryGirl.create(:challenge, name: 'Challenge 1', start_date: Time.now, end_date: Time.now + 6.day, payout: 30, finish_points: 200, establishment: @est21)
@challenge25 = FactoryGirl.create(:challenge, name: 'Challenge 2', start_date: Time.now + 1.week, end_date: Time.now + 1.week + 6.day, payout: 30, finish_points: 200, establishment: @est21)
@challenge26 = FactoryGirl.create(:challenge, name: 'Challenge 3', start_date: Time.now + 2.week, end_date: Time.now + 2.week + 6.day, payout: 30, finish_points: 200, establishment: @est21)
@challenge27 = FactoryGirl.create(:challenge, name: 'Challenge 4', start_date: Time.now + 3.week, end_date: Time.now + 3.week + 6.day, payout: 30, finish_points: 200, establishment: @est21)
@challenge28 = FactoryGirl.create(:challenge, name: 'Challenge 5', start_date: Time.now + 4.week, end_date: Time.now + 4.week + 6.day, payout: 30, finish_points: 200, establishment: @est21)
@challenge29 = FactoryGirl.create(:challenge, name: 'Challenge 1', start_date: Time.now, end_date: Time.now + 6.day, payout: 30, finish_points: 200, establishment: @est22)
@challenge30 = FactoryGirl.create(:challenge, name: 'Challenge 1', start_date: Time.now, end_date: Time.now + 6.day, payout: 30, finish_points: 200, establishment: @est23)

puts 'ENROLLING PATRONS IN SOME CHALLENGES..'
FactoryGirl.create(:enrolled_challenge, challenge: @challenge1, patron: @user2, current_points: 100)
FactoryGirl.create(:enrolled_challenge, challenge: @challenge2, patron: @user2, current_points: 180)
FactoryGirl.create(:enrolled_challenge, challenge: @challenge3, patron: @user2, current_points: 70)
=end
