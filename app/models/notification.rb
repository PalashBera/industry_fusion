class Notification < ApplicationRecord
  after_commit -> { NotificationRelayJob.perform_later(self, User.current_user) }

  belongs_to :user
  belongs_to :recipient, class_name: "User"
  belongs_to :notifiable, polymorphic: true

  scope :order_by_date, -> { order(created_at: :desc) }
end
