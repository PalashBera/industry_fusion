class UserMailer < ApplicationMailer
  def account_activation_acknowledgement(receiver_id, sender_id)
    @receiver = User.find(receiver_id)
    @sender = User.find(sender_id)
    mail to: @receiver.email, subject: I18n.t("mail.account.activate.subject", name: @sender.organization.name)
  end

  def account_deactivation_acknowledgement(receiver_id, sender_id)
    @receiver = User.find(receiver_id)
    @sender = User.find(sender_id)
    mail to: @receiver.email, subject: I18n.t("mail.account.archive.subject", name: @sender.organization.name)
  end
end
