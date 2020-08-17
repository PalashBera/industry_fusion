require "rails_helper"

RSpec.describe Indent, type: :model do
  let(:user)   { create(:user) }
  let(:indent) { create(:indent, requirement_date: Time.zone.now + 10.day) }

  before(:each) do
    ActsAsTenant.stub(:current_tenant).and_return(user.organization)
    User.stub(:current_user).and_return(user)
    Organization.stub(:current_organization).and_return(user.organization)
  end

  it_behaves_like "user_tracking_module"
  it_behaves_like "organization_association_module"
  it_behaves_like "timestamp_module"

  describe "#active_record_columns" do
    it { should have_db_column(:company_id) }
    it { should have_db_column(:warehouse_id) }
    it { should have_db_column(:serial) }
    it { should have_db_column(:requirement_date) }
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
    let!(:indent_1) { create(:indent, requirement_date: Time.zone.now) }
    let!(:indent_2) { create(:indent, requirement_date: Time.zone.now + 1.days) }
    let!(:indent_3) { create(:indent, requirement_date: Time.zone.now + 2.days) }

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
end
