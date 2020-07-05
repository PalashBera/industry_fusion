class Indent < ApplicationRecord
  include UserTrackingModule

  acts_as_tenant(:organization)

  before_validation :set_serial, on: :create

  belongs_to :organization
  belongs_to :company
  belongs_to :warehouse
  belongs_to :indentor, optional: true

  has_many :indent_items, dependent: :destroy

  accepts_nested_attributes_for :indent_items, reject_if: :all_blank, allow_destroy: true

  delegate :name, to: :company,   prefix: :company
  delegate :name, to: :warehouse, prefix: :warehouse
  delegate :name, to: :indentor,  prefix: :indentor, allow_nil: true

  validates :serial, :indent_items, presence: true

  scope :order_by_serial,        -> { order(:serial) }
  scope :filter_with_date_range, ->(start_date, end_date) { where("requirement_date >= ? AND requirement_date <= ?", start_date, end_date) }

  has_paper_trail ignore: %i[created_at]

  def serial_number
    start_date, end_date = fy_date_range
    "IND/#{start_date.strftime("%y")}-#{end_date.strftime("%y")}/#{company.short_name}/#{warehouse.short_name}/#{serial.to_s.rjust(4, "0")}"
  end

  private

  def set_serial
    start_date, end_date = fy_date_range
    current_fy_indents = Indent.filter_with_date_range(start_date, end_date).order_by_serial
    last_indent_serial = current_fy_indents.last&.serial || 0
    self.serial = last_indent_serial + 1
  end

  def fy_date_range
    return unless requirement_date

    requirement_date.month < 4 ? start_year = requirement_date.year - 1 : start_year = requirement_date.year
    requirement_date.month < 4 ? end_year =   requirement_date.year : end_year =   requirement_date.year + 1
    [Date.new(start_year, 4, 1), Date.new(end_year, 3, 30)]
  end
end
