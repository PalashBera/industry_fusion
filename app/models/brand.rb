class Brand < ApplicationRecord
  include Archivable
  include ModalFormable
  include UserTrackable
  include Nameable

  acts_as_tenant(:organization)

  after_create_commit -> { Notification.create(recipient: User.first, user: User.last, action: "has changed In Brands", notifiable: User.first) }

  belongs_to :organization

  has_many :makes

  has_paper_trail ignore: %i[created_at updated_at]
end
