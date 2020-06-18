FactoryBot.define do
  factory :role do
    name { ["Admin", "Staff"].sample }
    organization
  end
end
