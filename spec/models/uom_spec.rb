require "rails_helper"

RSpec.describe Uom, type: :model do
  let(:user) { create(:user) }
  let(:uom)  { create(:uom) }

  before(:each) do
    ActsAsTenant.stub(:current_tenant).and_return(user.organization)
    User.stub(:current_user).and_return(user)
  end

  it_behaves_like "nameable"
  it_behaves_like "archivable"
  it_behaves_like "modal_formable"
  it_behaves_like "user_trackable"
  it_behaves_like "organization_associable"
  it_behaves_like "timestampble"

  describe "#active_record_columns" do
    it { should have_db_column(:short_name) }
  end

  describe "#callbacks" do
    context "when short_name contains extra space" do
      it "should remove extra space" do
        uom = build(:uom, short_name: " Kg  ")
        uom.valid?
        expect(uom.short_name).to eq ("Kg")
      end
    end
  end

  describe "#associations" do
    it { should have_many(:items) }
    it { should have_many(:indent_items) }
  end

  describe "#validations" do
    let!(:uom) { create(:uom) }

    it { should validate_presence_of(:short_name) }
    it { should validate_length_of(:short_name).is_at_most(4) }
    it { should validate_uniqueness_of(:short_name).case_insensitive.scoped_to(:organization_id) }
  end

  describe "#scopes" do
    context "order_by_short_name" do
      let!(:uom_1) { create(:uom, short_name: "Dzn") }
      let!(:uom_2) { create(:uom, short_name: "mm") }

      it "should return records order by short name" do
        expect(user.organization.uoms.order_by_short_name).to eq([uom_1, uom_2])
      end
    end
  end
end
