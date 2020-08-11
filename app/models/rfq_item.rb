class RfqItem < ApplicationRecord
  include UserTrackingModule

  VALID_DECIMAL_REGEX = /\A\d+(?:\.\d{0,2})?\z/.freeze

  belongs_to :rfq
  belongs_to :indent_item

  validates :quantity, presence: true, format: { with: VALID_DECIMAL_REGEX }, numericality: { greater_than: 0 }
end
