require "rails_helper"

RSpec.describe ItemGroup, type: :model do
  let!(:current_user) { create :user }
  before              { User.stub(:current_user).and_return(current_user)  }
  let!(:organization) { create(:organization) }
  let!(:item_group)   { create(:item_group, name: "Toolkit", organization: organization) }

  it_behaves_like "archivable"
  it_behaves_like "modal_formable"
  it_behaves_like "nameable"
  it_behaves_like "user_trackable"

  describe "active record columns" do
    it { should have_db_column(:description) }
    it { should have_db_column(:organization_id) }
    it { should have_db_column(:created_by_id) }
    it { should have_db_column(:updated_by_id) }
    it { should have_db_column(:created_at) }
    it { should have_db_column(:updated_at) }
  end

  describe "active record index" do
    it { should have_db_index(:organization_id) }
    it { should have_db_index(:created_by_id) }
    it { should have_db_index(:updated_by_id) }
  end

  describe "associations" do
    it { should belong_to(:organization) }
    it { should have_many(:items) }
  end
end
