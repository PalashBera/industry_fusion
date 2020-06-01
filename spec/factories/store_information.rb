FactoryBot.define do
  factory :store_information do
    name         { Faker::Company.industry + rand(9999999).to_s }
    address1     { Faker::Address.street_address }
    address2     { Faker::Address.secondary_address }
    city         { Faker::Address.city }
    state        { Faker::Address.state }
    country      { Faker::Address.country }
    pin_code     { Faker::Number.number(digits: 6) }
    phone_number { Faker::PhoneNumber.phone_number }
    pan_number   { Faker::Number.number(digits: 10) }
    gstn         { Faker::Number.number(digits: 15) }
    vendor
  end
end
