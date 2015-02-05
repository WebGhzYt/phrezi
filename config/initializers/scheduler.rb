require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.every '15m' do
  Checkin.checkout_all_patrons
end

scheduler.every '15m' do
  PatronCart.remove_carts
end

scheduler.every '15m' do
  Challenge.create_upcoming_challenges
end


