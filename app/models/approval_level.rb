class ApprovalLevel < ApplicationRecord
  include UserTrackable
  include ModalFormable

  acts_as_tenant(:organization)

  belongs_to :organization

  has_many :level_users, dependent: :destroy

  accepts_nested_attributes_for :level_users, allow_destroy: true, reject_if: :all_blank

  validates :approval_type, presence: true, length: { maximum: 255 }
  validates :level_users, presence: true

  scope :indent, -> { where(approval_type: "indent") }
  scope :qc,     -> { where(approval_type: "qc") }
  scope :po,     -> { where(approval_type: "po") }
  scope :grn,    -> { where(approval_type: "grn") }

  def self.included_resources
    includes({ level_users: :user })
  end
end
