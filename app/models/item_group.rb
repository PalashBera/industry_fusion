class ItemGroup < ApplicationRecord
  include NameModule
  include ArchiveModule
  include ModalFormModule
  include UserTrackingModule

  acts_as_tenant(:organization)

  before_validation { self.hsn_code = hsn_code.to_s.squish.upcase }

  belongs_to :organization

  has_many :items

  validates :hsn_code, length: { minimum: 6, maximum: 8 }

  has_paper_trail ignore: %i[created_at updated_at updated_by_id]
end
