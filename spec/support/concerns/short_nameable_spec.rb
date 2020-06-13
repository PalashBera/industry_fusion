shared_examples_for "short_nameable" do
  describe "#active_record_columns" do
    it { should have_db_column(:short_name) }
  end

  describe "#callbacks" do
    context "when short name contains extra space" do
      it "should remove extra space" do
        resource = build(described_class.to_s.underscore.to_sym, short_name: " SBC ")
        resource.valid?
        expect(resource.short_name).to eq ("SBC")
      end
    end

    context "when short name is not in upcase" do
      it "should make short name in upcase" do
        resource = build(described_class.to_s.underscore.to_sym, short_name: " sbc ")
        resource.valid?
        expect(resource.short_name).to eq ("SBC")
      end
    end
  end

  describe "#validations" do
    let!(:short_named_resource) { create(described_class.to_s.underscore.to_sym) }

    it { should validate_presence_of(:short_name) }
    it { should validate_length_of(:short_name).is_at_most(3) }
    it { should validate_uniqueness_of(:short_name).case_insensitive.scoped_to(:organization_id) }
  end
end
