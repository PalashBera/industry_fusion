require "rails_helper"

RSpec.describe LevelUser, type: :model do
  let(:user)       { create :user }
  let(:level_user) { create(:level_user) }

  before(:each) do
    ActsAsTenant.stub(:current_tenant).and_return(user.organization)
    User.stub(:current_user).and_return(user)
  end

  it_behaves_like "user_trackable"
  it_behaves_like "timestampble"

  describe "#active_record_columns" do
    it { should have_db_column(:approval_level_id) }
    it { should have_db_column(:user_id) }
  end

  describe "#active_record_index" do
    it { should have_db_index(:approval_level_id) }
    it { should have_db_index(:user_id) }
  end

  describe "#associations" do
    it { should belong_to(:approval_level).inverse_of(:level_users) }
    it { should belong_to(:user) }
  end
end
