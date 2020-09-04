require "rails_helper"

RSpec.describe UsersHelper, type: :helper do
  let(:user) { create(:user) }

  describe "#resend_user_invitation_action_link" do
    it "create a resend invitation link for user" do
      link = Nokogiri::HTML(helper.resend_user_invitation_action_link(user)).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/admin/users/#{user.id}/resend_invitation")
      expect(link.attributes["data-method"].value).to eq("put")
      expect(link.attributes["data-confirm"].value).to eq("Are you sure do you want to resend invitation?")
      expect(link.attributes["title"].value).to eq("Resend Invitation")
      expect(link.attributes["class"].value).to eq("btn btn-sm btn-secondary")
    end
  end

  describe "#assign_warehouse_action_link" do
    it "create a assign warehouse link for user" do
      link = Nokogiri::HTML(helper.assign_warehouse_action_link("admin/users", user)).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/admin/users/#{user.id}/edit")
      expect(link.attributes["data-remote"].value).to eq("true")
      expect(link.attributes["title"].value).to eq("Assign Warehouse")
      expect(link.attributes["class"].value).to eq("btn btn-sm btn-secondary")
    end
  end
end
