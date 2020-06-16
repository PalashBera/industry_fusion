class Role < ApplicationRecord
  include Archivable
  include Nameable
  include UserTrackable

  acts_as_tenant(:organization)

  belongs_to :organization, optional: true

  has_many :users
  has_and_belongs_to_many :permissions

  def self.included_resources
    includes(:permissions)
  end
end
