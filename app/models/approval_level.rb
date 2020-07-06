class ApprovalLevel < ApplicationRecord
  include UserTrackingModule
  include ModalFormModule

  APPROVAL_TYPES = %w[indent qc po grn].freeze
  enum approval_type: Hash[APPROVAL_TYPES.map { |item| [item, item] }]

  acts_as_tenant(:organization)

  belongs_to :organization

  has_many :level_users, dependent: :destroy

  accepts_nested_attributes_for :level_users, allow_destroy: true, reject_if: :all_blank

  validates :approval_type, presence: true
  validates :level_users, presence: true

  def self.included_resources
    includes({ level_users: :user })
  end
end
