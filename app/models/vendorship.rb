class Vendorship < ApplicationRecord
  include ArchiveModule
  include ModalFormModule
  include UserTrackingModule

  belongs_to :organization
  belongs_to :vendor

  validates_uniqueness_of :vendor_id, scope: :organization_id
end
