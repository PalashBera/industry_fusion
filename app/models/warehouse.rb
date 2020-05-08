class Warehouse < ApplicationRecord
  include ModalFormable
  include Archivable
  include UserTrackable
  include Nameable
  include Addressable

  acts_as_tenant(:organization)

  before_validation { self.short_name = short_name.to_s.squish.upcase }

  belongs_to :organization
  belongs_to :company

  has_many :indents

  validates :short_name, presence: true, length: { maximum: 3 }, uniqueness: { case_sensitive: false, scope: :organization_id }

  has_paper_trail ignore: %i[created_at updated_at]

  def self.included_resources
    includes(:company)
  end
end
