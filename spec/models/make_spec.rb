require "rails_helper"

RSpec.describe Make, type: :model do
  let(:user)  { create(:user) }
  let(:brand) { create(:brand, name: "Lenovo") }
  let(:make)  { create(:make, brand: brand, cat_no: "1234") }

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
    it { should have_db_column(:item_id) }
    it { should have_db_column(:brand_id) }
    it { should have_db_column(:cat_no) }
  end

  describe "#active_record_index" do
    it { should have_db_index(:item_id) }
    it { should have_db_index(:brand_id) }
  end

  describe "#associations" do
    it { should belong_to(:item) }
    it { should belong_to(:brand) }

    it { should have_many(:indent_items) }
  end

  describe "#validations" do
    let!(:make) { create(:make) }

    it { should validate_length_of(:cat_no).is_at_most(255) }
    it { should validate_uniqueness_of(:cat_no).case_insensitive.scoped_to(:item_id, :brand_id).allow_blank }
  end

  describe "#brand_with_cat_no" do
    context "when we want to get brand with category no" do
      it "should return brand with category number" do
        expect(make.brand_with_cat_no).to eq("Lenovo - 1234")
      end
    end
  end

  describe "#scopes" do
    let(:item_1) { create :item }
    let(:item_2) { create :item }
    let(:make_1) { create :make, item_id: item_1.id }
    let(:make_2) { create :make, item_id: item_2.id }

    context "#item_filter" do
      it "should return make records associated to some specific item" do
        expect(Make.item_filter(item_1.id).include?(make_1)).to eq(true)
        expect(Make.item_filter(item_1.id).include?(make_2)).to eq(false)
      end
    end
  end
end
