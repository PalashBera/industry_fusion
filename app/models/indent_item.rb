class IndentItem < ApplicationRecord
  include UserTrackable
  extend FinancialYearHelper

  VALID_DECIMAL_REGEX = /\A\d+(?:\.\d{0,2})?\z/.freeze
  enum priority: { default: "default", high: "high", medium: "medium", low: "low" }, _suffix: true

  acts_as_tenant(:organization)

  belongs_to :organization
  belongs_to :indent
  belongs_to :item
  belongs_to :uom
  belongs_to :cost_center
  belongs_to :make, optional: true

  delegate :name, to: :cost_center, prefix: :cost_center
  delegate :name, to: :item, prefix: :item
  delegate :requirement_date, to: :indent, prefix: :indent
  delegate :serial_number, to: :indent, prefix: :indent
  delegate :brand_with_cat_no, to: :make, prefix: :make, allow_nil: true

  validates :quantity, presence: true, format: { with: VALID_DECIMAL_REGEX }, numericality: { greater_than: 0 }
  validates :priority, presence: true

  has_paper_trail ignore: %i[created_at updated_at]

  scope :order_by_indent_serial, -> { order("indents.serial desc") }
  # scope :financial_year_filter, ->(fy_start_date, fy_end_date) { where("indents.requirement_date BETWEEN ? AND ?", fy_start_date, fy_end_date) }

  def self.fy_filter(fy_param = nil)
    fy_start_date, fy_end_date = fy_date_range(fy_param)
    where("indents.requirement_date BETWEEN ? AND ?", fy_start_date, fy_end_date)
  end

  def self.ransackable_scopes(_auth_object = nil)
    %i[fy_filter]
  end

  def self.included_resources
    includes({ indent: %i[company warehouse] }, :item, { make: :brand }, :uom, :cost_center)
  end

  def quantity_with_uom
    "#{quantity} #{uom.short_name}"
  end
end
