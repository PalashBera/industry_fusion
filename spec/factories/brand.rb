FactoryBot.define do
  factory :brand do
    name         { Faker::Company.industry + (Time.now.to_f * 100000000000000000000000000000000).to_i.to_s }
    archive      { false }
    organization
  end
end
