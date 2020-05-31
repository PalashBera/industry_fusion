class Brand < ApplicationRecord
  include Archivable
  include ModalFormable
  include UserTrackable
  include Nameable

  acts_as_tenant(:organization)

  after_commit :create_notification

  belongs_to :organization

  has_many :makes

  has_paper_trail ignore: %i[created_at updated_at]

  private

  def create_notification
    current_user = User.current_user
    users = current_user.organization.users.reject{ |user| User.current_user == user }

    users.each do |user|
      user.user_notifications.create(message: "#{current_user.full_name} has changed something in brands")
    end
  end
end
