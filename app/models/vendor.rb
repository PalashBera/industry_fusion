class Vendor < ApplicationRecord
  include ModalFormable
  include UserInformable

  devise :database_authenticatable, :recoverable, :rememberable, :validatable, :confirmable, :trackable, :invitable, :async

  has_one :store_information
  has_many :organization_vendors
  has_many :organizations, through: :organization_vendors

  delegate :name, to: :store_information, allow_nil: true

  def self.import(file)
    CSV.foreach(file.path, headers: true, header_converters: :symbol) do |row|
      invite_vendor(row.to_h[:email])
    end
  end

  def self.invite_vendor(email)
    vendor = find_or_initialize_by(email: email)

    if vendor.new_record?
      invite!({ email: email }, User.current_user).deliver_invitation
      vendor = find_by_email(email)
    else
      vendor.send_new_vendorship_mail
    end

    vendor.organization_vendors.create(organization_id: Organization.current_organization.id)
  end

  def send_new_vendorship_mail
    VendorMailer.organization_acknowledgement(self, User.current_user).deliver_later
  end

  protected

  def send_confirmation_instructions
    invitation_token.present? ? skip_confirmation_notification! : super
  end
end
