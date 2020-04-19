FactoryBot.define do
  factory :make do
    cat_no { Faker::Code.isbn }
    brand
    item
    organization
  end
end
