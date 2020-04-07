FactoryBot.define do
  factory :brand do
    name    { Faker::Appliance.brand }
    archive { true }
    organization
  end
end
