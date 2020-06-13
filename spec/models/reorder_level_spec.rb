require "rails_helper"

RSpec.describe ReorderLevel, type: :model do
  let!(:current_user)  { create :user }
  before               { User.stub(:current_user).and_return(current_user)  }

  it_behaves_like "archivable"
  it_behaves_like "modal_formable"
  it_behaves_like "user_trackable"

  describe "active record columns" do
    it { should have_db_column(:organization_id) }
    it { should have_db_column(:created_by_id) }
    it { should have_db_column(:updated_by_id) }
    it { should have_db_column(:created_at) }
    it { should have_db_column(:updated_at) }
    it { should have_db_column(:warehouse_id) }
    it { should have_db_column(:quantity) }
    it { should have_db_column(:priority) }
  end

  describe "active record index" do
    it { should have_db_index(:organization_id) }
    it { should have_db_index(:warehouse_id) }
    it { should have_db_index(:item_id) }
    it { should have_db_index(:created_by_id) }
    it { should have_db_index(:updated_by_id) }
  end

  describe "associations" do
    it { should belong_to(:organization) }
    it { should belong_to(:warehouse) }
    it { should belong_to(:item) }
  end

  describe "validations" do
    it { should validate_presence_of(:quantity) }
    it { should validate_numericality_of(:quantity).is_greater_than(0) }
  end
end
