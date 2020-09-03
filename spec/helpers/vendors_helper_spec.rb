require "rails_helper"

RSpec.describe VendorsHelper, type: :helper do
  let(:vendorship) { create(:vendorship) }
  let(:vendor)     { create(:vendor) }

  describe "#archive_link" do
    it "create a archive link for vendorship" do
      link = Nokogiri::HTML(helper.archive_link(vendorship)).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/master/vendors/#{vendorship.id}")
      expect(link.attributes["data-method"].value).to eq("put")
      expect(link.attributes["data-confirm"].value).to eq("Are you sure do you want to archive?")
      expect(link.attributes["title"].value).to eq("Archive")
      expect(link.attributes["class"].value).to eq("btn btn-sm btn-secondary")
    end
  end

  describe "#activate_link" do
    it "create a activate link for vendorship" do
      link = Nokogiri::HTML(helper.activate_link(vendorship)).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/master/vendors/#{vendorship.id}")
      expect(link.attributes["data-method"].value).to eq("put")
      expect(link.attributes["data-confirm"].value).to eq("Are you sure do you want to activate?")
      expect(link.attributes["title"].value).to eq("Activate")
      expect(link.attributes["class"].value).to eq("btn btn-sm btn-secondary")
    end
  end

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

  describe "#vendorship_action_btn" do
    context "when vendor invitation is pending" do
      it "should return resend invitation link" do
        link = Nokogiri::HTML(helper.vendorship_action_btn(vendorship)).children.children.children[0]
        expect(link.attributes["href"].value).to eq("/master/vendors/#{vendorship.vendor.id}/resend_invitation")
        expect(link.attributes["data-method"].value).to eq("put")
        expect(link.attributes["data-confirm"].value).to eq("Are you sure do you want to resend invitation?")
        expect(link.attributes["title"].value).to eq("Resend Invitation")
        expect(link.attributes["class"].value).to eq("btn btn-sm btn-secondary")
      end
    end

    context "when vendor invitation is not pending and vendor is archived" do
      it "should return activation link" do
        vendorship.update(archive: true)
        vendorship.vendor.update(invitation_accepted_at: DateTime.now)
        link = Nokogiri::HTML(helper.vendorship_action_btn(vendorship)).children.children.children[0]
        expect(link.attributes["href"].value).to eq("/master/vendors/#{vendorship.id}")
        expect(link.attributes["data-method"].value).to eq("put")
        expect(link.attributes["data-confirm"].value).to eq("Are you sure do you want to activate?")
        expect(link.attributes["title"].value).to eq("Activate")
        expect(link.attributes["class"].value).to eq("btn btn-sm btn-secondary")
      end
    end

    context "when vendor invitation is not pending and vendor is not archived" do
      it "should return activation link" do
        vendorship.update(archive: false)
        vendorship.vendor.update(invitation_accepted_at: DateTime.now)
        link = Nokogiri::HTML(helper.vendorship_action_btn(vendorship)).children.children.children[0]
        expect(link.attributes["href"].value).to eq("/master/vendors/#{vendorship.id}")
        expect(link.attributes["data-method"].value).to eq("put")
        expect(link.attributes["data-confirm"].value).to eq("Are you sure do you want to archive?")
        expect(link.attributes["title"].value).to eq("Archive")
        expect(link.attributes["class"].value).to eq("btn btn-sm btn-secondary")
      end
    end
  end
end
