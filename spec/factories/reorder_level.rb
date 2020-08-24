FactoryBot.define do
  factory :reorder_level do
    quantity { rand(1..100) }
    priority { ReorderLevel::PRIORITY_LIST.sample }
    warehouse
    item
    organization
  end
end
