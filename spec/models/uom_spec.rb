require "rails_helper"

RSpec.describe Uom, type: :model do
  let(:user) { create(:user) }
  let(:uom)  { create(:uom) }

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
    it { should have_db_column(:short_name) }
  end

  describe "#callbacks" do
    context "when name contains extra space" do
      it "should remove extra space" do
        uom = build(:uom, name: " KFC  ")
        uom.valid?
        expect(uom.name).to eq ("KFC")
      end
    end

    context "when short name contains extra space" do
      it "should remove extra space" do
        uom = build(:uom, short_name: " SBC ")
        uom.valid?
        expect(uom.short_name).to eq ("SBC")
      end
    end
  end

  describe "#associations" do
    it { should have_many(:items) }
    it { should have_many(:indent_items) }
  end

  describe "#validations" do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(255) }
    it { should validate_presence_of(:short_name) }
    it { should validate_length_of(:short_name).is_at_most(4) }

    context "when same uom name and short name present for an organization" do
      let!(:uom) { create(:uom, name: "Nokia", short_name: "AAA") }

      it "should not save this uom" do
        new_uom = build(:uom, name: "Nokia", short_name: "AAA")
        new_uom.valid?
        expect(new_uom.errors[:name]).to include("has already been taken")
        expect(new_uom.errors[:short_name]).to include("has already been taken")
      end
    end
  end

  describe "#scopes" do
    let!(:uom_1) { create(:uom, name: "Name 1", archive: true) }
    let!(:uom_2) { create(:uom, name: "Name 2", archive: false) }

    context "order_by_name" do
      it "should return uoms order by name" do
        expect(Uom.order_by_name).to eq([uom_1, uom_2])
      end
    end
  end
end
