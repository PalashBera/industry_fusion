class AdditionalTerm < ApplicationRecord
  include NameModule
  include ArchiveModule
  include UserTrackingModule
  include ModalFormModule

  acts_as_tenant(:organization)

  validates :conditions, presence: true

  has_paper_trail ignore: %i[created_at updated_at updated_by_id]
end
