require "spec_helper"

shared_examples_for "user_trackable" do
  let!(:resource) { create(described_class.to_s.underscore.to_sym) }

  describe "@callbacks" do
    it { is_expected.to callback(:set_created_by).before(:create) }
    it { is_expected.to callback(:set_updated_by).before(:save) }
  end

  describe "#{}associations" do
    it { should belong_to(:created_by).class_name("User").optional }
    it { should belong_to(:updated_by).class_name("User").optional }
  end

  describe "#set_created_by" do
    context "when we want to set created_by" do
      it "should return the details of record creator" do
        expect(resource.created_by).to eq(User.current_user)
      end
    end
  end

  describe "#set_updated_by" do
    context "when we want to set updated_by" do
      it "should return the details of record updator" do
        expect(resource.updated_by).to eq(User.current_user)
      end
    end
  end

  describe "#created_by" do
    context "when we want to get creator of the record" do
      it "should return the details of record creator" do
        expect(resource.class.created_by(User.current_user)).to include(resource)
      end
    end
  end

  describe "#updated_by" do
    context "when we want to get updator of the record" do
      it "should return the details of record updator" do
        expect(resource.class.updated_by(User.current_user)).to include(resource)
      end
    end
  end
end
