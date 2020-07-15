class ItemImage < ApplicationRecord
  include UserTrackingModule

  belongs_to :item

  has_attached_file :image

  validates :image, presence: true
  validates_attachment_content_type :image, content_type: ["image/jpeg", "image/png"]
  validates_attachment_size :image, less_than: 2.megabytes

  scope :item_filter, ->(item_id) { where(item_id: item_id) }
end
