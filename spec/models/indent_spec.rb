require "rails_helper"

RSpec.describe Indent, type: :model do
  let(:user)   { create(:user) }
  let(:indent) { create(:indent) }

  before(:each) do
    ActsAsTenant.current_tenant = user.organization
    User.current_user = user
    Organization.stub(:current_organization).and_return(user.organization)
  end

  it_behaves_like "user_tracking_module"
  it_behaves_like "organization_association_module"
  it_behaves_like "timestamp_module"

  describe "#active_record_columns" do
    it { should have_db_column(:company_id) }
    it { should have_db_column(:warehouse_id) }
    it { should have_db_column(:serial) }
    it { should have_db_column(:serial_number) }
  end

  describe "#active_record_index" do
    it { should have_db_index(:company_id) }
    it { should have_db_index(:warehouse_id) }
  end

  describe "#callbacks" do
    it { is_expected.to callback(:set_serial_number).before(:validation).on(:create) }
  end

  describe "#associations" do
    it { should belong_to(:company) }
    it { should belong_to(:warehouse) }
    it { should belong_to(:indentor).optional }

    it { should have_many(:indent_items) }
  end

  describe "#validations" do
    it { should accept_nested_attributes_for(:indent_items).allow_destroy(true) }
  end

  describe "#order_by_serial" do
    let!(:indent_1) { create(:indent) }
    let!(:indent_2) { create(:indent) }
    let!(:indent_3) { create(:indent) }

    it "should return records ordered by serial" do
      expect(Indent.order_by_serial).to eq([indent_1, indent_2, indent_3])
    end
  end

  describe "#date_range_filter" do
    let!(:indent_1) { create(:indent, created_at: Time.zone.now) }
    let!(:indent_2) { create(:indent, created_at: Time.zone.now + 1.days) }
    let!(:indent_3) { create(:indent, created_at: Time.zone.now - 380.days) }

    it "should return records filtered in a specific date range" do
      start_date, end_date = indent_1.organization.fy_date_range
      filtered_records = Indent.date_range_filter(start_date, end_date)
      expect(filtered_records.include?(indent_1)).to eq(true)
      expect(filtered_records.include?(indent_2)).to eq(true)
      expect(filtered_records.include?(indent_3)).to eq(false)
    end
  end

  describe "#warehouse_filter" do
    let!(:warehouse_1)  { create(:warehouse) }
    let!(:warehouse_2)  { create(:warehouse) }
    let!(:indent_1)     { create(:indent, warehouse_id: warehouse_1.id) }
    let!(:indent_2)     { create(:indent, warehouse_id: warehouse_2.id) }

    it "should return records filtered with warehouse" do
      filtered_records = Indent.warehouse_filter(warehouse_1.id)
      expect(filtered_records.include?(indent_1)).to eq(true)
      expect(filtered_records.include?(indent_2)).to eq(false)
    end
  end

  describe "#indent_item_vs_item" do
    let(:non_current_user)  { create :user }
    let!(:diff_warehouse)   { create :warehouse }
    let!(:diff_item)        { create :item }
    let!(:diff_indent)      { create :indent, warehouse_id: diff_warehouse.id}
    let!(:diff_indent_item) { create :indent_item, indent_id: diff_indent.id, item_id: diff_item.id }

    let!(:warehouse)   { create :warehouse }
    let!(:item)        { create :item }
    let!(:indent_item) { create :indent_item, indent_id: indent.id, item_id: item.id }

    before do
      indent.update!(warehouse_id: warehouse.id)
      user.update!(warehouse_ids: [warehouse.id])
      non_current_user.update!(warehouse_ids: [diff_warehouse.id])
    end

    it "should return indent item & item as result" do
      item_names, indent_items_count = Indent.indent_item_vs_item

      expect(item_names).to include(item.name)
      expect(indent_items_count).to include(1)
    end

    it "should not return indent item & item which are associated with different warehouse & user as result" do
      item_names, indent_items_count = Indent.indent_item_vs_item

      expect(item_names).not_to include(diff_item.name)
    end
  end


  describe "#indent_item_vs_cost_center" do
    let(:non_current_user)  { create :user }
    let!(:diff_warehouse)   { create :warehouse }
    let!(:diff_cost_center) { create :cost_center }
    let!(:diff_indent)      { create :indent, warehouse_id: diff_warehouse.id}
    let!(:diff_indent_item) { create :indent_item, indent_id: diff_indent.id, cost_center_id: diff_cost_center.id }

    let!(:warehouse)   { create :warehouse }
    let!(:cost_center) { create :cost_center }
    let!(:indent_item) { create :indent_item, indent_id: indent.id, cost_center_id: cost_center.id }

    before do
      indent.update!(warehouse_id: warehouse.id)
      user.update!(warehouse_ids: [warehouse.id])
      non_current_user.update!(warehouse_ids: [diff_warehouse.id])
    end

    it "should return indent item & cost center as result" do
      cost_center_names, indent_items_count = Indent.indent_item_vs_cost_center

      expect(cost_center_names).to include(cost_center.name)
      expect(indent_items_count).to include(1)
    end

    it "should not return indent item & cost center which are associated with different warehouse & user as result" do
      cost_center_names, indent_items_count = Indent.indent_item_vs_cost_center

      expect(cost_center_names).not_to include(diff_cost_center.name)
    end
  end
end
