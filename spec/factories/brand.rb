FactoryBot.define do
  factory :brand do
    name         { Faker::Appliance.brand + Time.now.to_i.to_s }
    archive      { false }
    organization
  end
end
