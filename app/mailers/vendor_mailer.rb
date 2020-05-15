class VendorMailer < ApplicationMailer
  def organization_acknowledgement(vendor, user)
    @vendor = vendor
    @user = user
    mail to: @vendor.email, subject: "New Vendorship – #{@user.organization.name}"
  end
end
