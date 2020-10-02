class QuotationRequestVendor < ApplicationRecord
  include UserTrackingModule

  after_create_commit :notify_vendor

  belongs_to :vendorship
  belongs_to :quotation_request

  private

  def notify_vendor
    VendorMailer.quotation_request_notification(vendorship_id, quotation_request_id).deliver_later
  end
end
