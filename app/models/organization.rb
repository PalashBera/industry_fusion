class Organization < ApplicationRecord
  include Archivable
  include UserTrackable

  has_paper_trail ignore: %i[created_at updated_at]

  before_validation do
    self.name = name.to_s.squish
    self.address1 = address1.to_s.squish
    self.address2 = address2.to_s.squish
    self.city = city.to_s.squish.titleize
    self.state = state.to_s.squish.titleize
    self.country = country.to_s.squish.titleize
    self.pin_code = pin_code.to_s.squish
    self.phone_number = phone_number.to_s.squish
  end

  has_many :users
  has_many :companies
  has_many :warehouses
  has_many :brands
  has_many :uoms
  has_many :item_groups
  has_many :cost_centers

  validates :name, presence: true, length: { maximum: 255 }, uniqueness: { case_sensitive: false }
  validates :address1, :city, :state, :country, presence: true, length: { maximum: 255 }
  validates :address2, :phone_number, length: { maximum: 255 }
  validates :pin_code, presence: true, length: { is: 6 }

  scope :order_by_name, -> { order(:name) }
end
