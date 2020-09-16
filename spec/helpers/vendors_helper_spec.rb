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

  describe "#change_class_title" do
    let!(:vendorship_1) { create :vendorship }

    it "should return vendor as class title for vendorship_1" do
      change_class_title(vendorship_1)
      expect(vendorship_1.class_title).to eq("Vendor")
      expect(vendorship.class_title).to eq("Vendorship")
    end
  end
end
