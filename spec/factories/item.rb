FactoryBot.define do
  factory :item do
    name               { Faker::Company.industry + (Time.now.to_f * 100000000000000000000000000000000).to_i.to_s }
    archive            { false }
    primary_quantity   { rand(1..100) }
    secondary_quantity { rand(1..100) }
    uom
    secondary_uom      { create :uom }
    item_group
    organization
  end
end
