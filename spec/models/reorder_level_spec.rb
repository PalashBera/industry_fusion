require "rails_helper"

RSpec.describe ReorderLevel, type: :model do
  let(:user)          { create(:user) }
  let(:reorder_level) { create(:reorder_level) }

  before(:each) do
    Organization.current_organization = user.organization
    User.current_user = user
  end

  it_behaves_like "archivable"
  it_behaves_like "modal_formable"
  it_behaves_like "user_trackable"
  it_behaves_like "organization_associable"
  it_behaves_like "timestampble"

  describe "#active_record_columns" do
    it { should have_db_column(:item_id) }
    it { should have_db_column(:warehouse_id) }
    it { should have_db_column(:quantity) }
    it { should have_db_column(:priority) }
  end

  describe "#active_record_index" do
    it { should have_db_index(:item_id) }
    it { should have_db_index(:warehouse_id) }
  end

  describe "#associations" do
    it { should belong_to(:warehouse) }
    it { should belong_to(:item) }
  end

  describe "#validations" do
    it { should validate_presence_of(:quantity) }
    it { should validate_numericality_of(:quantity).is_greater_than(0) }
  end
end
