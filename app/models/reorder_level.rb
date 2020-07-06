class ReorderLevel < ApplicationRecord
  include ArchiveModule
  include ModalFormModule
  include UserTrackingModule

  VALID_DECIMAL_REGEX = /\A\d+(?:\.\d{0,2})?\z/.freeze
  PRIORITY_LIST = %w[default high medium low].freeze
  enum priority: Hash[PRIORITY_LIST.map { |item| [item, item] }], _suffix: true

  acts_as_tenant(:organization)

  belongs_to :organization
  belongs_to :item
  belongs_to :warehouse

  delegate :name, to: :item, prefix: true
  delegate :name, to: :warehouse, prefix: true

  validates :quantity, presence: true, format: { with: VALID_DECIMAL_REGEX }, numericality: { greater_than: 0 }
  validates :priority, presence: true

  has_paper_trail ignore: %i[created_at updated_at]

  def self.included_resources
    includes(:warehouse, { item: :uom })
  end

  def quantity_with_uom
    "#{quantity} #{item.uom.short_name}"
  end
end
