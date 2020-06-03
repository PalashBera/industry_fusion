FactoryBot.define do
  factory :indent do
    requirement_date { Faker::Date.forward(days: 14) }
    serial           { Faker::Number.number(digits: 3) }
    company
    warehouse
    organization

    before :create do |indent|
      indent.indent_items << build(:indent_item, indent_id: indent.id)
    end
  end
end
