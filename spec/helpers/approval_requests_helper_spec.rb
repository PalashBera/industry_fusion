require "rails_helper"

RSpec.describe ActionLinksHelper, type: :helper do
  let(:user)             { create(:user) }
  let(:approval_request) { create(:approval_request) }

  before(:each) do
    ActsAsTenant.current_tenant = user.organization
    User.current_user = user
  end

  describe "#approve_action_link" do
    it "creates a approve link for indent item" do
      link = Nokogiri::HTML(helper.approve_action_link("procurement/approval_requests/indents", approval_request)).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/procurement/approval_requests/indents/#{approval_request.id}?type=approve")
      expect(link.attributes["data-method"].value).to eq("put")
      expect(link.attributes["data-confirm"].value).to eq("Are you sure you want to approve?")
      expect(link.attributes["title"].value).to eq("Approve")
      expect(link.attributes["class"].value).to eq("dropdown-item")
    end
  end

  describe "#reject_action_link" do
    it "creates a reject link for indent item" do
      link = Nokogiri::HTML(helper.reject_action_link("procurement/approval_requests/indents", approval_request)).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/procurement/approval_requests/indents/#{approval_request.id}?type=reject")
      expect(link.attributes["data-method"].value).to eq("put")
      expect(link.attributes["data-confirm"].value).to eq("Are you sure you want to reject?")
      expect(link.attributes["title"].value).to eq("Reject")
      expect(link.attributes["class"].value).to eq("dropdown-item")
    end
  end
end
