class Make < ApplicationRecord
  include ArchiveModule
  include ModalFormModule
  include UserTrackingModule

  acts_as_tenant(:organization)

  belongs_to :organization
  belongs_to :item
  belongs_to :brand

  has_many :indent_items

  delegate :name, to: :item,  prefix: :item
  delegate :name, to: :brand, prefix: :brand

  validates :cat_no, length: { maximum: 255 }, uniqueness: { allow_blank: true, case_sensitive: false, scope: %i[item_id brand_id] }

  has_paper_trail ignore: %i[created_at updated_at]

  def self.included_resources
    includes(:item, :brand)
  end

  def brand_with_cat_no
    [brand_name, cat_no].reject(&:blank?).join(" - ")
  end
end
