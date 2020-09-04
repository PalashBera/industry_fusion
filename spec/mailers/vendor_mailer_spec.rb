require "rails_helper"

RSpec.describe VendorMailer, type: :mailer do
  let(:user) { create(:user) }

  before(:each) do
    ActsAsTenant.current_tenant = user.organization
    User.current_user = user
  end

  describe "#organization_acknowledgement" do
    let(:vendor) { create(:vendor) }
    let(:mail)   { VendorMailer.organization_acknowledgement(vendor.id, user.id) }

    it "renders the headers" do
      expect(mail.subject).to eq(I18n.t("mail.vendorship.new.subject", name: user.organization.name))
      expect(mail.to).to eq([vendor.email])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Congratulation!! You have been added as a vendor")
    end
  end

  describe "#vendorship_activation_acknowledgement" do
    let(:vendor) { create(:vendor) }
    let(:mail)   { VendorMailer.vendorship_activation_acknowledgement(vendor.id, user.id) }

    it "renders the headers" do
      expect(mail.subject).to eq(I18n.t("mail.vendorship.activate.subject", name: user.organization.name))
      expect(mail.to).to eq([vendor.email])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("We're glad to see you again.")
    end
  end

  describe "#vendorship_deactivation_acknowledgement" do
    let(:vendor) { create(:vendor) }
    let(:mail)   { VendorMailer.vendorship_deactivation_acknowledgement(vendor.id, user.id) }

    it "renders the headers" do
      expect(mail.subject).to eq(I18n.t("mail.vendorship.archive.subject", name: user.organization.name))
      expect(mail.to).to eq([vendor.email])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("We'd love to see you again.")
    end
  end
end
