# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ballyhoo do
    title "MyString"
    description "MyText"
    start_time "2014-05-04 13:51:48"
    end_time "2014-05-04 13:51:48"
    start_date "2014-05-04"
    repeat_type 1
    end_repeat "2014-05-04"
    establishment_id 1
    total_checkin_qty 1
    include_friends false
    friends_sync false
    point_value 1
    item_id 1
    ballyhoo_type "MyString"
  end
end
