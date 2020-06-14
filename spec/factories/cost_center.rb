FactoryBot.define do
  factory :cost_center do
    name         { Faker::Company.industry + (Time.now.to_f * 100000000000000000000000000000000).to_i.to_s }
    description  { Faker::Marketing.buzzwords }
    archive      { false }
    organization
  end
end
