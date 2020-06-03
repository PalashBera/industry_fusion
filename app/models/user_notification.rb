class UserNotification < ApplicationRecord
  include UserTrackable

  after_save -> { NotificationRelayJob.perform_later(self, User.current_user) }

  belongs_to :user
  scope :order_by_date, -> { order(created_at: :desc) }
end
