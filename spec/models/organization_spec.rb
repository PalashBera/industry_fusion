require "rails_helper"

RSpec.describe Organization, type: :model do
  let(:user)         { create(:user) }

  before(:each) do
    ActsAsTenant.current_tenant = user.organization
    User.current_user = user
  end

  it_behaves_like "archive_module"
  it_behaves_like "user_tracking_module"
  it_behaves_like "timestamp_module"

  describe "#active_record_columns" do
    it { should have_db_column(:name) }
    it { should have_db_column(:fy_start_month) }
    it { should have_db_column(:page_help_needed) }
    it { should have_db_column(:send_master_notification) }
  end

  describe "#callbacks" do
    context "when name contains extra space" do
      it "should remove extra space" do
        organization = build(:organization, name: " Industry  Fusion ")
        organization.valid?
        expect(organization.name).to eq("Industry Fusion")
      end
    end
  end

  describe "#associations" do
    it { should have_many(:users) }
    it { should have_many(:companies) }
    it { should have_many(:warehouses) }
    it { should have_many(:brands) }
    it { should have_many(:uoms) }
    it { should have_many(:item_groups) }
    it { should have_many(:cost_centers) }
    it { should have_many(:items) }
    it { should have_many(:makes) }
    it { should have_many(:indents) }
    it { should have_many(:indent_items) }
    it { should have_many(:vendorships) }
    it { should have_many(:warehouse_locations) }
    it { should have_many(:reorder_levels) }
    it { should have_many(:approval_levels) }
    it { should have_many(:vendors) }
  end

  describe "#validations" do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(255) }
    it { should validate_presence_of(:fy_start_month) }
  end

  describe "#scopes" do
    context "order_by_name" do
      let!(:org_1) { create(:organization, name: "ZARA Private Limited") }
      let!(:org_2) { create(:organization, name: "KFC Private Limited") }

      it "should return records order by name" do
        expect(Organization.where(name: ["Industry Fusion", "ZARA Private Limited", "KFC Private Limited"]).order_by_name).to eq([org_2, org_1])
      end
    end
  end

  describe "#fy_date_range" do
    let(:organization_1)   { create :organization, fy_start_month: 1 }
    let(:organization_2) { create :organization, fy_start_month: 3 }

    context "when fy_start_month is january" do
      it "it should return fy_start_month and fy_end_month as an array" do
        fy_date_range = [Date.new(Time.zone.now.year, organization_1.fy_start_month, 1), Date.civil(Time.zone.now.year, 12, -1)]
        expect(organization_1.fy_date_range).to eq(fy_date_range)
      end
    end

    context "when fy_start_month is not january" do
      it "it should return fy_start_month and fy_end_month as an array" do
        fy_date_range = [Date.new(Time.zone.now.year, organization_2.fy_start_month, 1), Date.civil(Time.zone.now.year + 1, 2, -1)]
        expect(organization_2.fy_date_range).to eq(fy_date_range)
      end
    end
  end
end
