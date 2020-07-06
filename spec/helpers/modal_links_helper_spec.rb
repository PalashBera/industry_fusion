require "rails_helper"

RSpec.describe ModalLinksHelper, type: :helper do
  let(:brand) { create(:brand) }
  let(:user)  { create(:user) }

  before(:each) do
    ActsAsTenant.stub(:current_tenant).and_return(user.organization)
    User.stub(:current_user).and_return(user)
  end

  describe "#new_link_using_modal" do
    it "creates a button link for add new records" do
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
      expect(link.attributes["title"].value).to eq("Show Change Logs")
      expect(link.attributes["class"].value).to eq("dropdown-item")
    end
  end

  describe "#filter_link_using_modal" do
    context "when params present" do
      it "creates a button link with filter form modal" do
        link = Nokogiri::HTML(helper.filter_link_using_modal("params")).children.children.children[0]
        expect(link.attributes["href"].value).to eq("#")
        expect(link.attributes["data-toggle"].value).to eq("modal")
        expect(link.attributes["data-target"].value).to eq("#filter_modal")
        expect(link.attributes["title"].value).to eq("Filter Applied")
        expect(link.attributes["class"].value).to eq("btn btn-warning")
      end
    end

    context "when params is not present" do
      it "creates a button link with filter form modal" do
        link = Nokogiri::HTML(helper.filter_link_using_modal(nil)).children.children.children[0]
        expect(link.attributes["href"].value).to eq("#")
        expect(link.attributes["data-toggle"].value).to eq("modal")
        expect(link.attributes["data-target"].value).to eq("#filter_modal")
        expect(link.attributes["title"].value).to eq("Filter")
        expect(link.attributes["class"].value).to eq("btn btn-secondary")
      end
    end
  end

  describe "#import_link_using_modal" do
    it "creates a button link for import records modal" do
      link = Nokogiri::HTML(helper.import_link_using_modal("master/brands")).children.children.children[0]
      expect(link.attributes["href"].value).to eq("#")
      expect(link.attributes["data-toggle"].value).to eq("modal")
      expect(link.attributes["data-target"].value).to eq("#import_modal")
      expect(link.attributes["class"].value).to eq("btn btn-info")
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
end
