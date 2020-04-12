FactoryBot.define do
  factory :organization do
    name        { Faker::Company.industry }
    address1    { Faker::Address.street_address }
    address2    { Faker::Address.secondary_address }
    city        { Faker::Address.city }
    state       { Faker::Address.state }
    country     { Faker::Address.country }
    pin_code    { Faker::Number.number(digits: 6) }
    description { Faker::Lorem.paragraph }
    archive     { false }
  end
end
