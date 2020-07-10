class Approval < ApplicationRecord
  include UserTrackingModule
  include ArchiveModule

  ACTION_TYPES = %w[approved rejected].freeze

  belongs_to :indent_item
  belongs_to :action_taken_by, class_name: "User", optional: true

  validates :level, presence: true
  validates :action_type, inclusion: { in: ACTION_TYPES }, allow_nil: true

  def approve(user_id)
    if action_already_taken?
      action_already_taken_message
    else
      update(action_type: "approved", action_taken_at: Time.now, action_taken_by_id: user_id)
      indent_item.send_for_approval(level + 1)
      I18n.t("indent_approval.action_taken", action: "approved")
    end
  end

  def reject(user_id)
    if action_already_taken?
      action_already_taken_message
    else
      update(action_type: "rejected", action_taken_at: Time.now, action_taken_by_id: user_id)
      indent_item.unlock_item
      I18n.t("indent_approval.action_taken", action: "rejected")
    end
  end

  def approved?
    action_type == "approved"
  end

  def rejected?
    action_type == "rejected"
  end

  def action_already_taken?
    action_type == "approved" || action_type == "rejected"
  end

  private

  def action_already_taken_message
    if approved?
      I18n.t("indent_approval.action_already_taken", action: "approved")
    elsif rejected?
      I18n.t("indent_approval.action_already_taken", action: "rejected")
    end
  end
end
