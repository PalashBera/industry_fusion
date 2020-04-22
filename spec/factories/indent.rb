FactoryBot.define do
  factory :indent do
    requirement_date { Faker::Date.forward(days: 14) }
    company
    warehouse
    organization
  end
end
