class Company < ApplicationRecord
  include ModalFormable
  include Archivable
  include UserTrackable
  include Nameable
  include Addressable
  include ShortNameable

  acts_as_tenant(:organization)

  belongs_to :organization

  has_many :warehouses
  has_many :indents

  has_paper_trail ignore: %i[created_at updated_at]
end
