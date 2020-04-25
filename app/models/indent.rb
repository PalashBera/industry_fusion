class Indent < ApplicationRecord
  include UserTrackable

  acts_as_tenant(:organization)

  belongs_to :organization
  belongs_to :company
  belongs_to :warehouse

  has_many :indent_items

  has_paper_trail ignore: %i[created_at]

  accepts_nested_attributes_for :indent_items, reject_if: :all_blank, allow_destroy: true

  validates :indent_items, presence: true
end
