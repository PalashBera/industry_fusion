require "rails_helper"

RSpec.describe Organization, type: :model do
  let!(:organization) { create(:organization, name: "Industry Fusion") }

  it_behaves_like "archivable"
  it_behaves_like "addressable"

  describe "active record columns" do
    it { should have_db_column(:name) }
    it { should have_db_column(:created_by_id) }
    it { should have_db_column(:updated_by_id) }
    it { should have_db_column(:created_at) }
    it { should have_db_column(:updated_at) }
  end

  describe "active record index" do
    it { should have_db_index(:created_by_id) }
    it { should have_db_index(:updated_by_id) }
  end

  describe "callbacks" do
    context "when name contains extra space" do
      it "should remove extra space" do
        organization = build(:organization, name: " Industry  Fusion ")
        organization.valid?
        expect(organization.name).to eq ("Industry Fusion")
      end
    end
  end

  describe "associations" do
    it { should have_many(:users) }
    it { should have_many(:brands) }
    it { should have_many(:uoms) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(255) }
    it { should validate_uniqueness_of(:name).case_insensitive }
  end

  describe "scopes" do
    context "order_by_name" do
      let!(:organization_1) { create(:organization, name: "ZARA Private Limited") }
      let!(:organization_2) { create(:organization, name: "KFC Private Limited") }
      it "should return records order by name" do
        expect(Organization.order_by_name).to eq([organization, organization_2, organization_1])
      end
    end
  end
end
