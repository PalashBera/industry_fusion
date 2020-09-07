FactoryBot.define do
  factory :indent_item do
    quantity         { rand(1..100) }
    priority         { IndentItem::PRIORITY_LIST.sample }
    locked           { false }
    status           { "created" }
    requirement_date { Faker::Date.forward(days: 14) }
    indent
    item
    make
    uom
    cost_center
    organization
  end
end
