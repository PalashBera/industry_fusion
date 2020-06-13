class WarehouseLocation < ApplicationRecord
  include Archivable
  include ModalFormable
  include UserTrackable

  acts_as_tenant(:organization)

  before_validation { self.name = name.to_s.squish }

  belongs_to :organization
  belongs_to :warehouse

  validates :name, presence: true, length: { maximum: 255 }, uniqueness: { case_sensitive: false, scope: %i[organization_id warehouse_id] }

  has_paper_trail ignore: %i[created_at updated_at]

  scope :order_by_name, -> { order(:name) }

  def self.included_resources
    includes(:warehouse)
  end
end
