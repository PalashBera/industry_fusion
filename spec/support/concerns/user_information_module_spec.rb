require "spec_helper"

shared_examples_for "user_information_module" do
  let!(:resource) { create(described_class.to_s.underscore.to_sym) }

  describe "#active_record_columns" do
    it { should have_db_column(:email) }
    it { should have_db_column(:encrypted_password) }
    it { should have_db_column(:first_name) }
    it { should have_db_column(:last_name) }
    it { should have_db_column(:mobile_number) }
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

  describe "#active_record_index" do
    it { should have_db_index(:email) }
    it { should have_db_index(:reset_password_token) }
    it { should have_db_index(:confirmation_token) }
  end

  describe "#validations" do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_length_of(:email).is_at_most(255) }
    it { should validate_presence_of(:password) }
    it { should validate_length_of(:password).is_at_most(128).is_at_least(6) }
    it { should validate_presence_of(:mobile_number) }
    it { should validate_length_of(:mobile_number).is_equal_to(10) }
  end

  describe "#full_name" do
    context "when we want to get full_name of the user" do
      it "should return the full_name of the user" do
        expect(resource.full_name).to eq("#{resource.first_name} #{resource.last_name}")
      end
    end
  end

  describe "#initial" do
    context "when we want to get initial of the user name" do
      it "should return the initial of the user name" do
        expect(resource.initial).to eq("#{resource.first_name[0]}#{resource.last_name[0]}")
      end
    end
  end

  describe "#callbacks" do
    context "when first_name contains extra space and is not titleize" do
      it "should remove extra space and make titleize" do
        resource = build(described_class.to_s.underscore.to_sym, first_name: " sachin   ramesh  ")
        resource.valid?
        expect(resource.first_name).to eq ("Sachin Ramesh")
      end
    end

    context "when last_name contains extra space and is not titleize" do
      it "should remove extra space and make titleize" do
        resource = build(described_class.to_s.underscore.to_sym, last_name: " roy   chowdhury  ")
        resource.valid?
        expect(resource.last_name).to eq ("Roy Chowdhury")
      end
    end

    context "when email contains extra space and is not in downcase" do
      it "should remove extra space and make downcase" do
        resource = build(described_class.to_s.underscore.to_sym, email: " PBERA@KREETI.COM ")
        resource.valid?
        expect(resource.email).to eq ("pbera@kreeti.com")
      end
    end

    context "when mobile_number contains extra space" do
      it "should remove extra space" do
        resource = build(described_class.to_s.underscore.to_sym, mobile_number: " 8441005506 ")
        resource.valid?
        expect(resource.mobile_number).to eq ("8441005506")
      end
    end
  end
end
