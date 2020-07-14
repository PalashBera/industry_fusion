FactoryBot.define do
  factory :indent_item do
    quantity      { rand(1..100) }
    priority      { IndentItem::PRIORITY_LIST.sample }
    locked        { false }
    status        { "pending" }
    current_level { 0 }
    approval_ids  { [] }
    indent
    item
    make
    uom
    cost_center
    organization
  end
end
