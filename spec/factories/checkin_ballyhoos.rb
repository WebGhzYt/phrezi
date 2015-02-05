# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :checkin_ballyhoo do
    include_friends false
    friends_sync false
    total_checkin_qty 1
    point_value 1
    ballyhoo_start "2014-04-15 16:44:38"
    ballyhoo_end "2014-04-15 16:44:38"
    end_repeat "2014-04-15"
    establishment nil
  end
end
