require "rails_helper"

RSpec.describe Indent, type: :model do
  let!(:current_user) { create :user }
  before              { User.stub(:current_user).and_return(current_user)  }
  let!(:indent_1)     { create(:indent, serial: 2, requirement_date: Time.zone.now) }
  let!(:indent)       { create(:indent, serial: 1, requirement_date: Time.zone.now + 1.day) }
  let!(:indent_2)     { create(:indent, serial: 3, requirement_date: Time.zone.now + 2.days) }
  let!(:indent_3)     { create(:indent, requirement_date: Time.zone.now + 2.days) }

  it_behaves_like "user_trackable"

  describe "active record columns" do
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

  describe "active record index" do
    it { should have_db_index(:organization_id) }
    it { should have_db_index(:company_id) }
    it { should have_db_index(:warehouse_id) }
    it { should have_db_index(:created_by_id) }
    it { should have_db_index(:updated_by_id) }
  end

  describe "associations" do
    it { should belong_to(:organization) }
    it { should belong_to(:company) }
    it { should belong_to(:warehouse) }

    it { should have_many(:indent_items) }
  end

  describe "#callbacks" do
    it { is_expected.to callback(:set_serial).before(:create) }
  end

  describe "#order_by_serial" do
    context "when we want records ordered by serial" do
      it "should return records ordered by serial" do
        expect(Indent.where(serial: [1, 2, 3]).order_by_serial).to eq([indent_1, indent, indent_2])
      end
    end
  end

  describe "#filter_with_date_range" do
    context "when we want records filtered in a specific date range" do
      it "should return records filtered in a specific date range" do
        expect(Indent.where(serial: [1,2,3]).filter_with_date_range(Time.zone.now, Time.zone.now + 1.days).order_by_serial).to eq([indent_1, indent])
      end
    end
  end

  # describe "#fy_date_range" do
  #   context "when we want to get financial year range" do
  #     it "should return financial year range" do
  #       expect(indent_1.fy_date_range).to eq([Date.new(Time.zone.now.year, 4, 1), Date.new(Time.zone.now.year + 1, 3, 30)])
  #     end
  #   end
  # end

  describe "#set_serial" do
    context "when we want to get serial_number of the indent" do
      it "should return serial_number of the indent" do
        expect(indent_3.serial).to eq(4)
      end
    end
  end

  describe "#serial_number" do
    context "when we want to get serial number of the indent" do
      it "should return the serial number of the indent" do
        expect(indent_3.serial_number).to eq("IND/20-21/#{indent_3.company.short_name}/#{indent_3.warehouse.short_name}/#{indent_3.serial.to_s.rjust(4, "0")}")
      end
    end
  end
end
