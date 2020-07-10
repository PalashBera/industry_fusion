class VendorMailer < ApplicationMailer
  def organization_acknowledgement(vendor_id, user_id)
    @vendor = Vendor.find(vendor_id)
    @user = User.find(user_id)
    mail to: @vendor.email, subject: I18n.t("mail.new_vendorship.subject", name: @user.organization.name)
  end
end
