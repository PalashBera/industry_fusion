require "rails_helper"

RSpec.describe Brand, type: :model do
  let(:user)  { create(:user) }
  let(:brand) { create(:brand) }

  before(:each) do
    ActsAsTenant.stub(:current_tenant).and_return(user.organization)
    User.stub(:current_user).and_return(user)
  end

  it_behaves_like "modal_formable"
  it_behaves_like "user_trackable"
  it_behaves_like "organization_associable"
  it_behaves_like "timestampble"

  describe "#active_record_columns" do
    it { should have_db_column(:name) }
    it { should have_db_column(:archive) }
  end

  describe "#callbacks" do
    context "when name contains extra space" do
      it "should remove extra space" do
        brand = build(:brand, name: " KFC  ")
        brand.valid?
        expect(brand.name).to eq ("KFC")
      end
    end
  end

  describe "#associations" do
    it { should have_many(:makes) }
  end

  describe "#validations" do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(255) }

    context "when same brand name present for an organization" do
      let!(:brand) { create(:brand, name: "Nokia") }

      it "should not save this brand" do
        new_brand = build(:brand, name: "Nokia")
        new_brand.valid?
        expect(new_brand.errors[:name]).to include("has already been taken")
      end
    end
  end

  describe "#scopes" do
    let!(:brand_1) { create(:brand, name: "Name 1", archive: true) }
    let!(:brand_2) { create(:brand, name: "Name 2", archive: false) }

    context "order_by_name" do
      it "should return brands order by name" do
        expect(Brand.order_by_name).to eq([brand_1, brand_2])
      end
    end

    context "archived" do
      it "should return archived brands" do
        expect(Brand.archived.include?(brand_1)).to eq(true)
        expect(Brand.archived.include?(brand_2)).to eq(false)
      end
    end

    context "non-archived" do
      it "should return non-archived brands" do
        expect(Brand.non_archived.include?(brand_1)).to eq(false)
        expect(Brand.non_archived.include?(brand_2)).to eq(true)
      end
    end
  end

  describe "#archived?" do
    let!(:brand_1) { create(:brand, name: "Name 1", archive: true) }
    let!(:brand_2) { create(:brand, name: "Name 2", archive: false) }

    it "should return true for archived brands" do
      expect(brand_1.archived?).to eq(true)
      expect(brand_2.archived?).to eq(false)
    end
  end

  describe "#non_archived?" do
    let!(:brand_1) { create(:brand, name: "Name 1", archive: true) }
    let!(:brand_2) { create(:brand, name: "Name 2", archive: false) }

    it "should return true for non-archived brands" do
      expect(brand_1.non_archived?).to eq(false)
      expect(brand_2.non_archived?).to eq(true)
    end
  end

  describe "#archived_status" do
    let!(:brand_1) { create(:brand, name: "Name 1", archive: true) }
    let!(:brand_2) { create(:brand, name: "Name 2", archive: false) }

    context "when record is archived" do
      it "should return Archived" do
        expect(brand_1.archived_status).to eq("Archived")
      end
    end

    context "when record is non-archived" do
      it "should return Active" do
        expect(brand_2.archived_status).to eq("Active")
      end
    end
  end
end
