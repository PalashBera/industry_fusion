class Organization < ApplicationRecord
  include Archivable
  include UserTrackable

  has_paper_trail ignore: %i[created_at updated_at]

  before_validation { self.name = name.to_s.squish }
  before_validation { self.address1 = address1.to_s.squish }
  before_validation { self.address2 = address2.to_s.squish }
  before_validation { self.city = city.to_s.squish.titleize }
  before_validation { self.state = state.to_s.squish.titleize }
  before_validation { self.country = country.to_s.squish.titleize }
  before_validation { self.pin_code = pin_code.to_s.squish }
  before_validation { self.description = description.to_s.squish }

  has_many :users
  has_many :brands

  validates :name, presence: true, length: { maximum: 255 }, uniqueness: { case_sensitive: false }
  validates :address1, :city, :state, :country, presence: true, length: { maximum: 255 }
  validates :address2, length: { maximum: 255 }
  validates :pin_code, presence: true, length: { is: 6 }

  scope :order_by_name, -> { order(:name) }
end
