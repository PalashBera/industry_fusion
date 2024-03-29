require "rails_helper"

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  before(:each) do
    ActsAsTenant.current_tenant = user.organization
    User.current_user = user
  end

  it_behaves_like "user_information_module"
  it_behaves_like "modal_form_module"
  it_behaves_like "organization_association_module"
  it_behaves_like "timestamp_module"

  describe "#active_record_columns" do
    it { should have_db_column(:admin) }
    it { should have_db_column(:sidebar_collapse) }
    it { should have_db_column(:warehouse_ids) }
    it { should have_db_column(:invitation_token) }
    it { should have_db_column(:invitation_created_at) }
    it { should have_db_column(:invitation_sent_at) }
    it { should have_db_column(:invitation_accepted_at) }
    it { should have_db_column(:invitation_limit) }
    it { should have_db_column(:invited_by_type) }
    it { should have_db_column(:invited_by_id) }
    it { should have_db_column(:invitations_count) }
  end

  describe "#active_record_index" do
    it { should have_db_index(:invitation_token) }
    it { should have_db_index(:invitations_count) }
    it { should have_db_index([:invited_by_type, :invited_by_id]) }
  end

  describe "#callbacks" do
    it { is_expected.to callback(:create_approval_levels).after(:create).if(:admin?) }
  end

  describe "#associations" do
    it { should have_many(:level_users).dependent(:destroy) }
    it { should have_many(:approval_request_users).dependent(:destroy) }
  end

  # TODO: Add validation specs here

  describe "#non_admin?" do
    let(:admin_user) { create(:admin_user) }

    context "when user is admin" do
      it "should return false" do
        expect(admin_user.non_admin?).to eq(false)
      end
    end

    context "when user is not admin" do
      it "should return true" do
        expect(user.non_admin?).to eq(true)
      end
    end
  end

  describe "#pending_invitation?" do
    let(:pending_user) { create(:user, invitation_accepted_at: nil) }

    it "should return pending" do
      expect(pending_user.pending_invitation?).to eq(true)
    end
  end

  describe "#toggle_sidebar_collapse" do
    it "should toggle sidebar_collapse value" do
      previous_value = user.sidebar_collapse
      user.toggle_sidebar_collapse
      expect(user.sidebar_collapse).to eq(!previous_value)
      expect(user.sidebar_collapse).not_to eq(previous_value)
    end
  end

  describe "#toggle_archive" do
    context "when archive is true" do
      let(:user) { create(:user, archive: true) }

      it "should set archive as false" do
        user.toggle_archive
        expect(user.archive).to eq(false)
      end
    end

    context "when archive is false" do
      let(:user) { create(:user, archive: false) }

      it "should set archive as true" do
        user.toggle_archive
        expect(user.archive).to eq(true)
      end
    end
  end
end
