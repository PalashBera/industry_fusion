FactoryBot.define do
  factory :cost_center do
    name        { Faker::Lorem.word + rand(9999).to_s }
    description { Faker::Marketing.buzzwords }
    archive     { Faker::Boolean.boolean }
    organization
  end
end
