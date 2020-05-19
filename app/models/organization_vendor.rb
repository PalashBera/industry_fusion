class OrganizationVendor < ApplicationRecord
  include Archivable
  include ModalFormable
  include UserTrackable

  belongs_to :organization
  belongs_to :vendor

  validates_uniqueness_of :vendor_id, scope: :organization_id
end
