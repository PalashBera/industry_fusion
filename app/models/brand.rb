class Brand < ApplicationRecord
  include Archivable
  include ModalFormable

  has_paper_trail on: [:update]

  before_validation { self.name = name.to_s.squish }

  validates :name, presence: true, length: { maximum: 255 }, uniqueness: { case_sensitive: false }

  scope :order_by_name, -> { order(:name) }
end
