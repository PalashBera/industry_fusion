require "rails_helper"

RSpec.describe ActionLinksHelper, type: :helper do
  let(:brand)  { create(:brand) }
  let(:user)   { create(:user) }
  let(:vendor) { create(:vendor) }
  let(:indent) { create(:indent) }

  before(:each) do
    ActsAsTenant.current_tenant = user.organization
    User.current_user = user
  end

  describe "#edit_action_link" do
    it "create a edit link for record" do
      link = Nokogiri::HTML(helper.edit_action_link("master/brands", brand)).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/master/brands/#{brand.id}/edit")
      expect(link.attributes["class"].value).to eq("dropdown-item")
    end
  end

  describe "#show_action_link" do
    it "create a show link for record" do
      link = Nokogiri::HTML(helper.show_action_link("procurement/indents", indent)).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/procurement/indents/#{indent.id}")
      expect(link.attributes["class"].value).to eq("dropdown-item")
    end
  end

  describe "#activation_action_link" do
    it "create a activation link for user" do
      link = Nokogiri::HTML(helper.activation_action_link("admin/users", user)).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/admin/users/#{user.id}/toggle_activation")
      expect(link.attributes["data-confirm"].value).to eq("Are you sure?")
      expect(link.attributes["title"].value).to eq("Activate")
      expect(link.attributes["class"].value).to eq("dropdown-item")
    end
  end

  describe "#deactivation_action_link" do
    it "create a deactivation link for user" do
      link = Nokogiri::HTML(helper.deactivation_action_link("admin/users", user)).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/admin/users/#{user.id}/toggle_activation")
      expect(link.attributes["data-confirm"].value).to eq("Are you sure?")
      expect(link.attributes["title"].value).to eq("Deactivate")
      expect(link.attributes["class"].value).to eq("dropdown-item")
    end
  end

  describe "#assign_warehouse_action_link" do
    it "create a assign warehouse link for user" do
      link = Nokogiri::HTML(helper.assign_warehouse_action_link("admin/users", user)).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/admin/users/#{user.id}/edit")
      expect(link.attributes["data-remote"].value).to eq("true")
      expect(link.attributes["title"].value).to eq("Assign Warehouses")
      expect(link.attributes["class"].value).to eq("dropdown-item")
    end
  end

  describe "#resend_user_invitation_action_link" do
    it "create a resend invitation link for user" do
      link = Nokogiri::HTML(helper.resend_user_invitation_action_link(user)).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/admin/users/#{user.id}/resend_invitation")
      expect(link.attributes["data-method"].value).to eq("put")
      expect(link.attributes["title"].value).to eq("Resend Invitation")
      expect(link.attributes["class"].value).to eq("dropdown-item")
    end
  end

  describe "#resend_vendor_invitation_action_link" do
    it "create a resend invitation link for vendor" do
      link = Nokogiri::HTML(helper.resend_vendor_invitation_action_link(vendor)).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/master/vendors/#{vendor.id}/resend_invitation")
      expect(link.attributes["data-method"].value).to eq("put")
      expect(link.attributes["title"].value).to eq("Resend Invitation")
      expect(link.attributes["class"].value).to eq("dropdown-item")
    end
  end
end
