FactoryBot.define do
  factory :page_help do
    controller_name { "master/brands" }
    action_name     { "index" }
    help_text       { "Please help me." }
    help_type       { "primary" }
  end
end
