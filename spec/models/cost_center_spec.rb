require "rails_helper"

RSpec.describe CostCenter, type: :model do
  let(:organization) { create(:organization) }
  let!(:cost_center) { create(:cost_center, name: "Toolkit", organization: organization) }

  it_behaves_like "archivable"
  it_behaves_like "modal_formable"

  describe "active record columns" do
    it { should have_db_column(:name) }
    it { should have_db_column(:description) }
    it { should have_db_column(:archive) }
    it { should have_db_column(:organization_id) }
    it { should have_db_column(:created_by_id) }
    it { should have_db_column(:updated_by_id) }
    it { should have_db_column(:created_at) }
    it { should have_db_column(:updated_at) }
  end

  describe "active record index" do
    it { should have_db_index(:organization_id) }
    it { should have_db_index(:created_by_id) }
    it { should have_db_index(:updated_by_id) }
  end

  describe "callbacks" do
    context "when name contains extra space" do
      it "should remove extra space" do
        cost_center = build(:cost_center, name: " Some Reason  ")
        cost_center.valid?
        expect(cost_center.name).to eq ("Some Reason")
      end
    end
  end

  describe "associations" do
    it { should belong_to(:organization) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(255) }
    it { should validate_uniqueness_of(:name).case_insensitive.scoped_to(:organization_id) }
  end

  describe "scopes" do
    context "order_by_name" do
      let!(:cost_center_1) { create(:cost_center, name: "ZARA", organization: organization) }
      let!(:cost_center_2) { create(:cost_center, name: "KFC", organization: organization) }
      it "should return records order by name" do
        expect(organization.cost_centers.order_by_name).to eq([cost_center_2, cost_center, cost_center_1])
      end
    end
  end
end
