# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :employee do
    role 'server'
    user
    establishment
    enabled true
  end
end
