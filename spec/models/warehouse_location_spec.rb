require "rails_helper"

RSpec.describe WarehouseLocation, type: :model do
  let!(:current_user) { create :user }
  before              { User.stub(:current_user).and_return(current_user)  }
  let(:warehouse)     { create(:warehouse) }
  let(:nameable_org)  { create(:organization) }
  let!(:location)     { create(:warehouse_location, name: "Name3", warehouse_id: warehouse.id, organization_id: nameable_org.id) }

  it_behaves_like "archivable"
  it_behaves_like "modal_formable"
  it_behaves_like "user_trackable"

  describe "active record columns" do
    it { should have_db_column(:organization_id) }
    it { should have_db_column(:created_by_id) }
    it { should have_db_column(:updated_by_id) }
    it { should have_db_column(:created_at) }
    it { should have_db_column(:updated_at) }
    it { should have_db_column(:warehouse_id) }
    it { should have_db_column(:name) }
  end

  describe "active record index" do
    it { should have_db_index(:organization_id) }
    it { should have_db_index(:warehouse_id) }
    it { should have_db_index(:created_by_id) }
    it { should have_db_index(:updated_by_id) }
  end

  describe "associations" do
    it { should belong_to(:organization) }
    it { should belong_to(:warehouse) }
  end

  describe "callbacks" do
    context "when name contains extra space" do
      it "should remove extra space" do
        record_1 = build(described_class.to_s.underscore.to_sym, name: " KFC  ")
        record_1.valid?
        expect(record_1.name).to eq ("KFC")
      end
    end
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(255) }
    it { should validate_uniqueness_of(:name).case_insensitive.scoped_to([:organization_id, :warehouse_id]) }
  end

  describe "scopes" do
    context "order_by_name" do
      let(:record_1) { create(described_class.to_s.underscore.to_sym, name: "Name 1", organization: nameable_org) }
      let(:record_2) { create(described_class.to_s.underscore.to_sym, name: "Name 2", organization: nameable_org) }

      it "should return records order by name" do
        expect(nameable_org.public_send(described_class.to_s.pluralize.underscore).order_by_name).to eq([record_1, record_2, location])
      end
    end
  end
end
