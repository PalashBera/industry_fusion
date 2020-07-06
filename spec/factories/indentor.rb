FactoryBot.define do
  factory :indentor do
    name         { Faker::Name.name + Time.zone.now.to_s }
    archive      { Faker::Boolean.boolean }
    organization
  end
end
