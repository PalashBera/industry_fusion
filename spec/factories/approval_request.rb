FactoryBot.define do
  factory :approval_request do
    approval_requestable_id   { create(:indent_item).id }
    approval_requestable_type { "IndentItem" }
    action_type               { "approved" }
    action_taken_at           { DateTime.now }
    action_taken_by_id        { create(:user).id }
    next_approval_request_id  { nil }
  end
end
