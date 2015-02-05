FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.free_email }
    password 'changeme'
    password_confirmation 'changeme'
    confirmed_at Time.now
  end
end
