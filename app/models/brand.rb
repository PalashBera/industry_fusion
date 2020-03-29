class Brand < ApplicationRecord
  has_paper_trail on: [:update]

  before_validation { self.name = name.to_s.squish }

  validates :name, presence: true, length: { maximum: 250 }, uniqueness: { case_sensitive: false }
  validates :active, inclusion: { in: [true, false] }

  scope :active, -> { where(active: true) }
end
