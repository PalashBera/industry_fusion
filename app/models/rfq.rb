class Rfq < ApplicationRecord
  include UserTrackingModule

  STATUS_LIST = %w[pending approved amended rejected cancelled].freeze
  enum status: Hash[STATUS_LIST.map { |item| [item, item] }]

  acts_as_tenant(:organization)

  before_validation { self.note = note.to_s.squish }
  before_validation :set_serial, on: :create

  belongs_to :organization
  belongs_to :company
  belongs_to :warehouse

  has_many :rfq_items,   dependent: :destroy
  has_many :rfq_vendors, dependent: :destroy

  accepts_nested_attributes_for :rfq_items, reject_if: :all_blank, allow_destroy: true

  delegate :name, to: :company,   prefix: :company
  delegate :name, to: :warehouse, prefix: :warehouse

  validates :serial, :rfq_items, presence: true

  scope :order_by_serial,           -> { order(:serial) }
  scope :in_current_org_date_range, ->(start_date, end_date) { where(created_at: start_date...end_date) }

  has_paper_trail ignore: %i[created_at]

  def self.included_resources
    includes(:company, :warehouse, :created_by)
  end

  private

  def set_serial
    start_date, end_date = User.current_user.organization.fy_date_range
    current_fy_rfqs = Rfq.in_current_org_date_range(start_date, end_date).order_by_serial
    last_rfq_serial = current_fy_rfqs.last&.serial || 0
    self.serial = last_rfq_serial + 1
    self.serial_number = generate_serial_number
  end

  def generate_serial_number
    start_date, end_date = User.current_user.organization.fy_date_range
    "RFQ/#{start_date.strftime("%y")}-#{end_date.strftime("%y")}/#{company.short_name}/#{warehouse.short_name}/#{serial.to_s.rjust(4, "0")}"
  end
end
