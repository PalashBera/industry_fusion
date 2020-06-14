require "rails_helper"

RSpec.describe Warehouse, type: :model do
  let(:user)      { create(:user) }
  let(:company)   { create(:company) }
  let(:warehouse) { create(:warehouse, company) }

  before(:each) do
    ActsAsTenant.stub(:current_tenant).and_return(user.organization)
    User.stub(:current_user).and_return(user)
  end

  it_behaves_like "addressable"
  it_behaves_like "modal_formable"
  it_behaves_like "user_trackable"
  it_behaves_like "organization_associable"
  it_behaves_like "timestampble"

  describe "#active_record_columns" do
    it { should have_db_column(:company_id) }
    it { should have_db_column(:name) }
    it { should have_db_column(:short_name) }
    it { should have_db_column(:archive) }
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

    context "when short name contains extra space" do
      it "should remove extra space" do
        warehouse = build(:warehouse, short_name: " SBC ")
        warehouse.valid?
        expect(warehouse.short_name).to eq ("SBC")
      end
    end

    context "when short name is not in upcase" do
      it "should make short name in upcase" do
        warehouse = build(:warehouse, short_name: " sbc ")
        warehouse.valid?
        expect(warehouse.short_name).to eq ("SBC")
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
    let!(:warehouse_1) { create(:warehouse, name: "Name 1", archive: true) }
    let!(:warehouse_2) { create(:warehouse, name: "Name 2", archive: false) }

    context "order_by_name" do
      it "should return warehouses order by name" do
        expect(Warehouse.order_by_name).to eq([warehouse_1, warehouse_2])
      end
    end

    context "archived" do
      it "should return archived warehouses" do
        expect(Warehouse.archived.include?(warehouse_1)).to eq(true)
        expect(Warehouse.archived.include?(warehouse_2)).to eq(false)
      end
    end

    context "non-archived" do
      it "should return non-archived warehouses" do
        expect(Warehouse.non_archived.include?(warehouse_1)).to eq(false)
        expect(Warehouse.non_archived.include?(warehouse_2)).to eq(true)
      end
    end
  end

  describe "#archived?" do
    let!(:warehouse_1) { create(:warehouse, name: "Name 1", archive: true) }
    let!(:warehouse_2) { create(:warehouse, name: "Name 2", archive: false) }

    it "should return true for archived warehouses" do
      expect(warehouse_1.archived?).to eq(true)
      expect(warehouse_2.archived?).to eq(false)
    end
  end

  describe "#non_archived?" do
    let!(:warehouse_1) { create(:warehouse, name: "Name 1", archive: true) }
    let!(:warehouse_2) { create(:warehouse, name: "Name 2", archive: false) }

    it "should return true for non-archived warehouses" do
      expect(warehouse_1.non_archived?).to eq(false)
      expect(warehouse_2.non_archived?).to eq(true)
    end
  end

  describe "#archived_status" do
    let!(:warehouse_1) { create(:warehouse, name: "Name 1", archive: true) }
    let!(:warehouse_2) { create(:warehouse, name: "Name 2", archive: false) }

    context "when record is archived" do
      it "should return Archived" do
        expect(warehouse_1.archived_status).to eq("Archived")
      end
    end

    context "when record is non-archived" do
      it "should return Active" do
        expect(warehouse_2.archived_status).to eq("Active")
      end
    end
  end
end
