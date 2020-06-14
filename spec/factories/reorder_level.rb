FactoryBot.define do
  factory :reorder_level do
    quantity { rand(1..100) }
    priority { %w[default high medium low].sample }
    warehouse
    item
    organization
  end
end
