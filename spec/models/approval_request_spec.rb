require "rails_helper"

RSpec.describe ApprovalRequest, type: :model do
  let(:user)             { create(:user) }
  let(:approval_request) { create(:approval_request) }

  before(:each) do
    ActsAsTenant.current_tenant = user.organization
    User.current_user = user
  end

  it_behaves_like "user_tracking_module"
  it_behaves_like "timestamp_module"

  describe "#active_record_columns" do
    it { should have_db_column(:approval_requestable_id) }
    it { should have_db_column(:approval_requestable_type) }
    it { should have_db_column(:action_type) }
    it { should have_db_column(:action_taken_at) }
    it { should have_db_column(:action_taken_by_id) }
    it { should have_db_column(:next_approval_request_id) }
  end

  describe "#enums" do
    it { should define_enum_for(:action_type).with_values(approved: "approved", rejected: "rejected").backed_by_column_of_type(:string) }
  end

  describe "#associations" do
    it { should belong_to(:action_taken_by).class_name("User").optional }
    it { should belong_to(:next_approval_request).class_name("ApprovalRequest").optional }
    it { should belong_to(:approval_requestable) }

    it { should have_many(:approval_request_users).dependent(:destroy) }
  end

  describe "#action_already_taken?" do
    context "when approval is rejected" do
      let(:approval_request) { create(:approval_request, action_type: "rejected") }

      it "should return true" do
        expect(approval_request.action_already_taken?).to eq(true)
      end
    end

    context "when approval is approved" do
      let(:approval_request) { create(:approval_request, action_type: "approved") }

      it "should return true" do
        expect(approval_request.action_already_taken?).to eq(true)
      end
    end

    context "when approval action is not taken yet" do
      let(:approval_request) { create(:approval_request, action_type: nil) }

      it "should return false" do
        expect(approval_request.action_already_taken?).to eq(false)
      end
    end
  end
end
