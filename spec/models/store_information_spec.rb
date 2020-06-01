require "rails_helper"

RSpec.describe StoreInformation, type: :model do
  let!(:resource) { create(:store_information, name: " Salt Lake City Khaitan  ", pan_number: "eqtfc6151k", gstn: "11eqtfc6151k3zv") }

  it_behaves_like "addressable"

  describe "active record columns" do
    it { should have_db_column(:name) }
    it { should have_db_column(:pan_number) }
    it { should have_db_column(:gstn) }
    it { should have_db_column(:created_at) }
    it { should have_db_column(:updated_at) }
  end

  describe "active record index" do
    it { should have_db_index(:vendor_id) }
  end

  describe "callbacks" do
    context "when we want to get squished name, pan_number & gstn" do
      it "should return squished name of store" do
        expect(resource.name).to eq ("Salt Lake City Khaitan")
      end

      it "should return squished & capitalized pan_number of store" do
        expect(resource.pan_number).to eq ("EQTFC6151K")
      end

      it "should return squished & capitalized gstn of store" do
        expect(resource.gstn).to eq ("11EQTFC6151K3ZV")
      end
    end
  end

  describe "associations" do
    it { should belong_to(:vendor) }
  end

  describe "#validattions" do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(255) }
    it { should validate_uniqueness_of(:name).case_insensitive }
    it { should validate_length_of(:pan_number).is_at_most(10) }
    it { should validate_uniqueness_of(:pan_number).case_insensitive }
    it { should_not allow_value("test@test").for(:pan_number) }
    it { should validate_length_of(:gstn).is_at_most(15) }
    it { should validate_uniqueness_of(:gstn).case_insensitive }
    it { should_not allow_value("test@test").for(:gstn) }
  end
end
