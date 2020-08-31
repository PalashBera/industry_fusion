class Uom < ApplicationRecord
  include NameModule
  include ArchiveModule
  include ModalFormModule
  include UserTrackingModule

  acts_as_tenant(:organization)

  before_validation { self.short_name = short_name.to_s.squish }

  belongs_to :organization

  has_many :items
  has_many :indent_items

  validates :short_name, presence: true, length: { maximum: 4 }, uniqueness: { case_sensitive: false, scope: :organization_id }

  scope :order_by_short_name, -> { order(:short_name) }

  has_paper_trail ignore: %i[created_at updated_at updated_by_id]
end
