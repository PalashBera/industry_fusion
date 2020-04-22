class IndentItem < ApplicationRecord
  act_as_tenant(:organization)

  VALID_DECIMAL_REGEX = /\A\d+(?:\.\d{0,2})?\z/.freeze

  belongs_to :organization
  belongs_to :indent
  belongs_to :item
  belongs_to :make
  belongs_to :uom
  belongs_to :cost_center

  has_paper_trail ignore: %i[created_at updated_at]

  enum priority: { default: "default", high: "high", medium: "medium", low: "low" }, _suffix: true

  validates :quantity, presence: true, format: { with: VALID_DECIMAL_REGEX }, numericality: { greater_than: 0 }
end
