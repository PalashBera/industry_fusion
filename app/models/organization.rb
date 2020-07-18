class Organization < ApplicationRecord
  include ArchiveModule
  include UserTrackingModule

  cattr_accessor :current_organization

  before_validation { self.name = name.to_s.squish }

  has_many :users
  has_many :companies
  has_many :warehouses
  has_many :brands
  has_many :uoms
  has_many :item_groups
  has_many :cost_centers
  has_many :items
  has_many :makes
  has_many :indents
  has_many :indent_items
  has_many :vendorships
  has_many :warehouse_locations
  has_many :reorder_levels
  has_many :approval_levels
  has_many :vendors, through: :vendorships

  validates :name, presence: true, length: { maximum: 255 }
  validates :subdomain, presence: true, length: { maximum: 255 }, uniqueness: { case_sensitive: false }
  validates :fy_start_month, presence: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 12 }

  scope :order_by_name, -> { order(:name) }

  has_paper_trail ignore: %i[created_at updated_at]

  def self.subdomain_match(subdomain, _request)
    subdomain == "app" || Organization.find_by(subdomain: subdomain)
  end

  def fy_date_range
    fy_end_month = 0
    date_range = []

    if fy_start_month == 1
      date_range = [Date.new(Time.zone.now.year, fy_start_month, 1), Date.civil(Time.zone.now.year, 12, -1)]
    elsif fy_start_month.to_i.between?(2, 12)
      date_range = [Date.new(Time.zone.now.year, fy_start_month, 1), Date.civil(Time.zone.now.year + 1, fy_start_month - 1, -1)]
    end

    date_range
  end
end
