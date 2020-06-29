require "rails_helper"

RSpec.describe LevelUser, type: :model do
  let(:user)       { create :user }
  let(:level_user) { create(:level_user, user_id: user.id) }

  before(:each) do
    ActsAsTenant.stub(:current_tenant).and_return(user.organization)
    User.stub(:current_user).and_return(user)
  end

  it_behaves_like "user_tracking_module"
  it_behaves_like "organization_association_module"
  it_behaves_like "timestamp_module"

  describe "#active_record_columns" do
    it { should have_db_column(:approval_level_id) }
    it { should have_db_column(:user_id) }
  end

  describe "#active_record_index" do
    it { should have_db_index(:approval_level_id) }
    it { should have_db_index(:user_id) }
  end

  describe "#associations" do
    it { should belong_to(:approval_level) }
    it { should belong_to(:user) }
  end

  describe "#validations" do
    context "when same user is present for an approval level" do
      let!(:approval_level) { create(:approval_level) }
      let!(:level_user)     { create(:level_user, user_id: user.id, approval_level_id: approval_level.id) }

      it "should not save this level user" do
        new_level_user = build(:level_user, user_id: user.id, approval_level_id: approval_level.id)
        new_level_user.valid?
        expect(new_level_user.errors[:user_id]).to include("has already been taken")
      end
    end
  end
end
