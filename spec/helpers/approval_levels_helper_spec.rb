require "rails_helper"

RSpec.describe ApprovalLevelsHelper, type: :helper do
  describe "#approval_level_type" do
    let(:controller_name) { "indent_approval" }

    it "should return type of controller" do
      expect(approval_level_type).to eq("indent")
    end
  end
end
