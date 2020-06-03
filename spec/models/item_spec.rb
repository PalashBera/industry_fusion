require "rails_helper"

RSpec.describe Item, type: :model do
  let!(:current_user) { create :user }
  before              { User.stub(:current_user).and_return(current_user)  }
  let(:organization)  { create(:organization) }
  let(:uom)           { create(:uom) }
  let!(:secondary_uom) { create :uom }
  let(:item_group)    { create(:item_group) }
  let!(:item)         { create(:item, uom_id: uom.id, secondary_uom_id: secondary_uom.id) }
  let!(:item_1)       { create(:item, uom_id: uom.id, secondary_uom_id: nil) }

  it_behaves_like "archivable"
  it_behaves_like "modal_formable"
  it_behaves_like "nameable"
  it_behaves_like "user_trackable"

  describe "active record columns" do
    it { should have_db_column(:organization_id) }
    it { should have_db_column(:created_by_id) }
    it { should have_db_column(:updated_by_id) }
    it { should have_db_column(:created_at) }
    it { should have_db_column(:updated_at) }
    it { should have_db_column(:uom_id) }
    it { should have_db_column(:item_group_id) }
    it { should have_db_column(:secondary_uom_id) }
    it { should have_db_column(:primary_quantity) }
    it { should have_db_column(:secondary_quantity) }
  end

  describe "active record index" do
    it { should have_db_index(:organization_id) }
    it { should have_db_index(:uom_id) }
    it { should have_db_index(:secondary_uom_id) }
    it { should have_db_index(:item_group_id) }
    it { should have_db_index(:created_by_id) }
    it { should have_db_index(:updated_by_id) }
  end

  describe "associations" do
    it { should belong_to(:organization) }
    it { should belong_to(:uom) }
    it { should belong_to(:secondary_uom).class_name("Uom").optional }
    it { should belong_to(:item_group) }

    it { should have_many(:makes) }
    it { should have_many(:indent_items) }
  end

  describe "validations" do
    context "if secondary uom is present" do
      let(:secondary_uom) { create(:uom) }
      let(:item1)         { build(:item, secondary_uom_id: secondary_uom.id) }

      before { Item.any_instance.stub(:secondary_uom).and_return(true)  }
      it { should validate_presence_of(:primary_quantity) }
      it { should validate_presence_of(:secondary_quantity) }
      it { should validate_numericality_of(:secondary_quantity).is_greater_than(0) }
    end

    context "if secondary uom is absent" do
      before { Item.any_instance.stub(:secondary_uom).and_return(false)  }
      it { should_not validate_presence_of(:primary_quantity) }
      it { should_not validate_presence_of(:secondary_quantity) }
      it { should_not validate_numericality_of(:secondary_quantity).is_greater_than(0) }
    end
  end

  describe "#convertion_equation" do
    context "if secondary uom is present" do
      it "should return conversion equation with secondary uom" do
        expect(item.convertion_equation).to eq("#{item.primary_quantity} #{item.uom.short_name} = #{item.secondary_quantity} #{item.secondary_uom.short_name}")
      end
    end

    context "if secondary uom is absent" do
      it "should return null" do
        expect(item_1.convertion_equation).to eq(nil)
      end
    end
  end
end
