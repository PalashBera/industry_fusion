class IndentItem < ApplicationRecord
  include UserTrackingModule

  VALID_DECIMAL_REGEX = /\A\d+(?:\.\d{0,2})?\z/.freeze
  PRIORITY_LIST = %w[default high medium low].freeze
  STATUS_LIST = %w[pending approved amended rejected cancelled].freeze

  enum priority: Hash[PRIORITY_LIST.map { |item| [item, item] }], _suffix: true
  enum status: Hash[STATUS_LIST.map { |item| [item, item] }]

  acts_as_tenant(:organization)

  before_validation { self.note = note.to_s.squish }

  belongs_to :organization
  belongs_to :indent
  belongs_to :item
  belongs_to :make, optional: true
  belongs_to :uom
  belongs_to :cost_center

  has_many :approvals, dependent: :destroy

  delegate :serial_number,     to: :indent,      prefix: :indent
  delegate :requirement_date,  to: :indent,      prefix: :indent
  delegate :name,              to: :item,        prefix: :item
  delegate :short_name,        to: :uom,         prefix: :uom
  delegate :name,              to: :cost_center, prefix: :cost_center

  validates :quantity, presence: true, format: { with: VALID_DECIMAL_REGEX }, numericality: { greater_than: 0 }
  validates :priority, presence: true

  default_scope { order(created_at: :desc) }

  has_paper_trail ignore: %i[created_at updated_at current_level approval_ids locked approved]

  def self.included_resources
    includes({ indent: %i[company warehouse] }, :item, { make: :brand }, :uom, :cost_center)
  end

  def quantity_with_uom
    "#{quantity} #{uom.short_name}"
  end

  def display_priority
    priority.humanize.titleize
  end

  def brand_details
    if make_id
      [make.brand_name, make.cat_no].reject(&:blank?).join(" – ")
    else
      "N/A"
    end
  end

  def send_for_approval(level = 1)
    approval = Approval.find_by(id: approval_ids[level - 1].to_i)
    mark_as_approved && return unless approval

    approval.user_ids.each do |recipient_id|
      ApprovalMailer.indent_approval(id, approval.id, recipient_id, User.current_user.id).deliver_later
    end

    update(locked: true, current_level: level)
  end

  def create_approvals
    approval_items = []

    ApprovalLevel.indent.each.with_index(1) do |level, index|
      approval_items << approvals.create(level: index, user_ids: level.user_ids)
    end

    update(approval_ids: approval_items.map(&:id))
  end

  def unlocked?
    !locked
  end

  def mark_as_rejected
    update(locked: false, status: "rejected")
  end

  def mark_as_approved
    update(locked: true, status: "approved")
  end

  def mark_as_amended
    update(locked: true, status: "amended")
  end

  def mark_as_cancelled
    update(locked: true, status: "cancelled")
  end

  def mark_as_pending
    update(locked: false, status: "pending")
  end

  def display_status
    status.humanize.titleize
  end
end
