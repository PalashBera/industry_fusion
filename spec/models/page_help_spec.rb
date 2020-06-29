require "rails_helper"

RSpec.describe PageHelp, type: :model do
  describe "#active_record_columns" do
    it { should have_db_column(:controller_name) }
    it { should have_db_column(:action_name) }
    it { should have_db_column(:help_text) }
    it { should have_db_column(:help_type) }
  end

  describe "#callbacks" do
    context "when controller name contains extra space" do
      it "should remove extra space" do
        page_help = build(:page_help, controller_name: " kfc  ")
        page_help.valid?
        expect(page_help.controller_name).to eq ("kfc")
      end
    end

    context "when controller name is not in downcase" do
      it "should make this downcase" do
        page_help = build(:page_help, controller_name: " KFC  ")
        page_help.valid?
        expect(page_help.controller_name).to eq ("kfc")
      end
    end

    context "when action name contains extra space" do
      it "should remove extra space" do
        page_help = build(:page_help, action_name: " kfc  ")
        page_help.valid?
        expect(page_help.action_name).to eq ("kfc")
      end
    end

    context "when action name is not in downcase" do
      it "should make this downcase" do
        page_help = build(:page_help, action_name: " KFC  ")
        page_help.valid?
        expect(page_help.action_name).to eq ("kfc")
      end
    end

    context "when help text contains extra space" do
      it "should remove extra space" do
        page_help = build(:page_help, help_text: " KFC  ")
        page_help.valid?
        expect(page_help.help_text).to eq ("KFC")
      end
    end

    context "when help type contains extra space" do
      it "should remove extra space" do
        page_help = build(:page_help, help_type: " kfc  ")
        page_help.valid?
        expect(page_help.help_type).to eq ("kfc")
      end
    end

    context "when help type is not in downcase" do
      it "should make this downcase" do
        page_help = build(:page_help, help_type: " KFC  ")
        page_help.valid?
        expect(page_help.help_type).to eq ("kfc")
      end
    end
  end

  describe "#validations" do
    it { should validate_presence_of(:controller_name) }
    it { should validate_presence_of(:action_name) }
    it { should validate_presence_of(:help_text) }
    it { should validate_presence_of(:help_type) }
    it { should validate_length_of(:controller_name).is_at_most(255) }
    it { should validate_length_of(:action_name).is_at_most(255) }
    it { should validate_length_of(:help_text).is_at_most(255) }
    it { should validate_length_of(:help_type).is_at_most(255) }


    context "when controller name present for same action name" do
      let!(:page_help) { create(:page_help, controller_name: "master/brands", action_name: "index", help_text: "Please help me.", help_type: "primary") }

      it "should not save this page help" do
        new_page_help = build(:page_help, controller_name: "master/brands", action_name: "index", help_text: "Please help me.", help_type: "primary")
        new_page_help.valid?
        expect(new_page_help.errors[:controller_name]).to include("has already been taken")
      end
    end
  end
end
