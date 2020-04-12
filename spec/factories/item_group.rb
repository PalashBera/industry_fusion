FactoryBot.define do
  factory :item_group do
    name        { Faker::Beer.name + rand(9999).to_s }
    description { Faker::Lorem.sentence }
    archive     { Faker::Boolean.boolean }
    organization
  end
end
