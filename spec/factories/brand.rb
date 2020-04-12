FactoryBot.define do
  factory :brand do
    name         { Faker::Appliance.brand }
    archive      { false }
    organization
  end
end
