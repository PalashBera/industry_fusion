require "rails_helper"

RSpec.describe Uom, type: :model do
  let(:organization) { create(:organization) }
  let!(:uom)         { create(:uom, name: "Kilograms", short_name: "KG", organization: organization) }

  it_behaves_like "archivable"
  it_behaves_like "modal_formable"
  it_behaves_like "nameable"

  describe "active record columns" do
    it { should have_db_column(:short_name) }
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
    context "when short_name contains extra space" do
      it "should remove extra space" do
        uom = build(:uom, short_name: " Kg  ")
        uom.valid?
        expect(uom.short_name).to eq ("Kg")
      end
    end
  end

  describe "associations" do
    it { should belong_to(:organization) }
  end

  describe "validations" do
    it { should validate_presence_of(:short_name) }
    it { should validate_length_of(:short_name).is_at_most(4) }
    it { should validate_uniqueness_of(:short_name).case_insensitive.scoped_to(:organization_id) }
  end

  describe "scopes" do
    context "order_by_short_name" do
      let!(:uom_1) { create(:uom, short_name: "Dzn", organization: organization) }
      let!(:uom_2) { create(:uom, short_name: "mm", organization: organization) }
      it "should return records order by short name" do
        expect(organization.uoms.order_by_short_name).to eq([uom_1, uom, uom_2])
      end
    end
  end
end
