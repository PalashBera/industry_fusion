class User < ApplicationRecord
  include ArchiveModule
  include UserTrackingModule
  include UserInformationModule
  include ModalFormModule

  cattr_accessor :current_user
  attr_accessor  :name
  attr_accessor  :fy_start_month
  attr_accessor  :subdomain

  SUBDOMAIN_REGEX = /\A([a-z][a-z\d]*(-[a-z\d]+)*|xn--[\-a-z\d]+)\z/i.freeze

  before_validation do
    self.name = name.to_s.squish
    self.subdomain = subdomain.to_s.squish.downcase
  end

  after_create :create_approval_levels, if: :admin?

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable, :trackable, :invitable, :async

  belongs_to :organization

  has_many :level_users

  validates :organization_id, presence: true, unless: proc { |f| f.subdomain.present? }
  validates :admin, inclusion: { in: [true, false] }
  validate :organizaion_details, if: proc { |f| f.subdomain.present? }

  has_paper_trail only: %i[archive warehouse_ids]

  def non_admin?
    !admin?
  end

  def toggle_sidebar_collapse
    update_column(:sidebar_collapse, !sidebar_collapse)
  end

  def toggle_activation
    update_column(:archive, !archive)
  end

  def pending_acception?
    invitation_accepted_at.nil?
  end

  protected

  def send_confirmation_instructions
    invitation_token.present? ? skip_confirmation_notification! : super
  end

  private

  def organizaion_details
    if !subdomain.match(SUBDOMAIN_REGEX)
      errors.add(:subdomain, "is not valid. Spaces and special characters (like $,!,% etc) are not allowed")
    elsif %w[app www vendor account admin superadmin].include?(subdomain) || Organization.find_by(subdomain: subdomain)
      errors.add(:subdomain, "has already been taken")
    end
  end

  def create_approval_levels
    ApprovalLevel::APPROVAL_TYPES.each do |type|
      ApprovalLevel.create(
        approval_type: type,
        organization_id: organization_id,
        created_by_id: id,
        level_users_attributes: [
          { user_id: id, organization_id: organization_id, created_by_id: id }
        ]
      )
    end
  end
end
