FactoryBot.define do
  factory :store_information do
    name         { Faker::Company.industry + (Time.now.to_f * 100000000000000000000000000000000).to_i.to_s }
    address1     { Faker::Address.street_address }
    address2     { Faker::Address.secondary_address }
    city         { Faker::Address.city }
    state        { Faker::Address.state }
    country      { Faker::Address.country }
    pin_code     { Faker::Number.number(digits: 6) }
    phone_number { Faker::PhoneNumber.phone_number }
    pan_number   { "BNEPB7758N" }
    gstn         { "29BNEPB7758N2Z9" }
    vendor
  end
end
