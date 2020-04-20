class Vendor < ApplicationRecord
  include UserTrackable
  include ModalFormable

  acts_as_tenant(:organization)

  before_validation do
    self.name = name.to_s.squish
    self.email = email.to_s.squish.downcase
  end

  validates :name, presence: true, length: { maximum: 255 }, uniqueness: { case_sensitive: false, scope: %i[email organization_id] }
  validates :email, presence: true, length: { maximum: 255 }, uniqueness: { case_sensitive: false, scope: :organization_id }

  scope :order_by_name, -> { order(:name) }
end
