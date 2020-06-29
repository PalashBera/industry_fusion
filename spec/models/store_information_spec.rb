require "rails_helper"

RSpec.describe StoreInformation, type: :model do
  let(:store_information) { create(:store_information) }

  it_behaves_like "address_module"
  it_behaves_like "timestamp_module"

  describe "#active_record_columns" do
    it { should have_db_column(:name) }
    it { should have_db_column(:pan_number) }
    it { should have_db_column(:gstn) }
  end

  describe "#active_record_index" do
    it { should have_db_index(:vendor_id) }
  end

  describe "#callbacks" do
    context "when name contains extra spaces" do
      it "should remove extra spaces" do
        store_information = build(:store_information, name: " Industry  Fusion ")
        store_information.valid?
        expect(store_information.name).to eq("Industry Fusion")
      end
    end

    context "when PAN number is not capitalize" do
      it "should capitalized PAN number" do
        store_information = build(:store_information, pan_number: "bnepb7758n")
        store_information.valid?
        expect(store_information.pan_number).to eq("BNEPB7758N")
      end
    end

    context "when GST number is not capitalize" do
      it "should capitalized GST number" do
        store_information = build(:store_information, gstn: "29bnepb7758n2z9")
        store_information.valid?
        expect(store_information.gstn).to eq("29BNEPB7758N2Z9")
      end
    end
  end

  describe "#associations" do
    it { should belong_to(:vendor) }
  end

  describe "#validattions" do
    let!(:store_information) { create(:store_information) }

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
