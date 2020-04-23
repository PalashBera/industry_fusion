FactoryBot.define do
  factory :warehouse do
    name         { Faker::Company.industry }
    short_name   { Faker::Name.initials(number: 4) }
    address1     { Faker::Address.street_address }
    address2     { Faker::Address.secondary_address }
    city         { Faker::Address.city }
    state        { Faker::Address.state }
    country      { Faker::Address.country }
    pin_code     { Faker::Number.number(digits: 6) }
    phone_number { Faker::PhoneNumber.phone_number }
    archive      { false }
    company
    organization
  end
end
