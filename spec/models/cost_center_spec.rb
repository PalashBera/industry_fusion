require "rails_helper"

RSpec.describe CostCenter, type: :model do
  let(:user)        { create(:user) }
  let(:cost_center) { create(:cost_center) }

  before(:each) do
    Organization.current_organization = user.organization
    User.current_user = user
  end

  it_behaves_like "archivable"
  it_behaves_like "modal_formable"
  it_behaves_like "user_trackable"
  it_behaves_like "organization_associable"
  it_behaves_like "timestampble"

  describe "#active_record_columns" do
    it { should have_db_column(:name) }
    it { should have_db_column(:description) }
  end

  describe "#callbacks" do
    context "when name contains extra space" do
      it "should remove extra space" do
        cost_center = build(:cost_center, name: " KFC  ")
        cost_center.valid?
        expect(cost_center.name).to eq ("KFC")
      end
    end
  end

  describe "#associations" do
    it { should have_many(:indent_items) }
  end

  describe "#validations" do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(255) }

    context "when same cost center name present for an organization" do
      let!(:cost_center) { create(:cost_center, name: "Nokia", organization_id: Organization.current_organization.id) }

      it "should not save this cost_center" do
        new_cost_center = build(:cost_center, name: "Nokia", organization_id: Organization.current_organization.id)
        new_cost_center.valid?
        expect(new_cost_center.errors[:name]).to include("has already been taken")
      end
    end
  end

  describe "#scopes" do
    let!(:cost_center_1) { create(:cost_center, name: "Name 1", archive: true) }
    let!(:cost_center_2) { create(:cost_center, name: "Name 2", archive: false) }

    context "order_by_name" do
      it "should return cost centers order by name" do
        expect(CostCenter.order_by_name).to eq([cost_center_1, cost_center_2])
      end
    end
  end
end
