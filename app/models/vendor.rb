class Vendor < ApplicationRecord
  include UserTrackable
  include ModalFormable

  before_validation { self.email = email.to_s.squish.downcase }

  validates :name, :email, presence: true, length: { maximum: 255 }
  validates :email, uniqueness: { case_sensitive: false }

  scope :order_by_name, -> { order(:name) }
end
