FactoryBot.define do
  factory :level_user do
    user
    approval_level
    organization
  end
end
