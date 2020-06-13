class Brand < ApplicationRecord
  include Nameable
  include Archivable
  include ModalFormable
  include UserTrackable

  acts_as_tenant(:organization)

  belongs_to :organization

  has_many :makes

  has_paper_trail ignore: %i[created_at updated_at]
end
