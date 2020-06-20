class LevelUser < ApplicationRecord
  include UserTrackable

  acts_as_tenant(:organization)

  belongs_to :approval_level, inverse_of: :level_users
  belongs_to :user

  has_paper_trail ignore: %i[created_at updated_at]

  def self.included_resources
    includes(:approval_level, :user, :organization)
  end

  def check_user_presence(ids)
    ids.include?(user_id) ? "error" : "success"
  end
end
