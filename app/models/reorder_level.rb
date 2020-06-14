class ReorderLevel < ApplicationRecord
  include Archivable
  include ModalFormable
  include UserTrackable

  VALID_DECIMAL_REGEX = /\A\d+(?:\.\d{0,2})?\z/.freeze
  enum priority: { default: "default", high: "high", medium: "medium", low: "low" }, _suffix: true

  acts_as_tenant(:organization)

  belongs_to :organization
  belongs_to :item
  belongs_to :warehouse

  delegate :name, to: :item, prefix: true
  delegate :name, to: :warehouse, prefix: true

  validates :quantity, presence: true, format: { with: VALID_DECIMAL_REGEX }, numericality: { greater_than: 0 }

  has_paper_trail ignore: %i[created_at updated_at]

  def self.included_resources
    includes(:warehouse, { item: :uom })
  end

  def quantity_with_uom
    "#{quantity} #{item.uom.short_name}"
  end
end