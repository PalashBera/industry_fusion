class Item < ApplicationRecord
  include NameModule
  include ArchiveModule
  include ModalFormModule
  include UserTrackingModule

  acts_as_tenant(:organization)

  attr_accessor :attachments

  belongs_to :organization
  belongs_to :item_group
  belongs_to :uom
  belongs_to :secondary_uom, class_name: "Uom", optional: true

  has_many :makes
  has_many :indent_items
  has_many :reorder_levels
  has_many :item_images, dependent: :destroy

  accepts_nested_attributes_for :makes, reject_if: :all_blank, allow_destroy: true

  validates :primary_quantity, :secondary_quantity, presence: true, numericality: { greater_than: 0 }, if: :secondary_uom
  validate :check_secondary_uom_equality

  has_paper_trail ignore: %i[created_at updated_at]

  def self.included_resources
    includes(:item_group, :uom, :secondary_uom, :item_images)
  end

  def uoms
    [uom, secondary_uom].compact
  end

  def convertion_equation
    "#{primary_quantity} #{uom.short_name} = #{secondary_quantity} #{secondary_uom.short_name}" if secondary_uom
  end

  def image_attached?
    item_images.present?
  end

  private

  def check_secondary_uom_equality
    errors.add(:secondary_uom, "can't be same as UOM") if secondary_uom.present? && uom == secondary_uom
  end
end
