require "rails_helper"

RSpec.describe ActionLinksHelper, type: :helper do
  let(:brand)  { create(:brand) }
  let(:user)   { create(:user) }
  let(:vendor) { create(:vendor) }
  let(:indent) { create(:indent) }

  before(:each) do
    ActsAsTenant.stub(:current_tenant).and_return(user.organization)
    User.stub(:current_user).and_return(user)
  end

  describe "#edit_action_link" do
    it "creates a button link for edit record" do
      link = Nokogiri::HTML(helper.edit_action_link("master/brands", brand)).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/master/brands/#{brand.id}/edit")
      expect(link.attributes["class"].value).to eq("dropdown-item")
    end
  end

  describe "#show_action_link" do
    it "creates a button link for edit record" do
      link = Nokogiri::HTML(helper.show_action_link("procurement/pending_indents", indent)).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/procurement/indents/pending/#{indent.id}")
      expect(link.attributes["class"].value).to eq("dropdown-item")
    end
  end

  describe "#activation_action_link" do
    it "creates a button link for edit record" do
      link = Nokogiri::HTML(helper.activation_action_link("admin/users", user)).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/admin/users/#{user.id}/toggle_activation")
      expect(link.attributes["data-confirm"].value).to eq("Are you sure?")
      expect(link.attributes["title"].value).to eq("Activate")
      expect(link.attributes["class"].value).to eq("dropdown-item")
    end
  end

  describe "#deactivation_action_link" do
    it "creates a button link for edit record" do
      link = Nokogiri::HTML(helper.deactivation_action_link("admin/users", user)).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/admin/users/#{user.id}/toggle_activation")
      expect(link.attributes["data-confirm"].value).to eq("Are you sure?")
      expect(link.attributes["title"].value).to eq("Deactivate")
      expect(link.attributes["class"].value).to eq("dropdown-item")
    end
  end

  describe "#assign_warehouse_action_link" do
    it "creates a button link for edit record" do
      link = Nokogiri::HTML(helper.assign_warehouse_action_link("admin/users", user)).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/admin/users/#{user.id}/edit")
      expect(link.attributes["data-remote"].value).to eq("true")
      expect(link.attributes["title"].value).to eq("Assign Warehouses")
      expect(link.attributes["class"].value).to eq("dropdown-item")
    end
  end

  describe "#resend_user_invitation_action_link" do
    it "creates a resend invitation link for user" do
      link = Nokogiri::HTML(helper.resend_user_invitation_action_link(user)).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/admin/users/#{user.id}/resend_invitation")
      expect(link.attributes["data-method"].value).to eq("put")
      expect(link.attributes["title"].value).to eq("Resend Invitation")
      expect(link.attributes["class"].value).to eq("dropdown-item")
    end
  end

  describe "#resend_vendor_invitation_action_link" do
    it "creates a resend invitation link for vendor" do
      link = Nokogiri::HTML(helper.resend_vendor_invitation_action_link(vendor)).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/master/vendors/#{vendor.id}/resend_invitation")
      expect(link.attributes["data-method"].value).to eq("put")
      expect(link.attributes["title"].value).to eq("Resend Invitation")
      expect(link.attributes["class"].value).to eq("dropdown-item")
    end
  end

  describe "#print_action_link" do
    let(:indent_item) { indent.indent_items.first }

    it "creates a sned for approval link for indent item" do
      link = Nokogiri::HTML(helper.print_action_link("procurement/pending_indents", indent_item)).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/procurement/indents/pending/#{indent_item.id}/print")
      expect(link.attributes["title"].value).to eq("Print")
      expect(link.attributes["class"].value).to eq("dropdown-item")
    end
  end

  describe "#send_approval_action_link" do
    let(:indent_item) { indent.indent_items.first }

    it "creates a sned for approval link for indent item" do
      link = Nokogiri::HTML(helper.send_approval_action_link("procurement/pending_indents", indent_item)).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/procurement/indents/pending/#{indent_item.id}/send_for_approval")
      expect(link.attributes["title"].value).to eq("Send for Approval")
      expect(link.attributes["class"].value).to eq("dropdown-item")
    end
  end
end
