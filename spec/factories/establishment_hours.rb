# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :establishment_hour do
    establishment nil
    day "MyString"
    open_time Time.parse('8:00am')
    close_time Time.parse('11:00pm')
  end

  factory :monday, class: EstablishmentHour do
    establishment nil
    day "monday"
    open_time Time.parse('8:00am')
    close_time Time.parse('11:00pm')
  end

  factory :tuesday, class: EstablishmentHour do
    establishment nil
    day "tuesday"
    open_time Time.parse('8:00am')
    close_time Time.parse('11:00pm')
  end

  factory :wednesday, class: EstablishmentHour do
    establishment nil
    day "wednesday"
    open_time Time.parse('8:00am')
    close_time Time.parse('11:00pm')
  end

  factory :thursday, class: EstablishmentHour do
    establishment nil
    day "thursday"
    open_time Time.parse('8:00am')
    close_time Time.parse('11:00pm')
  end

  factory :friday, class: EstablishmentHour do
    establishment nil
    day "friday"
    open_time Time.parse('8:00am')
    close_time Time.parse('11:00pm')
  end

  factory :saturday, class: EstablishmentHour do
    establishment nil
    day "saturday"
    open_time Time.parse('8:00am')
    close_time Time.parse('11:00pm')
  end

  factory :sunday, class: EstablishmentHour do
    establishment nil
    day "sunday"
    open_time Time.parse('8:00am')
    close_time Time.parse('11:00pm')
  end
end
