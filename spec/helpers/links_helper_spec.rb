require "rails_helper"

RSpec.describe LinksHelper, type: :helper do
  let(:user)           { create(:user) }
  let(:brand)          { create(:brand) }
  let(:vendor)         { create(:vendor) }
  let(:approval_level) { create :approval_level }
  let(:indent)         { create :indent }

  before(:each) do
    ActsAsTenant.stub(:current_tenant).and_return(user.organization)
    User.stub(:current_user).and_return(user)
  end

  describe "#excel_export_btn" do
    it "creates a button link for excel export" do
      link = Nokogiri::HTML(helper.excel_export_btn("master/brands")).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/master/brands/export.xlsx")
      expect(link.attributes["class"].value).to eq("btn btn-dark")
    end
  end

  describe "#remove_filter_btn" do
    it "creates a button link for remove filter" do
      link = Nokogiri::HTML(helper.remove_filter_btn("master/brands")).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/master/brands")
      expect(link.attributes["class"].value).to eq("btn btn-secondary")
    end
  end

  describe "#link_to_remove_fields" do
    it "creates a button link for removing fields" do
      link = Nokogiri::HTML(helper.link_to_remove_fields).children.children.children[0]
      expect(link.attributes["href"].value).to eq("#")
      expect(link.attributes["class"].value).to eq("remove_fields")
      expect(link.attributes["title"].value).to eq("Remove Item")
    end
  end

  describe "#new_link" do
    it "creates a button link for add new records" do
      link = Nokogiri::HTML(helper.new_link("master/brands")).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/master/brands/new")
      expect(link.attributes["class"].value).to eq("btn btn-primary")
    end
  end

  describe "#edit_link" do
    it "creates a button link for edit record" do
      link = Nokogiri::HTML(helper.edit_link("master/brands", brand)).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/master/brands/#{brand.id}/edit")
    end
  end

  describe "#resend_user_invitation_link" do
    it "creates a resend invitation link for user" do
      link = Nokogiri::HTML(helper.resend_user_invitation_link(user)).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/admin/users/#{user.id}/resend_invitation")
      expect(link.attributes["data-method"].value).to eq("put")
      expect(link.attributes["title"].value).to eq("Resend Invitation")
      expect(link.attributes["class"].value).to eq("dropdown-item")
    end
  end

  describe "#resend_vendor_invitation_link" do
    it "creates a resend invitation link for vendor" do
      link = Nokogiri::HTML(helper.resend_vendor_invitation_link(vendor)).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/master/vendors/#{vendor.id}/resend_invitation")
      expect(link.attributes["data-method"].value).to eq("put")
      expect(link.attributes["title"].value).to eq("Resend Invitation")
      expect(link.attributes["class"].value).to eq("dropdown-item")
    end
  end

  describe "#delete_link" do
    it "creates a button link for delete records" do
      link = Nokogiri::HTML(helper.delete_link("admin/indent_approval_levels", approval_level)).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/admin/indent_approval_levels/#{approval_level.id}")
      expect(link.attributes["data-confirm"].value).to eq("Are you sure?")
      expect(link.attributes["title"].value).to eq("Delete Admin/Indent Approval Level")
      expect(link.attributes["data-method"].value).to eq("delete")
    end
  end

  describe "#edit_link" do
    it "creates a button link for edit records" do
      link = Nokogiri::HTML(helper.edit_link("admin/indent_approval_levels", approval_level)).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/admin/indent_approval_levels/#{approval_level.id}/edit")
      expect(link.attributes["title"].value).to eq("Edit Admin/Indent Approval Level")
    end
  end

  describe "#show_link" do
    it "creates a button link for showing records" do
      link = Nokogiri::HTML(helper.show_link("transactions/indents", indent)).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/transactions/indents/#{indent.id}")
      expect(link.attributes["title"].value).to eq("Show Indent")
    end
  end
end
