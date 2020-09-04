require "rails_helper"

RSpec.describe VendorsHelper, type: :helper do
  let(:vendorship) { create(:vendorship) }
  let(:vendor)     { create(:vendor) }

  describe "#resend_vendor_invitation_action_link" do
    it "create a resend invitation link for vendor" do
      link = Nokogiri::HTML(helper.resend_vendor_invitation_action_link(vendor)).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/master/vendors/#{vendor.id}/resend_invitation")
      expect(link.attributes["data-method"].value).to eq("put")
      expect(link.attributes["data-confirm"].value).to eq("Are you sure do you want to resend invitation?")
      expect(link.attributes["title"].value).to eq("Resend Invitation")
      expect(link.attributes["class"].value).to eq("btn btn-sm btn-secondary")
    end
  end
end
