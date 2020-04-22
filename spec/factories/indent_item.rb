FactoryBot.define do
  factory :indent_item do
    quantity { rand(9999.99) }
    priority { %w[default high medium low].sample }
    indent
    item
    make
    uom
    cost_center
    organization
  end
end
