require "rails_helper"

RSpec.describe ItemGroup, type: :model do
  let(:user)       { create(:user) }
  let(:item_group) { create(:item_group) }

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
    it { should have_db_column(:description) }
    it { should have_db_column(:hsn_code) }
  end

  describe "#callbacks" do
    context "when name contains extra space" do
      it "should remove extra space" do
        item_group = build(:item_group, name: " KFC  ")
        item_group.valid?
        expect(item_group.name).to eq ("KFC")
      end
    end
  end

  describe "#associations" do
    it { should have_many(:items) }
  end

  describe "#validations" do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(255) }
    it { should validate_length_of(:hsn_code).is_at_least(6).is_at_most(8) }

    context "when same item group name present for an organization" do
      let!(:item_group) { create(:item_group, name: "Nokia") }

      it "should not save this item group" do
        new_item_group = build(:item_group, name: "Nokia")
        new_item_group.valid?
        expect(new_item_group.errors[:name]).to include("has already been taken")
      end
    end
  end

  describe "#scopes" do
    let!(:item_group_1) { create(:item_group, name: "Name 1", archive: true) }
    let!(:item_group_2) { create(:item_group, name: "Name 2", archive: false) }

    context "order_by_name" do
      it "should return item group order by name" do
        expect(ItemGroup.order_by_name).to eq([item_group_1, item_group_2])
      end
    end
  end
end
