class IndentItem < ApplicationRecord
  include UserTrackingModule

  VALID_DECIMAL_REGEX = /\A\d+(?:\.\d{0,2})?\z/.freeze
  enum priority: { default: "default", high: "high", medium: "medium", low: "low" }, _suffix: true

  acts_as_tenant(:organization)

  belongs_to :organization
  belongs_to :indent
  belongs_to :item
  belongs_to :make, optional: true
  belongs_to :uom
  belongs_to :cost_center

  delegate :serial_number,     to: :indent,      prefix: :indent
  delegate :requirement_date,  to: :indent,      prefix: :indent
  delegate :name,              to: :item,        prefix: :item
  delegate :brand_with_cat_no, to: :make,        prefix: :make, allow_nil: true
  delegate :name,              to: :cost_center, prefix: :cost_center

  validates :quantity, presence: true, format: { with: VALID_DECIMAL_REGEX }, numericality: { greater_than: 0 }
  validates :priority, presence: true

  has_paper_trail ignore: %i[created_at updated_at]

  def self.included_resources
    includes({ indent: %i[company warehouse] }, :item, { make: :brand }, :uom, :cost_center)
  end

  def quantity_with_uom
    "#{quantity} #{uom.short_name}"
  end
end
