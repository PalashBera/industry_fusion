FactoryBot.define do
  factory :uom do
    name         { Faker::Company.industry + (Time.now.to_f * 100000000000000000000000000000000).to_i.to_s }
    short_name   { Faker::Name.unique.initials(number: 4) }
    archive      { false }
    organization
  end
end
