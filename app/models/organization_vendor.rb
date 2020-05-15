class OrganizationVendor < ApplicationRecord
  include Archivable
  include ModalFormable
  include UserTrackable

  belongs_to :organization
  belongs_to :vendor
end
