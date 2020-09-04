require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let(:user) { create(:user) }

  before(:each) do
    ActsAsTenant.current_tenant = user.organization
    User.current_user = user
  end

  describe "#account_activation_acknowledgement" do
    let(:receiver) { create(:user) }
    let(:mail)     { UserMailer.account_activation_acknowledgement(receiver.id, user.id) }

    it "renders the headers" do
      expect(mail.subject).to eq(I18n.t("mail.account.activate.subject", name: user.organization.name))
      expect(mail.to).to eq([vendor.email])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("We're glad to see you again.")
    end
  end

  describe "#account_deactivation_acknowledgement" do
    let(:receiver) { create(:user) }
    let(:mail)     { UserMailer.account_deactivation_acknowledgement(receiver.id, user.id) }

    it "renders the headers" do
      expect(mail.subject).to eq(I18n.t("mail.account.archive.subject", name: user.organization.name))
      expect(mail.to).to eq([vendor.email])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("We'd love to see you again.")
    end
  end
end
