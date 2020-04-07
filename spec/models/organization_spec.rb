require "rails_helper"

RSpec.describe Organization, type: :model do
  let!(:organization) { create(:organization, name: "Industry Fusion") }

  describe "active record columns" do
    it { should have_db_column(:name) }
    it { should have_db_column(:address1) }
    it { should have_db_column(:address2) }
    it { should have_db_column(:city) }
    it { should have_db_column(:state) }
    it { should have_db_column(:country) }
    it { should have_db_column(:pin_code) }
    it { should have_db_column(:description) }
    it { should have_db_column(:archive) }
    it { should have_db_column(:discarded_at) }
    it { should have_db_column(:created_by_id) }
    it { should have_db_column(:updated_by_id) }
    it { should have_db_column(:created_at) }
    it { should have_db_column(:updated_at) }
  end

  describe "active record index" do
    it { should have_db_index(:created_by_id) }
    it { should have_db_index(:discarded_at) }
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

    context "when address1 contains extra space" do
      it "should remove extra space" do
        organization = build(:organization, address1: " Salt Lake City ")
        organization.valid?
        expect(organization.address1).to eq ("Salt Lake City")
      end
    end

    context "when address2 contains extra space" do
      it "should remove extra space" do
        organization = build(:organization, address2: " Salt Lake City ")
        organization.valid?
        expect(organization.address2).to eq ("Salt Lake City")
      end
    end

    context "when city contains extra space and is not titleize" do
      it "should remove extra space and make titleize" do
        organization = build(:organization, city: " kolkata  ")
        organization.valid?
        expect(organization.city).to eq ("Kolkata")
      end
    end

    context "when state contains extra space and is not titleize" do
      it "should remove extra space and make titleize" do
        organization = build(:organization, state: " west  Bengal  ")
        organization.valid?
        expect(organization.state).to eq ("West Bengal")
      end
    end

    context "when country contains extra space and is not titleize" do
      it "should remove extra space and make titleize" do
        organization = build(:organization, country: " india  ")
        organization.valid?
        expect(organization.country).to eq ("India")
      end
    end

    context "when pin_code contains extra space" do
      it "should remove extra space" do
        organization = build(:organization, pin_code: " 700091 ")
        organization.valid?
        expect(organization.pin_code).to eq ("700091")
      end
    end

    context "when description contains extra space" do
      it "should remove extra space" do
        organization = build(:organization, description: " Produces a number with 2 digits leading    and   trailing the decimal ")
        organization.valid?
        expect(organization.description).to eq ("Produces a number with 2 digits leading and trailing the decimal")
      end
    end
  end

  describe "associations" do
    it { should have_many(:users) }
    it { should have_many(:brands) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:address1) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:country) }
    it { should validate_presence_of(:pin_code) }
    it { should validate_length_of(:name).is_at_most(255) }
    it { should validate_length_of(:address1).is_at_most(255) }
    it { should validate_length_of(:address2).is_at_most(255) }
    it { should validate_length_of(:city).is_at_most(255) }
    it { should validate_length_of(:state).is_at_most(255) }
    it { should validate_length_of(:country).is_at_most(255) }
    it { should validate_length_of(:pin_code).is_equal_to(6) }
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
