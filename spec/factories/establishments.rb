# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :establishment do
    name { Faker::Company.name }
    address
    phone { Faker::PhoneNumber.phone_number }
    gps_lat { Faker::Address.latitude }
    gps_long { Faker::Address.longitude }
    website { Faker::Internet.domain_name }
    facebook { Faker::Internet.domain_word }
    twitter { Faker::Internet.domain_word }
    group nil
    point_dollar "1"
    default_currency "usd"

    after(:create) do |establishment|
        create(:monday, establishment: establishment)
        create(:tuesday, establishment: establishment)
        create(:wednesday, establishment: establishment)
        create(:thursday, establishment: establishment)
        create(:friday, establishment: establishment)
        create(:saturday, establishment: establishment)
        create(:sunday, establishment: establishment)
    end
  end
end
