FactoryBot.define do
  factory :additional_term do
    name         { Faker::Company.industry + (Time.now.to_f * 100000000000000000000000000000000).to_i.to_s }
    conditions   { Faker::Lorem.words }
    archive      { false }
    organization
  end
end
