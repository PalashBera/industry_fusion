class IndentItem < ApplicationRecord
  include UserTrackingModule
  include ModalFormModule

  VALID_DECIMAL_REGEX = /\A\d+(?:\.\d{0,2})?\z/.freeze
  PRIORITY_LIST = %w[default high medium low].freeze
  STATUS_LIST = %w[created approved amended rejected cancelled approval_pending].freeze

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
  belongs_to :approval_request, optional: true

  has_one :quotation_request_item, dependent: :destroy

  has_many :approval_requests, as: :approval_requestable, dependent: :destroy
  has_many :approval_request_users, through: :approval_request
  has_many :quotation_request_items, dependent: :destroy

  delegate :serial_number,     to: :indent,      prefix: :indent
  delegate :name,              to: :item,        prefix: :item
  delegate :short_name,        to: :uom,         prefix: :uom
  delegate :name,              to: :cost_center, prefix: :cost_center
  delegate :company_name,      to: :indent
  delegate :warehouse_name,    to: :indent
  delegate :indentor_name,     to: :indent

  validates :quantity, presence: true, format: { with: VALID_DECIMAL_REGEX }, numericality: { greater_than: 0 }
  validates :priority, presence: true

  default_scope { order(created_at: :desc) }
  scope :pending_for_approval,    ->(user_id) { joins({ approval_request: :approval_request_users }).where(approval_requests: { action_taken_at: nil }, approval_request_users: { user_id: user_id }) }
  scope :brand_and_cat_no_filter, ->(query) { joins({ make: :brand }).where("brands.name ILIKE :q OR makes.cat_no ILIKE :q", q: "%#{query.squish}%") }
  scope :id_filter,               ->(ids) { where(id: ids) }
  scope :available_for_qr,        -> { joins("LEFT JOIN quotation_request_items ON indent_items.id = quotation_request_items.indent_item_id").where(quotation_request_items: { id: nil }) }

  has_paper_trail ignore: %i[created_at updated_at updated_by_id approval_request_id]

  def self.included_resources
    includes(:indent, :item, { make: :brand }, :uom, :cost_center)
  end

  def self.ransackable_scopes(_auth_object = nil)
    [:brand_and_cat_no_filter]
  end

  def quantity_with_uom
    "#{quantity} #{uom.short_name}"
  end

  def brand_details
    if make_id
      [make.brand_name, make.cat_no].reject(&:blank?).join(" – ")
    else
      "N/A"
    end
  end

  def send_approval_request_mails(sender_id = nil)
    sender_id ||= User.current_user.id

    approval_request_users.each do |approval_request_user|
      ApprovalMailer.indent_approval(approval_request_user.id, sender_id).deliver_later
    end
  end

  def create_approval_requests
    prev_approval_request = nil

    ApprovalLevel.indents.each.with_index(1) do |level, index|
      approval_request = ApprovalRequest.create(approval_requestable_id: id, approval_requestable_type: self.class.name)
      prev_approval_request&.update(next_approval_request_id: approval_request.id)
      update(approval_request_id: approval_request.id) if index == 1

      level.level_users.each do |user|
        approval_request.approval_request_users.create(user_id: user.user_id)
      end

      prev_approval_request = approval_request
    end
  end

  def locked?
    rejected? || approved? || cancelled? || approval_pending?
  end

  def unlocked?
    amended? || created?
  end

  def mark_as_rejected
    update(status: "rejected", approval_request_id: nil)
  end

  def mark_as_approved
    update(status: "approved", approval_request_id: nil)
  end

  def mark_as_amended
    update(status: "amended")
  end

  def mark_as_cancelled
    update(status: "cancelled", approval_request_id: nil)
  end

  def mark_as_created
    update(status: "created")
  end

  def mark_as_approval_pending
    update(status: "approval_pending")
  end

  def send_approval_requests(user_id = nil)
    user_id ||= User.current_user.id

    if approval_request&.next_approval_request_id?
      update(approval_request_id: approval_request.next_approval_request_id)
      send_approval_request_mails(user_id)
    else
      mark_as_approved
    end
  end
end
