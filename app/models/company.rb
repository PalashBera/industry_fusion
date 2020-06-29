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

  scope :accessible_companies, ->(warehouse_ids) { joins(:warehouses).where(warehouses: { id: warehouse_ids }).distinct }

  has_paper_trail ignore: %i[created_at updated_at]
end
