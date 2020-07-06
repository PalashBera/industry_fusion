require "rails_helper"

RSpec.describe LinksHelper, type: :helper do
  let(:user)           { create(:user) }
  let(:brand)          { create(:brand) }
  let(:approval_level) { create :approval_level }

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

  describe "#new_link_btn" do
    it "creates a button link for add new records" do
      link = Nokogiri::HTML(helper.new_link_btn("master/brands")).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/master/brands/new")
      expect(link.attributes["class"].value).to eq("btn btn-primary")
    end
  end

  describe "#new_link" do
    it "creates a button link for add new records" do
      link = Nokogiri::HTML(helper.new_link("master/brands")).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/master/brands/new")
    end
  end

  describe "#edit_link" do
    it "creates a button link for edit record" do
      link = Nokogiri::HTML(helper.edit_link("master/brands", brand)).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/master/brands/#{brand.id}/edit")
    end
  end

  describe "#delete_link" do
    it "creates a button link for delete records" do
      link = Nokogiri::HTML(helper.delete_link("admin/indent_approval_levels", approval_level)).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/admin/indent_approval_levels/#{approval_level.id}")
      expect(link.attributes["data-method"].value).to eq("delete")
      expect(link.attributes["data-confirm"].value).to eq("Are you sure?")
      expect(link.attributes["class"].value).to eq("text-danger")
    end
  end
end
