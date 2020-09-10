class QuotationRequest < ApplicationRecord
  include UserTrackingModule

  acts_as_tenant(:organization)

  belongs_to :company
  belongs_to :warehouse

  has_many :quotation_request_items
  has_many :indent_items, through: :quotation_request_items

  has_many :quotation_request_vendors
  has_many :vendorships, through: :quotation_request_vendors
end
