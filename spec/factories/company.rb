FactoryBot.define do
  factory :company do
    name         { Faker::Company.industry + (Time.now.to_f * 100000000000000000000000000000000).to_i.to_s }
    short_name   { Faker::Name.unique.initials(number: 3) }
    address1     { Faker::Address.street_address }
    address2     { Faker::Address.secondary_address }
    city         { Faker::Address.city }
    state        { Faker::Address.state }
    country      { Faker::Address.country }
    pin_code     { Faker::Number.number(digits: 6) }
    phone_number { Faker::PhoneNumber.phone_number }
    archive      { false }
    organization
  end
end
