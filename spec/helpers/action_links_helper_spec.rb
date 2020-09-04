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
      expect(link.attributes["href"].value).to eq("/admin/users/#{user.id}/toggle_archive")
      expect(link.attributes["data-confirm"].value).to eq("Are you sure do you want to activate?")
      expect(link.attributes["title"].value).to eq("Activate")
      expect(link.attributes["class"].value).to eq("btn btn-sm btn-secondary")
    end
  end

  describe "#archive_action_link" do
    it "create a archive link for user" do
      link = Nokogiri::HTML(helper.archive_action_link("admin/users", user)).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/admin/users/#{user.id}/toggle_archive")
      expect(link.attributes["data-confirm"].value).to eq("Are you sure do you want to archive?")
      expect(link.attributes["title"].value).to eq("Archive")
      expect(link.attributes["class"].value).to eq("btn btn-sm btn-secondary")
    end
  end
end
