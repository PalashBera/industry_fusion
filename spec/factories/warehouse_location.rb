FactoryBot.define do
  factory :warehouse_location do
    name         { Faker::Company.industry + (Time.now.to_f * 100000000000000000000000000000000).to_i.to_s }
    warehouse
    organization
  end
end
