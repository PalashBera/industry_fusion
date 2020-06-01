FactoryBot.define do
  factory :uom do
    name         { Faker::Name.first_name + rand(9999).to_s }
    short_name   { Faker::Name.initials(number: 4) }
    archive      { false }
    organization
  end
end
