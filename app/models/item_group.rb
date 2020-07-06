class ItemGroup < ApplicationRecord
  include NameModule
  include ArchiveModule
  include ModalFormModule
  include UserTrackingModule

  acts_as_tenant(:organization)

  before_validation { self.hsn_code = hsn_code.to_s.squish.upcase }

  belongs_to :organization

  has_many :items

  has_paper_trail ignore: %i[created_at updated_at]

  validates :hsn_code, length: { minimum: 6, maximum: 8 }
end
