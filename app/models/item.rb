class Item < ApplicationRecord
  include Archivable
  include ModalFormable
  include UserTrackable
  include Nameable

  acts_as_tenant(:organization)

  belongs_to :organization
  belongs_to :item_group
  belongs_to :uom
  belongs_to :secondary_uom, class_name: "Uom", optional: true

  has_many :makes
  has_many :indent_items

  accepts_nested_attributes_for :makes, reject_if: :all_blank, allow_destroy: true

  validates :primary_quantity, :secondary_quantity, presence: true, numericality: { greater_than: 0 }, if: :secondary_uom
  validate :check_secondary_uom_equality

  has_paper_trail ignore: %i[created_at updated_at]

  def self.included_resources
    includes(:item_group, :uom, :secondary_uom)
  end

  def uoms
    [uom, secondary_uom].compact
  end

  private

  def check_secondary_uom_equality
    errors.add(:secondary_uom, "can't be same as UOM") if secondary_uom.present? && uom == secondary_uom
  end
end
