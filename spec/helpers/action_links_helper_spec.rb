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
end
