class QuotationRequestItem < ApplicationRecord
  include UserTrackingModule

  belongs_to :indent_item
  belongs_to :quotation_request
end
