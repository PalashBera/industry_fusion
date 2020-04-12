class ItemGroup < ApplicationRecord
  include Archivable
  include ModalFormable
  include UserTrackable

  acts_as_tenant(:organization)
  has_paper_trail ignore: %i[created_at updated_at]

  before_validation do
    self.name = name.to_s.squish
  end

  belongs_to :organization

  validates :name, presence: true, length: { maximum: 255 }, uniqueness: { case_sensitive: false, scope: :organization_id }

  scope :order_by_name, -> { order(:name) }
end
