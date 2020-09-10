class QuotationRequestVendor < ApplicationRecord
  include UserTrackingModule

  belongs_to :vendorship
  belongs_to :quotation_request
end
