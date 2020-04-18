class Uom < ApplicationRecord
  include Archivable
  include ModalFormable
  include UserTrackable
  include Nameable

  acts_as_tenant(:organization)
  has_paper_trail ignore: %i[created_at updated_at]

  before_validation { self.short_name = short_name.to_s.squish }

  belongs_to :organization

  has_many :items

  validates :short_name, presence: true, length: { maximum: 4 }, uniqueness: { case_sensitive: false, scope: :organization_id }

  scope :order_by_short_name, -> { order(:short_name) }
end
