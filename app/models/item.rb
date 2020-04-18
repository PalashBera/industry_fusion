class Item < ApplicationRecord
  include Archivable
  include ModalFormable
  include UserTrackable
  include Nameable

  acts_as_tenant(:organization)
  has_paper_trail ignore: %i[created_at updated_at]

  before_save :remove_quantities_if_secondary_uom_absent

  belongs_to :organization
  belongs_to :item_group
  belongs_to :uom
  belongs_to :secondary_uom, class_name: "Uom", optional: true

  validates :primary_quantity, :secondary_quantity, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10_000_000, allow_nil: true }
  validate :secondary_uom_value

  def self.included_resources
    includes(:item_group, :uom, :secondary_uom)
  end

  private

  def remove_quantities_if_secondary_uom_absent
    return unless secondary_uom.blank?

    self.primary_quantity = nil
    self.secondary_quantity = nil
  end

  def secondary_uom_value
    errors.add(:secondary_uom, "can't be same as UOM") if secondary_uom == uom
  end
end
