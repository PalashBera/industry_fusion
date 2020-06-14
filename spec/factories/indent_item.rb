FactoryBot.define do
  factory :indent_item do
    quantity { rand(1..100) }
    priority { %w[default high medium low].sample }
    indent
    item
    make
    uom
    cost_center
    organization
  end
end
