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

  def general_user?
    invitation_accepted_at.present?
  end

  def pending_acception?
    user_role == "pending"
  end

  def add_organization(organization)
    update(admin: true, organization_id: organization.id)
  end

  def user_role
    if general_user?
      "general_user"
    elsif admin?
      "admin"
    else
      "pending"
    end
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
end
