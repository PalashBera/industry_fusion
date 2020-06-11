require "rails_helper"

shared_examples_for "modal_formable" do
  let!(:resource) { create(described_class.to_s.underscore.to_sym) }

  describe "#class_title" do
    it "should return resource class name as title" do
      expect(resource.class_title).to eq (described_class.to_s.underscore.humanize.titleize)
    end
  end

  describe "#button_name" do
    context "when resource is a new record" do
      it "should return create as button name" do
        new_resource = build(described_class.to_s.underscore.to_sym)
        expect(new_resource.button_name).to eq ("Create")
      end
    end

    context "when resource is a old record" do
      it "should return update as button name" do
        expect(resource.button_name).to eq ("Update")
      end
    end
  end

  describe "#button_name" do
    context "when resource is a new record" do
      it "should return modal header for new record" do
        new_resource = build(described_class.to_s.underscore.to_sym)
        expect(new_resource.modal_header).to eq ("New #{new_resource.class_title}")
      end
    end

    context "when resource is a old record" do
      it "should return modal header for edit record" do
        expect(resource.modal_header).to eq ("Edit #{resource.class_title}")
      end
    end
  end
end
