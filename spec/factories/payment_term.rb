FactoryBot.define do
  factory :payment_term do
    name         { Faker::Company.industry + (Time.now.to_f * 100000000000000000000000000000000).to_i.to_s }
    description  { Faker::Name.name }
    archive      { false }
    organization
  end
end
