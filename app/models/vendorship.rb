class Vendorship < ApplicationRecord
  include ArchiveModule
  include ModalFormModule
  include UserTrackingModule

  acts_as_tenant(:organization)

  belongs_to :organization
  belongs_to :vendor

  has_many :quotation_request_vendors

  delegate :name,           to: :vendor, prefix: true
  delegate :contact_person, to: :vendor, prefix: true
  delegate :email,          to: :vendor, prefix: true
  delegate :mobile_number,  to: :vendor, prefix: true

  validates :vendor_id, uniqueness: { scope: :organization_id }

  scope :id_filter, ->(ids) { where(id: ids) }

  has_paper_trail only: %i[archive invitation_sent_at]

  def status
    if vendor.pending?
      I18n.t("status.pending")
    elsif archive?
      I18n.t("status.archived")
    else
      I18n.t("status.active")
    end
  end

  def toggle_archive
    update(archive: !archive)

    if archive?
      VendorMailer.vendorship_deactivation_acknowledgement(vendor.id, User.current_user.id).deliver_later
    else
      VendorMailer.vendorship_activation_acknowledgement(vendor.id, User.current_user.id).deliver_later
    end
  end
end
