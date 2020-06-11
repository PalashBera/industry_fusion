require "rails_helper"

RSpec.describe IndentItem, type: :model do
  let!(:user)        { create :user }
  let!(:uom)         { create(:uom, short_name: "KG") }
  let!(:indent)      { create :indent }
  let!(:indent_item) { create(:indent_item, indent: indent, uom: uom, quantity: 10) }

  before { User.stub(:current_user).and_return(user) }

  it_behaves_like "user_trackable"

  describe "#active_record_columns" do
    it { should have_db_column(:organization_id) }
    it { should have_db_column(:created_by_id) }
    it { should have_db_column(:updated_by_id) }
    it { should have_db_column(:created_at) }
    it { should have_db_column(:updated_at) }
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
    it { should have_db_index(:organization_id) }
    it { should have_db_index(:indent_id) }
    it { should have_db_index(:cost_center_id) }
    it { should have_db_index(:item_id) }
    it { should have_db_index(:make_id) }
    it { should have_db_index(:uom_id) }
    it { should have_db_index(:created_by_id) }
    it { should have_db_index(:updated_by_id) }
  end

  describe "#associations" do
    it { should belong_to(:organization) }
    it { should belong_to(:indent) }
    it { should belong_to(:cost_center) }
    it { should belong_to(:item) }
    it { should belong_to(:make).optional }
    it { should belong_to(:uom) }
  end

  describe "#validations" do
    it { should validate_presence_of(:quantity) }
    it { should validate_presence_of(:priority) }
    it { should validate_numericality_of(:quantity).is_greater_than(0) }
  end

  describe "#quantity_with_uom" do
    it "should return quantity with uom of indent item" do
      expect(indent_item.quantity_with_uom).to eq("10.0 KG")
    end
  end
end
