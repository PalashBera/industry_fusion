FactoryBot.define do
  factory :item do
    name              { rand(999).to_s + " # " + Faker::Lorem.word + " # " + rand(99999).to_s }
    archive           { false }
    uom
    item_group
    organization
  end
end
