# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :group do
    name { "#{Faker::Company.name} #{Faker::Company.suffix}" }
    phone { Faker::PhoneNumber.phone_number }
    address
  end
end
