require "rails_helper"

RSpec.describe User, type: :model do
  let(:user) { create(:user, first_name: "Palash", last_name: "Bera") }

  describe "active record columns" do
    it { should have_db_column(:email) }
    it { should have_db_column(:encrypted_password) }
    it { should have_db_column(:first_name) }
    it { should have_db_column(:last_name) }
    it { should have_db_column(:mobile_number) }
    it { should have_db_column(:organization_id) }
    it { should have_db_column(:reset_password_token) }
    it { should have_db_column(:reset_password_sent_at) }
    it { should have_db_column(:remember_created_at) }
    it { should have_db_column(:sign_in_count) }
    it { should have_db_column(:current_sign_in_at) }
    it { should have_db_column(:last_sign_in_at) }
    it { should have_db_column(:current_sign_in_ip) }
    it { should have_db_column(:last_sign_in_ip) }
    it { should have_db_column(:confirmation_token) }
    it { should have_db_column(:confirmed_at) }
    it { should have_db_column(:confirmation_sent_at) }
    it { should have_db_column(:unconfirmed_email) }
    it { should have_db_column(:created_at) }
    it { should have_db_column(:updated_at) }
  end

  describe "active record index" do
    it { should have_db_index(:email) }
    it { should have_db_index(:reset_password_token) }
    it { should have_db_index(:organization_id) }
    it { should have_db_index(:confirmation_token) }
  end

  describe "callbacks" do
    context "when first_name contains extra space and is not titleize" do
      it "should remove extra space and make titleize" do
        user = build(:user, first_name: " sachin   ramesh  ")
        user.valid?
        expect(user.first_name).to eq ("Sachin Ramesh")
      end
    end

    context "when last_name contains extra space and is not titleize" do
      it "should remove extra space and make titleize" do
        user = build(:user, last_name: " roy   chowdhury  ")
        user.valid?
        expect(user.last_name).to eq ("Roy Chowdhury")
      end
    end

    context "when email contains extra space and is not in downcase" do
      it "should remove extra space and make downcase" do
        user = build(:user, email: " PBERA@KREETI.COM ")
        user.valid?
        expect(user.email).to eq ("pbera@kreeti.com")
      end
    end

    context "when mobile_number contains extra space" do
      it "should remove extra space" do
        user = build(:user, mobile_number: " 8441005506 ")
        user.valid?
        expect(user.mobile_number).to eq ("8441005506")
      end
    end
  end

  describe "validations" do
    it { should belong_to(:organization).optional }
  end

  describe "validations" do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:mobile_number) }
    it { should validate_presence_of(:password).on(:create) }
    it { should validate_length_of(:first_name).is_at_most(255) }
    it { should validate_length_of(:last_name).is_at_most(255) }
    it { should validate_length_of(:email).is_at_most(255) }
    it { should validate_length_of(:mobile_number).is_equal_to(10) }
    it { should validate_length_of(:password).is_at_least(6).is_at_most(128) }
  end

  describe "#full_name" do
    it "should return full name of user" do
      expect(user.full_name).to eq ("Palash Bera")
    end
  end

  describe "#initial" do
    it "should return initial of user" do
      expect(user.initial).to eq ("PB")
    end
  end
end
