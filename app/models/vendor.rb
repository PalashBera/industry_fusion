class Vendor < ApplicationRecord
  include UserInformationModule
  include ModalFormModule

  devise :database_authenticatable, :invitable, :async

  has_one  :store_information
  has_many :vendorships
  has_many :organizations, through: :vendorships

  delegate :name, to: :store_information, allow_nil: true

  def self.import(file)
    CSV.foreach(file.path, headers: true, header_converters: :symbol) do |row|
      invite_vendor(row.to_h[:email])
    end
  end

  protected

  def send_confirmation_instructions
    invitation_token.present? ? skip_confirmation_notification! : super
  end

  private

  def invite_vendor(email)
    vendor = find_or_initialize_by(email: email)
    return if vendorship?(vendor)

    if vendor.new_record?
      invite!({ email: email }, User.current_user).deliver_invitation
      vendor = find_by_email(email)
    else
      vendor.send_new_vendorship_mail
    end

    vendor.vendorships.create(organization_id: Organization.current_organization.id)
  end

  def vendorship?(vendor)
    vendor.organizations.include?(Organization.current_organization)
  end

  def send_new_vendorship_mail
    VendorMailer.organization_acknowledgement(self, User.current_user).deliver_later
  end
end
