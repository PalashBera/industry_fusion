class Vendorship < ApplicationRecord
  include ArchiveModule
  include ModalFormModule
  include UserTrackingModule

  acts_as_tenant(:organization)

  belongs_to :organization
  belongs_to :vendor

  delegate :name,           to: :vendor, prefix: true
  delegate :contact_person, to: :vendor, prefix: true
  delegate :email,          to: :vendor, prefix: true
  delegate :mobile_number,  to: :vendor, prefix: true

  validates :vendor_id, uniqueness: { scope: :organization_id }

  def status
    if vendor.pending?
      I18n.t("status.pending")
    elsif archive?
      I18n.t("status.archived")
    else
      I18n.t("status.active")
    end
  end

  def toggle_activation
    update(archive: !archive)
  end
end
