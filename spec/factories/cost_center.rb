FactoryBot.define do
  factory :cost_center do
    name        { Faker::Lorem.word + rand(9999).to_s }
    description { Faker::Marketing.buzzwords }
    archive     { false }
    organization
  end
end
