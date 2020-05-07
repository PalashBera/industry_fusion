class ItemGroup < ApplicationRecord
  include Archivable
  include ModalFormable
  include UserTrackable
  include Nameable

  acts_as_tenant(:organization)

  belongs_to :organization

  has_many :items

  has_paper_trail ignore: %i[created_at updated_at]
end
