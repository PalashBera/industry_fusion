require "rails_helper"

RSpec.describe ActionLinksHelper, type: :helper do
  let(:user)   { create(:user) }
  let(:indent) { create(:indent) }

  before(:each) do
    ActsAsTenant.current_tenant = user.organization
    User.current_user = user
  end

  describe "#edit_action_link" do
    it "create a edit link for record" do
      link = Nokogiri::HTML(helper.edit_action_link("procurement/indents", indent)).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/procurement/indents/#{indent.id}/edit")
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

  describe "#print_action_link" do
    it "create a print link for record" do
      link = Nokogiri::HTML(helper.print_action_link("procurement/indents", indent)).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/procurement/indents/#{indent.id}/print")
      expect(link.attributes["title"].value).to eq("Print")
      expect(link.attributes["class"].value).to eq("dropdown-item")
    end
  end

  describe "#send_approval_action_link" do
    it "create a send for approval link for record" do
      link = Nokogiri::HTML(helper.send_approval_action_link("procurement/indents", indent)).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/procurement/indents/#{indent.id}/send_for_approval")
      expect(link.attributes["data-method"].value).to eq("put")
      expect(link.attributes["data-confirm"].value).to eq("Do you want to send for approval this indent?")
      expect(link.attributes["title"].value).to eq("Send for Approval")
      expect(link.attributes["class"].value).to eq("dropdown-item")
    end
  end

  describe "#restore_action_link" do
    it "create a restore link for record" do
      link = Nokogiri::HTML(helper.restore_action_link("procurement/indents", indent)).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/procurement/indents/#{indent.id}/restore")
      expect(link.attributes["data-method"].value).to eq("put")
      expect(link.attributes["data-confirm"].value).to eq("Do you want to restore this indent?")
      expect(link.attributes["title"].value).to eq("Restore")
      expect(link.attributes["class"].value).to eq("dropdown-item")
    end
  end

  describe "#amended_action_link" do
    it "create a amend link for record" do
      link = Nokogiri::HTML(helper.amended_action_link("procurement/indents", indent)).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/procurement/indents/#{indent.id}/amend")
      expect(link.attributes["data-method"].value).to eq("put")
      expect(link.attributes["data-confirm"].value).to eq("Do you want to amend this indent?")
      expect(link.attributes["title"].value).to eq("Amend")
      expect(link.attributes["class"].value).to eq("dropdown-item")
    end
  end

  describe "#cancelled_action_link" do
    it "create a cancel link for record" do
      link = Nokogiri::HTML(helper.cancelled_action_link("procurement/indents", indent)).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/procurement/indents/#{indent.id}/cancel")
      expect(link.attributes["data-method"].value).to eq("put")
      expect(link.attributes["data-confirm"].value).to eq("Do you want to cancel this indent?")
      expect(link.attributes["title"].value).to eq("Cancel")
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

  describe "#history_action_link_using_modal" do
    it "creates a link for history modal" do
      link = Nokogiri::HTML(helper.history_action_link_using_modal("procurement/indents", indent)).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/procurement/indents/#{indent.id}/change_logs")
      expect(link.attributes["data-remote"].value).to eq("true")
      expect(link.attributes["title"].value).to eq("Show History")
      expect(link.attributes["class"].value).to eq("dropdown-item")
    end
  end

  describe "#approval_history_action_link_using_modal" do
    it "creates a link for approval history modal" do
      link = Nokogiri::HTML(helper.approval_history_action_link_using_modal("procurement/indents", indent)).children.children.children[0]
      expect(link.attributes["href"].value).to eq("/procurement/indents/#{indent.id}/approval_history")
      expect(link.attributes["data-remote"].value).to eq("true")
      expect(link.attributes["title"].value).to eq("Show Approval History")
      expect(link.attributes["class"].value).to eq("dropdown-item")
    end
  end
end
