require "auth"

class ApprovalMailer < ApplicationMailer
  def indent_approval(indent_item_id, approval_id, recipient_id, sender_id)
    @indent_item = IndentItem.find(indent_item_id)
    @recipient = User.find(recipient_id)
    @sender = User.find(sender_id)
    @jwt_token = Auth.issue(approval: approval_id, user: recipient_id)

    mail to: @recipient.email, subject: "Indent Approval Request for – ##{@indent_item.indent_serial_number}"
  end
end
