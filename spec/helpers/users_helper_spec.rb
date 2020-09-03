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

  describe "#activation_action_link" do
    it "create a activation link for user" do
      link = Nokogiri::HTML(helper.activation_action_link("admin/users", user)).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/admin/users/#{user.id}/toggle_activation")
      expect(link.attributes["data-confirm"].value).to eq("Are you sure do you want to deactivate?")
      expect(link.attributes["title"].value).to eq("Activate")
      expect(link.attributes["class"].value).to eq("btn btn-sm btn-secondary")
    end
  end

  describe "#deactivation_action_link" do
    it "create a deactivation link for user" do
      link = Nokogiri::HTML(helper.deactivation_action_link("admin/users", user)).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/admin/users/#{user.id}/toggle_activation")
      expect(link.attributes["data-confirm"].value).to eq("Are you sure do you want to activate?")
      expect(link.attributes["title"].value).to eq("Deactivate")
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
