module Nameable
  extend ActiveSupport::Concern

  included do
    before_validation { self.name = name.to_s.squish }

    validates :name, presence: true, length: { maximum: 255 }, uniqueness: { case_sensitive: false, scope: :organization_id }

    scope :order_by_name, -> { order(:name) }
  end
end
