class ApprovalLevel < ApplicationRecord
  include UserTrackable
  include ModalFormable

  acts_as_tenant(:organization)

  belongs_to :organization

  has_many :level_users, inverse_of: :approval_level, dependent: :destroy

  accepts_nested_attributes_for :level_users, allow_destroy: true, reject_if: :all_blank

  validates :approval_type, presence: true, length: { maximum: 255 }
  validates :level_users, presence: true

  scope :indent, ->{ where(approval_type: "Indent") }
  scope :qc,     ->{ where(approval_type: "Qc") }
  scope :po,     ->{ where(approval_type: "Po") }
  scope :grn,    ->{ where(approval_type: "Grn") }

  has_paper_trail ignore: %i[created_at updated_at]

  def self.included_resources
    includes(:organization, :level_users)
  end

  def level_users_attributes=(attributes)
    ids = LevelUser.joins(:approval_level).where(approval_levels: { approval_type: self.approval_type }).pluck(:user_id)

    attributes.each do |a|
      if a[1].has_key?("id") == false

        if ids.include?(a[1]["user_id"].to_i)
          errors.add(:base, "User has been added already")
          attributes.delete(a[0])
        end
      end
    end
    super
  end
end
