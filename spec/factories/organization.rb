FactoryBot.define do
  factory :organization do
    name           { Faker::Company.industry + (Time.now.to_f * 100000000000000000000000000000000).to_i.to_s }
    fy_start_month { 4 }
    fy_end_month   { 3 }
    address1       { Faker::Address.street_address }
    address2       { Faker::Address.secondary_address }
    city           { Faker::Address.city }
    state          { Faker::Address.state }
    country        { Faker::Address.country }
    pin_code       { Faker::Number.number(digits: 6) }
    phone_number   { Faker::PhoneNumber.phone_number }
    archive        { false }
  end
end
