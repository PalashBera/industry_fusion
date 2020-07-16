FactoryBot.define do
  factory :user do
    first_name       { Faker::Name.first_name }
    last_name        { Faker::Name.last_name }
    mobile_number    { Faker::PhoneNumber.subscriber_number(length: 10) }
    email            { Faker::Internet.email }
    password         { Faker::Internet.password(min_length: 6, max_length: 128) }
    sidebar_collapse { false }
    warehouse_ids    { [] }
    organization

    after(:build)    { |user| user.stub(:create_approval_levels) {}}
  end

  factory :admin_user, parent: :user do
    admin { true }
  end
end
