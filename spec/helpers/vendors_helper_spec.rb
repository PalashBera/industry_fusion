require "rails_helper"

RSpec.describe VendorsHelper, type: :helper do
  let(:vendor) { create(:vendor) }

  describe "#vendor_status" do
    context "when invitation_accepted_at is nil" do
      it "should return pending badge" do
        link = Nokogiri::HTML(helper.vendor_status(vendor)).children.children.children[0]
        expect(link.attributes["class"].value).to eq("badge badge-secondary")
        expect(link.attributes["title"].value).to eq("Pending")
        expect(link.children.text).to eq("Pending")
      end
    end

    context "when invitation_accepted_at is not nil" do
      it "should return active badge" do
        vendor.update(invitation_accepted_at: Time.now)
        link = Nokogiri::HTML(helper.vendor_status(vendor)).children.children.children[0]
        expect(link.attributes["class"].value).to eq("badge badge-success")
        expect(link.attributes["title"].value).to eq("Active")
        expect(link.children.text).to eq("Active")
      end
    end
  end
end
