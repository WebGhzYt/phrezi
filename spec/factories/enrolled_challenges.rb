# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :enrolled_challenge do
    challenge
    association :patron, factory: :user
    current_points 0
    amount 1
  end
end
