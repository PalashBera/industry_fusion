class Indent < ApplicationRecord
  include UserTrackable

  acts_as_tenant(:organization)

  before_create :set_serial

  belongs_to :organization
  belongs_to :company
  belongs_to :warehouse

  has_many :indent_items, dependent: :destroy

  accepts_nested_attributes_for :indent_items, reject_if: :all_blank, allow_destroy: true

  validates :indent_items, presence: true

  scope :filter_with_date_range, ->(start_date, end_date) { where("requirement_date >= ? AND requirement_date <= ?", start_date, end_date) }
  scope :order_by_serial, -> { order("serial asc") }

  has_paper_trail ignore: %i[created_at]

  def self.initial_financial_year
    order(requirement_date: :asc).first&.financial_year_range
  end

  def serial_number
    start_date, end_date = fy_date_range
    "IND/#{start_date.strftime("%y")}-#{end_date.strftime("%y")}/#{company.short_name}/#{warehouse.short_name}/#{serial.to_s.rjust(4, "0")}"
  end

  def financial_year_range
    fy_start_year, fy_end_year = fy_date_range
    [fy_start_year.year, fy_end_year.year]
  end

  private

  def set_serial
    start_date, end_date = fy_date_range
    current_fy_indents = Indent.filter_with_date_range(start_date, end_date).order_by_serial
    last_indent_serial = current_fy_indents.last&.serial || 0
    self.serial = last_indent_serial + 1
  end

  def fy_date_range
    fy_start_month = Organization.current_organization.fy_start_month
    fy_end_month = Organization.current_organization.fy_end_month

    requirement_date.month < fy_start_month ? start_year = requirement_date.year - 1 : start_year = requirement_date.year
    requirement_date.month < fy_end_month ? end_year = requirement_date.year : end_year = requirement_date.year + 1
    [Date.new(start_year, 4, 1), Date.new(end_year, 3, 31)]
  end
end
