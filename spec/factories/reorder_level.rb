FactoryBot.define do
  factory :reorder_level do
    quantity { rand(9999.99) }
    priority { %w[default high medium low].sample }
    warehouse
    item
    organization
  end
end
