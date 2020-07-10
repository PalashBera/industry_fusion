require "rails_helper"

RSpec.describe VendorMailer, type: :mailer do
  let(:user) { create(:user) }

  before(:each) do
    ActsAsTenant.stub(:current_tenant).and_return(user.organization)
    User.stub(:current_user).and_return(user)
  end

  describe "#organization_acknowledgement" do
    let(:vendor) { create(:vendor) }
    let(:mail)   { VendorMailer.organization_acknowledgement(vendor.id, user.id) }

    it "renders the headers" do
      expect(mail.subject).to eq(I18n.t("mail.new_vendorship.subject", name: user.organization.name))
      expect(mail.to).to eq([vendor.email])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hurrah!! One new vendorship has been added for")
    end
  end
end
