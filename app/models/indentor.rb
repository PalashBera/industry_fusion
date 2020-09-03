class Indentor < ApplicationRecord
  include UserTrackingModule
  include NameModule
  include ArchiveModule
  include ModalFormModule

  acts_as_tenant(:organization)

  belongs_to :organization

  has_many :indents

  has_paper_trail ignore: %i[created_at updated_at updated_by_id]
end
