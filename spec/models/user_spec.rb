require "rails_helper"

RSpec.describe User, type: :model do
  let(:user)         { create(:user) }
  let(:organization) { create(:organization) }

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

  describe "#admin?" do
    let(:admin_user) { create(:admin_user) }

    context "when user is admin" do
      it "should return true" do
        expect(admin_user.admin?).to eq(true)
      end
    end

    context "when user is not admin" do
      it "should return false" do
        expect(user.admin?).to eq(false)
      end
    end
  end

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

  describe "#pending_acception?" do
    let(:pending_user) { create(:user, invitation_accepted_at: nil) }

    it "should return pending" do
      expect(pending_user.pending_acception?).to eq(true)
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

  describe "#toggle_activation" do
    it "should toggle archive value" do
      previous_value = user.archive
      user.toggle_activation
      expect(user.archive).to eq(!previous_value)
      expect(user.archive).not_to eq(previous_value)
    end
  end
end
