FactoryBot.define do
  factory :approval do
    level              { 1 }
    user_ids           { [1] }
    action_type        { "approved" }
    action_taken_at    { Time.now }
    action_taken_by_id { 1 }
    indent_item
  end
end
