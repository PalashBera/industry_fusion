class QuotationRequestItem < ApplicationRecord
  include UserTrackingModule

  belongs_to :indent_item
  belongs_to :quotation_request

  delegate :serial_number,     to: :quotation_request, prefix: :indent
  delegate :item_name,         to: :indent_item
  delegate :uom_short_name,    to: :indent_item
  delegate :cost_center_name,  to: :indent_item
  delegate :company_name,      to: :quotation_request
  delegate :warehouse_name,    to: :quotation_request
  delegate :brand_details,     to: :indent_item
  delegate :quantity_with_uom, to: :indent_item
  delegate :indent,            to: :indent_item
  delegate :requirement_date,  to: :indent_item, prefix: :indent
  delegate :priority,          to: :indent_item
  delegate :status,            to: :indent_item

  def self.included_resources
    includes({ indent_item: [{ indent: %i[company warehouse indentor] }, { make: :brand }, :uom, :cost_center ]}, :quotation_request)
  end
end
