class Brand < ApplicationRecord
  include Archivable
  include ModalFormable
  include UserTrackable

  has_paper_trail ignore: %i[created_at updated_at]

  before_validation { self.name = name.to_s.squish }

  validates :name, presence: true, length: { maximum: 255 }, uniqueness: { case_sensitive: false }

  scope :order_by_name, -> { order(:name) }
end
