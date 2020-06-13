require "rails_helper"

RSpec.describe Warehouse, type: :model do
  let(:user)      { create(:user) }
  let(:company)   { create(:company) }
  let(:warehouse) { create(:warehouse, company) }

  before(:each) do
    ActsAsTenant.stub(:current_tenant).and_return(user.organization)
    User.stub(:current_user).and_return(user)
  end

  it_behaves_like "nameable"
  it_behaves_like "short_nameable"
  it_behaves_like "addressable"
  it_behaves_like "archivable"
  it_behaves_like "modal_formable"
  it_behaves_like "user_trackable"
  it_behaves_like "organization_associable"
  it_behaves_like "timestampble"

  describe "#active_record_columns" do
    it { should have_db_column(:company_id) }
  end

  describe "#active_record_index" do
    it { should have_db_index(:company_id) }
  end

  describe "#associations" do
    it { should belong_to(:company) }

    it { should have_many(:indents) }
    it { should have_many(:warehouse_locations) }
    it { should have_many(:reorder_levels) }
  end
end
