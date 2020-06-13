require "rails_helper"

RSpec.describe Brand, type: :model do
  let(:user)  { create(:user) }
  let(:brand) { create(:brand) }

  before(:each) do
    ActsAsTenant.stub(:current_tenant).and_return(user.organization)
    User.stub(:current_user).and_return(user)
  end

  it_behaves_like "nameable"
  it_behaves_like "archivable"
  it_behaves_like "modal_formable"
  it_behaves_like "user_trackable"
  it_behaves_like "organization_associable"
  it_behaves_like "timestampble"

  describe "#active_record_columns" do
    it { should have_db_column(:created_by_id) }
    it { should have_db_column(:updated_by_id) }
  end

  describe "#active_record_index" do
    it { should have_db_index(:created_by_id) }
    it { should have_db_index(:updated_by_id) }
  end

  describe "#associations" do
    it { should have_many(:makes) }
  end
end
