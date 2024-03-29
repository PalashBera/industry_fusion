class Indent < ApplicationRecord
  include UserTrackingModule

  acts_as_tenant(:organization)

  before_validation :set_serial_number, on: :create

  belongs_to :organization
  belongs_to :company
  belongs_to :warehouse
  belongs_to :indentor, optional: true

  has_many :indent_items, dependent: :destroy

  accepts_nested_attributes_for :indent_items, reject_if: :all_blank, allow_destroy: true

  delegate :name, to: :company,   prefix: :company
  delegate :name, to: :warehouse, prefix: :warehouse
  delegate :name, to: :indentor,  prefix: :indentor, allow_nil: true

  validates :indent_items, presence: true
  validates :serial, :serial_number, presence: true, uniqueness: { scope: :warehouse_id }

  scope :order_by_serial,   -> { order(:serial) }
  scope :date_range_filter, ->(start_date, end_date) { where(created_at: start_date...end_date) }
  scope :warehouse_filter,  ->(warehouse_id) { where(warehouse_id: warehouse_id) }

  has_paper_trail ignore: %i[created_at]

  def self.indent_item_vs_item
    indent_item_count_plot = IndentItem.joins({ indent: :warehouse }, :item)
                                       .includes(:item)
                                       .where(warehouses: { id: User.current_user.accessible_warehouse_ids })
                                       .group_by(&:item_name).map { |k, v| [k, v.size] }
                                       .sort_by(&:last)
                                       .reverse
                                       .first(15)

    item_names = indent_item_count_plot.map(&:first)
    indent_items_count = indent_item_count_plot.map(&:last)

    [item_names, indent_items_count]
  end

  def self.indent_item_vs_cost_center
    indent_item_count_plot = IndentItem.joins({ indent: :warehouse }, :cost_center)
                                       .includes(:cost_center)
                                       .where(warehouses: { id: User.current_user.accessible_warehouse_ids })
                                       .group_by(&:cost_center_name).map { |k, v| [k, v.size] }
                                       .sort_by(&:last)
                                       .reverse
                                       .first(15)

    cost_center_names = indent_item_count_plot.map(&:first)
    indent_items_count = indent_item_count_plot.map(&:last)

    [cost_center_names, indent_items_count]
  end

  private

  def set_serial_number
    start_date, end_date = User.current_user.organization.fy_date_range
    current_fy_indents = Indent.date_range_filter(start_date, end_date).warehouse_filter(warehouse_id).order_by_serial
    last_indent_serial = current_fy_indents.last&.serial || 0
    self.serial = last_indent_serial + 1
    self.serial_number = "IND/#{start_date.strftime("%y")}-#{end_date.strftime("%y")}/#{warehouse&.short_name}/#{serial.to_s.rjust(4, "0")}"
  end
end
