require "rails_helper"

RSpec.describe ApprovalMailer, type: :mailer do
  let(:user) { create(:user) }

  before(:each) do
    ActsAsTenant.stub(:current_tenant).and_return(user.organization)
    User.stub(:current_user).and_return(user)
  end

  describe "#indent_approval" do
    let(:indent_item) { create(:indent_item) }
    let(:mail)        { ApprovalMailer.indent_approval(indent_item.id, 1, user.id, user.id) }

    it "renders the headers" do
      expect(mail.subject).to eq(I18n.t("mail.indent_approval.subject", serial: indent_item.indent_serial_number))
      expect(mail.to).to eq([user.email])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Item is waiting for your approval. Please review and take required action.")
    end
  end
end
