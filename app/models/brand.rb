class Brand < ApplicationRecord
  include Archivable
  include ModalFormable
  include UserTrackable

  acts_as_tenant(:organization)
  has_paper_trail ignore: %i[created_at updated_at]

  before_validation { self.name = name.to_s.squish }

  belongs_to :organization

  validates :name, presence: true, length: { maximum: 255 }, uniqueness: { case_sensitive: false, scope: :organization_id }
end
