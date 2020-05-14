class NotificationRelayJob < ApplicationJob
  queue_as :default

  def perform(notification, current_user)
    html = ApplicationController.render partial: "notifications/users/followed", locals: {notification: notification}, formats: [:html]
    users = current_user.organization.users

    users.each do |user|
      NotificationsChannel.broadcast_to(
        user,
        title: "J",
        html: html
      )
    end
  end
end
