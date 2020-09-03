class Company < ApplicationRecord
  include NameModule
  include ShortNameModule
  include AddressModule
  include ArchiveModule
  include ModalFormModule
  include UserTrackingModule

  acts_as_tenant(:organization)

  belongs_to :organization

  has_many :warehouses
  has_many :indents

  has_attached_file :logo

  validates_attachment_content_type :logo, content_type: ["image/jpeg", "image/png"]
  validates_attachment_size :logo, less_than: 2.megabytes

  scope :warehouse_filter, ->(warehouse_ids) { joins(:warehouses).where(warehouses: { id: warehouse_ids }).distinct }

  has_paper_trail ignore: %i[created_at updated_at updated_by_id]
end
