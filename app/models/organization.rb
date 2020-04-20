class Organization < ApplicationRecord
  include Archivable
  include UserTrackable
  include Addressable

  has_paper_trail ignore: %i[created_at updated_at]

  before_validation { self.name = name.to_s.squish }

  has_many :users
  has_many :companies
  has_many :warehouses
  has_many :brands
  has_many :uoms
  has_many :item_groups
  has_many :cost_centers
  has_many :items
  has_many :makes

  validates :name, presence: true, length: { maximum: 255 }, uniqueness: { case_sensitive: false }

  scope :order_by_name, -> { order(:name) }
end
