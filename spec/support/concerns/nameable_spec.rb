require "rails_helper"

shared_examples_for "nameable" do
  let!(:resource)    { create(described_class.to_s.underscore.to_sym) }
  let(:nameable_org) { create(:organization) }

  describe "#active_record_columns" do
    it { should have_db_column(:name) }
  end

  describe "#callbacks" do
    context "when name contains extra space" do
      it "should remove extra space" do
        record_1 = build(described_class.to_s.underscore.to_sym, name: " KFC  ")
        record_1.valid?
        expect(record_1.name).to eq ("KFC")
      end
    end
  end

  describe "#validations" do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(255) }
    it { should validate_uniqueness_of(:name).case_insensitive.scoped_to(:organization_id) }
  end

  describe "#scopes" do
    context "order_by_name" do
      let(:record_1) { create(described_class.to_s.underscore.to_sym, name: "Name 1", organization: nameable_org) }
      let(:record_2) { create(described_class.to_s.underscore.to_sym, name: "Name 2", organization: nameable_org) }

      it "should return records order by name" do
        expect(nameable_org.public_send(described_class.to_s.pluralize.underscore).order_by_name).to eq([record_1, record_2])
      end
    end
  end
end
