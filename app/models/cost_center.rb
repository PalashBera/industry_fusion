class CostCenter < ApplicationRecord
  include Archivable
  include ModalFormable
  include UserTrackable
  include Nameable

  acts_as_tenant(:organization)
  has_paper_trail ignore: %i[created_at updated_at]

  belongs_to :organization

  has_many :indent_items
end
