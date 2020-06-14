require "rails_helper"

RSpec.describe ItemGroup, type: :model do
  let(:user)       { create(:user) }
  let(:item_group) { create(:item_group) }

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
    it { should have_db_column(:description) }
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
