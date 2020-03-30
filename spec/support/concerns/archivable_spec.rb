require "rails_helper"

shared_examples_for "archivable" do
  let!(:resource_1) { create(described_class.to_s.underscore.to_sym, name: "KFC", archive: true) }
  let!(:resource_2) { create(described_class.to_s.underscore.to_sym, name: "ZARA", archive: false) }

  it { should validate_inclusion_of(:archive).in_array([true, false]) }

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
end
