require "rails_helper"

RSpec.describe Brand, type: :model do
  let(:user)  { create(:user) }
  let(:brand) { create(:brand) }

  before(:each) do
    ActsAsTenant.stub(:current_tenant).and_return(user.organization)
    User.stub(:current_user).and_return(user)
  end

  it_behaves_like "archive_module"
  it_behaves_like "modal_form_module"
  it_behaves_like "user_tracking_module"
  it_behaves_like "organization_association_module"
  it_behaves_like "timestamp_module"

  describe "#active_record_columns" do
    it { should have_db_column(:name) }
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
  end
end
