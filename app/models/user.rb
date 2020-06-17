class User < ApplicationRecord
  include Archivable
  include UserTrackable
  include UserInformable
  include ModalFormable

  cattr_accessor :current_user

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable, :trackable, :invitable, :async

  belongs_to :organization, optional: true

  validates :admin, inclusion: { in: [true, false] }

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
end
