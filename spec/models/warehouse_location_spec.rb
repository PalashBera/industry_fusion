require "rails_helper"

RSpec.describe WarehouseLocation, type: :model do
  let(:user)     { create :user }
  let(:location) { create(:warehouse_location) }

  before(:each) do
    ActsAsTenant.stub(:current_tenant).and_return(user.organization)
    User.stub(:current_user).and_return(user)
  end

  it_behaves_like "archivable"
  it_behaves_like "modal_formable"
  it_behaves_like "user_trackable"
  it_behaves_like "organization_associable"
  it_behaves_like "timestampble"

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
        record_1 = build(described_class.to_s.underscore.to_sym, name: " KFC  ")
        record_1.valid?
        expect(record_1.name).to eq ("KFC")
      end
    end
  end

  describe "#validations" do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(255) }
    it { should validate_uniqueness_of(:name).case_insensitive.scoped_to([:organization_id, :warehouse_id]) }
  end

  describe "#scopes" do
    context "order_by_name" do
      let!(:record_1) { create(described_class.to_s.underscore.to_sym, name: "Name 1") }
      let!(:record_2) { create(described_class.to_s.underscore.to_sym, name: "Name 2") }

      it "should return records order by name" do
        expect(user.organization.warehouse_locations.order_by_name).to eq([record_1, record_2])
      end
    end
  end
end
