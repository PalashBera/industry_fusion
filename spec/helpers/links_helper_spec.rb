require "rails_helper"

RSpec.describe LinksHelper, type: :helper do
  let(:user)           { create(:user) }
  let(:brand)          { create(:brand) }
  let(:vendor)         { create(:vendor) }
  let(:approval_level) { create :approval_level }

  before(:each) do
    ActsAsTenant.stub(:current_tenant).and_return(user.organization)
    User.stub(:current_user).and_return(user)
  end

  describe "#new_link_using_modal" do
    it "creates a button link with new form" do
      link = Nokogiri::HTML(helper.new_link_using_modal("master/brands")).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/master/brands/new")
      expect(link.attributes["data-remote"].value).to eq("true")
      expect(link.attributes["class"].value).to eq("btn btn-primary")
    end
  end

  describe "#edit_link_using_modal" do
    it "creates a button link with edit form" do
      link = Nokogiri::HTML(helper.edit_link_using_modal("master/brands", brand)).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/master/brands/#{brand.id}/edit")
      expect(link.attributes["data-remote"].value).to eq("true")
      expect(link.attributes["class"].value).to eq("dropdown-item")
    end
  end

  describe "#change_logs_link_using_modal" do
    it "creates a button link for change log modal" do
      link = Nokogiri::HTML(helper.change_logs_link_using_modal("master/brands", brand)).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/master/brands/#{brand.id}/change_logs")
      expect(link.attributes["data-remote"].value).to eq("true")
      expect(link.attributes["class"].value).to eq("dropdown-item")
    end
  end

  describe "#excel_export_btn" do
    it "creates a button link for excel export" do
      link = Nokogiri::HTML(helper.excel_export_btn("master/brands")).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/master/brands/export.xlsx")
      expect(link.attributes["class"].value).to eq("btn btn-dark")
    end
  end

  describe "#filter_button" do
    context "when params present" do
      it "creates a button link with filter form modal" do
        link = Nokogiri::HTML(helper.filter_button("params")).children.children.children[0]
        expect(link.attributes["href"].value).to eq("#")
        expect(link.attributes["class"].value).to eq("btn btn-warning")
        expect(link.attributes["data-toggle"].value).to eq("modal")
        expect(link.attributes["data-target"].value).to eq("#filter_modal")
        expect(link.attributes["title"].value).to eq("Filter Applied")
      end
    end

    context "when params is not present" do
      it "creates a button link with filter form modal" do
        link = Nokogiri::HTML(helper.filter_button(nil)).children.children.children[0]
        expect(link.attributes["href"].value).to eq("#")
        expect(link.attributes["class"].value).to eq("btn btn-secondary")
        expect(link.attributes["data-toggle"].value).to eq("modal")
        expect(link.attributes["data-target"].value).to eq("#filter_modal")
        expect(link.attributes["title"].value).to eq("Filter")
      end
    end
  end

  describe "#remove_filter_btn" do
    it "creates a button link for remove filter" do
      link = Nokogiri::HTML(helper.remove_filter_btn("master/brands")).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/master/brands")
      expect(link.attributes["class"].value).to eq("btn btn-secondary")
    end
  end

  describe "#import_modal_btn" do
    it "creates a button link for import records modal" do
      link = Nokogiri::HTML(helper.import_modal_btn("master/brands")).children.children.children[0]
      expect(link.attributes["href"].value).to eq("#")
      expect(link.attributes["class"].value).to eq("btn btn-info")
      expect(link.attributes["data-toggle"].value).to eq("modal")
      expect(link.attributes["data-target"].value).to eq("#import_modal")
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

  describe "#new_modal_link" do
    it "creates a button link for add new records" do
      link = Nokogiri::HTML(helper.new_modal_link("master/brands")).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/master/brands/new")
      expect(link.attributes["data-remote"].value).to eq("true")
      expect(link.attributes["class"].value).to eq("ml-1")
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
end
