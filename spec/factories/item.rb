FactoryBot.define do
  factory :item do
    name               { rand(999).to_s + " # " + Faker::Lorem.word + " # " + rand(99999).to_s }
    archive            { false }
    primary_quantity   { rand(9999.99) }
    secondary_quantity { rand(9999.99) }
    uom
    secondary_uom      { create :uom }
    item_group
    organization
  end
end
