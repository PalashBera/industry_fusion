require "rails_helper"

shared_examples_for "archive_module" do
  let!(:archived_resource)     { create(described_class.to_s.underscore.to_sym, archive: true) }
  let!(:non_archived_resource) { create(described_class.to_s.underscore.to_sym, archive: false) }

  describe "#active_record_columns" do
    it { should have_db_column(:archive) }
  end

  describe "#scopes" do
    context "archived" do
      it "should return archived reccords" do
        expect(described_class.archived.include?(archived_resource)).to eq(true)
        expect(described_class.archived.include?(non_archived_resource)).to eq(false)
      end
    end

    context "non-archived" do
      it "should return non-archived reccords" do
        expect(described_class.non_archived.include?(non_archived_resource)).to eq(true)
        expect(described_class.non_archived.include?(archived_resource)).to eq(false)
      end
    end
  end

  describe "#archived?" do
    it "should return true for archived reccords" do
      expect(archived_resource.archived?).to eq(true)
      expect(non_archived_resource.archived?).to eq(false)
    end
  end

  describe "#non_archived?" do
    it "should return true for non-archived reccords" do
      expect(archived_resource.non_archived?).to eq(false)
      expect(non_archived_resource.non_archived?).to eq(true)
    end
  end

  describe "#archived_status" do
    context "when record is archived" do
      it "should return Archived" do
        expect(archived_resource.archived_status).to eq("Archived")
      end
    end

    context "when record is non-archived" do
      it "should return Active" do
        expect(non_archived_resource.archived_status).to eq("Active")
      end
    end
  end
end
