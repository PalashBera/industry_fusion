require "rails_helper"

RSpec.describe ReorderLevel, type: :model do
  let(:user)          { create(:user) }
  let(:reorder_level) { create(:reorder_level) }

  before(:each) do
    ActsAsTenant.current_tenant = user.organization
    User.current_user = user
  end

  it_behaves_like "archive_module"
  it_behaves_like "modal_form_module"
  it_behaves_like "user_tracking_module"
  it_behaves_like "organization_association_module"
  it_behaves_like "timestamp_module"

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

  describe "#enums" do
    it { should define_enum_for(:priority).with_values(default: "default", high: "high", medium: "medium", low: "low").backed_by_column_of_type(:string).with_suffix }
  end

  describe "#associations" do
    it { should belong_to(:warehouse) }
    it { should belong_to(:item) }
  end

  describe "#validations" do
    it { should validate_presence_of(:quantity) }
    it { should validate_numericality_of(:quantity).is_greater_than(0) }
    it { should validate_presence_of(:priority) }
  end

  describe "#quantity_with_uom" do
    let!(:uom)           { create(:uom, short_name: "Ft") }
    let!(:item)          { create(:item, uom_id: uom.id) }
    let!(:reorder_level) { create(:reorder_level, quantity: 10, item_id: item.id) }

    it "should return quantity with uom" do
      expect(reorder_level.quantity_with_uom).to eq("10.0 Ft")
    end
  end
end
