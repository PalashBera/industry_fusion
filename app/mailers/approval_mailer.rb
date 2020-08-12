require "auth"

class ApprovalMailer < ApplicationMailer
  def indent_approval(approval_request_user_id, sender_id)
    approval_request_user = ApprovalRequestUser.find(approval_request_user_id)
    @indent_item = IndentItem.find(approval_request_user.approval_request.approval_requestable_id)
    @recipient = User.find(approval_request_user.user_id)
    @sender = User.find(sender_id)
    @jwt_token = Auth.issue(approval_request_user: approval_request_user_id)

    mail to: @recipient.email, subject: I18n.t("mail.indent_approval.subject", serial: @indent_item.indent_serial_number)
  end
end
