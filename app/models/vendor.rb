class Vendor < ApplicationRecord
  include ModalFormable
  include UserInformable

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable, :trackable, :invitable, :async

  has_one :store_information
  has_many :organization_vendors
  has_many :organizations, through: :organization_vendors

  delegate :name, to: :store_information, allow_nil: true

  def method_name
    VendorMailer.organization_acknowledgement(self, User.current_user).deliver_later
  end

  protected

  def send_confirmation_instructions
    invitation_token.present? ? skip_confirmation_notification! : super
  end
end
