require "rails_helper"

RSpec.describe WarehouseLocation, type: :model do
  let(:user)     { create :user }
  let(:location) { create(:warehouse_location) }

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
    it { should have_db_column(:name) }
    it { should have_db_column(:warehouse_id) }
  end

  describe "#active_record_index" do
    it { should have_db_index(:warehouse_id) }
  end

  describe "#associations" do
    it { should belong_to(:warehouse) }
  end

  describe "#callbacks" do
    context "when name contains extra space" do
      it "should remove extra space" do
        warehouse_location = build(:warehouse_location, name: " KFC  ")
        warehouse_location.valid?
        expect(warehouse_location.name).to eq ("KFC")
      end
    end
  end

  describe "#validations" do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(255) }

    context "when same warehouse location name present for an organization and warehouse" do
      let!(:warehouse)          { create(:warehouse) }
      let!(:warehouse_location) { create(:warehouse_location, name: "Nokia", warehouse: warehouse) }

      it "should not save this warehouse location" do
        new_warehouse_location = build(:warehouse_location, name: "Nokia", warehouse_id: warehouse.id)
        new_warehouse_location.valid?
        expect(new_warehouse_location.errors[:name]).to include("has already been taken")
      end
    end
  end

  describe "#scopes" do
    context "order_by_name" do
      let!(:warehouse_location_1) { create(:warehouse_location, name: "Name 1") }
      let!(:warehouse_location_2) { create(:warehouse_location, name: "Name 2") }

      it "should return warehouse locations order by name" do
        expect(WarehouseLocation.order_by_name).to eq([warehouse_location_1, warehouse_location_2])
      end
    end
  end
end
