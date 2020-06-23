FactoryBot.define do
  factory :approval_level do
    approval_type { ["Indent", "Qc", "Po", "Grn"].sample }
    organization

    before :create do |approval_level|
      approval_level.level_users << build(:level_user, approval_level_id: approval_level.id)
    end
  end
end
