FactoryBot.define do
  factory :vendorship do
    archive      { false }
    organization
    vendor
  end
end
