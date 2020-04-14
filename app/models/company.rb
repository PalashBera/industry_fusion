class Company < ApplicationRecord
  include ModalFormable
  include Archivable
  include UserTrackable
  include Nameable
  include Addressable

  acts_as_tenant(:organization)
  has_paper_trail ignore: %i[created_at updated_at]

  belongs_to :organization

  has_many :warehouses
end
