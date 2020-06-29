class LevelUser < ApplicationRecord
  include UserTrackingModule

  acts_as_tenant(:organization)

  belongs_to :approval_level
  belongs_to :user

  validates :user_id, uniqueness: { scope: :approval_level_id }

  # validates_each :user_id do |record, attr, value|
  #   record.errors.add attr, :taken if record.approval_level.level_users.map(&:user_id).count(value) > 1
  # end
end
