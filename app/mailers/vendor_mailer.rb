class VendorMailer < ApplicationMailer
  def organization_acknowledgement(vendor_id, user_id)
    @vendor = Vendor.find(vendor_id)
    @user = User.find(user_id)
    mail to: @vendor.email, subject: I18n.t("mail.vendorship.new.subject", name: @user.organization.name)
  end

  def vendorship_activation_acknowledgement(vendor_id, user_id)
    @vendor = Vendor.find(vendor_id)
    @user = User.find(user_id)
    mail to: @vendor.email, subject: I18n.t("mail.vendorship.activate.subject", name: @user.organization.name)
  end

  def vendorship_deactivation_acknowledgement(vendor_id, user_id)
    @vendor = Vendor.find(vendor_id)
    @user = User.find(user_id)
    mail to: @vendor.email, subject: I18n.t("mail.vendorship.archive.subject", name: @user.organization.name)
  end
end
