require "rails_helper"

RSpec.describe Approval, type: :model do
  let(:user)     { create(:user) }
  let(:approval) { create(:approval) }

  before(:each) do
    ActsAsTenant.stub(:current_tenant).and_return(user.organization)
    User.stub(:current_user).and_return(user)
  end

  it_behaves_like "archive_module"
  it_behaves_like "user_tracking_module"
  it_behaves_like "timestamp_module"

  describe "#active_record_columns" do
    it { should have_db_column(:indent_item_id) }
    it { should have_db_column(:level) }
    it { should have_db_column(:user_ids) }
    it { should have_db_column(:action_type) }
    it { should have_db_column(:action_taken_at) }
    it { should have_db_column(:action_taken_by_id) }
  end

  describe "#active_record_index" do
    it { should have_db_index(:indent_item_id) }
  end

  describe "#associations" do
    it { should belong_to(:indent_item) }
    it { should belong_to(:action_taken_by).class_name("User").optional }
  end

  describe "#validations" do
    it { should validate_presence_of(:level) }
    it { should validate_inclusion_of(:action_type).in_array(Approval::ACTION_TYPES).allow_nil }
  end

  describe "#approve" do
    context "when approval is already approved" do
      let(:approval) { create(:approval, action_type: "approved") }

      it "should return already approved message" do
        expect(approval.approve(1)).to eq(I18n.t("indent_approval.action_already_taken", action: "approved"))
      end
    end

    context "when approval is already rejected" do
      let(:approval) { create(:approval, action_type: "rejected") }

      it "should return already rejected message" do
        expect(approval.approve(1)).to eq(I18n.t("indent_approval.action_already_taken", action: "rejected"))
      end
    end

    context "when approval is not approved" do
      let(:approval) { create(:approval, action_type: nil) }

      it "should return approved message" do
        expect(approval.approve(1)).to eq(I18n.t("indent_approval.action_taken", action: "approved"))
      end
    end
  end

  describe "#reject" do
    context "when approval is already rejected" do
      let(:approval) { create(:approval, action_type: "rejected") }

      it "should return already rejected message" do
        expect(approval.reject(1)).to eq(I18n.t("indent_approval.action_already_taken", action: "rejected"))
      end
    end

    context "when approval is already approved" do
      let(:approval) { create(:approval, action_type: "approved") }

      it "should return already approved message" do
        expect(approval.reject(1)).to eq(I18n.t("indent_approval.action_already_taken", action: "approved"))
      end
    end

    context "when approval is not rejected" do
      let(:approval) { create(:approval, action_type: nil) }

      it "should return rejected message" do
        expect(approval.reject(1)).to eq(I18n.t("indent_approval.action_taken", action: "rejected"))
      end
    end
  end

  describe "#approved?" do
    context "when approval is approved" do
      let(:approval) { create(:approval, action_type: "approved") }

      it "should return true" do
        expect(approval.approved?).to eq(true)
      end
    end

    context "when approval is rejected" do
      let(:approval) { create(:approval, action_type: "rejected") }

      it "should return false" do
        expect(approval.approved?).to eq(false)
      end
    end

    context "when approval is not approved" do
      let(:approval) { create(:approval, action_type: nil) }

      it "should return false" do
        expect(approval.approved?).to eq(false)
      end
    end
  end

  describe "#rejected?" do
    context "when approval is rejected" do
      let(:approval) { create(:approval, action_type: "rejected") }

      it "should return true" do
        expect(approval.rejected?).to eq(true)
      end
    end

    context "when approval is approved" do
      let(:approval) { create(:approval, action_type: "approved") }

      it "should return false" do
        expect(approval.rejected?).to eq(false)
      end
    end

    context "when approval is not rejected" do
      let(:approval) { create(:approval, action_type: nil) }

      it "should return false" do
        expect(approval.rejected?).to eq(false)
      end
    end
  end

  describe "#action_already_taken?" do
    context "when approval is rejected" do
      let(:approval) { create(:approval, action_type: "rejected") }

      it "should return true" do
        expect(approval.action_already_taken?).to eq(true)
      end
    end

    context "when approval is approved" do
      let(:approval) { create(:approval, action_type: "approved") }

      it "should return true" do
        expect(approval.action_already_taken?).to eq(true)
      end
    end

    context "when approval action is not taken yet" do
      let(:approval) { create(:approval, action_type: nil) }

      it "should return false" do
        expect(approval.action_already_taken?).to eq(false)
      end
    end
  end
end
