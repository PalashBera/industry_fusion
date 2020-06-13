FactoryBot.define do
  factory :warehouse_location do
    name       { rand(999).to_s + " # " + Faker::Lorem.word + " # " + rand(99999).to_s }
    warehouse
    organization
  end
end
