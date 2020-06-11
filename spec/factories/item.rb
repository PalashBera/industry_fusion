FactoryBot.define do
  factory :item do
    name               { Faker::Beer.name + Time.zone.now.to_i.to_s }
    archive            { false }
    primary_quantity   { (1..100).to_a.sample }
    secondary_quantity { (1..100).to_a.sample }
    uom
    secondary_uom      { create :uom }
    item_group
    organization
  end
end
