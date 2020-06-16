FactoryBot.define do
  factory :role do
    name { ["Admin", "Staff"].sample }
  end
end
