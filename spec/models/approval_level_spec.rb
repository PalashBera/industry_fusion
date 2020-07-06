require "rails_helper"

RSpec.describe ApprovalLevel, type: :model do
  let(:user)           { create :user }
  let(:approval_level) { create(:approval_level) }

  before(:each) do
    ActsAsTenant.stub(:current_tenant).and_return(user.organization)
    User.stub(:current_user).and_return(user)
  end

  it_behaves_like "modal_form_module"
  it_behaves_like "user_tracking_module"
  it_behaves_like "organization_association_module"
  it_behaves_like "timestamp_module"

  describe "#active_record_columns" do
    it { should have_db_column(:approval_type) }
  end

  describe "#active_record_index" do
    it { should have_db_index(:approval_type) }
  end

  describe "#enums" do
    it { should define_enum_for(:approval_type).with_values(indent: "indent", qc: "qc", po: "po", grn: "grn").backed_by_column_of_type(:string) }
  end

  describe "#associations" do
    it { should have_many(:level_users).dependent(:destroy) }
    it { should accept_nested_attributes_for(:level_users).allow_destroy(true) }
  end

  describe "#validations" do
    it { should validate_presence_of(:approval_type) }
    it { should validate_presence_of(:level_users) }
  end
end
