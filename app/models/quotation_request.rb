class QuotationRequest < ApplicationRecord
  include UserTrackingModule

  acts_as_tenant(:organization)

  before_validation :set_serial_number, on: :create

  belongs_to :company
  belongs_to :warehouse

  has_many :quotation_request_items
  has_many :quotation_request_vendors
  has_many :indent_items, through: :quotation_request_items
  has_many :vendorships, through: :quotation_request_vendors

  validates :serial, :serial_number, presence: true, uniqueness: { scope: :warehouse_id }

  scope :order_by_serial,   -> { order(:serial) }
  scope :date_range_filter, ->(start_date, end_date) { where(created_at: start_date...end_date) }
  scope :warehouse_filter,  ->(warehouse_id) { where(warehouse_id: warehouse_id) }

  def create_quotation_request_items(items)
    items.each do |item|
      quotation_request_items.create(indent_item: item)
    end
  end

  def create_quotation_request_vendors(vendors)
    vendors.each do |vendor|
      quotation_request_vendors.create(vendorship: vendor)
    end
  end

  private

  def set_serial_number
    start_date, end_date = User.current_user.organization.fy_date_range
    current_fy_quotation_requests = QuotationRequest.date_range_filter(start_date, end_date).warehouse_filter(warehouse_id).order_by_serial
    last_quotation_request_serial = current_fy_quotation_requests.last&.serial || 0
    self.serial = last_quotation_request_serial + 1
    self.serial_number = "QR/#{start_date.strftime("%y")}-#{end_date.strftime("%y")}/#{warehouse&.short_name}/#{serial.to_s.rjust(4, "0")}"
  end
end
