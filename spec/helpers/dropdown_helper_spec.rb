require "rails_helper"

RSpec.describe DropdownHelper, type: :helper do
  describe "#month_selection" do
    it "should return 12 months" do
      expect(month_selection.length).to eq(12)
    end

    it "should have 1 to 12 months serial" do
      serials = month_selection.map{ |m| m[1].to_i }
      expect(serials).to eq((1..12).to_a)
    end
  end

  describe "#status_selection" do
    it "should return 2 statuses" do
      expect(status_selection.length).to eq(2)
    end

    it "should have true and false value" do
      values = status_selection.map{ |s| s[1] }
      expect(values).to eq(["false", "true"])
    end
  end

  describe "#priority_selection" do
    it "should return 4 priorities" do
      expect(priority_selection.length).to eq(4)
    end

    it "should have 4 priorities" do
      values = priority_selection.map{ |p| p[1] }
      expect(values).to eq(["default", "high", "medium", "low"])
    end
  end
end
