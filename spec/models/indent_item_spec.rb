require "rails_helper"

RSpec.describe IndentItem, type: :model do
  let(:user)        { create(:user) }
  let(:indent_item) { create(:indent_item) }

  before(:each) do
    ActsAsTenant.stub(:current_tenant).and_return(user.organization)
    User.stub(:current_user).and_return(user)
  end

  it_behaves_like "user_tracking_module"
  it_behaves_like "organization_association_module"
  it_behaves_like "timestamp_module"

  describe "#active_record_columns" do
    it { should have_db_column(:indent_id) }
    it { should have_db_column(:item_id) }
    it { should have_db_column(:make_id) }
    it { should have_db_column(:uom_id) }
    it { should have_db_column(:cost_center_id) }
    it { should have_db_column(:quantity) }
    it { should have_db_column(:note) }
    it { should have_db_column(:priority) }
  end

  describe "#active_record_index" do
    it { should have_db_index(:indent_id) }
    it { should have_db_index(:item_id) }
    it { should have_db_index(:make_id) }
    it { should have_db_index(:uom_id) }
    it { should have_db_index(:cost_center_id) }
  end

  describe "#associations" do
    it { should belong_to(:indent) }
    it { should belong_to(:item) }
    it { should belong_to(:make).optional }
    it { should belong_to(:uom) }
    it { should belong_to(:cost_center) }
  end

  describe "#validations" do
    it { should validate_presence_of(:quantity) }
    it { should validate_presence_of(:priority) }
    it { should validate_numericality_of(:quantity).is_greater_than(0) }
  end

  describe "#quantity_with_uom" do
    let!(:indent_item) { create(:indent_item) }

    it "should return quantity with uom of indent item" do
      quantity_with_uom = "#{indent_item.quantity} #{indent_item.uom.short_name}"
      expect(indent_item.quantity_with_uom).to eq(quantity_with_uom)
    end
  end
end
