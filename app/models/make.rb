class Make < ApplicationRecord
  include UserTrackable

  acts_as_tenant(:organization)

  belongs_to :brand
  belongs_to :item
  belongs_to :organization

  has_many :indent_items

  validates :cat_no, length: { maximum: 255 }, uniqueness: { allow_blank: true, case_sensitive: false, scope: %i[item_id brand_id] }

  def self.included_resources
    includes(:brand)
  end

  def brand_name
    [brand.name, cat_no].reject(&:blank?).join(" - ")
  end
end
