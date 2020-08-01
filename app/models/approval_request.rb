class ApprovalRequest < ApplicationRecord
  include UserTrackingModule

  ACTION_TYPES = %w[approved rejected].freeze
  enum action_type: Hash[ACTION_TYPES.map { |item| [item, item] }]

  belongs_to :action_taken_by,       class_name: "User",            optional: true
  belongs_to :next_approval_request, class_name: "ApprovalRequest", optional: true
  belongs_to :approval_requestable, polymorphic: true

  has_many :approval_request_users, dependent: :destroy

  validates :action_type, inclusion: { in: ACTION_TYPES }, allow_nil: true

  def action_already_taken?
    approved? || rejected?
  end
end
