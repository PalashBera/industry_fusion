class PaymentTerm < ApplicationRecord
  include NameModule
  include ArchiveModule
  include ModalFormModule
  include UserTrackingModule

  acts_as_tenant(:organization)

  belongs_to :organization

  validates :description, presence: true

  has_paper_trail ignore: %i[created_at updated_at]
end
