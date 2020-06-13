class Warehouse < ApplicationRecord
  include Nameable
  include ShortNameable
  include Addressable
  include Archivable
  include ModalFormable
  include UserTrackable

  acts_as_tenant(:organization)

  belongs_to :organization
  belongs_to :company

  has_many :indents
  has_many :warehouse_locations
  has_many :reorder_levels

  has_paper_trail ignore: %i[created_at updated_at]

  def self.included_resources
    includes(:company)
  end
end
