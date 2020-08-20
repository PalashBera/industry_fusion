require "rails_helper"

RSpec.describe ApprovalMailer, type: :mailer do
  let(:user)                  { create(:user) }
  let(:indent_item)           { create(:indent_item) }
  let(:approval_request)      { create(:approval_request, approval_requestable_id: indent_item.id) }
  let(:approval_request_user) { create(:approval_request_user, approval_request_id: approval_request.id, user_id: user.id) }

  before(:each) do
    ActsAsTenant.current_tenant = user.organization
    User.current_user = user
  end

  describe "#indent_approval" do
    let(:mail) { ApprovalMailer.indent_approval(approval_request_user.id, user.id) }

    it "renders the headers" do
      expect(mail.subject).to eq(I18n.t("mail.indent_approval.subject", serial: indent_item.indent_serial_number))
      expect(mail.to).to eq([user.email])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Item is waiting for your approval. Please review and take required action.")
    end
  end
end
