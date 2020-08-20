require "rails_helper"

RSpec.describe Warehouse, type: :model do
  let(:user)      { create(:user) }
  let(:company)   { create(:company) }
  let(:warehouse) { create(:warehouse, company) }

  before(:each) do
    ActsAsTenant.current_tenant = user.organization
    User.current_user = user
  end

  it_behaves_like "address_module"
  it_behaves_like "archive_module"
  it_behaves_like "modal_form_module"
  it_behaves_like "user_tracking_module"
  it_behaves_like "organization_association_module"
  it_behaves_like "timestamp_module"

  describe "#active_record_columns" do
    it { should have_db_column(:company_id) }
    it { should have_db_column(:name) }
    it { should have_db_column(:short_name) }
  end

  describe "#active_record_index" do
    it { should have_db_index(:company_id) }
  end

  describe "#callbacks" do
    context "when name contains extra space" do
      it "should remove extra space" do
        warehouse = build(:warehouse, name: " KFC  ")
        warehouse.valid?
        expect(warehouse.name).to eq ("KFC")
      end
    end
  end

  describe "#associations" do
    it { should belong_to(:company) }

    it { should have_many(:indents) }
    it { should have_many(:warehouse_locations) }
    it { should have_many(:reorder_levels) }
  end

  describe "#validations" do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(255) }
    it { should validate_presence_of(:short_name) }
    it { should validate_length_of(:short_name).is_at_most(3) }

    context "when same warehouse name and short name present for an organization" do
      let!(:warehouse) { create(:warehouse, name: "Nokia", short_name: "AAA") }

      it "should not save this warehouse" do
        new_warehouse = build(:warehouse, name: "Nokia", short_name: "AAA")
        new_warehouse.valid?
        expect(new_warehouse.errors[:name]).to include("has already been taken")
        expect(new_warehouse.errors[:short_name]).to include("has already been taken")
      end
    end
  end

  describe "#scopes" do
    let!(:company_1)   { create :company }
    let!(:company_2)   { create :company }
    let!(:warehouse_1) { create(:warehouse, name: "Name 1", archive: true, company_id: company_1.id) }
    let!(:warehouse_2) { create(:warehouse, name: "Name 2", archive: false, company_id: company_2.id) }

    context "order_by_name" do
      it "should return warehouses order by name" do
        expect(Warehouse.order_by_name).to eq([warehouse_1, warehouse_2])
      end
    end

    context "id_filter" do
      it "should return specific warehouse passed as parameter" do
        expect(Warehouse.id_filter(warehouse_1.id).include?(warehouse_1)).to eq(true)
        expect(Warehouse.id_filter(warehouse_1.id).include?(warehouse_2)).to eq(false)
      end
    end

    context "company_filter" do
      it "should return specific warehouse associated with some company passed as parameter" do
        expect(Warehouse.company_filter(company_1.id).include?(warehouse_1)).to eq(true)
        expect(Warehouse.company_filter(company_1.id).include?(warehouse_2)).to eq(false)
      end
    end
  end
end
