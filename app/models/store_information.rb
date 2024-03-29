class StoreInformation < ApplicationRecord
  include AddressModule

  PAN_REGEX = /[a-z]{3}[cphfatblj][a-z]\d{4}[a-z]/i.freeze
  GSTN_REGEX = /\d{2}[A-Z]{5}\d{4}[A-Z]{1}[A-Z\d]{1}[Z]{1}[A-Z\d]{1}/i.freeze

  before_validation do
    self.name = name.to_s.squish
    self.pan_number = pan_number.to_s.squish.upcase
    self.gstn = gstn.to_s.squish.upcase
  end

  belongs_to :vendor

  validates :name, presence: true, length: { maximum: 255 }, uniqueness: { case_sensitive: false }
  validates :pan_number, format: { with: PAN_REGEX }, length: { maximum: 10 }, uniqueness: { case_sensitive: false }
  validates :gstn, format: { with: GSTN_REGEX }, length: { maximum: 15 }, uniqueness: { case_sensitive: false }

  has_paper_trail ignore: %i[created_at updated_at]
end
