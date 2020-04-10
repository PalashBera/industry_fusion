class Uom < ApplicationRecord
  include Archivable
  include ModalFormable
  include UserTrackable

  acts_as_tenant(:organization)
  has_paper_trail ignore: %i[created_at updated_at]

  before_validation do
    self.name = name.to_s.squish
    self.short_name = short_name.to_s.squish
  end

  validates :name, presence: true, length: { maximum: 255 }, uniqueness: { case_sensitive: false, scope: :organization_id }
  validates :short_name, presence: true, length: { maximum: 4 }, uniqueness: { case_sensitive: false, scope: :organization_id }
end