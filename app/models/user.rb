class User < ApplicationRecord
  include ArchiveModule
  include UserTrackingModule
  include UserInformationModule
  include ModalFormModule

  acts_as_tenant(:organization)

  cattr_accessor :current_user
  attr_accessor  :name
  attr_accessor  :fy_start_month

  before_validation do
    self.name = name.to_s.squish
  end

  after_create :create_approval_levels, if: :admin?

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable, :trackable, :invitable, :async

  belongs_to :organization

  has_many :level_users,            dependent: :destroy
  has_many :approval_request_users, dependent: :destroy

  validates :organization_id, presence: true
  validates :admin, inclusion: { in: [true, false] }

  has_paper_trail only: %i[archive warehouse_ids]

  def non_admin?
    !admin?
  end

  def pending_acception?
    invitation_accepted_at.nil?
  end

  def toggle_sidebar_collapse
    update_column(:sidebar_collapse, !sidebar_collapse)
  end

  def toggle_activation
    update_column(:archive, !archive)
  end

  def accessible_warehouse_ids
    if admin?
      @accessible_warehouse_ids ||= Warehouse.all.pluck(:id)
    else
      @accessible_warehouse_ids ||= warehouse_ids.map(&:to_i)
    end
  end

  protected

  def send_confirmation_instructions
    invitation_token.present? ? skip_confirmation_notification! : super
  end

  private

  def create_approval_levels
    ApprovalLevel::APPROVAL_TYPES.each do |type|
      ApprovalLevel.create(
        approval_type: type,
        organization_id: organization_id,
        created_by_id: id,
        level_users_attributes: [
          { user_id: id, created_by_id: id }
        ]
      )
    end
  end
end
