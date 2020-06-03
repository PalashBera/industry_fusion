class NotificationRelayJob < ApplicationJob
  queue_as :default

  def perform(notification, current_user)
    html = ApplicationController.render partial: "notifications/users/user", locals: {notification: notification}, formats: [:html]
    users = current_user.organization.users.reject{ |user| User.current_user == user }

    users.each do |user|
      NotificationsChannel.broadcast_to(
        user.id,
        length: user.user_notifications.length,
        not_notifiable: notification.created_by_id,
        html: html
      )
    end
  end
end
