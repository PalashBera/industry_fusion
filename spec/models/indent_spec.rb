require "rails_helper"

RSpec.describe Indent, type: :model do
  let(:user)   { create :user }
  let(:indent) { create(:indent, requirement_date: Time.zone.now + 10.day) }

  before(:each) do
    ActsAsTenant.stub(:current_tenant).and_return(user.organization)
    User.stub(:current_user).and_return(user)
  end

  it_behaves_like "user_trackable"
  it_behaves_like "organization_associable"
  it_behaves_like "timestampble"

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

  describe "#associations" do
    it { should belong_to(:company) }
    it { should belong_to(:warehouse) }

    it { should have_many(:indent_items) }
  end

  describe "#callbacks" do
    it { is_expected.to callback(:set_serial).before(:create) }
  end

  describe "#order_by_serial" do
    let!(:indent_1) { create(:indent, requirement_date: Time.zone.now) }
    let!(:indent_2) { create(:indent, requirement_date: Time.zone.now + 1.days) }
    let!(:indent_3) { create(:indent, requirement_date: Time.zone.now + 2.days) }

    it "should return records ordered by serial" do
      expect(Indent.order_by_serial).to eq([indent_1, indent_2, indent_3])
    end
  end

  describe "#filter_with_date_range" do
    let!(:indent_1) { create(:indent, requirement_date: Time.zone.now) }
    let!(:indent_2) { create(:indent, requirement_date: Time.zone.now + 1.days) }
    let!(:indent_3) { create(:indent, requirement_date: Time.zone.now + 2.days) }

    it "should return records filtered in a specific date range" do
      filtered_records = Indent.filter_with_date_range(Time.zone.now, Time.zone.now + 1.days).order_by_serial
      expect(filtered_records.include?(indent_1)).to eq(true)
      expect(filtered_records.include?(indent_2)).to eq(true)
      expect(filtered_records.include?(indent_3)).to eq(false)
    end
  end

  describe "#serial_number" do
    let!(:indent) { create(:indent, requirement_date: Time.zone.now + 10.day) }

    it "should return the serial number of the indent" do
      serial = "IND/20-21/#{indent.company.short_name}/#{indent.warehouse.short_name}/#{indent.serial.to_s.rjust(4, "0")}"
      expect(indent.serial_number).to eq(serial)
    end
  end
end
