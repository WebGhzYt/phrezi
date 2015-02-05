# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :challenge do
    name { "#{Faker::Commerce.color.humanize} Challenge"}
    start_date Time.now
    end_date Time.now + 1.week
    challenge_prize 20
    challenge_winner 25
    win_differential 10
    payout 5
  end
end
