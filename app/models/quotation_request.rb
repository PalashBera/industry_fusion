class QuotationRequest < ApplicationRecord
  include UserTrackingModule

  acts_as_tenant(:organization)

  after_create :set_items_and_vendor

  before_validation :set_company_warehouse

  attr_accessor :current_step, :indent_item_ids, :vendorship_ids

  belongs_to :company,   optional: true
  belongs_to :warehouse, optional: true

  has_many :quotation_request_items
  has_many :indent_items, through: :quotation_request_items

  has_many :quotation_request_vendors
  has_many :vendorships, through: :quotation_request_vendors

  delegate :name, to: :company,   prefix: :company
  delegate :name, to: :warehouse, prefix: :warehouse
  delegate :name, to: :indentor,  prefix: :indentor, allow_nil: true

  validates :indent_item_ids, presence: true, if: lambda { |quotation_request| quotation_request.current_step == "approved_item_addition" }
  validates :vendorship_ids, presence: true, if: lambda { |quotation_request| quotation_request.current_step == "vendor_addition" }
  validates :serial, :serial_number, :company_id, :warehouse_id, presence: true, if: lambda { |quotation_request| quotation_request.current_step == "approved_item_addition" }

  def current_step
    @current_step || steps.first
  end

  def steps
    %w[approved_item_addition vendor_addition]
  end

  def next_step
    self.current_step = steps[steps.index(current_step)+1]
  end

  def previous_step
    self.current_step = steps[steps.index(current_step)-1]
  end

  def first_step?
    current_step == steps.first
  end

  def last_step?
    current_step == steps.last
  end

  def all_valid?
    steps.all? do |step|
      self.current_step = step
      valid?
    end
  end

  private

  def set_company_warehouse
    items = IndentItem.where(id: indent_item_ids)

    if items.map(&:warehouse_name).uniq.length > 1
      errors.add(:base, "Please select items for same warehouses only")
      throw :abort
    end

    if first_step? && items.present?
      self.company_id = items.first.indent.company_id
      self.warehouse_id = items.first.indent.warehouse_id
      self.serial_number = items.first.indent_serial_number
      self.serial = items.first.indent.serial
    end
  end

  def set_items_and_vendor
    indent_item_ids.each do |i|
      quotation_request_items.create(indent_item_id: i.to_i)
    end

    vendorship_ids.each do |v|
      quotation_request_vendors.create(vendorship_id: v.to_i)
    end
  end
end
