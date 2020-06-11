require "rails_helper"

RSpec.describe Make, type: :model do
  let!(:user) { create(:user) }
  let(:brand) { create(:brand, name: "Lenovo") }
  let!(:make) { create(:make, brand: brand, cat_no: "1234") }

  before { User.stub(:current_user).and_return(user) }

  it_behaves_like "user_trackable"

  describe "#active_record_columns" do
    it { should have_db_column(:organization_id) }
    it { should have_db_column(:created_by_id) }
    it { should have_db_column(:updated_by_id) }
    it { should have_db_column(:created_at) }
    it { should have_db_column(:updated_at) }
    it { should have_db_column(:item_id) }
    it { should have_db_column(:brand_id) }
    it { should have_db_column(:cat_no) }
  end

  describe "#active_record_index" do
    it { should have_db_index(:organization_id) }
    it { should have_db_index(:item_id) }
    it { should have_db_index(:brand_id) }
    it { should have_db_index(:created_by_id) }
    it { should have_db_index(:updated_by_id) }
  end

  describe "#associations" do
    it { should belong_to(:organization) }
    it { should belong_to(:item) }
    it { should belong_to(:brand) }

    it { should have_many(:indent_items) }
  end

  describe "#validations" do
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
end
