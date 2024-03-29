FactoryBot.define do
  factory :indent do
    serial           { Faker::Number.number(digits: 3) }
    indentor
    company
    warehouse
    organization

    before :create do |indent|
      indent.indent_items << build(:indent_item, indent_id: indent.id)
    end
  end
end
