require "rails_helper"

RSpec.describe Item, type: :model do
  let(:user) { create(:user) }
  let(:item) { create(:item) }

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
    it { should have_db_column(:item_group_id) }
    it { should have_db_column(:uom_id) }
    it { should have_db_column(:secondary_uom_id) }
    it { should have_db_column(:primary_quantity) }
    it { should have_db_column(:secondary_quantity) }
  end

  describe "#active_record_index" do
    it { should have_db_index(:item_group_id) }
    it { should have_db_index(:uom_id) }
    it { should have_db_index(:secondary_uom_id) }
  end

  describe "#callbacks" do
    context "when name contains extra space" do
      it "should remove extra space" do
        item = build(:item, name: " KFC  ")
        item.valid?
        expect(item.name).to eq ("KFC")
      end
    end
  end

  describe "#associations" do
    it { should belong_to(:item_group) }
    it { should belong_to(:uom) }
    it { should belong_to(:secondary_uom).class_name("Uom").optional }

    it { should have_many(:makes) }
    it { should have_many(:indent_items) }
    it { should have_many(:reorder_levels) }
  end

  describe "#validations" do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(255) }

    context "when same item name present for an organization" do
      let!(:item) { create(:item, name: "Nokia") }

      it "should not save this item" do
        new_item = build(:item, name: "Nokia")
        new_item.valid?
        expect(new_item.errors[:name]).to include("has already been taken")
      end
    end

    context "if secondary uom is present" do
      let(:secondary_uom) { create(:uom) }
      let(:another_item)  { build(:item, secondary_uom: secondary_uom) }

      before { Item.any_instance.stub(:secondary_uom).and_return(true) }

      it { should validate_presence_of(:primary_quantity) }
      it { should validate_presence_of(:secondary_quantity) }
      it { should validate_numericality_of(:secondary_quantity).is_greater_than(0) }
    end

    context "if secondary uom is absent" do
      before { Item.any_instance.stub(:secondary_uom).and_return(false) }

      it { should_not validate_presence_of(:primary_quantity) }
      it { should_not validate_presence_of(:secondary_quantity) }
      it { should_not validate_numericality_of(:secondary_quantity).is_greater_than(0) }
    end
  end

  describe "#scopes" do
    let!(:item_1) { create(:item, name: "Name 1", archive: true) }
    let!(:item_2) { create(:item, name: "Name 2", archive: false) }

    context "order_by_name" do
      it "should return items order by name" do
        expect(Item.order_by_name).to eq([item_1, item_2])
      end
    end
  end

  describe "#convertion_equation" do
    context "if secondary uom is present" do
      it "should return conversion equation with secondary uom" do
        expect(item.convertion_equation).to eq("#{item.primary_quantity} #{item.uom.short_name} = #{item.secondary_quantity} #{item.secondary_uom.short_name}")
      end
    end

    context "if secondary uom is absent" do
      before { Item.any_instance.stub(:secondary_uom).and_return(false)  }

      it "should return null" do
        expect(item.convertion_equation).to eq(nil)
      end
    end
  end

  describe "#uoms" do
    let!(:uom_1) { create(:uom) }
    let!(:uom_2) { create(:uom) }
    let!(:item)  { create(:item, uom_id: uom_1.id, secondary_uom_id: uom_2.id) }

    it "should return associated uoms" do
      expect(item.uoms.include?(uom_1)).to eq(true)
      expect(item.uoms.include?(uom_2)).to eq(true)
    end
  end
end
