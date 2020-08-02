require "rails_helper"

RSpec.describe LinksHelper, type: :helper do
  let(:user)           { create(:user) }
  let(:brand)          { create(:brand) }
  let(:approval_level) { create :approval_level }
  let(:item_image)     { create :item_image }
  let(:item)           { create :item }

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
      expect(link.attributes["title"].value).to eq("Remove Item")
      expect(link.attributes["class"].value).to eq("remove_fields")
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
      link = Nokogiri::HTML(helper.delete_link("admin/approval_levels/indents", approval_level)).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/admin/approval_levels/indents/#{approval_level.id}")
      expect(link.attributes["data-method"].value).to eq("delete")
      expect(link.attributes["data-confirm"].value).to eq("Are you sure you want to delete?")
      expect(link.attributes["class"].value).to eq("text-danger")
    end
  end

  describe "#show_images_link" do
    it "creates a button link for showing images records" do
      link = Nokogiri::HTML(helper.show_images_link(item)).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/master/item_images?item_id=#{item.id}")
      expect(link.attributes["data-remote"].value).to eq("true")
      expect(link.attributes["title"].value).to eq("Show Images")
      expect(link.attributes["class"].value).to eq("text-secondary")
    end
  end

  describe "#delete_image_link" do
    it "creates a button link for delete image record" do
      link = Nokogiri::HTML(helper.delete_image_link(item_image)).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/master/item_images/#{item_image.id}")
      expect(link.attributes["data-method"].value).to eq("delete")
      expect(link.attributes["data-confirm"].value).to eq("Are you sure you want to delete the image?")
      expect(link.attributes["title"].value).to eq("Delete Image")
      expect(link.attributes["class"].value).to eq("btn btn-danger btn-sm delete-image-btn")
    end
  end
end
