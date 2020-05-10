module VendorTrackable
  extend ActiveSupport::Concern

  included do
    before_create :set_created_by
    before_save   :set_updated_by

    belongs_to :created_by, class_name: "Vendor", optional: true
    belongs_to :updated_by, class_name: "Vendor", optional: true

    scope :created_by, ->(vendor) { where(created_by_id: vendor.id) }
    scope :updated_by, ->(vendor) { where(updated_by_id: vendor.id) }
  end

  protected

  def set_created_by
    self.created_by = Vendor.current_vendor
    true
  end

  def set_updated_by
    self.updated_by = Vendor.current_vendor
    true
  end
end
