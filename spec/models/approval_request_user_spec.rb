require "rails_helper"

RSpec.describe ApprovalRequestUser, type: :model do
  let(:user)                  { create(:user) }
  let(:approval_request_user) { create(:approval_request_user) }

  before(:each) do
    ActsAsTenant.stub(:current_tenant).and_return(user.organization)
    User.stub(:current_user).and_return(user)
  end

  it_behaves_like "timestamp_module"

  describe "#active_record_columns" do
    it { should have_db_column(:approval_request_id) }
    it { should have_db_column(:user_id) }
  end

  describe "#active_record_index" do
    it { should have_db_index(:approval_request_id) }
    it { should have_db_index(:user_id) }
  end

  describe "#associations" do
    it { should belong_to(:approval_request) }
    it { should belong_to(:user) }
  end

  describe "#scopes" do
    context "user_filter" do
      let(:user_1)                  { create(:user) }
      let(:user_2)                  { create(:user) }
      let(:approval_request_user_1) { create(:approval_request_user, user_id: user_1.id) }
      let(:approval_request_user_2) { create(:approval_request_user, user_id: user_2.id) }

      it "should return records of the user" do
        expect(ApprovalRequestUser.user_filter(user_1.id).include?(approval_request_user_1)).to eq(true)
        expect(ApprovalRequestUser.user_filter(user_1.id).include?(approval_request_user_2)).to eq(false)
      end
    end
  end

  describe "#approve" do
    context "when it is approved already" do
      let(:approval_request)      { create(:approval_request, action_type: "approved") }
      let(:approval_request_user) { create(:approval_request_user, approval_request_id: approval_request.id) }

      it "should return already approved message" do
        approval_request.approval_requestable.update(approval_request_id: approval_request.id)
        expect(approval_request_user.approve).to eq(I18n.t("approval_request.action_already_taken", name: "Indent item", action: "approved"))
      end
    end

    context "when it is rejected already" do
      let(:approval_request)      { create(:approval_request, action_type: "rejected") }
      let(:approval_request_user) { create(:approval_request_user, approval_request_id: approval_request.id) }

      it "should return already rejected message" do
        approval_request.approval_requestable.update(approval_request_id: approval_request.id)
        expect(approval_request_user.approve).to eq(I18n.t("approval_request.action_already_taken", name: "Indent item", action: "rejected"))
      end
    end

    context "when approval action is not taken yet" do
      let(:approval_request)      { create(:approval_request, action_type: nil) }
      let(:approval_request_user) { create(:approval_request_user, approval_request_id: approval_request.id) }

      it "should return approved message" do
        approval_request.approval_requestable.update(approval_request_id: approval_request.id)
        expect(approval_request_user.approve).to eq(I18n.t("approval_request.action_taken", name: "Indent item", action: "approved"))
      end
    end
  end

  describe "#reject" do
    context "when it is rejected already" do
      let(:approval_request)      { create(:approval_request, action_type: "rejected") }
      let(:approval_request_user) { create(:approval_request_user, approval_request_id: approval_request.id) }

      it "should return already rejected message" do
        approval_request.approval_requestable.update(approval_request_id: approval_request.id)
        expect(approval_request_user.reject).to eq(I18n.t("approval_request.action_already_taken", name: "Indent item", action: "rejected"))
      end
    end

    context "when it is rejected already" do
      let(:approval_request)      { create(:approval_request, action_type: "rejected") }
      let(:approval_request_user) { create(:approval_request_user, approval_request_id: approval_request.id) }

      it "should return already rejected message" do
        approval_request.approval_requestable.update(approval_request_id: approval_request.id)
        expect(approval_request_user.reject).to eq(I18n.t("approval_request.action_already_taken", name: "Indent item", action: "rejected"))
      end
    end

    context "when approval action is not taken yet" do
      let(:approval_request)      { create(:approval_request, action_type: nil) }
      let(:approval_request_user) { create(:approval_request_user, approval_request_id: approval_request.id) }

      it "should return rejected message" do
        approval_request.approval_requestable.update(approval_request_id: approval_request.id)
        expect(approval_request_user.reject).to eq(I18n.t("approval_request.action_taken", name: "Indent item", action: "rejected"))
      end
    end
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
