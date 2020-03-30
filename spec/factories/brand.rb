FactoryBot.define do
  factory :brand do
    name    { Faker::Appliance.brand }
    archive { Faker::Boolean.boolean }
  end
end
