require "rails_helper"

shared_examples_for "archivable" do
  let(:resource_1) { create(described_class.to_s.underscore.to_sym, archive: true) }
  let(:resource_2) { create(described_class.to_s.underscore.to_sym, archive: false) }

  describe "active record columns" do
    it { should have_db_column(:archive) }
  end

  describe "scopes" do
    context "archived" do
      it "should return archived reccords" do
        expect(described_class.archived.include?(resource_1)).to eq (true)
        expect(described_class.archived.include?(resource_2)).to eq (false)
      end
    end

    context "non-archived" do
      it "should return non-archived reccords" do
        expect(described_class.non_archived.include?(resource_2)).to eq (true)
        expect(described_class.non_archived.include?(resource_1)).to eq (false)
      end
    end
  end

  describe "#archived?" do
    it "should return true for archived reccords" do
      expect(resource_1.archived?).to eq (true)
      expect(resource_2.archived?).to eq (false)
    end
  end

  describe "#non_archived?" do
    it "should return true for non-archived reccords" do
      expect(resource_1.non_archived?).to eq (false)
      expect(resource_2.non_archived?).to eq (true)
    end
  end

  describe "#archived_status" do
    context "when record is archived" do
      it "should return Archived" do
        expect(resource_1.archived_status).to eq ("Archived")
      end
    end

    context "when record is non-archived" do
      it "should return Active" do
        expect(resource_2.archived_status).to eq ("Active")
      end
    end
  end
end
