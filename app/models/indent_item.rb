class IndentItem < ApplicationRecord
  include UserTrackable

  acts_as_tenant(:organization)

  VALID_DECIMAL_REGEX = /\A\d+(?:\.\d{0,2})?\z/.freeze

  belongs_to :organization
  belongs_to :indent
  belongs_to :item
  belongs_to :uom
  belongs_to :cost_center
  belongs_to :make, optional: true

  has_paper_trail ignore: %i[created_at updated_at]

  enum priority: { default: "default", high: "high", medium: "medium", low: "low" }, _suffix: true

  validates :quantity, presence: true, format: { with: VALID_DECIMAL_REGEX }, numericality: { greater_than: 0 }
  validates :priority, presence: true

  def self.included_resources
    includes({ indent: %i[company warehouse] }, :item, { make: :brand }, :uom, :cost_center)
  end

  def quantity_with_uom
    "#{quantity} #{uom.short_name}"
  end
end
