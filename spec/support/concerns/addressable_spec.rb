require "rails_helper"

shared_examples_for "addressable" do
  describe "#active_record_columns" do
    it { should have_db_column(:address1) }
    it { should have_db_column(:address2) }
    it { should have_db_column(:city) }
    it { should have_db_column(:state) }
    it { should have_db_column(:country) }
    it { should have_db_column(:pin_code) }
    it { should have_db_column(:phone_number) }
  end

  describe "#callbacks" do
    context "when address1 contains extra space" do
      it "should remove extra space" do
        resource = build(described_class.to_s.underscore.to_sym, address1: " Salt Lake City ")
        resource.valid?
        expect(resource.address1).to eq ("Salt Lake City")
      end
    end

    context "when address2 contains extra space" do
      it "should remove extra space" do
        resource = build(described_class.to_s.underscore.to_sym, address2: " Salt Lake City ")
        resource.valid?
        expect(resource.address2).to eq ("Salt Lake City")
      end
    end

    context "when city contains extra space and is not titleize" do
      it "should remove extra space and make titleize" do
        resource = build(described_class.to_s.underscore.to_sym, city: " kolkata  ")
        resource.valid?
        expect(resource.city).to eq ("Kolkata")
      end
    end

    context "when state contains extra space and is not titleize" do
      it "should remove extra space and make titleize" do
        resource = build(described_class.to_s.underscore.to_sym, state: " west  Bengal  ")
        resource.valid?
        expect(resource.state).to eq ("West Bengal")
      end
    end

    context "when country contains extra space and is not titleize" do
      it "should remove extra space and make titleize" do
        resource = build(described_class.to_s.underscore.to_sym, country: " india  ")
        resource.valid?
        expect(resource.country).to eq ("India")
      end
    end

    context "when pin_code contains extra space" do
      it "should remove extra space" do
        resource = build(described_class.to_s.underscore.to_sym, pin_code: " 700091 ")
        resource.valid?
        expect(resource.pin_code).to eq ("700091")
      end
    end

    context "when phone_number contains extra space" do
      it "should remove extra space" do
        resource = build(described_class.to_s.underscore.to_sym, phone_number: " +033  2585  2565 ")
        resource.valid?
        expect(resource.phone_number).to eq ("+033 2585 2565")
      end
    end
  end

  describe "#validations" do
    it { should validate_presence_of(:address1) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:country) }
    it { should validate_presence_of(:pin_code) }
    it { should validate_length_of(:address1).is_at_most(255) }
    it { should validate_length_of(:address2).is_at_most(255) }
    it { should validate_length_of(:city).is_at_most(255) }
    it { should validate_length_of(:state).is_at_most(255) }
    it { should validate_length_of(:country).is_at_most(255) }
    it { should validate_length_of(:phone_number).is_at_most(255) }
    it { should validate_length_of(:pin_code).is_equal_to(6) }
  end

  describe "#address" do
    let!(:resource) { create(described_class.to_s.underscore.to_sym, address1: "Salt Lake City", address2: "College More", city: "Kolkata", state: "West Bengal", country: "India", pin_code: "700091") }

    it "should return address of the record" do
      expect(resource.address).to eq ("Salt Lake City, College More, Kolkata, West Bengal, India")
    end
  end
end
