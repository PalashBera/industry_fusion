FactoryBot.define do
  factory :item_group do
    name         { Faker::Company.industry + (Time.now.to_f * 100000000000000000000000000000000).to_i.to_s }
    hsn_code     { Faker::Number.number(digits: 8) }
    description  { Faker::Lorem.sentence }
    archive      { false }
    organization
  end
end
