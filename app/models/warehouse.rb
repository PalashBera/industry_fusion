class Warehouse < ApplicationRecord
  include ModalFormable
  include Archivable
  include UserTrackable
  include Nameable
  include Addressable

  acts_as_tenant(:organization)
  has_paper_trail ignore: %i[created_at updated_at]

  belongs_to :organization
  belongs_to :company

  def self.included_resources
    includes(:company)
  end
end
