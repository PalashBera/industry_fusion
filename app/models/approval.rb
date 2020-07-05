class Approval < ApplicationRecord
  include UserTrackingModule
  include ArchiveModule

  ACTION_TYPES = %w[approved rejected].freeze

  belongs_to :indent_item
  belongs_to :action_taken_by, class_name: "User", optional: true

  validates :level, presence: true
  validates :action_type, inclusion: { in: ACTION_TYPES }, allow_nil: true

  def approve(user_id)
    if approved?
      "Indent item has been approved already."
    else
      update(action_type: "approved", action_taken_at: Time.now, action_taken_by_id: user_id)
      indent_item.send_for_approval(level + 1)
      "Indent item has been successfully approved."
    end
  end

  def reject(user_id)
    if rejected?
      "Indent item has been rejected already."
    else
      update(action_type: "rejected", action_taken_at: Time.now, action_taken_by_id: user_id)
      indent_item.unlock_item
      "Indent item has been successfully rejected."
    end
  end

  def approved?
    action_type == "approved"
  end

  def rejected?
    action_type == "rejected"
  end
end
