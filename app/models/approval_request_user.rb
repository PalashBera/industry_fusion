class ApprovalRequestUser < ApplicationRecord
  belongs_to :approval_request
  belongs_to :user

  scope :user_filter, ->(user_id) { where(user_id: user_id) }

  def approve
    if approval_request.action_already_taken?
      action_already_taken_message
    else
      approval_request.update(action_type: "approved", action_taken_at: Time.now, action_taken_by_id: user_id)
      approval_request.approval_requestable.send_approval_requests
      I18n.t("approval_request.action_taken", name: "Indent item", action: "approved")
    end
  end

  def reject
    if approval_request.action_already_taken?
      action_already_taken_message
    else
      approval_request.update(action_type: "rejected", action_taken_at: Time.now, action_taken_by_id: user_id)
      approval_request.approval_requestable.mark_as_rejected
      I18n.t("approval_request.action_taken", name: "Indent item", action: "rejected")
    end
  end

  def action_already_taken_message
    if approval_request.approved?
      I18n.t("approval_request.action_already_taken", name: "Indent item", action: "approved")
    elsif approval_request.rejected?
      I18n.t("approval_request.action_already_taken", name: "Indent item", action: "rejected")
    end
  end
end
