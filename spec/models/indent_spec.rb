require "rails_helper"

RSpec.describe Indent, type: :model do
  let!(:user)         { create :user }
  let!(:organization) { create(:organization) }
  let!(:indent)       { create(:indent, organization: organization, requirement_date: Time.zone.now + 1.day) }
  let!(:indent_1)     { create(:indent, organization: organization, requirement_date: Time.zone.now) }
  let!(:indent_2)     { create(:indent, organization: organization, requirement_date: Time.zone.now + 2.days) }
  let!(:indent_3)     { create(:indent, organization: organization, requirement_date: Time.zone.now + 2.days) }

  before { User.stub(:current_user).and_return(user) }

  it_behaves_like "user_trackable"

  describe "#active_record_columns" do
    it { should have_db_column(:organization_id) }
    it { should have_db_column(:created_by_id) }
    it { should have_db_column(:updated_by_id) }
    it { should have_db_column(:created_at) }
    it { should have_db_column(:updated_at) }
    it { should have_db_column(:company_id) }
    it { should have_db_column(:warehouse_id) }
    it { should have_db_column(:serial) }
    it { should have_db_column(:requirement_date) }
  end

  describe "#active_record_index" do
    it { should have_db_index(:organization_id) }
    it { should have_db_index(:company_id) }
    it { should have_db_index(:warehouse_id) }
    it { should have_db_index(:created_by_id) }
    it { should have_db_index(:updated_by_id) }
  end

  describe "#associations" do
    it { should belong_to(:organization) }
    it { should belong_to(:company) }
    it { should belong_to(:warehouse) }

    it { should have_many(:indent_items) }
  end

  describe "#callbacks" do
    it { is_expected.to callback(:set_serial).before(:create) }
  end

  describe "#order_by_serial" do
    it "should return records ordered by serial" do
      expect(organization.indents.order_by_serial).to eq([indent, indent_1, indent_2, indent_3])
    end
  end

  describe "#filter_with_date_range" do
    it "should return records filtered in a specific date range" do
      expect(organization.indents.filter_with_date_range(Time.zone.now, Time.zone.now + 1.days).order_by_serial).to eq([indent, indent_1])
    end
  end

  describe "#serial_number" do
    it "should return the serial number of the indent" do
      expect(indent_3.serial_number).to eq("IND/20-21/#{indent_3.company.short_name}/#{indent_3.warehouse.short_name}/#{indent_3.serial.to_s.rjust(4, "0")}")
    end
  end
end
