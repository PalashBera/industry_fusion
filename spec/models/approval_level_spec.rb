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

  describe "#associations" do
    it { should have_many(:level_users).dependent(:destroy) }
    it { should accept_nested_attributes_for(:level_users).allow_destroy(true) }
  end

  describe "#validations" do
    it { should validate_presence_of(:approval_type) }
    it { should validate_length_of(:approval_type).is_at_most(255) }
    it { should validate_presence_of(:level_users) }
  end

  describe "#scopes" do
    let!(:approval_level_indent) { create(:approval_level, approval_type: "indent") }
    let!(:approval_level_qc)     { create(:approval_level, approval_type: "qc") }
    let!(:approval_level_po)     { create(:approval_level, approval_type: "po") }
    let!(:approval_level_grn)    { create(:approval_level, approval_type: "grn") }

    context "indent" do
      it "should return approval_levels whose approval_type is indent" do
        expect(ApprovalLevel.indent).to eq([approval_level_indent])
      end
    end

    context "po" do
      it "should return approval_levels whose approval_type is po" do
        expect(ApprovalLevel.po).to eq([approval_level_po])
      end
    end

    context "qc" do
      it "should return approval_levels whose approval_type is qc" do
        expect(ApprovalLevel.qc).to eq([approval_level_qc])
      end
    end

    context "grn" do
      it "should return approval_levels whose approval_type is grn" do
        expect(ApprovalLevel.grn).to eq([approval_level_grn])
      end
    end
  end
end
