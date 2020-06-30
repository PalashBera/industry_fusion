FactoryBot.define do
  factory :approval_level do
    approval_type { ApprovalLevel::APPROVAL_TYPES.sample }
    organization

    before :create do |approval_level|
      user = create(:user) if user.nil?
      approval_level.level_users << build(:level_user, approval_level_id: approval_level.id, user_id: user.id)
    end
  end
end
