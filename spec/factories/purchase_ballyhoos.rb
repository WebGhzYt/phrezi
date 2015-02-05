# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :purchase_ballyhoo do
    purchase_type 1
    item_id 1
    point_adjustment 1
    title "MyString"
    description "MyText"
    ballyhoo_start "2014-05-01 21:27:55"
    ballyhoo_end "2014-05-01 21:27:55"
    end_repeat "2014-05-01"
    repeat_type 1
    establishment nil
  end
end
